# Les procédures d'ajout (dans l'ordre à respecter)

DROP PROCEDURE IF EXISTS AjoutCoordonnees; 
DELIMITER //
CREATE PROCEDURE AjoutCoordonnees(
IN num_voie INT,
IN nom_rue VARCHAR(100),
IN nom_residence VARCHAR(100),
IN nom_batiment VARCHAR(50),
IN etage INT,
IN code_postal INT,
IN ville VARCHAR(50),
IN tel_mobile VARCHAR(15),
IN autre_tel_1 VARCHAR(15),
IN autre_tel_2 VARCHAR(15),
IN actif tinyint(1))
BEGIN
INSERT INTO Coordonnees (num_voie, nom_rue, nom_residence, nom_batiment, etage, code_postal, ville, tel_mobile, autre_tel_1, autre_tel_2,actif)
VALUES 
(num_voie, nom_rue, nom_residence, nom_batiment, etage, code_postal, ville, tel_mobile, autre_tel_1, autre_tel_2,actif);
END//
DELIMITER ;

#CALL AjoutCoordonnees (9, 'Rue Dr Delalande', 'Illia', NULL, 3, 29200, 'Brest', '0699822546', NULL, NULL,1);
#SELECT * FROM Coordonnees;

DROP PROCEDURE IF EXISTS AjoutPersonnel;     #Ajouter un employé. Attention, pré-requis : créer son adresse avant !
DELIMITER //
CREATE PROCEDURE AjoutPersonnel (
IN prenom_personnel VARCHAR(50),
IN nom_personnel VARCHAR(50),
IN mail_pro VARCHAR(100),
IN date_embauche INT,
IN id_coordonnees INT,
IN actif tinyint(1)
)
BEGIN
INSERT INTO Personnel (prenom_personnel, nom_personnel ,mail_pro ,date_embauche,id_coordonnees,actif)
VALUES (prenom_personnel, nom_personnel ,mail_pro ,date_embauche, id_coordonnees, actif);
END//
DELIMITER ;

#CALL AjoutCoordonnees (8, 'Rue Dr Delalande', 'Illia', NULL, 3, 29200, 'Brest', '0699822546', NULL, NULL,1);
#SELECT * FROM Coordonnees;
#CALL AjoutPersonnel ('Maële', 'Pompon', 'maele.pompon@voyage.fr', 1656367200, 52,1);
#SELECT * FROM Personnel;

DROP PROCEDURE IF EXISTS AjoutTransport; 
DELIMITER //
CREATE PROCEDURE AjoutTransport(     #Ajout d'un moyen de transport
IN nom_moyen_transport VARCHAR(50),
IN nom_transporteur VARCHAR(50),
IN prix_km FLOAT,
IN actif tinyint(1))
BEGIN
INSERT INTO Moyen_transport (nom_moyen_transport, nom_transporteur, prix_km, actif)
VALUES 
(nom_moyen_transport, nom_transporteur, prix_km, actif);
END //
DELIMITER ;

#CALL AjoutTransport ('Train', 'TER', 0.18,1);
#SELECT * FROM Moyen_transport;

# Potentiel pré-requis : ajout 1 ou 2 coordonees et un moyen de transport s'ils n'existent pas déjà
DROP PROCEDURE IF EXISTS AjoutEtape;           
DELIMITER //
CREATE PROCEDURE AjoutEtape(     #Ajout d'une étape
IN date_depart INT,
IN date_arrivee INT,
IN kilometrage FLOAT,
IN id_depart INT,
IN id_arrivee INT,
IN id_moyen_transport INT)
BEGIN
INSERT INTO Etape (date_depart, date_arrivee, kilometrage, id_depart, id_arrivee, id_moyen_transport)
VALUES 
(date_depart, date_arrivee, kilometrage, id_depart, id_arrivee, id_moyen_transport);
END //
DELIMITER ;

#CALL AjoutEtape (1669367000,1669399999,88,1,18,8);
#SELECT * FROM Etape;

DROP PROCEDURE IF EXISTS AjoutVoyageur; 
DELIMITER //
CREATE PROCEDURE AjoutVoyageur(     #Ajout d'un voyageur
IN nom_voyageur VARCHAR(50),
IN prenom_voyageur VARCHAR(50),
IN naissance_voyageur VARCHAR(50),
IN genre_voyageur VARCHAR(1))
BEGIN
INSERT INTO Voyageurs (nom_voyageur, prenom_voyageur, naissance_voyageur, genre_voyageur)
VALUES 
(nom_voyageur, prenom_voyageur, naissance_voyageur, genre_voyageur);
END //
DELIMITER ;

#CALL AjoutVoyageur ('52', 'Pelle', 'Teuse', '1996-08-26', 'N');
#SELECT * FROM Voyageurs;

DROP PROCEDURE IF EXISTS AjoutVoyage;           
DELIMITER //
CREATE PROCEDURE AjoutVoyage(     #Ajout d'un voyage
IN nom_voyage VARCHAR(50)
)
BEGIN
INSERT INTO Voyage (nom_voyage)
VALUES 
(nom_voyage);
END //
DELIMITER ;

#CALL AjoutVoyage ('Verseau');
#SELECT * FROM Voyage;

DROP PROCEDURE IF EXISTS AjoutClients;   #Pré-requis : il faut créer une ou deux adresses avant d'ajouter un client pour récuperer les id
DELIMITER //
CREATE PROCEDURE AjoutClients (
  IN prenom_client VARCHAR(50),
  IN nom_client VARCHAR(50),
  IN date_naissance VARCHAR(10),
  IN genre VARCHAR(1),
  IN adresse_mail VARCHAR(100),
  IN id_livraison INT,
  IN id_facturation INT,
  IN actif tinyint(1)
 )
BEGIN
INSERT INTO Clients (prenom_client, nom_client ,date_naissance ,genre ,adresse_mail, id_livraison ,id_facturation,actif)
VALUES 
(prenom_client, nom_client ,date_naissance ,genre ,adresse_mail ,id_livraison, id_facturation, actif);
END//
DELIMITER ;

#CALL AjoutCoordonnees (9, 'Rue Dr Delalande', 'Illia', NULL, 3, 29200, 'Brest', '0699822546', NULL, NULL,1);
#SELECT * FROM Coordonnees;
#CALL AjoutClients ('Lily', 'Machin', '2003-12-06', 'F','Lily.machin@gmail.com',53, 53,1);
#SELECT * FROM Clients;

