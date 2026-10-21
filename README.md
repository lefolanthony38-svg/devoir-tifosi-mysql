Tifosi – Base de données MySQL

Le Tifosi, restaurant de street-food italien, souhaite une base de données dynamique, hébergée en local, pour gérer ses focaccias, ses ingrédients, ses boissons, ses clients et leurs menus.

Le projet se déroule en trois phases :

1 création de la base de données tifosi ;
2 insertion des données dans tifosi ;
3 requêtes de test de la base tifosi.

Prérequis
Serveur MySQL 8.0.46 (8.0.16 minimum pour que les contraintes CHECK soient appliquées)
MySQL Workbench pour exécuter les scripts

Contenu
Fichier	Rôle
sql/01_creation_schema.sql	Création de la base, de l'utilisateur tifosi et de ses droits, puis des tables à partir du schéma fourni
sql/02_insertion_donnees.sql	Insertion des données des fichiers Excel : tables parents d'abord, puis celles qui ont des clés étrangères
sql/03_requetes_test.sql	Les 10 requêtes de test, avec pour chacune son but, le résultat attendu et le résultat obtenu après exécution

Utilisation

Exécuter les scripts dans l'ordre :

sql/01_creation_schema.sql
sql/02_insertion_donnees.sql
sql/03_requetes_test.sql

Choix de conception
1 Orthographe : j'ai retenu « focaccia ». Le schéma fourni écrit « foccacia », mais le brief et les fichiers Excel écrivent « focaccia », qui est la bonne orthographe. En tant que dyslexique, cette différence m'a beaucoup gêné : j'ai dû relire et vérifier pour ne pas reporter cette faute dans le code, autant que faire se peut.
2 Code postal : j'ai rendu le code postal obligatoire (NOT NULL), pour que le restaurant puisse voir quels clients habitent dans le même département, ce qui peut être utile pour des campagnes de fidélisation. Je l'ai gardé en INT comme dans le schéma, même si un code comme 01000 perd son zéro.
3 Date d'achat : j'ai mis la date dans la clé primaire de achete. Un client peut ainsi racheter le même menu un autre jour, et on garde une traçabilité des achats par rapport aux produits. Pour un restaurant, c'est important : en cas d'accusation d'intoxication alimentaire, un suivi rigoureux permet de vérifier ce qui a été vendu et quand, et d'éviter les fausses accusations.
4 Données Excel : j'ai fait attention aux détails qui auraient pu créer des erreurs (un espace en trop, des noms écrits différemment d'un fichier à l'autre). Le détail est en commentaire dans le script 2.

Limites que j'ai remarquées
Un client ne peut pas acheter deux fois le même menu le même jour, parce que la date (sans l'heure) fait partie de la clé de achete.
Le schéma dit qu'une focaccia a au moins un ingrédient, mais mon script ne peut pas l'imposer avec de simples contraintes.
Les tables menu, client et achete n'ont pas de données de test.