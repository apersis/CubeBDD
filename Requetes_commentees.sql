#Requête 1 : Connaître le nombre de clients
SELECT count(*) AS Nb_Clients #Compte de nombre de lignes (que l'on nomme Nb_Clients)
FROM Clients; #De la table Clients

#Requête 2 : Connaître le nombre de clients par villes !
SELECT Coordonnees.ville,count(Clients.id_client) AS Clients_par_ville  #Sélectionne la ville et son nombre de clients (que l'on nomme Clients_par_ville)
FROM Clients #De la table Clients
INNER JOIN Coordonnees ON Coordonnees.id_coordonnees=Clients.id_facturation #Jointe à la table coordonnees pour connaitre la ville
GROUP BY Coordonnees.ville # Regroupés par villes (une ville n'apparait qu'une fois dans la requête)
ORDER BY count(Clients.id_client) DESC; #Dans l'ordre des villes les plus habitées par nos clients (de haut en bas)

#Requête 3 : Connaître le coût moyen des voyages
DROP VIEW IF EXISTS Req3;

CREATE VIEW Req3 AS SELECT etape.id_etape, etape.kilometrage, moyen_transport.prix_km, Facture.marge, facture.tva, moyen_transport.nom_moyen_transport,
moyen_transport.id_moyen_transport FROM facture 
INNER JOIN Commande ON Facture.n_commande=Commande.n_commande 
INNER JOIN correspond ON commande.n_commande=correspond.n_commande 
INNER JOIN Voyage ON Voyage.id_voyage=Correspond.id_voyage 
INNER JOIN Compose ON compose.id_voyage=Voyage.id_voyage 
INNER JOIN Etape ON etape.id_etape=Compose.id_etape
INNER JOIN moyen_transport ON Etape.id_moyen_transport=moyen_transport.id_moyen_transport; #View qui lie les tables des moyens de transport jusqu'à la facture

SELECT round(avg(prix),2) AS Prix_Moyen_Voyages #Sélectionne la moyenne des prix arrondis au centime (que l'on nomme Prix_Moyen_Voyages)
FROM (SELECT 
(CASE WHEN req3.id_etape=T1.id_etape AND T1.ville=T2.ville THEN 2 #Qui renvoit 2 quand c'est en intra ville, la ville de depart (T1) est la même que celle d'arrivée (T2)
ELSE (round(avg(req3.kilometrage*req3.prix_km*(1+req3.marge)*(1+req3.tva)),2))END) #Quand c'est en extra-ville, il renvoit le kilométrage*le prix au km*la marge*la tva 
AS prix #Que l'on nomme prix
FROM Req3 #Depuis la view Req3
INNER JOIN (SELECT coordonnees.ville, etape.id_etape, coordonnees.id_coordonnees, etape.date_depart, etape.id_depart, etape.id_arrivee, etape.kilometrage 
FROM Coordonnees INNER JOIN etape ON coordonnees.id_coordonnees=etape.id_depart) 
AS T1 ON T1.id_etape = Req3.id_etape
INNER JOIN (SELECT coordonnees.ville, etape.id_etape, coordonnees.id_coordonnees, etape.date_depart, etape.id_depart, etape.id_arrivee 
FROM Coordonnees INNER JOIN etape ON coordonnees.id_coordonnees=etape.id_arrivee) 
AS T2 ON T2.id_etape = Req3.id_etape # On lie deux fois etape pour avoir la ville de départ et d'arrivée
GROUP BY req3.id_etape ORDER BY req3.id_etape) AS prix_total; #On le regroupe par étape pour avoir la moyenne des prix par étapes et on trie dans l'ordre des étapes

#Requête 4 : Connaître les villes les plus prisées
SELECT Coordonnees.ville,count(Etape.id_etape) AS 'Villes les plus prisées' #On sélectionne la ville et on les compte
FROM Etape #Depuis la table etape
INNER JOIN Coordonnees ON Coordonnees.id_coordonnees=Etape.id_arrivee #Qu'on joint à coordonnée pour avoir la ville d'arrivée
GROUP BY Coordonnees.ville #On regroupe par ville pour avoir le compte par ville
ORDER BY count(Etape.id_etape) DESC; #On trie par villes les plus présentes