DROP PROCEDURE IF EXISTS AjoutCommande;           # Pré-requis : avoir créé au préalable le client et le personnel
DELIMITER //
CREATE PROCEDURE AjoutCommande(     #Ajout d'une commande
IN date_commande INT,
IN id_client INT,
IN id_personnel INT)
BEGIN
INSERT INTO Commande (date_commande, id_client, id_personnel)
VALUES 
(date_commande, id_client, id_personnel);
END //
DELIMITER ;

#CALL AjoutPersonnel ('Maële', 'Pompon', 'maele.pompon@voyage.fr', 1656367200, 52);
#CALL AjoutClients ('Lily', 'Machin', '2003-12-06', 'F','Lily.machin@gmail.com',53, 53);
#CALL AjoutCommande (1671836400,1,1);
#SELECT * FROM Commande;

DROP PROCEDURE IF EXISTS AjoutFacture;                      #pré-requis : il faut tout d'abord créer un client et une commande et tout ce que ça implique
DELIMITER //
CREATE PROCEDURE AjoutFacture(     #Ajout d'une facture
IN tva FLOAT,
IN marge FLOAT,
IN acquittee tinyint(1),
IN id_client INT,
IN n_commande INT
)
BEGIN
INSERT INTO Facture (tva, marge, acquittee, id_client, n_commande)
VALUES 
(tva, marge, acquittee, id_client, n_commande);
END //
DELIMITER ;

#CALL AjoutFacture (0.2, 0.1, 0, 1, 2);
#SELECT * FROM Facture;

DROP PROCEDURE IF EXISTS AjoutPaiement; 
DELIMITER //
CREATE PROCEDURE AjoutPaiement(     #Ajout d'un paiement : pré-requis ajout d'une facture au préalable
IN date_paiement INT,
IN moyen_paiement VARCHAR(10),
IN taux_paiement FLOAT,
IN id_facture INT)
BEGIN
INSERT INTO Paiement (date_paiement, moyen_paiement, taux_paiement, id_facture)
VALUES 
(date_paiement, moyen_paiement, taux_paiement, id_facture);
END //
DELIMITER ;

#CALL AjoutPaiement (1637416800,"CB", 0.75, 20);
#SELECT * FROM Paiement;

DROP PROCEDURE IF EXISTS AjoutCompose; 
DELIMITER //
CREATE PROCEDURE AjoutCompose(     #Ajout d'une donnée compose
IN id_etape INT,
IN id_voyage INT)
BEGIN
INSERT INTO compose (id_etape,id_voyage)
VALUES 
(id_etape,id_voyage);
END //
DELIMITER ;

#CALL AjoutCompose (1,1);
#SELECT * FROM Compose;

DROP PROCEDURE IF EXISTS AjoutCorrespond; 
DELIMITER //
CREATE PROCEDURE AjoutCorrespond(     #Ajout d'une donnée Correspond
IN n_commande INT,
IN id_voyage INT)
BEGIN
INSERT INTO Correspond (n_commande,id_voyage)
VALUES 
(n_commande,id_voyage);
END //
DELIMITER ;

#CALL AjoutCorrespond (1,13);
#SELECT * FROM Correspond;

DROP PROCEDURE IF EXISTS AjoutParticipe; 
DELIMITER //
CREATE PROCEDURE AjoutParticipe(     #Ajout d'une donnée Participe
IN id_voyage INT,
IN id_voyageur INT)
BEGIN
INSERT INTO Participe (id_voyage,id_voyageur)
VALUES 
(id_voyage,id_voyageur);
END //
DELIMITER ;

#CALL AjoutParticipe (1,12);
#SELECT * FROM Participe;

#======================================================================================================================================================================================
#Procédures de modification

DROP PROCEDURE IF EXISTS ModifCoordonnees; 
DELIMITER //
CREATE PROCEDURE ModifCoordonnees (   #modifier toutes les données concernant 1 coordonnées
IN id_coordo INT,
IN num_voie INT,
IN nom_rue VARCHAR(100),
IN nom_residence VARCHAR(100),
IN nom_batiment VARCHAR(50),
IN etage INT,
IN code_postal INT,
IN ville VARCHAR(50),
IN tel_mobile VARCHAR(15),
IN autre_tel_1 VARCHAR(15),
IN autre_tel_2 VARCHAR(15),
IN actif tinyint(1))
BEGIN
UPDATE Coordonnees
SET num_voie=num_voie,
nom_rue=nom_rue,
nom_residence=nom_residence,
nom_batiment=nom_batiment,
etage=etage,
code_postal=code_postal,
ville=ville,
tel_mobile=tel_mobile,
autre_tel_1=autre_tel_1,
autre_tel_2=autre_tel_2,
actif=actif
WHERE id_coordonnees=id_coordo;
END//
DELIMITER ; 

#CALL ModifCoordonnees (53,10, 'Rue Delalande', 'Ilia', NULL, 2, 29200, 'Brest', '0699822545', NULL, NULL,1);
#SELECT * FROM Coordonnees;

DROP PROCEDURE IF EXISTS ModifPersonnel; 
DELIMITER //
CREATE PROCEDURE ModifPersonnel (             #Modifier tout la ligne d'un personnel via son id
IN id_perso INT,
IN prenom_personnel VARCHAR(50),
IN nom_personnel VARCHAR(50),
IN mail_pro VARCHAR(100),
IN date_embauche INT,
IN id_coordonnees INT,
IN actif tinyint(1)
)
BEGIN
UPDATE Personnel
SET 
prenom_personnel=prenom_personnel,
nom_personnel=nom_personnel,
mail_pro=mail_pro,
date_embauche=date_embauche,
id_coordonnees=id_coordonnees,
actif=actif
WHERE id_personnel=id_perso;
END //
DELIMITER ;

#CALL ModifPersonnel (6, 'Maëlle', 'Pompom', 'maelle.pompom@voyage.fr', 1656367200, 52,1);
#SELECT * FROM Personnel;

DROP PROCEDURE IF EXISTS ModifTransport; 
DELIMITER //
CREATE PROCEDURE ModifTransport  #modifier toutes les données concernant 1 moyen de transport
(IN id_transport INT,
IN nom_moyen_transport VARCHAR(50),
IN nom_transporteur VARCHAR(50),
IN prix_km FLOAT,
IN actif tinyint(1))
BEGIN
UPDATE Moyen_transport
SET nom_moyen_transport=nom_moyen_transport,
nom_transporteur=nom_transporteur,
prix_km=prix_km,
actif=actif
WHERE id_moyen_transport = id_transport;
END //
DELIMITER ;

