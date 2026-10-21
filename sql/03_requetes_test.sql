--  ============================================================
-- Script 3 : requêtes de test de la base tifosi
-- Prérequis : scripts 01_creation_schema.sql et
--             02_insertion_donnees.sql exécutés
-- Pour chaque requête : numéro et but, résultat attendu
-- (calculé à la main depuis les fichiers Excel AVANT
-- l'exécution), code SQL, résultat obtenu, écart éventuel.
-- ============================================================
USE tifosi;
-- =============================================================
-- REQUÊTE 1
-- But : afficher la liste des noms des focaccias par ordre
--       alphabétique croissant
-- Résultat attendu : (8 lignes, d'après focaccia.xlsx) 
-- résultat obtenu : identique à focaccia.xlsx
-- Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia, Paysanne, Raclaccia, Tradizione
-- aucun ecart 
-- =============================================================
SELECT nom
FROM focaccia
ORDER BY nom ASC;


-- =============================================================
-- REQUÊTE 2
-- But : afficher le nombre total d'ingrédients
-- Résultat attendu : 25 (nombre de lignes de ingredient.xlsx)
-- aucun ecart
-- resultat obtenu : 25
-- =============================================================
SELECT COUNT(*) AS nombre_ingredients
FROM ingredient;


-- =============================================================
-- REQUÊTE 3
-- But : afficher le prix moyen des focaccias
-- Résultat attendu : (9.80 + 10.80 + 8.90 + 9.80 + 8.90 + 11.20
--                     + 10.80 + 12.80) / 8 = 83.00 / 8 = 10.375
-- resultat obtenu : 10.375, et 10.38 avec ROUND
-- =============================================================
SELECT AVG(prix) AS prix_moyen
FROM focaccia;
SELECT ROUND(AVG(prix), 2) AS prix_moyen
FROM focaccia;


-- =============================================================
-- REQUÊTE 4
-- But : afficher la liste des boissons avec leur marque,
--       triée par nom de boisson
-- Résultat attendu (12 lignes, d'après boisson.xlsx trié)
-- boisson > nom de marque 
-- aucun ecart
-- =============================================================
SELECT b.nom AS boisson, m.nom AS marque
FROM boisson AS b
INNER JOIN marque AS m ON b.id_marque = m.id_marque
ORDER BY b.nom ASC;


-- =============================================================
-- REQUÊTE 5
-- But : afficher la liste des ingrédients pour une Raclaccia
-- Résultat attendu (7 lignes, recette de focaccia.xlsx)
-- aucun ecart
-- resultat obtenu : 7 ingrédients 
-- Ail, Base Tomate, Champignon, Cresson, Parmesan, Poivre, Raclette
-- =============================================================
SELECT i.nom AS ingredient                 -- on affiche le nom des ingrédients
FROM focaccia AS f
-- 1er pont : focaccia → table de liaison (les numéros des ingrédients)
INNER JOIN focaccia_ingredient AS fi ON fi.id_focaccia  = f.id_focaccia
-- 2e pont : table de liaison → ingredient (leurs noms)
INNER JOIN ingredient          AS i  ON i.id_ingredient = fi.id_ingredient
WHERE f.nom = 'Raclaccia'                 -- seulement la Raclaccia
ORDER BY i.nom ASC;



-- =============================================================
-- REQUÊTE 6
-- But : afficher le nom et le nombre d'ingrédients pour
--       chaque focaccia
-- Résultat attendu (8 lignes, comptage des recettes) 
-- aucun ecart
-- resultat obtenu : 8 focaccias 
-- Américaine 8, Emmentalaccia 7, Gorgonzollaccia 8, Hawaienne 9, Mozaccia 10, Paysanne 12, Raclaccia 7, Tradizione 9
-- =============================================================
SELECT f.nom AS focaccia, COUNT(*) AS nb_ingredients
FROM focaccia AS f
INNER JOIN focaccia_ingredient AS fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.nom
ORDER BY f.nom ASC;


-- =============================================================
-- REQUÊTE 7
-- But : afficher le nom de la focaccia qui a le plus
--       d'ingrédients
-- Résultat attendu : Paysanne (12 ingrédients)
-- aucun ecart
-- resultat obtenu : Paysanne (12 ingrédients)
-- =============================================================
SELECT f.nom AS focaccia, COUNT(*) AS nb_ingredients
FROM focaccia AS f
INNER JOIN focaccia_ingredient AS fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.nom
ORDER BY nb_ingredients DESC
LIMIT 1;


-- =============================================================
-- REQUÊTE 8
-- But : afficher la liste des focaccias qui contiennent de l'ail
-- Résultat attendu (4 lignes) 
-- aucun ecart
-- resultat obtenu : 4 focaccias Gorgonzollaccia, Mozaccia, Paysanne, Raclaccia
-- =============================================================
SELECT f.nom AS focaccia
FROM focaccia AS f
INNER JOIN focaccia_ingredient AS fi ON fi.id_focaccia  = f.id_focaccia
INNER JOIN ingredient          AS i  ON i.id_ingredient = fi.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom ASC;


-- =============================================================
-- REQUÊTE 9
-- But : afficher la liste des ingrédients inutilisés
-- Résultat attendu (2 lignes) 
-- aucun ecart
-- resultat obtenu : 2 ingrédients Salami, Tomate cerise
-- =============================================================
SELECT i.nom AS ingredient
FROM ingredient AS i
LEFT JOIN focaccia_ingredient AS fi ON fi.id_ingredient = i.id_ingredient
WHERE fi.id_focaccia IS NULL
ORDER BY i.nom ASC;


-- =============================================================
-- REQUÊTE 10
-- But : afficher la liste des focaccias qui n'ont pas de
--       champignons
-- Résultat attendu (2 lignes) 
-- aucun ecart
-- resultat obtenu : 2 focaccias Américaine, Hawaienne
-- =============================================================
SELECT f.nom AS focaccia
FROM focaccia AS f
WHERE f.id_focaccia NOT IN (
    -- Sous-requête : les id des focaccias qui contiennent du champignon
    SELECT fi.id_focaccia
    FROM focaccia_ingredient AS fi
    INNER JOIN ingredient AS i ON i.id_ingredient = fi.id_ingredient
    WHERE i.nom = 'Champignon'
)
ORDER BY f.nom ASC;