#Requête 5 : Connaître la proportion des voyages intra-villes et inter-villes

DROP VIEW intra; #La view Intra ressort toutes les étapes ayant la même ville de départ et d'arrivée

CREATE VIEW intra AS select T1.ville AS ville1, T2.ville AS ville2, etape.id_etape FROM etape #on renomme pour avoir des noms plus clairs
INNER JOIN (SELECT coordonnees.ville, etape.id_etape, coordonnees.id_coordonnees, etape.date_depart, etape.id_depart, etape.id_arrivee FROM coordonnees 
INNER JOIN etape ON coordonnees.id_coordonnees=etape.id_depart) AS T1 ON T1.id_etape = etape.id_etape #On lie deux fois etape pour avoir la ville de départ et d'arrivée
INNER JOIN (SELECT coordonnees.ville, etape.id_etape, coordonnees.id_coordonnees, etape.date_depart, etape.id_depart, etape.id_arrivee FROM coordonnees 
INNER JOIN etape ON coordonnees.id_coordonnees=etape.id_arrivee) AS T2 ON T2.id_etape = etape.id_etape 
HAVING ville1=ville2; #Et on selectionne uniquement les étapes ayant la même ville de départ et d'arrivée

SELECT (SELECT count(id_etape) FROM intra)/count(id_etape) #On prend le nombre d'étapes dans intra et on le divise par le nombre total d'étapes
AS 'Proportion voyages intra-ville', #Qu'on renomme
1-(SELECT count(id_etape) FROM intra)/count(id_etape) AS 'Proportion voyages inter-villes' #On enlève à 1 la premiere proportion pour obtenir l'autre proportion
FROM Etape; #Puisqu'une étape ne peut être seulement intra ou inter ville (et pas les deux à la fois)

#Requête 6 : Connaître le nombre de voyages dont le moyen de transport est l'avion
SELECT count(DISTINCT id_voyage) AS "Nb voyages par Avion" #On selectionne le nombre de voyages
FROM Etape #De la table etape
INNER JOIN Moyen_transport ON Etape.id_moyen_transport=Moyen_transport.id_moyen_transport #On lie à moyen de transport pour comparer son nom
INNER JOIN compose ON compose.id_etape=Etape.id_etape  #On la lie à compose pour dire quels étapes composent chaque voyage
WHERE Moyen_transport.nom_moyen_transport="Avion"; #On sélectionne uniquement celles dont le moyen de transport est l'avion

#Requête 7 : Connaître le nombre de voyages dont les moyens de transports sont l'avion et le car.
DROP VIEW req7; #Cette fois je suis passé par une view pour alléger la requête 

CREATE VIEW req7 AS SELECT Moyen_transport.nom_moyen_transport,compose.id_voyage,compose.id_etape 
FROM Etape 
INNER JOIN Moyen_transport ON Etape.id_moyen_transport=Moyen_transport.id_moyen_transport 
INNER JOIN Compose ON compose.id_etape=Etape.id_etape; #Même chose que pour la requête numéro 6

SELECT count(DISTINCT id_voyage) AS "Nb voyages par avion et car"
FROM req7 
WHERE id_voyage IN 
(SELECT id_voyage FROM req7 AS T1 WHERE EXISTS  #On est obligé d'appeler deux fois req7 pour avoir deux cases moyen de transport pour les differentes étapes
(SELECT * FROM req7 AS T2 WHERE (T1.nom_moyen_transport = "Avion") #On sélectionne uniquement ceux qui ont pour moyen de transport l'avion
AND (T2.nom_moyen_transport = "Bus") #Et le bus
AND (T1.id_voyage=T2.id_voyage))); #Et qui ont le même id_voyage

#Requête 8 : Connaître la période de l'année la plus attractive pour les ventes de voyages
SELECT MONTHNAME(FROM_UNIXTIME(date_commande)) AS mois, #On sélectionne les mois de l'année   
count(n_commande) AS "nb commandes" #et on compte le nombre de fois où ils apparaissent dans commande
FROM Commande #De la table commande
GROUP BY mois  #On regroupe par mois pour le count
ORDER BY count(n_commande) DESC; #On affiche en premier les mois les plus attractifs