#CALL ModifTransport (11,'Train','TER', 0.19,1);
#SELECT * FROM Moyen_transport;

#modifier toutes les données concernant 1 étape
DROP PROCEDURE IF EXISTS ModifEtape; 
DELIMITER //
CREATE PROCEDURE ModifEtape  
(IN id INT,
IN date_depart INT,
IN date_arrivee INT,
IN kilometrage FLOAT,
IN id_depart INT,
IN id_arrivee INT,
IN id_moyen_transport INT)
BEGIN
UPDATE Etape
SET date_depart=date_depart,
date_arrivee=date_arrivee,
kilometrage=kilometrage,
id_depart=id_depart,
id_arrivee=id_arrivee,
id_moyen_transport=id_moyen_transport
WHERE id_etape = id;
END //
DELIMITER ;

#CALL ModifEtape (11,1669367000,1669399999,80,2,18,8);
#SELECT * FROM Etape;

DROP PROCEDURE IF EXISTS ModifVoyageur; 
DELIMITER //
CREATE PROCEDURE ModifVoyageur  #modifier toutes les données concernant 1 voyageur
(IN id INT,
IN nom_voyageur VARCHAR(50),
IN prenom_voyageur VARCHAR(50),
IN naissance_voyageur VARCHAR(50),
IN genre_voyageur VARCHAR(1))
BEGIN
UPDATE Voyageurs
SET nom_voyageur=nom_voyageur,
prenom_voyageur=prenom_voyageur,
naissance_voyageur=naissance_voyageur,
genre_voyageur=genre_voyageur
WHERE id_voyageur = id;
END //
DELIMITER ;

#CALL ModifVoyageur ('52', 'Ri', 'Cardo', '1996-02-08', 'M');
#SELECT * FROM Voyageurs;

DROP PROCEDURE IF EXISTS ModifVoyage; 
DELIMITER //
CREATE PROCEDURE ModifVoyage  #modifier toutes les données concernant 1 étape
(IN id_trip INT,
IN nom_voyage VARCHAR(50)
)
BEGIN
UPDATE Voyage
SET nom_voyage=nom_voyage
WHERE id_voyage = id_trip;
END //
DELIMITER ;

#CALL ModifVoyage (16,'Cancer');
#SELECT * FROM Voyage;

DROP PROCEDURE IF EXISTS ModifClients; 
DELIMITER //
CREATE PROCEDURE ModifClients (         #modification de toute la ligne d'un client via son id
IN id_cli INT,
IN prenom_client VARCHAR(50),
IN nom_client VARCHAR(50),
IN date_naissance VARCHAR(10),
IN genre VARCHAR(1),
IN adresse_mail VARCHAR(100),
IN adresse_livraison INT,
IN adresse_facturation INT,
IN actif tinyint(1)
)
BEGIN
UPDATE Clients
SET prenom_client = prenom_client,
nom_client = nom_client,
prenom_client = prenom_client,
date_naissance = date_naissance,
genre = genre,
adresse_mail = adresse_mail,
id_livraison = id_livraison,
id_facturation = id_facturation,
actif=actif
WHERE id_client = id_cli;
END //
DELIMITER ;

#CALL ModifClients (22, 'Lily', 'Truc', '2003-12-09', 'F','Lily.machin@gmail.com',53, 53,1);
#SELECT * FROM Clients;

DROP PROCEDURE IF EXISTS ModifCommande; 
DELIMITER //
CREATE PROCEDURE ModifCommande  #modifier toutes les données concernant une commande
(IN n_cde INT,
IN date_commande INT,
IN id_client INT,
IN id_personnel INT
)
BEGIN
UPDATE Commande
SET date_commande=date_commande,
id_client=id_client,
id_personnel=id_personnel
WHERE n_commande = n_cde;
END //
DELIMITER ;

#CALL ModifCommande (26,1671836600,1,2);
#SELECT * FROM Commande;

DROP PROCEDURE IF EXISTS ModifFacture; 
DELIMITER //
CREATE PROCEDURE ModifFacture  #modifier toutes les données concernant 1 facture
(IN id_fact INT,
IN tva FLOAT,
IN marge FLOAT,
IN acquittee tinyint(1),
IN id_client INT,
IN n_commande INT)
BEGIN
UPDATE Facture
SET tva=tva,
marge=marge,
acquittee=acquittee,
id_client=id_client,
n_commande=n_commande
WHERE id_facture=id_fact;
END //
DELIMITER ;

#CALL ModifFacture (29,0.2, 0.15, 0, 1, 2);
#SELECT * FROM Facture;

DROP PROCEDURE IF EXISTS ModifPaiement; 
DELIMITER //
CREATE PROCEDURE ModifPaiement  #modifier toutes les données concernant 1 paiement
(IN id_paie INT,
IN date_paiement INT,
IN moyen_paiement VARCHAR(10),
IN taux_paiement FLOAT,
IN id_facture INT)
BEGIN
UPDATE Paiement
SET date_paiement=date_paiement,
moyen_paiement=moyen_paiement,
taux_paiement=taux_paiement,
id_facture=id_facture
WHERE id_paiement = id_paie;
END //
DELIMITER ;

#CALL ModifPaiement (30,1637416810,"Chèque", 0.50, 20);
#SELECT * FROM Paiement;

#===============================================================================================================================================================================
#Exemple de procédure de modification d'une seule donnée

DROP PROCEDURE IF EXISTS ModifDonneeCoordonnees;      #modifier une seule données pour une id_coordonnee donnee (exemple avec changement du tel mobile)
DELIMITER //
CREATE PROCEDURE ModifDonneeCoordonnees ( 
IN id_coordo INT,
IN num_voie VARCHAR(50)
)
BEGIN
UPDATE Coordonnees
SET num_voie=num_voie
WHERE id_coordonnees=id_coordo;
END//
DELIMITER ;

#CALL ModifDonneeCoordonnees (53,9);
#SELECT * FROM Coordonnees ;

DROP PROCEDURE IF EXISTS ModifDonneePersonnel; 
DELIMITER //
CREATE PROCEDURE ModifDonneePersonnel (         #Modifier une seule donnée d'un personnel via son id
IN id_perso INT,
IN nom_personnel VARCHAR(50)
)
BEGIN
UPDATE Personnel
SET nom_personnel = nom_personnel
WHERE id_personnel=id_perso;
END//
DELIMITER ;

#CALL ModifDonneePersonnel (6, 'Pouettepouette');
#SELECT * FROM Personnel;

