-- ============================================================
-- Script 2 : insertion des données dans tifosi
-- Prérequis : exécuter 01_creation_schema.sql juste avant
-- Source : fichiers Excel fournis par le restaurant
-- ============================================================

USE tifosi;

-- ------------------------------------------------------------
-- Ordre d'insertion : tables parents d'abord (marque,
-- ingredient, focaccia), puis celles qui ont des clés
-- étrangères (boisson, focaccia_ingredient)
-- ------------------------------------------------------------

-- Marques (source : marque.xlsx)
INSERT INTO marque (id_marque, nom) VALUES
    (1, 'Coca-cola'),
    (2, 'Cristalline'),
    (3, 'Monster'),
    (4, 'Pepsico');

    -- Boissons (source : boisson.xlsx)
-- La marque est convertie de son nom vers son id_marque
INSERT INTO boisson (id_boisson, nom, id_marque) VALUES
    (1, 'Coca-cola zéro', 1),
    (2, 'Coca-cola original', 1),
    (3, 'Fanta citron', 1),
    (4, 'Fanta orange', 1),
    (5, 'Capri-sun', 1),
    (6, 'Pepsi', 4),
    (7, 'Pepsi Max Zéro', 4),
    (8, 'Lipton zéro citron', 4),
    (9, 'Lipton Peach', 4),
    (10, 'Monster energy ultra gold', 3),
    (11, 'Monster energy ultra blue', 3),
    (12, 'Eau de source', 2);

    -- ingredient (source : ingredient.xlsx)
INSERT INTO ingredient (id_ingredient, nom) VALUES
    (1, 'Ail'),
    (2, 'Ananas'),
    (3, 'Artichaut'),
    (4, 'Bacon'),
    (5, 'Base Tomate'),
    (6, 'Base crème'),
    (7, 'Champignon'),
    (8, 'Chevre'),
    (9, 'Cresson'),
    (10, 'Emmental'),
    (11, 'Gorgonzola'),
    (12, 'Jambon cuit'),
    (13, 'Jambon fumé'),
    (14, 'Oeuf'),
    (15, 'Oignon'),
    (16, 'Olive noire'),
    (17, 'Olive verte'),
    (18, 'Parmesan'),
    (19, 'Piment'),
    (20, 'Poivre'),
    (21, 'Pomme de terre'),
    (22, 'Raclette'),
    (23, 'Salami'),
    (24, 'Tomate cerise'),
    (25, 'Mozarella');

-- focaccia (source : focaccia.xlsx)
INSERT INTO focaccia (id_focaccia, nom, prix) VALUES
    (1,'Mozaccia',9.80),
    (2,'Gorgonzollaccia',10.80),
    (3,'Raclaccia',8.90),
    (4,'Emmentalaccia',9.80),
    (5,'Tradizione',8.90),
    (6,'Hawaienne',11.20),
    (7,'Américaine',10.80),
    (8,'Paysanne',12.80);

INSERT INTO focaccia_ingredient (id_focaccia, id_ingredient, quantite) VALUES
    (1, 5, 200),
    (1, 25, 50),
    (1, 9, 20),
    (1, 13, 80),
    (1, 1, 2),
    (1, 3, 20),
    (1, 7, 40),
    (1, 18, 50),
    (1, 20, 1),
    (1, 16, 20),
    (2, 5, 200),
    (2, 11, 50),
    (2, 9, 20),
    (2, 1, 2),
    (2, 7, 40),
    (2, 18, 50),
    (2, 20, 1),
    (2, 16, 20),
    (3, 5, 200),
    (3, 22, 50),
    (3, 9, 20),
    (3, 1, 2),
    (3, 7, 40),
    (3, 18, 50),
    (3, 20, 1),
    (4, 6, 200),
    (4, 10, 50),
    (4, 9, 20),
    (4, 7, 40),
    (4, 18, 50),
    (4, 20, 1),
    (4, 15, 20),
    (5, 5, 200),
    (5, 25, 50),
    (5, 9, 20),
    (5, 12, 80),
    (5, 7, 80),
    (5, 18, 50),
    (5, 20, 1),
    (5, 16, 10),
    (5, 17, 10),
    (6, 5, 200),
    (6, 25, 50),
    (6, 9, 20),
    (6, 4, 80),
    (6, 2, 40),
    (6, 19, 2),
    (6, 18, 50),
    (6, 20, 1),
    (6, 16, 20),
    (7, 5, 200),
    (7, 25, 50),
    (7, 9, 20),
    (7, 4, 80),
    (7, 21, 40),
    (7, 18, 50),
    (7, 20, 1),
    (7, 16, 20),
    (8, 6, 200),
    (8, 8, 50),
    (8, 9, 20),
    (8, 21, 80),
    (8, 13, 80),
    (8, 1, 2),
    (8, 3, 20),
    (8, 7, 40),
    (8, 18, 50),
    (8, 20, 1),
    (8, 16, 20),
    (8, 14, 50);
-- cetait horrible de cherche toutes les occurrence et les taper a la main : ( --