#Requête 9 : Connaître le moyen de transport le plus utilisé sur les 3 derniers mois
SELECT moyen_transport.nom_moyen_transport, #On sélectionne le nom du moyen de transport
count(moyen_transport.nom_moyen_transport) AS "nb de fois utilisé sur les 3 derniers mois" #Et on les comptes
FROM Etape #De la table etape
INNER JOIN moyen_transport ON etape.id_moyen_transport=moyen_transport.id_moyen_transport #Liée à la table moyen de transport pour sortir leur nom
WHERE Etape.date_depart >unix_timestamp(NOW())-7889400 #On sort uniquement ceux dont la date est superieure à la date d'aujourd'hui moins 3 mois (7889400 secondes) 
GROUP BY moyen_transport.nom_moyen_transport #On regroupe par nom de moyen de transport pour le count
ORDER BY count(moyen_transport.nom_moyen_transport) DESC; #On sort en premier le moyen de transport le plus utilisé
 
#Requête 10 : Connaître le tarif moyen des billets en fonction du transport

SELECT nom_moyen_transport, #On selectionne le nom du moyen de transport
round(AVG(prix),2) AS "tarif moyen des billets par tranport" #Et la moyenne de prix arrondis aux centimes près 
FROM (SELECT req3.nom_moyen_transport, #On fait une requête imbriquée pour la table
(CASE WHEN req3.id_etape=T1.id_etape AND T1.ville=T2.ville THEN 2 #Lorsque la ville de départ et d'arrivée sont les mêmes il ressort 2(pour 2€)
ELSE (round(avg(req3.kilometrage*req3.prix_km*(1+req3.marge)*(1+req3.tva)),2))END) #sinon il fait le prix d'un billet classique (kilometrage * prix au km * 1+marge * 1+tva)
AS prix #Qu'on renomme prix
FROM Req3 #On réutilise la view de la requête 3
INNER JOIN #Qu'on joint à une autre requête imbriquée
(SELECT coordonnees.ville, etape.id_etape, coordonnees.id_coordonnees, etape.date_depart, etape.id_depart, etape.id_arrivee #On sélectionne toutes les colones dont on a besoin
FROM Coordonnees # de la table coordonnees
INNER JOIN etape ON coordonnees.id_coordonnees=etape.id_depart) AS T1 ON T1.id_etape = Req3.id_etape #qu'on lie une fois avec etape
INNER JOIN  #Et la derniere requête imbriquée
(SELECT coordonnees.ville, etape.id_etape, coordonnees.id_coordonnees, etape.date_depart, etape.id_depart, etape.id_arrivee #On sélectionne toutes les colones dont on a besoin
FROM Coordonnees # de la table coordonnees
INNER JOIN etape ON coordonnees.id_coordonnees=etape.id_arrivee) AS T2 ON T2.id_etape = Req3.id_etape #qu'on lie une deuxième fois pour avoir la ville de départ et d'arrivée
GROUP BY req3.nom_moyen_transport,req3.id_etape,req3.kilometrage,req3.prix_km,req3.marge,req3.tva)# On regrouppe toutes les colones pour ne rien changer  
AS tarif GROUP BY nom_moyen_transport; #Et là on regrouppe par nom moyen de transport pour avoir le tarif moyen par nom de moyen de transport