DROP PROCEDURE IF EXISTS ModifDonneeTransport; 
DELIMITER //
CREATE PROCEDURE ModifDonneeTransport   # modifier 1 donnée 
(IN id_transport INT,
IN prix_km FLOAT)
BEGIN
UPDATE Moyen_transport
SET 
prix_km=prix_km
WHERE id_moyen_transport = id_transport;
END //
DELIMITER ;

#CALL ModifDonneeTransport (11, 0.20);
#SELECT * FROM Moyen_transport;

DROP PROCEDURE IF EXISTS ModifDonneeEtape; 
DELIMITER //
CREATE PROCEDURE ModifDonneeEtape   # modifier 1 donnée 
(IN id INT,
IN kilometrage FLOAT)
BEGIN
UPDATE Etape
SET 
kilometrage=kilometrage
WHERE id_etape = id;
END //
DELIMITER ;

#CALL ModifDonneeEtape (11, 145);
#SELECT * FROM Etape;

DROP PROCEDURE IF EXISTS ModifDonneeVoyageur; 
DELIMITER //
CREATE PROCEDURE ModifDonneeVoyageur   # modifier 1 donnée 
(IN id INT,
IN nom_voyageur VARCHAR(50))
BEGIN
UPDATE Voyageurs
SET 
nom_voyageur=nom_voyageur
WHERE id_voyageur = id;
END //
DELIMITER ;

#CALL ModifDonneeVoyageur (52, 'Henri');
#SELECT * FROM Voyageurs;

# Comme il n'y avait qu'un seul attribut non clé dans la table voyage, 1 seule procédure de modification est nécessaire

DROP PROCEDURE IF EXISTS ModifDonneeClients; 
DELIMITER //
CREATE PROCEDURE ModifDonneeClients (       # Modification d'une donnée d'un client via son id
IN id_cli INT,
IN nom_client VARCHAR(50)
)
BEGIN
UPDATE Clients
SET nom_client = nom_client
WHERE id_client = id_cli;
END//
DELIMITER ;

#CALL ModifDonneeClients (22, 'Bidule');
#SELECT * FROM Clients;

DROP PROCEDURE IF EXISTS ModifDonneeCommande; 
DELIMITER //
CREATE PROCEDURE ModifDonneeCommande   # modifier 1 donnée 
(IN n_cde INT,
IN date_commande INT)
BEGIN
UPDATE Commande
SET 
date_commande=date_commande
WHERE n_commande = n_cde;
END //
DELIMITER ;

#CALL ModifDonneeCommande (26, 1671836800);
#SELECT * FROM Commande;

DROP PROCEDURE IF EXISTS ModifDonneeFacture; 
DELIMITER //
CREATE PROCEDURE ModifDonneeFacture   # modifier 1 donnée 
(IN id_fact INT,
IN marge FLOAT)
BEGIN
UPDATE Facture
SET 
marge=marge
WHERE id_facture=id_fact;
END //
DELIMITER ;

#CALL ModifDonneeFacture (29, 0.17);
#SELECT * FROM Facture;

DROP PROCEDURE IF EXISTS ModifDonneePaiement; 
DELIMITER //
CREATE PROCEDURE ModifDonneePaiement   # modifier 1 donnée 
(IN id_paie INT,
IN taux_paiement FLOAT)
BEGIN
UPDATE Paiement
SET 
taux_paiement=taux_paiement
WHERE id_paiement = id_paie;
END //
DELIMITER ;

#CALL ModifDonneePaiement (30,0.75);
#SELECT * FROM Paiement;

#=====================================================================================================================================================================================
#Procédure de recherche

DROP PROCEDURE IF EXISTS RechercheCoordonnees;
DELIMITER //
CREATE PROCEDURE RechercheCoordonnees # procédure de recherche d'une coordonnée en fonction de son id
(IN id_coordo INT)
BEGIN
SELECT id_coordonnees, num_voie, nom_rue, nom_residence, nom_batiment, etage, code_postal, ville, tel_mobile, autre_tel_1, autre_tel_2, actif
FROM Coordonnees
WHERE id_coordonnees=id_coordo;
END //
DELIMITER ;

#CALL RechercheCoordonnees (53);

DROP PROCEDURE IF EXISTS RecherchePersonnel;
DELIMITER //
CREATE PROCEDURE RecherchePersonnel (       #procédure de recherche d'un personnel via son id
IN id_perso INT
)
BEGIN
SELECT id_personnel, prenom_personnel, nom_personnel, mail_pro, date_embauche, id_coordonnees, actif
FROM Personnel
WHERE id_personnel=id_perso;
END//
DELIMITER ;

#CALL RecherchePersonnel (6);
#SELECT * FROM Personnel;

DROP PROCEDURE IF EXISTS RechercheTransport;      #recherche d'un moyen de transport via son id
DELIMITER //
CREATE PROCEDURE RechercheTransport 
(IN id_transport INT)
BEGIN
SELECT id_moyen_transport, nom_moyen_transport, nom_transporteur, prix_km, actif
FROM Moyen_transport
WHERE id_moyen_transport=id_transport;
END //
DELIMITER ;

#CALL RechercheTransport (11);

DROP PROCEDURE IF EXISTS RechercheEtape;      
DELIMITER //
CREATE PROCEDURE RechercheEtape       #recherche d'une etape via son id
(IN id INT)
BEGIN
SELECT id_etape, date_depart, date_arrivee, kilometrage, id_depart, id_arrivee, id_moyen_transport
FROM Etape
WHERE id_etape=id;
END //
DELIMITER ;

#CALL RechercheEtape (11);

DROP PROCEDURE IF EXISTS RechercheVoyageur;      #recherche d'un voyageur via son id
DELIMITER //
CREATE PROCEDURE RechercheVoyageur 
(IN id INT)
BEGIN
SELECT id_voyageur, nom_voyageur, prenom_voyageur, naissance_voyageur, genre_voyageur
FROM Voyageurs
WHERE id_voyageur=id;
END //
DELIMITER ;

#CALL RechercheVoyageur (52); 

DROP PROCEDURE IF EXISTS RechercheVoyage;      #recherche d'un voyage via son id
DELIMITER //
CREATE PROCEDURE RechercheVoyage 
(IN id_trip INT)
BEGIN
SELECT id_trip, nom_voyage
FROM Voyage
WHERE id_voyage=id_trip;
END //
DELIMITER ;

#CALL RechercheVoyage (16); 

