CREATE database IF NOT EXISTS brief1_sql;

-----------la création des tableaux
CREATE table project (
    projet_id int primary key AUTO_INCREMENT,
    nom_project VARCHAR(50) not null,
    description_project VARCHAR(255),
    startDate date,
    endDate date 
);


CREATE table squad (
    squad_id int primary key AUTO_INCREMENT,
    name_squad VARCHAR(50) not null,
    projet_id int,
    foreign key (projet_id) references project(projet_id)
);

CREATE TABLE Utilisateur (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    squad_id int,
    role_utilisateur VARCHAR(255) NOT NULL,
    foreign key (squad_id) references squad(squad_id),
);


CREATE table categorie (
    categorie_id int primary key AUTO_INCREMENT, 
    name_categorie VARCHAR(50) not null
);

CREATE table subCategory (
    sub_categorie_id int primary key AUTO_INCREMENT,
    categorie_id int,
    name_sub_categorie VARCHAR(50) not null,
    foreign key (categorie_id) references categorie(categorie_id)
);

CREATE table ressources (
    ressource_id int primary key AUTO_INCREMENT,
    categorie_id int,
    sub_categorie_id int,
    squad_id int,
    projet_id int, 
    name_ressource VARCHAR(255) not null,
    foreign key (categorie_id) references categorie(categorie_id),
    foreign key(sub_categorie_id) references subCategory(sub_categorie_id),
    foreign key (squad_id) references squad(squad_id),
    foreign key (projet_id) references project (projet_id)
);

-------------------les procédures pour l'insertion des données de chaque tableau

---------user
DELIMITER //
CREATE PROCEDURE CreateUser (
    p_nom VARCHAR(50),
    p_email VARCHAR(100),
    p_squad_id int,
    p_role_user VARCHAR(100)
)
BEGIN
    INSERT INTO Utilisateur (nom, email,squad_id,role_utilisateur)
    VALUES (p_nom, p_email,p_squad_id,p_role_user);
END //
DELIMITER ;

CALL CreateUser('hajar', 'hajar@gmail.com',1,'leader');
CALL CreateUser('latifa', 'latifa@gmail.com',1,'membre');
CALL CreateUser('hiba', 'hiba@gmail.com',1,'membre');
CALL CreateUser('assma', 'assma@gmail.com',2,'membre');
CALL CreateUser('chaima', 'chaima@gmail.com',2,'membre');
CALL CreateUser('ezzahra', 'ezzahra@gmail.com',2,'membre');


-----------project
DELIMITER //
create PROCEDURE CreateProject(
    p_name VARCHAR(50),
    p_description VARCHAR(255),
    p_date_debut date,
    p_date_fin date
)
BEGIN
    INSERT INTO project(nom_project,description_project,startDate,endDate)
    VALUES(p_name,p_description,p_date_debut,p_date_fin);
END //
DELIMITER;

CALL CreateProject('MyRessources', 'realiser le projet','2023-02-12','2023-02-18');
CALL CreateProject('ScrumBoard', 'realiser le projet','2023-02-12','2023-02-18');
CALL CreateProject('MySport', 'realiser ton projet ','2023-02-12','2023-02-18');
-------squad
DELIMITER //
create PROCEDURE CreateSquad (
    s_name VARCHAR(50),
    s_projet_id int
)
BEGIN
   INSERT INTO squad(name_squad,projet_id)
   VALUES(s_name,s_projet_id);
END //
DELIMITER;
CALL CreateSquad('codezilla',1);
CALL CreateSquad('dev',1);
CALL CreateSquad('codezilla',2);
CALL CreateSquad('dev',2);

------categie 
DELIMITER //
CREATE PROCEDURE CreateCategorie (
    c_name VARCHAR(50) 
)
BEGIN
    INSERT INTO categorie (name_categorie)
    VALUES (c_name);
END //
DELIMITER ;


CALL CreateCategorie('ecommerce');
CALL CreateCategorie('sport');
CALL CreateCategorie('nourriture');

