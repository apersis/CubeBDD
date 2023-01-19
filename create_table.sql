CREATE SCHEMA `bdd_voyage` ;

DROP TABLE IF EXISTS participe;
DROP TABLE IF EXISTS correspond;
DROP TABLE IF EXISTS compose;
DROP TABLE IF EXISTS Paiement;
DROP TABLE IF EXISTS Facture;
DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Voyageurs;
DROP TABLE IF EXISTS Voyage;
DROP TABLE IF EXISTS Etape;
DROP TABLE IF EXISTS Moyen_transport;
DROP TABLE IF EXISTS Personnel;
DROP TABLE IF EXISTS Coordonnees;

CREATE TABLE Coordonnees(
   id_coordonnees INT PRIMARY KEY AUTO_INCREMENT,
   num_voie INT NOT NULL,
   nom_rue VARCHAR(100) NOT NULL,
   nom_residence VARCHAR(100),
   nom_batiment VARCHAR(50),
   etage INT,
   code_postal INT NOT NULL,
   ville VARCHAR(50) NOT NULL,
   tel_mobile VARCHAR(15),
   autre_tel_1 VARCHAR(15),
   autre_tel_2 VARCHAR(15),
   actif BOOLEAN NOT NULL
);

CREATE TABLE Personnel(
   id_personnel INT PRIMARY KEY AUTO_INCREMENT,
   nom_personnel VARCHAR(50) NOT NULL,
   prenom_personnel VARCHAR(50) NOT NULL,
   mail_pro VARCHAR(100) NOT NULL,
   date_embauche INT NOT NULL,
   id_coordonnees INT NOT NULL,
   actif BOOLEAN NOT NULL,
   FOREIGN KEY(id_coordonnees) REFERENCES Coordonnees(id_coordonnees)
);

CREATE TABLE Moyen_transport(
   id_moyen_transport INT PRIMARY KEY AUTO_INCREMENT,
   nom_moyen_transport VARCHAR(50) NOT NULL,
   nom_transporteur VARCHAR(50) NOT NULL,
   prix_km FLOAT NOT NULL,
   actif BOOLEAN NOT NULL
);

CREATE TABLE Etape(
   id_etape INT PRIMARY KEY AUTO_INCREMENT,
   date_depart INT NOT NULL,
   date_arrivee INT NOT NULL,
   kilometrage FLOAT NOT NULL,
   id_depart INT NOT NULL,
   id_arrivee INT NOT NULL,
   id_moyen_transport INT NOT NULL,
   FOREIGN KEY(id_depart) REFERENCES Coordonnees(id_coordonnees),
   FOREIGN KEY(id_arrivee) REFERENCES Coordonnees(id_coordonnees),
   FOREIGN KEY(id_moyen_transport) REFERENCES Moyen_transport(id_moyen_transport)
);

CREATE TABLE Voyage(
   id_voyage INT PRIMARY KEY AUTO_INCREMENT,
   nom_voyage VARCHAR(50) NOT NULL
);

CREATE TABLE Voyageurs(
   id_voyageur INT PRIMARY KEY AUTO_INCREMENT,
   nom_voyageur VARCHAR(50) NOT NULL,
   prenom_voyageur VARCHAR(50) NOT NULL,
   naissance_voyageur VARCHAR(50) NOT NULL,
   genre_voyageur VARCHAR(1) NOT NULL
);

CREATE TABLE Clients(
   id_client INT PRIMARY KEY AUTO_INCREMENT,
   nom_client VARCHAR(50) NOT NULL,
   prenom_client VARCHAR(50) NOT NULL,
   date_naissance VARCHAR(10) NOT NULL,
   genre CHAR(1) NOT NULL,
   adresse_mail VARCHAR(100) NOT NULL,
   id_livraison INT NOT NULL,
   id_facturation INT NOT NULL,
   actif BOOLEAN NOT NULL,
   FOREIGN KEY(id_livraison) REFERENCES Coordonnees(id_coordonnees),
   FOREIGN KEY(id_facturation) REFERENCES Coordonnees(id_coordonnees)
);

CREATE TABLE Commande(
   n_commande INT PRIMARY KEY AUTO_INCREMENT,
   date_commande INT NOT NULL,
   id_client INT NOT NULL,
   id_personnel INT NOT NULL,
   FOREIGN KEY(id_client) REFERENCES Clients(id_client),
   FOREIGN KEY(id_personnel) REFERENCES Personnel(id_personnel)
);

CREATE TABLE Facture(
   id_facture INT PRIMARY KEY AUTO_INCREMENT,
   tva FLOAT NOT NULL,
   marge FLOAT NOT NULL,
   acquittee BOOLEAN NOT NULL,
   id_client INT NOT NULL,
   n_commande INT NOT NULL,
   FOREIGN KEY(id_client) REFERENCES Clients(id_client),
   FOREIGN KEY(n_commande) REFERENCES Commande(n_commande)
);

CREATE TABLE Paiement(
   id_paiement INT PRIMARY KEY AUTO_INCREMENT,
   date_paiement INT NOT NULL,
   moyen_paiement VARCHAR(10) NOT NULL,
   taux_paiement FLOAT NOT NULL,
   id_facture INT NOT NULL,
   FOREIGN KEY(id_facture) REFERENCES Facture(id_facture)
);

CREATE TABLE compose(
   id_etape INT,
   id_voyage INT,
   PRIMARY KEY(id_etape, id_voyage),
   FOREIGN KEY(id_etape) REFERENCES Etape(id_etape),
   FOREIGN KEY(id_voyage) REFERENCES Voyage(id_voyage)
);

CREATE TABLE correspond(
   n_commande INT,
   id_voyage INT,
   PRIMARY KEY(n_commande, id_voyage),
   FOREIGN KEY(n_commande) REFERENCES Commande(n_commande),
   FOREIGN KEY(id_voyage) REFERENCES Voyage(id_voyage)
);

CREATE TABLE participe(
   id_voyage INT,
   id_voyageur INT,
   PRIMARY KEY(id_voyage, id_voyageur),
   FOREIGN KEY(id_voyage) REFERENCES Voyage(id_voyage),
   FOREIGN KEY(id_voyageur) REFERENCES Voyageurs(id_voyageur)
);