DROP PROCEDURE IF EXISTS RechercheClients;
DELIMITER //
CREATE PROCEDURE RechercheClients (          #recherche d'un client en fonction de son id
IN id_cli INT
)
BEGIN
SELECT id_client, prenom_client, nom_client, date_naissance, genre, adresse_mail, id_livraison, id_facturation,actif
FROM Clients
WHERE id_client = id_cli;
END//
DELIMITER ;

#CALL RechercheClients (22);

DROP PROCEDURE IF EXISTS RechercheCommande;      #recherche d'une commande via son numéro
DELIMITER //
CREATE PROCEDURE RechercheCommande 
(IN n_cde INT)
BEGIN
SELECT n_commande, date_commande, id_client, id_personnel
FROM Commande
WHERE n_commande = n_cde;
END //
DELIMITER ;

#CALL RechercheCommande (26); 

DROP PROCEDURE IF EXISTS RechercheFacture;      #recherche d'une facture via son id
DELIMITER //
CREATE PROCEDURE RechercheFacture
(IN id_fact INT)
BEGIN
SELECT id_facture, tva, marge, acquittee, id_client, n_commande
FROM Facture
WHERE id_facture=id_fact;
END //
DELIMITER ;

#CALL RechercheFacture (29);

DROP PROCEDURE IF EXISTS RecherchePaiement;      #recherche d'un paiement via son id
DELIMITER //
CREATE PROCEDURE RecherchePaiement
(IN id_paie INT)
BEGIN
SELECT id_paiement, date_paiement, moyen_paiement, taux_paiement, id_facture
FROM Paiement
WHERE id_paiement=id_paie;                             #au lieu de chercher par id on peut faire par mode de paiement avec where mode_paiement Like "cheque" par exemple
END //
DELIMITER ;

#CALL RecherchePaiement (30); 

DROP PROCEDURE IF EXISTS RechercheCompose;      #recherche d'une donnée via un de ses id
DELIMITER //
CREATE PROCEDURE RechercheCompose
(IN id INT)
BEGIN
SELECT id_etape,id_voyage
FROM Compose
WHERE id_voyage=id OR id_etape=id;
END //
DELIMITER ;

#CALL RechercheCompose (12);

DROP PROCEDURE IF EXISTS RechercheCorrespond;      #recherche d'une donnée via un de ses id
DELIMITER //
CREATE PROCEDURE RechercheCorrespond
(IN id INT)
BEGIN
SELECT n_commande,id_voyage
FROM Correspond
WHERE id_voyage=id OR n_commande=id;
END //
DELIMITER ;

#CALL RechercheCorrespond (1);

DROP PROCEDURE IF EXISTS RechercheParticipe;      #recherche d'une donnée via un de ses id
DELIMITER //
CREATE PROCEDURE RechercheParticipe
(IN id INT)
BEGIN
SELECT id_voyage,id_voyageur
FROM Participe
WHERE id_voyageur=id OR id_voyage=id;
END //
DELIMITER ;

#CALL RechercheParticipe (1); 

#==================================================================================================================================================================================
#Procédure d'édition

DROP PROCEDURE IF EXISTS EditionCoordonnees;
DELIMITER //
CREATE PROCEDURE EditionCoordonnees    #procédure d'édition d'une coordonnées en fonction de son ID
(IN id_coordo INT,
IN tel_mobile VARCHAR(15))
BEGIN
SELECT id_coordonnees, num_voie, nom_rue, nom_residence, nom_batiment, etage, code_postal, ville, tel_mobile, autre_tel_1, autre_tel_2, actif
FROM Coordonnees WHERE id_coordonnees=id_coordo;
UPDATE Coordonnees
SET num_voie=num_voie
WHERE id_coordonnees=id_coordo;
SELECT id_coordonnees, num_voie, nom_rue, nom_residence, nom_batiment, etage, code_postal, ville, tel_mobile, autre_tel_1, autre_tel_2, actif
FROM Coordonnees WHERE id_coordonnees=id_coordo;
END //
DELIMITER ;

#CALL EditionCoordonnees (53,'0607030905');

DROP PROCEDURE IF EXISTS EditionPersonnel;     				# edition d'un personnel via son id
DELIMITER //
CREATE PROCEDURE EditionPersonnel  
(IN id_perso INT,
IN nom_personnel VARCHAR(50))
BEGIN
SELECT id_personnel, prenom_personnel, nom_personnel, mail_pro, date_embauche, id_coordonnees, actif
FROM Personnel WHERE id_personnel=id_perso;
UPDATE Personnel
SET nom_personnel=nom_personnel
WHERE id_personnel=id_perso ;
SELECT id_personnel, prenom_personnel, nom_personnel, mail_pro, date_embauche, id_coordonnees, actif
FROM Personnel WHERE id_personnel=id_perso;
END //
DELIMITER ;

#CALL EditionPersonnel (6, 'Pompidou');

DROP PROCEDURE IF EXISTS EditionTransport;     				# edition d'un moyen de transport via son id
DELIMITER //
CREATE PROCEDURE EditionTransport   
(IN id_transport INT,
IN prix_km FLOAT)
BEGIN
SELECT id_moyen_transport, nom_moyen_transport, nom_transporteur, prix_km, actif
FROM Moyen_transport WHERE id_moyen_transport=id_transport;
UPDATE Moyen_transport
SET prix_km=prix_km
WHERE id_moyen_transport=id_transport;
SELECT id_moyen_transport, nom_moyen_transport, nom_transporteur, prix_km, actif
FROM Moyen_transport WHERE id_moyen_transport=id_transport;
END //
DELIMITER ;

#CALL EditionTransport (11, 0.19);

DROP PROCEDURE IF EXISTS EditionEtape;     				
DELIMITER //
CREATE PROCEDURE EditionEtape       # edition d'une etape via son id
(IN id INT,
IN kilometrage FLOAT)
BEGIN
SELECT id_etape, date_depart, date_arrivee, kilometrage, id_depart, id_arrivee, id_moyen_transport
FROM Etape WHERE id_etape=id;
CALL ModifDonneeEtape (11, 145);
SELECT id_etape, date_depart, date_arrivee, kilometrage, id_depart, id_arrivee, id_moyen_transport
FROM Etape WHERE id_etape=id;
END //
DELIMITER ;

#CALL EditionEtape (11, 145);

DROP PROCEDURE IF EXISTS EditionVoyageur;     				# edition d'un voyageur via son id
DELIMITER //
CREATE PROCEDURE EditionVoyageur  
(IN id INT,
IN prenom_voyageur VARCHAR(50))
BEGIN
SELECT id_voyageur, nom_voyageur, prenom_voyageur, naissance_voyageur, genre_voyageur
FROM Voyageurs WHERE id_voyageur=id;
UPDATE Voyageurs
SET prenom_voyageur=prenom_voyageur
WHERE id_voyageur=id ;
SELECT id_voyageur, nom_voyageur, prenom_voyageur, naissance_voyageur, genre_voyageur
FROM Voyageurs WHERE id_voyageur=id;
END //
DELIMITER ;