------subcategorie
DELIMITER //
create PROCEDURE createSubCategory(
    sub_cat_name VARCHAR(50),
    sub_cat_id int
)
BEGIN
    INSERT INTO subCategory(name_sub_categorie,categorie_id)
    VALUES(sub_cat_name,sub_cat_id);
END //
DELIMITER;

CALL createSubCategory('vetemets',1);
CALL createSubCategory('shoes',1);
CALL createSubCategory('lait',1);

-----ressources
DELIMITER //
CREATE PROCEDURE CreateRessources(
    ressource_cat_id int,
    ressource_sub_cat_id int,
    ressource_squad_id int,
    ressource_project_id int,
    ressource_name VARCHAR(255) 
)
BEGIN
    INSERT INTO ressources(categorie_id,sub_categorie_id,squad_id,projet_id,name_ressource)
    VALUES(ressource_cat_id,ressource_sub_cat_id,ressource_squad_id,ressource_project_id,ressource_name);
END //
DELIMITER;

call CreateRessources(1,2,2,2,'W3Schools');
call CreateRessources(1,1,2,3,'sololearn');
call CreateRessources(2,2,1,1,'udemy');

---------select the project

DELIMITER //

CREATE PROCEDURE selectProject (
    IN p_squad_name VARCHAR(255)
)
BEGIN
    SELECT project.*
    FROM project
    JOIN squad ON project.projet_id = squad.projet_id
    WHERE squad.name_squad = p_squad_name;
END //

DELIMITER ;

call selectProject('codezilla')

---mettre à jour les details d'utilisateur
DELIMITER //

CREATE PROCEDURE updateUser (
    IN update_user_id INT,
    IN update_user_nom VARCHAR(255),
    IN update_user_email VARCHAR(255),
    IN update_user_sqaud_id INT,
    IN update_user_role VARCHAR(255)
)
BEGIN 
    UPDATE Utilisateur SET nom = update_user_nom, email = update_user_email, squad_id=update_user_sqaud_id, role_utilisateur =update_user_role
    WHERE user_id = update_user_id;
END //

DELIMITER ;
call updateUser(4,'meryam','meryam@gmail.com',1,'membre')

--mettre à jour les details du squad 
DELIMITER //

CREATE PROCEDURE updateSquad (
    IN update_squad_id INT,
    IN update_squad_nom VARCHAR(255),
    IN update_squad_project VARCHAR(255)
 
)
BEGIN 
    UPDATE squad SET name_squad = update_squad_nom, projet_id = update_squad_project
    WHERE squad_id = update_squad_id;
END //

DELIMITER ;
call updateSquad(1,'dev',1)

--mettre à jour les details du projet
DELIMITER //

CREATE PROCEDURE updateProject (
    IN update_project_id INT,
    IN update_project_nom VARCHAR(255),
    IN update_project_description VARCHAR(255),
    IN update_project_startDate date,
    IN update_project_endDate date
)
BEGIN 
   UPDATE project SET nom_project= update_project_nom, description_project= update_project_description, startDate= update_project_startDate, endDate= update_project_endDate
   WHERE projet_id=update_project_id;
END //

DELIMITER ;

call updateProject(3,'Amazon','realiser interface utilisateur','2023-06-12','2023-06-18')


--mettre à jour les details du projet
DELIMITER //

CREATE PROCEDURE updateRessources (
    IN update_Ressource_id INT,
    IN update_Ressource_categorie_id INT,
    IN update_Ressource_sub_categorie_id INT,
    IN update_Ressource_squad_id INT,
    IN update_Ressource_projet_id INT,
    IN update_Ressource_name_ressource VARCHAR(255)

)
BEGIN 
   UPDATE ressources SET categorie_id= update_Ressource_categorie_id, sub_categorie_id= update_Ressource_sub_categorie_id, squad_id= update_Ressource_squad_id, projet_id= update_Ressource_projet_id, name_ressource=update_Ressource_name_ressource
   WHERE ressource_id= update_Ressource_id;
END //

DELIMITER ;
 
call updateRessources(1,1,1,2,2,'WayToLearnX')