#Requête 11 : Connaître le taux des personnes par sexe qui voyagent les 6 derniers mois
SELECT genre_voyageur, #On sélectionne le genre
count(voyageurs.id_voyageur)/(SELECT count(voyageurs.id_voyageur) #On prend le nombre de voyageurs de ce genre qu'on divise par le nombre total de voyageurs 
FROM Voyageurs # de la table voyageurs
INNER JOIN participe ON participe.id_voyageur=voyageurs.id_voyageur
INNER JOIN voyage ON participe.id_voyage=voyage.id_voyage
INNER JOIN compose ON voyage.id_voyage=compose.id_voyage 
INNER JOIN etape ON compose.id_etape=etape.id_etape #Qu'on lie jusqu'à etape pour avoir la date de départ
WHERE date_depart>unix_timestamp(NOW())-15778800) #On ne sélectionne uniquement les voyages dont la date est supperieure à aujourd'hui moins 6 mois (15778800 secondes)
AS taux #On renomme en taux en fermant la requête imbriquée
FROM Voyageurs #de la table voyageurs
INNER JOIN participe ON participe.id_voyageur=voyageurs.id_voyageur
INNER JOIN voyage ON participe.id_voyage=voyage.id_voyage
INNER JOIN compose ON voyage.id_voyage=compose.id_voyage
INNER JOIN etape ON compose.id_etape=etape.id_etape WHERE date_depart>unix_timestamp(NOW())-15778800 #On fait pareil que dans la requête imbriquée
GROUP BY genre_voyageur; #Sauf qu'on regrouppe par genre

#Requête 12 : Connaître le taux de séniors qui ont voyagé les 6 derniers mois
SELECT COUNT(DISTINCT DATEDIFF(NOW(),str_to_date(naissance_voyageur, "%Y-%m-%d"))/365) #on sélectionne les voyageurs de plus de 65 ans
/(SELECT DISTINCT COUNT(DATEDIFF(NOW(),str_to_date(naissance_voyageur, "%Y-%m-%d"))/365) # on divise par le nombre total de voyageurs
FROM Voyageurs #De la table voyageurs
INNER JOIN participe ON participe.id_voyageur=voyageurs.id_voyageur
INNER JOIN voyage ON participe.id_voyage=voyage.id_voyage
INNER JOIN compose ON voyage.id_voyage=compose.id_voyage 
INNER JOIN etape ON compose.id_etape=etape.id_etape #Qu'on lie jusqu'à etape
WHERE date_depart>unix_timestamp(NOW())-15778800) AS taux #uniquement les voyages datant de moins de 6 mois
FROM Voyageurs #De la table voyageurs
INNER JOIN participe ON participe.id_voyageur=voyageurs.id_voyageur
INNER JOIN voyage ON participe.id_voyage=voyage.id_voyage
INNER JOIN compose ON voyage.id_voyage=compose.id_voyage
INNER JOIN etape ON compose.id_etape=etape.id_etape WHERE date_depart>unix_timestamp(NOW())-15778800 #Pareil que dans la requête imbriquée
AND DATEDIFF(NOW(),str_to_date(naissance_voyageur, "%Y-%m-%d"))/365>65; #Sauf qu'on sélectionne uniquement ceux dont l'âge est supérieur à 65 ans
 
#Requête 13 : Connaître le nombre moyen d'enfants qui ont voyagés les 6 derniers mois

SELECT COUNT(DISTINCT DATEDIFF(NOW(),str_to_date(naissance_voyageur, "%Y-%m-%d"))/365)/ #Litteralement la même requête que la n°12, juste on change l'âge
(SELECT DISTINCT COUNT(DATEDIFF(NOW(),str_to_date(naissance_voyageur, "%Y-%m-%d"))/365) 
FROM voyageurs 
INNER JOIN participe ON participe.id_voyageur=voyageurs.id_voyageur
INNER JOIN voyage ON participe.id_voyage=voyage.id_voyage
INNER JOIN compose ON voyage.id_voyage=compose.id_voyage
INNER JOIN etape ON compose.id_etape=etape.id_etape WHERE date_depart>unix_timestamp(NOW())-15778800) AS taux FROM voyageurs
INNER JOIN participe ON participe.id_voyageur=voyageurs.id_voyageur
INNER JOIN voyage ON participe.id_voyage=voyage.id_voyage
INNER JOIN compose ON voyage.id_voyage=compose.id_voyage
INNER JOIN etape ON compose.id_etape=etape.id_etape WHERE date_depart>unix_timestamp(NOW())-15778800 
AND DATEDIFF(NOW(),str_to_date(naissance_voyageur, "%Y-%m-%d"))/365<12; #on sélectionne uniquement ceux dont l'âge est inférieur à 12 ans