#CALL EditionVoyageur (52, "Card");

DROP PROCEDURE IF EXISTS EditionVoyage;     				# edition d'un voyage via son id
DELIMITER //
CREATE PROCEDURE EditionVoyage   
(IN id_trip INT,
IN nom_voyage VARCHAR(50))
BEGIN
SELECT id_voyage, nom_voyage
FROM Voyage WHERE id_voyage=id_trip;
CALL ModifVoyage (16, 'Verseau');
SELECT id_voyage, nom_voyage
FROM Voyage WHERE id_voyage=id_trip;
END //
DELIMITER ;

#CALL EditionVoyage (16, 'Verseau');

DROP PROCEDURE IF EXISTS EditionClients;     				# edition d'un client via son id
DELIMITER //
CREATE PROCEDURE EditionClients  
(IN id_cli INT,
IN nom_client VARCHAR(50))
BEGIN
SELECT id_client, prenom_client, nom_client, date_naissance, genre, adresse_mail, id_livraison, id_facturation, actif
FROM Clients WHERE id_client=id_cli ;
UPDATE Clients
SET nom_client=nom_client
WHERE id_client=id_cli ;
SELECT id_client, prenom_client, nom_client, date_naissance, genre, adresse_mail, id_livraison, id_facturation, actif
FROM Clients WHERE id_client=id_cli ;
END //
DELIMITER ;

#CALL EditionClients (22, 'Muche');

DROP PROCEDURE IF EXISTS EditionCommande;     				# edition d'une commande via son n°
DELIMITER //
CREATE PROCEDURE EditionCommande   
(IN n_cde INT,
IN date_commande FLOAT)
BEGIN
SELECT n_commande, date_commande, id_client, id_personnel
FROM Commande WHERE n_commande=n_cde;
CALL ModifDonneeCommande (26, 1671838800);
SELECT n_commande, date_commande, id_client, id_personnel
FROM Commande WHERE n_commande=n_cde;
END //
DELIMITER ;

#CALL EditionCommande (26, 1671838800);

DROP PROCEDURE IF EXISTS EditionFacture;     				# edition d'une facture via son id
DELIMITER //
CREATE PROCEDURE EditionFacture  
(IN id_fact INT,
IN marge VARCHAR(50))
BEGIN
SELECT id_facture, tva, marge, acquittee, id_client, n_commande
FROM Facture WHERE id_facture=id_fact;
CALL ModifDonneeFacture(29, 0.18);
SELECT id_facture, tva, marge, acquittee, id_client, n_commande
FROM Facture WHERE id_facture=id_fact;
END //
DELIMITER ;

#CALL EditionFacture(29, 0.18);

DROP PROCEDURE IF EXISTS EditionPaiement;     				# edition d'un paiement via son id
DELIMITER //
CREATE PROCEDURE EditionPaiement  
(IN id_paie INT,
IN taux_paiement FLOAT)
BEGIN
SELECT id_paiement, date_paiement, moyen_paiement, taux_paiement, id_facture
FROM Paiement WHERE id_paiement=id_paie;
UPDATE Paiement
SET taux_paiement=taux_paiement
WHERE id_paiement=id_paie;
SELECT id_paiement, date_paiement, moyen_paiement, taux_paiement, id_facture
FROM Paiement WHERE id_paiement=id_paie;
END //
DELIMITER ;

#CALL EditionPaiement (30,0.5);

#================================================================================================================================================================================
#Procédures de suppression (dans l'ordre dans lequel les données doivent être supprimées en fonction des relations entre les tables)

DROP PROCEDURE IF EXISTS SuppParticipe;    # procédure de suppression d'une participation en fonction de ses id
DELIMITER //
CREATE PROCEDURE SuppParticipe
(IN s_id_voyage INT,
IN s_id_voyageur INT)
BEGIN 
DELETE FROM participe
WHERE id_voyage=s_id_voyage AND id_voyageur=s_id_voyageur
LIMIT 1;
END//
DELIMITER ;

#CALL SuppParticipe (1,12);
#SELECT * FROM Participe;

DROP PROCEDURE IF EXISTS SuppParticipeVoyageur;    # procédure de suppression d'une participation en fonction de l'id voyageur
DELIMITER //
CREATE PROCEDURE SuppParticipeVoyageur
(IN id INT)
BEGIN 
WHILE (Select count(*) FROM participe WHERE id_voyageur=id) > 0 do
	DELETE FROM participe WHERE id_voyageur=id LIMIT 1;
END WHILE;   
END//
DELIMITER ;

#CALL SuppParticipeVoyageur (11);
#SELECT * FROM Participe;

DROP PROCEDURE IF EXISTS SuppParticipeVoyage;    # procédure de suppression d'une participation en fonction de l'id voyageur
DELIMITER //
CREATE PROCEDURE SuppParticipeVoyage
(IN id_trip INT)
BEGIN 
WHILE (Select count(*) FROM participe WHERE id_voyage=id_trip) > 0 do
	DELETE FROM participe WHERE id_voyage=id_trip LIMIT 1;
END WHILE;   
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS SuppCorrespond;    # procédure de suppression d'une correspondance en fonction de ses id
DELIMITER //
CREATE PROCEDURE SuppCorrespond
(IN s_n_commande INT,
IN s_id_voyage INT)
BEGIN 
DELETE FROM correspond
WHERE s_id_voyage=id_voyage AND s_n_commande=n_commande
LIMIT 1;
END//
DELIMITER ;

#CALL SuppCorrespond (1,13);
#SELECT * FROM Correspond;

DROP PROCEDURE IF EXISTS SuppCorrespondCde;    # procédure de suppression d'une correspondance en fonction du n° de commande
DELIMITER //
CREATE PROCEDURE SuppCorrespondCde
(IN n_cde INT)
BEGIN 
WHILE (Select count(*) FROM correspond WHERE n_commande=n_cde) > 0 do
	DELETE FROM correspond WHERE n_commande=n_cde LIMIT 1;
END WHILE;   
END //
DELIMITER ;

#CALL SuppCorrespondCde (1);

