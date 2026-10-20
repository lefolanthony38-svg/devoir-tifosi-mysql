-- ============================================================
-- Script 1 : création de la base de données tifosi
-- ============================================================

-- On supprime la base si elle existe déjà,
-- pour pouvoir relancer le script sans erreur
DROP DATABASE IF EXISTS tifosi;

-- utf8mb4 : pour gérer les accents (Américaine, Jambon fumé, œuf)
CREATE DATABASE tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Toutes les instructions suivantes s'appliquent à la base tifosi
USE tifosi;
-- ============================================================
-- Création de l'utilisateur tifosi
-- Principe du moindre privilège : il n'a des droits
-- QUE sur la base tifosi, pas sur le reste du serveur
-- ============================================================

-- Suppression préalable pour rendre le script rejouable
DROP USER IF EXISTS 'tifosi'@'localhost';

-- Mot de passe en clair car projet d'exercice local :
-- en production, il ne doit jamais être publié sur GitHub
CREATE USER 'tifosi'@'localhost' IDENTIFIED BY 'Tifosi2026!';

-- tifosi.* = toutes les tables de la base tifosi, et rien d'autre
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';

-- Recharge la table des droits pour appliquer les changements
FLUSH PRIVILEGES;
-- ============================================================
-- Création des tables
-- Ordre : d'abord les tables sans clé étrangère (parents),
-- puis celles qui en dépendent, puis les tables de liaison
-- ============================================================

-- Table marque : les marques des boissons
CREATE TABLE marque (
    id_marque INT         NOT NULL AUTO_INCREMENT,
    nom       VARCHAR(50) NOT NULL,
    CONSTRAINT pk_marque     PRIMARY KEY (id_marque),
    CONSTRAINT uq_marque_nom UNIQUE (nom)   -- pas deux marques du même nom
) ENGINE = InnoDB;

-- Table ingredient : les ingrdient des foccaia
CREATE TABLE  ingredient (
    id_ingredient INT         NOT NULL AUTO_INCREMENT,
    nom       VARCHAR(50) NOT NULL,
    CONSTRAINT pk_ingredient     PRIMARY KEY (id_ingredient),
    CONSTRAINT uq_ingredient_nom UNIQUE (nom)   -- pas deux ingredient du même nom
) ENGINE = InnoDB;

-- Table focaccia : les focaccias
CREATE TABLE focaccia (
-- LES COLONNES  →  nom   type   options
id_focaccia INT         NOT NULL AUTO_INCREMENT,
nom           VARCHAR(50) NOT NULL,
prix        DECIMAL(5,2) NOT NULL,
-- LES contraintes
CONSTRAINT pk_focaccia     PRIMARY KEY (id_focaccia),
CONSTRAINT uq_focaccia_nom UNIQUE (nom),   -- pas deux focaccias du même nom
    
CONSTRAINT ck_focaccia_prix CHECK (prix > 0)   -- un prix ne peut être ni nul ni négatif
) ENGINE = InnoDB;

-- Table boisson : les boissons
CREATE TABLE boisson (
-- LES COLONNES  →  id_nom nom   id_marque
id_boisson INT         NOT NULL AUTO_INCREMENT,
nom        VARCHAR(50) NOT NULL,
id_marque  INT         NOT NULL,
-- LES contraintes
CONSTRAINT pk_boisson PRIMARY KEY (id_boisson),
CONSTRAINT uq_boisson_nom UNIQUE (nom),
CONSTRAINT fk_boisson_marque FOREIGN KEY (id_marque)
    REFERENCES marque (id_marque)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    
) ENGINE = InnoDB;

-- Table menu : les menu
CREATE TABLE menu (
-- LES COLONNES  →  id_menu PK, nom, prix, #id_focaccia
id_menu INT         NOT NULL AUTO_INCREMENT,
nom           VARCHAR(50) NOT NULL,
prix		DECIMAL(5,2) NOT NULL,
id_focaccia        INT NOT NULL,
-- LES contraintes
CONSTRAINT pk_menu PRIMARY KEY (id_menu),
CONSTRAINT uq_menu_nom UNIQUE (nom),
CONSTRAINT ck_menu_prix CHECK (prix > 0),   -- un prix ne peut être ni nul ni négatif
CONSTRAINT fk_menu_focaccia FOREIGN KEY (id_focaccia)
    REFERENCES focaccia (id_focaccia)      
    ON DELETE RESTRICT                
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE focaccia_ingredient (
-- LES COLONNES  →  focaccia_ingredient ( #id_focaccia, #id_ingredient, quantite )
id_focaccia INT         NOT NULL ,
id_ingredient INT       NOT NULL ,
quantite	INT	NOT NULL,
-- LES contraintes
constraint pk_recette PRIMARY KEY (id_focaccia, id_ingredient),

CONSTRAINT ck_quantite CHECK (quantite > 0), 
  
CONSTRAINT fk_id_focaccia FOREIGN KEY (id_focaccia)
 REFERENCES focaccia (id_focaccia)      
    ON DELETE CASCADE            
    ON UPDATE CASCADE,
CONSTRAINT fk_id_ingredient FOREIGN KEY (id_ingredient)
     REFERENCES ingredient (id_ingredient)     
    ON DELETE RESTRICT                
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE menu_boisson (
-- LES COLONNES → menu_boisson ( #id_menu, #id_boisson )
id_menu INT NOT NULL ,
id_boisson INT NOT NULL ,
-- LES contraintes
constraint pk_menu_boisson PRIMARY KEY (id_menu, id_boisson),
CONSTRAINT fk_id_menu FOREIGN KEY (id_menu)
    REFERENCES menu (id_menu)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
CONSTRAINT fk_id_boisson FOREIGN KEY (id_boisson)
    REFERENCES boisson (id_boisson)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE client (
-- LES COLONNES → client ( id_client PK, nom, email, code_postal )
id_client INT NOT NULL auto_increment ,
nom VARCHAR (50) NOT NULL ,
email VARCHAR (150) NOT NULL,
code_postal INT NOT NULL,   -- INT conservé pour respecter le MCD
-- LES contraintes
CONSTRAINT pk_client PRIMARY KEY (id_client),
CONSTRAINT uq_client_email UNIQUE (email)
) ENGINE = InnoDB;


CREATE TABLE achete (
-- LES COLONNES → achete ( #id_client, #id_menu, date_achat )
id_client INT NOT NULL ,
id_menu int not null  ,
date_achat DATE not null,
-- LES contraintes
constraint pk_achete PRIMARY KEY (id_client, id_menu, date_achat),
CONSTRAINT fk_achete_client FOREIGN KEY (id_client)
    REFERENCES client (id_client)
    ON DELETE restrict -- RESTRICT : on conserve l'historique des ventes.
    ON UPDATE CASCADE,
CONSTRAINT fk_achete_menu FOREIGN KEY (id_menu)
    REFERENCES menu (id_menu)
    ON DELETE RESTRICT
    ON UPDATE CASCADE

) ENGINE = InnoDB;