CREATE DATABASE IF NOT EXISTS vite_et_gourmand;
USE vite_et_gourmand;

CREATE TABLE utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    telephone VARCHAR(20),
    adresse TEXT,
    role ENUM('utilisateur', 'employe', 'admin') DEFAULT 'utilisateur',
    actif TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);CREATE TABLE menus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    theme ENUM('noel', 'paques', 'classique', 'evenement') NOT NULL,
    regime ENUM('vegetarien', 'vegan', 'classique') NOT NULL,
    personnes_min INT NOT NULL,
    prix DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);CREATE TABLE plats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    type ENUM('entree', 'plat', 'dessert') NOT NULL
);CREATE TABLE allergenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
);CREATE TABLE menu_plats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    menu_id INT NOT NULL,
    plat_id INT NOT NULL,
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE,
    FOREIGN KEY (plat_id) REFERENCES plats(id) ON DELETE CASCADE
);

CREATE TABLE plat_allergene (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plat_id INT NOT NULL,
    allergene_id INT NOT NULL,
    FOREIGN KEY (plat_id) REFERENCES plats(id) ON DELETE CASCADE,
    FOREIGN KEY (allergene_id) REFERENCES allergenes(id) ON DELETE CASCADE
);CREATE TABLE images_menu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    menu_id INT NOT NULL,
    url VARCHAR(255) NOT NULL,
    ordre INT DEFAULT 0,
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE
);
CREATE TABLE commandes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    menu_id INT NOT NULL,
    nb_personnes INT NOT NULL,
    adresse_prestation TEXT NOT NULL,
    ville VARCHAR(255) NOT NULL,
    date_prestation DATE NOT NULL,
    heure_prestation TIME NOT NULL,
    prix_menu DECIMAL(10,2) NOT NULL,
    prix_livraison DECIMAL(10,2) DEFAULT 0,
    reduction DECIMAL(10,2) DEFAULT 0,
    prix_total DECIMAL(10,2) NOT NULL,
    statut ENUM('en_attente', 'accepte', 'en_preparation', 'en_livraison', 'livre', 'attente_materiel', 'termine', 'annule') DEFAULT 'en_attente',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
    FOREIGN KEY (menu_id) REFERENCES menus(id)
);CREATE TABLE suivi_commande (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commande_id INT NOT NULL,
    statut VARCHAR(100) NOT NULL,
    motif TEXT,
    mode_contact VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (commande_id) REFERENCES commandes(id) ON DELETE CASCADE
);

CREATE TABLE avis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    commande_id INT NOT NULL,
    note INT CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    valide TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
    FOREIGN KEY (commande_id) REFERENCES commandes(id)
);-- Données de test

-- Utilisateurs
INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, telephone, adresse, role) VALUES
('Dupont', 'Julie', 'julie@vite-gourmand.fr', '$2y$10$hashedpassword1', '0601020304', '1 rue de Bordeaux, 33000 Bordeaux', 'admin'),
('Martin', 'José', 'jose@vite-gourmand.fr', '$2y$10$hashedpassword2', '0605060708', '1 rue de Bordeaux, 33000 Bordeaux', 'employe'),
('Durand', 'Pierre', 'pierre@test.fr', '$2y$10$hashedpassword3', '0610111213', '5 avenue des Tests, 33000 Bordeaux', 'utilisateur');

-- Allergènes
INSERT INTO allergenes (nom) VALUES
('Gluten'),
('Lactose'),
('Oeufs'),
('Soja'),
('Fruits à coque');

-- Menus
INSERT INTO menus (titre, description, theme, regime, personnes_min, prix, stock) VALUES
('Menu Italien', 'Salade burrata, pâtes carbonara et tiramisu maison', 'classique', 'classique', 2, 25.00, 10),
('Menu Végétarien', 'Galette végétale, légumes grillés et salade de fruits', 'classique', 'vegetarien', 1, 18.00, 8),
('Menu Fête', 'Plat surprise, dessert et coupe de champagne', 'evenement', 'classique', 4, 45.00, 5);

-- Plats
INSERT INTO plats (nom, type) VALUES
('Salade burrata', 'entree'),
('Pâtes carbonara', 'plat'),
('Tiramisu maison', 'dessert'),
('Galette végétale', 'plat'),
('Salade de fruits', 'dessert');