DROP PROCEDURE IF EXISTS SuppCorrespondVoyage;    # procédure de suppression d'une correspondance en fonction de l'id voyage
DELIMITER //
CREATE PROCEDURE SuppCorrespondVoyage
(IN id_trip INT)
BEGIN 
WHILE (Select count(*) FROM correspond WHERE id_voyage=id_trip) > 0 do
	DELETE FROM correspond WHERE id_voyage=id_trip LIMIT 1;
END WHILE;   
END //
DELIMITER ;

#CALL SuppCorrespondVoyage (9);
#SELECT * FROM correspond; 

DROP PROCEDURE IF EXISTS SuppCompose;    # procédure de suppression d'une composition en fonction de ses id
DELIMITER //
CREATE PROCEDURE SuppCompose
(IN s_id_etape INT,
IN s_id_voyage INT)
BEGIN 
DELETE FROM compose
WHERE s_id_voyage=id_voyage AND s_id_etape=id_etape
;
END//
DELIMITER ;

#CALL SuppCompose (1,1);
#SELECT * FROM Compose;

DROP PROCEDURE IF EXISTS SuppComposeVoyage; 
DELIMITER //
CREATE PROCEDURE SuppComposeVoyage
(IN id_trip INT)
BEGIN 
WHILE (Select count(*) FROM compose WHERE id_voyage=id_trip) > 0 do
	DELETE FROM compose WHERE id_voyage=id_trip LIMIT 1;
END WHILE;
END //
DELIMITER ;

#CALL SuppComposeVoyage(15);
#SELECT * FROM compose;

DROP PROCEDURE IF EXISTS SuppComposeEtape; 
DELIMITER //
CREATE PROCEDURE SuppComposeEtape
(IN id_stop INT)
BEGIN 
WHILE (Select count(*) FROM compose WHERE id_etape=id_stop) > 0 do
	DELETE FROM compose WHERE id_etape=id_stop LIMIT 1;
END WHILE;
END //
DELIMITER ;

#CALL SuppComposeEtape(2);
#SELECT * FROM compose;

DROP PROCEDURE IF EXISTS SuppPaiement;    # procédure de suppression d'un paiement en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppPaiement
(IN id_paie INT)
BEGIN 
	WHILE (Select count(*) FROM Paiement WHERE id_paiement=id_paie) > 0 do
		DELETE FROM Paiement
		WHERE id_paiement=id_paie;
	END WHILE; 
END//
DELIMITER ;

#CALL SuppPaiement(20);
#SELECT * FROM Paiement;

DROP PROCEDURE IF EXISTS SuppFacture;    # procédure de suppression d'une facture en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppFacture 
(IN id_fact INT)
BEGIN 
DELETE FROM Facture
WHERE id_facture=id_fact;
END//
DELIMITER ;

#CALL SuppFacture (1);
#SELECT * FROM Facture;

DROP PROCEDURE IF EXISTS SuppFactureCascade;    # procédure de suppression en cascade d'une facture en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppFactureCascade 
(IN id_fact INT)
BEGIN
	WHILE (Select count(*) FROM Paiement WHERE id_facture=id_fact) > 0 do
		CALL SuppPaiement((SELECT id_paiement FROM Paiement WHERE id_facture=id_fact LIMIT 1));
	END WHILE;   
DELETE FROM Facture WHERE id_facture=id_fact;
END //
DELIMITER ;

#CALL SuppFactureCascade (14);
#SELECT * FROM Facture;

DROP PROCEDURE IF EXISTS SuppCommande;    # procédure de suppression d'une commande en fonction de son numéro
DELIMITER //
CREATE PROCEDURE SuppCommande
(IN n_cde INT)
BEGIN 
DELETE FROM Commande 
WHERE n_commande=n_cde;
END//
DELIMITER ;

#CALL SuppCommande (26);
#SELECT * FROM Commande;
#SELECT * FROM Facture;

DROP PROCEDURE IF EXISTS SuppCommandeCascade;    # procédure de suppression en cascade d'une commande en fonction de son numéro
DELIMITER //
CREATE PROCEDURE SuppCommandeCascade
(IN n_cde INT)
BEGIN 
WHILE (Select count(*) FROM correspond WHERE n_commande=n_cde) > 0 do
	CALL SuppCorrespondCde((SELECT (n_commande) FROM correspond  WHERE n_commande=n_cde LIMIT 1));
END WHILE;  
WHILE (Select count(*) FROM Facture WHERE n_commande=n_cde) > 0 do
	CALL SuppFactureCascade ((SELECT id_facture FROM FACTURE WHERE n_commande=n_cde));
END WHILE;
DELETE FROM Commande WHERE n_commande=n_cde;
END//
DELIMITER ;


#SELECT * FROM correspond;
#CALL SuppCommandeCascade (2);


DROP PROCEDURE IF EXISTS SuppClients; 
DELIMITER //
CREATE PROCEDURE SuppClients (
IN id_cli INT
)
BEGIN
DELETE FROM Clients 
WHERE id_client=id_cli;
END//
DELIMITER ;

#CALL SuppClients (22);
#SELECT * FROM Clients;

DROP PROCEDURE IF EXISTS SuppClientsCascade; 
DELIMITER //
CREATE PROCEDURE SuppClientsCascade (
IN id_cli INT
)
BEGIN
WHILE (Select count(*) FROM Commande WHERE id_client=id_cli) > 0 do
	CALL SuppCommandeCascade ((SELECT (n_commande) FROM Commande  WHERE id_client=id_cli LIMIT 1));
END WHILE;  
DELETE FROM Clients WHERE id_client=id_cli;
END//
DELIMITER ;

#CALL SuppClientsCascade(1);   

DROP PROCEDURE IF EXISTS SuppVoyage;    # procédure de suppression d'un voyage en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppVoyage
(IN id_trip INT)
BEGIN 
DELETE FROM Voyage 
WHERE id_voyage=id_trip;
END//
DELIMITER ;

#CALL SuppVoyage (16);
#SELECT * FROM Voyage;

DROP PROCEDURE IF EXISTS SuppVoyageCascade;    # procédure de suppression d'un voyage en cascade en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppVoyageCascade
(IN id_trip INT)
BEGIN 
	WHILE (Select count(*) FROM compose WHERE id_voyage=id_trip) > 0 do
		CALL SuppComposeVoyage((SELECT id_voyage FROM compose WHERE id_voyage=id_trip LIMIT 1));
	END WHILE; 
    WHILE (Select count(*) FROM correspond WHERE id_voyage=id_trip) > 0 do
		CALL SuppCorrespondVoyage((SELECT id_voyage FROM correspond WHERE id_voyage=id_trip LIMIT 1));
	END WHILE;
	WHILE (Select count(*) FROM participe WHERE id_voyage=id_trip) > 0 do
		CALL SuppparticipeVoyage((SELECT id_voyage FROM participe WHERE id_voyage=id_trip LIMIT 1));
	END WHILE;