#Requête 14 : Connaître le mode de paiement préféré des clients depuis "X date"
SELECT moyen_paiement,count(moyen_paiement) AS "nb utilisation" #on sélectionne le moyen de paiement et on le compte
FROM Paiement #de la table paiement
WHERE date_paiement>1623186000 #dont la date est supérieure à X (ici le 8 juin 2021 à 23h00)
GROUP BY moyen_paiement  #Regroupé par moyen de paiement pour le count
ORDER BY count(moyen_paiement) DESC; #Renvoie les moyens de paiements les plus utilisés de haut en bas

#Requête 15 : Connaître les personnels les plus anciens dans l'agence
SELECT nom_personnel,prenom_personnel, DATE_FORMAT(from_unixtime(date_embauche), '%d-%m-%Y') AS "Date d'embauche" #Sort le nom/prenom et la date d'embauche
FROM Personnel #De la table personnel
ORDER BY date_embauche; #Trié par personnel le plus ancien dans l'agence de haut en bas

#Requête 16 : Connaître les différentes informations pour un voyage : Numéro de voyage, son prix, date de départ, nombre de villes traversées.

DROP VIEW Req16;

CREATE VIEW Req16 #La View sert à lier les tables de moyen de transport jusqu'à facture
AS SELECT etape.id_etape, etape.kilometrage, moyen_transport.prix_km, Facture.marge, facture.tva, 
moyen_transport.nom_moyen_transport,moyen_transport.id_moyen_transport, voyage.id_voyage, etape.date_depart, etape.id_depart, etape.id_arrivee
FROM Voyage 
INNER JOIN Compose ON compose.id_voyage=Voyage.id_voyage 
INNER JOIN Etape ON etape.id_etape=Compose.id_etape
INNER JOIN correspond ON voyage.id_voyage=correspond.id_voyage
INNER JOIN Commande ON correspond.n_commande=Commande.n_commande 
INNER JOIN Facture ON Facture.n_commande=Commande.n_commande
INNER JOIN moyen_transport ON moyen_transport.id_moyen_transport=Etape.id_moyen_transport;

SELECT id_voyage, #on sélectionne l'id du voyage
round(AVG(prix),2) AS 'Prix du voyage', #le prix 
DATE_FORMAT(from_unixtime(min(date_depart)), '%d-%m-%Y') AS 'Date de départ', #la date de départ
count(id_etape)+1 AS villes_traversees #le nombres de villes traversées
FROM #Depuis une requête imbriquée
(SELECT id_voyage,req16.date_depart,req16.id_depart,req16.id_arrivee,req16.id_etape, #on selectionne les colonnes nécessaires
(CASE WHEN req16.id_etape=T1.id_etape AND T1.ville=T2.ville THEN 2 #qui renvoit le prix à 2€ lorsque c'est une étape intra-ville
ELSE (round(avg(req16.kilometrage*req16.prix_km*(1+req16.marge)*(1+req16.tva)),2))END) AS prix #ou le prix normal lors d'une étape inter-ville
FROM Req16 #de la view Req16
INNER JOIN (SELECT coordonnees.ville, etape.id_etape, coordonnees.id_coordonnees, etape.date_depart, etape.id_depart, etape.id_arrivee, etape.kilometrage 
FROM Coordonnees INNER JOIN etape ON coordonnees.id_coordonnees=etape.id_depart) 
AS T1 ON T1.id_etape = Req16.id_etape
INNER JOIN (SELECT coordonnees.ville, etape.id_etape, coordonnees.id_coordonnees, etape.date_depart, etape.id_depart, etape.id_arrivee 
FROM Coordonnees INNER JOIN etape ON coordonnees.id_coordonnees=etape.id_arrivee) 
AS T2 ON T2.id_etape = Req16.id_etape #Qu'on joint à coordonnees deux fois pour avoir la ville de départ et d'arrivée 
GROUP BY req16.nom_moyen_transport,req16.id_etape,req16.kilometrage,req16.prix_km,req16.marge,req16.tva,req16.id_voyage,req16.date_depart)#On regroupe par chaque élément pour ne rien changer
AS tarif #Ou l'on nomme la requête imbriquée 'tarif'
GROUP BY id_voyage; #Et on regroupe par voyage pour le tarif moyen