DELETE FROM Voyage WHERE id_voyage=id_trip;
END //
DELIMITER ;

#CALL SuppVoyageCascade(9);
#SELECT * FROM Voyage;

DROP PROCEDURE IF EXISTS SuppVoyageur;    # procédure de suppression d'un voyageur en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppVoyageur 
(IN id INT)
BEGIN 
DELETE FROM Voyageurs
WHERE id_voyageur=id;
END//
DELIMITER ;

#CALL SuppVoyageur (52);
#SELECT * FROM Voyageurs;

DROP PROCEDURE IF EXISTS SuppVoyageurCascade;    # procédure de suppression en cascade d'un voyageur en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppVoyageurCascade 
(IN id INT)
BEGIN 
WHILE (Select count(*) FROM participe WHERE id_voyageurs=id) > 0 do
	CALL SuppParticipeVoyageur((SELECT (id_voyageur) FROM participe  WHERE id_voyageur=id LIMIT 1));
END WHILE;  
DELETE FROM Voyageurs 
WHERE id_voyageurs=id;
END//
DELIMITER ;

#CALL SuppParticipeVoyageur(17);
#SELECT * FROM participe;

DROP PROCEDURE IF EXISTS SuppEtape;    
DELIMITER //
CREATE PROCEDURE SuppEtape      # procédure de suppression d'une étape en fonction de son id
(IN id INT)
BEGIN 
DELETE FROM Etape 
WHERE id_etape=id;
END//
DELIMITER ;

#CALL SuppEtape (11);
#SELECT * FROM Etape;

DROP PROCEDURE IF EXISTS SuppEtapeCascade;    
DELIMITER //
CREATE PROCEDURE SuppEtapeCascade     # procédure de suppression en cascade d'une étape en fonction de son id
(IN id_stop INT)
BEGIN 
WHILE (Select count(*) FROM compose WHERE id_etape=id_stop) > 0 do
	CALL SuppComposeEtape((SELECT (id_etape) FROM compose  WHERE id_etape=id_stop LIMIT 1));
END WHILE;
DELETE FROM Etape 
WHERE id_etape=id_stop;
END//
DELIMITER ;

#CALL SuppEtapeCascade (10);
#SELECT * FROM Etape;
#SELECT * FROM compose;

DROP PROCEDURE IF EXISTS SuppTransport;    # procédure de suppression d'un moyen de transport en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppTransport 
(IN id_transport INT)
BEGIN 
DELETE FROM Moyen_transport 
WHERE id_moyen_transport=id_transport;
END//
DELIMITER ;

#CALL SuppTransport (11);
#SELECT * FROM Moyen_transport;

DROP PROCEDURE IF EXISTS SuppTransportCascade;    # procédure de suppression en cascade d'un moyen de transport en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppTransportCascade 
(IN id_transport INT)
BEGIN 
WHILE (Select count(*) FROM Etape WHERE id_moyen_transport=id_transport) > 0 do
	CALL SuppEtapeCascade((SELECT id_etape FROM Etape WHERE id_moyen_transport=id_transport LIMIT 1));
END WHILE;  
DELETE FROM Moyen_transport 
WHERE id_moyen_transport=id_transport;
END//
DELIMITER ;

#CALL SuppTransportCascade (5);
#SELECT * FROM Moyen_transport;

DROP PROCEDURE IF EXISTS SuppPersonnel; 
DELIMITER //
CREATE PROCEDURE SuppPersonnel (
IN id_perso INT
)
BEGIN
DELETE FROM Personnel 
WHERE id_personnel=id_perso;
END //
DELIMITER ;

#CALL SuppPersonnel (6);
#SELECT * FROM Personnel

DROP PROCEDURE IF EXISTS SuppPersonnelCascade; 
DELIMITER //
CREATE PROCEDURE SuppPersonnelCascade (
IN id_perso INT
)
BEGIN
WHILE (Select count(*) FROM Commande WHERE id_personnel=id_perso) > 0 do
	CALL SuppCommandeCascade((SELECT (n_commande) FROM Commande  WHERE id_personnel=id_perso LIMIT 1));
END WHILE;  
WHILE (Select count(*) FROM Personnel WHERE id_personnel=id_perso) > 0 do
	DELETE FROM Personnel WHERE id_personnel=id_perso LIMIT 1;
END WHILE;
END //
DELIMITER ;

#CALL SuppPersonnelCascade (1);      #les personnels sont utilisés à chaque fois dans plusieurs commande... donc ça bloque
#SELECT * FROM Personnel;
#SELECT * FROM Commande;

DROP PROCEDURE IF EXISTS SuppCoordonnees;    # procédure de suppression d'une coordonnée en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppCoordonnees 
(IN id_coordo INT)
BEGIN 
DELETE FROM Coordonnees 
WHERE id_coordonnees=id_coordo;
END//
DELIMITER ;

#CALL SuppCoordonnees (53);
#SELECT * FROM Coordonnees;

DROP PROCEDURE IF EXISTS SuppCoordonneesCascade;    # procédure de suppression en cascade d'une coordonnée en fonction de son id
DELIMITER //
CREATE PROCEDURE SuppCoordonneesCascade 
(IN id_coordo INT)
BEGIN 
WHILE (Select count(*) FROM Etape WHERE id_coordonnees=id_coordo) > 0 do
	CALL SuppEtapeCascade((SELECT (id_etape) FROM Etape  WHERE id_coordonnees=id_coordo LIMIT 1));
END WHILE;
WHILE (Select count(*) FROM Clients WHERE id_coordonnees=id_coordo) > 0 do
	CALL SuppClientsCascade((SELECT (id_cient) FROM Clients  WHERE id_coordonnees=id_coordo LIMIT 1));  
END WHILE;
WHILE (Select count(*) FROM Personnel WHERE id_coordonnees=id_coordo) > 0 do
	CALL SuppPersonnelCascade((SELECT (id_personnel) FROM Personnel  WHERE id_coordonnees=id_coordo LIMIT 1));
END WHILE;
DELETE FROM Coordonnees 
WHERE id_coordonnees=id_coordo;
END//
DELIMITER ;

#CALL SuppCoordonnees (53); #error code : 1242 Subquery returns more than 1 row  # utiliser un group by ?
#SELECT * FROM Coordonnees;