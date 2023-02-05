-- 1) créer un nouveau modèle appelé COVID 

create database COVID; 

-- 2)  créer 2 tables 

use COVID; 
create table VACCINAL (
cléVAC int(4) not null auto_increment,
Nom varchar(17),
Prénom varchar(20),
Dose varchar(10),
nombredose int(5),
nombretest int(12),
primary key (cléVAC)
);


create table NAME (
clépos varchar(20),
ID_pos int(4),
Code_postal varchar(20),
commune varchar(20),
subvention int(250),
catégoriesocio varchar(20),
primary key (clépos)
);

-- 3) insérer des valeurs dans les tables ( 10 entreprises ) 

insert into VACCINAL (Nom, Prénom, Dose, nombretest, nombredose) values ('Feriani', 'Younas', 'pfizer', '5', '3'),
 ('Sawsana','Zimouche','moderna', 10, 2),
('Berrannoum', 'Rita','ARN', 1, 0),
('UNG','Laura','pfizer', 0, 4),
('Thibault','Alliot','moderna', 6, 0),
('Nastar','Felix','ARN', 7, 0),
('Cheron', 'Thomas','moderna', 9, 1),
('Abdelli','Nour','pfizer', 3, 1),
('Sellan','Edna','ARN', 6, 2),
('Helou','Jeremy','moderna', 8, 0);


insert into NAME (clépos, Id_pos, Code_postal, commune, subvention, catégoriesocio) values ('N1', '1', '951000', 'Argenteuil', '100','cadre'),
 ('N2', 2, 92500,'Courbevoie', 80, 'non cadre'),
('N3', 3, 92000, 'Nanterre', 0, 'retraite'),
('N4', 4, 75010,'Paris', 150, 'cadre'),
('N5', 5, 75013,'Paris', 0, 'non cadre'),
('N6', 6, 95100,'Argenteuil', 50, 'retraite'),
('N7', 7, 92400, 'Courbevoie', 50, 'cadre'),
('N8', 8, 92000,'Nanterre', 50,'non cadre'),
('N9', 9, 75010, 'Paris', 100, 'retraite'),
('N10', 10, 75013,'Paris',0, 'cadre');

select*from VACCINAL;
select*from NAME;

-- on effectue un tri alphanumérique, car on remarque que le N10 est au-dessus du N2 

create table NAME1 as 
select * from NAME ORDER BY ID_pos asc;

select*from NAME1;

-- 4) supprimer la dernière ligne de la table Name 

SET sql_safe_updates = 0;
delete from NAME1 WHERE clépos='N10';

-- 5) Augmenter toutes les subventions d'un euro 

SET sql_safe_updates = 0;
Update NAME1 set subvention = subvention+1;

-- 6)  Diminuer de 10 le nombretest et nommer nombretest2

 update VACCINAL set nombretest = nombretest -10 where nombretest>0;

alter table VACCINAL change nombretest nombretest2 int;

select*from NAME1;

-- 7) Calculer la moyenne des doses. Calculer la moyenne des doses en fonction de la dose.

Select *, round(avg(nombredose)) as "moyenne_doses" from VACCINAL;

SELECT Dose, round(avg(nombredose)) as Moyenne_dose2
 FROM VACCINAL group by dose;

create table Moyenne as 
SELECT Dose, round(avg(nombredose)) as Moyenne_dose2
 FROM VACCINAL group by dose;
 
 select*from moyenne;
 
-- 8) Créer une variable pass qui attribue « oui » si le nombre de dose est supérieur ou égale à 2 sinon « non »

create table nombre_dose as select *,
case when nombredose>=2 then 'OUI'
when nombredose<2 then 'NON'
end as PASS from VACCINAL;

Select*from nombre_dose;

-- 9) Calculer le pourcentage de personne ayant le pass  comparativement à 100

select PASS, round(count(PASS)*100/(select count(*) from nombre_dose)) as pourcentage
from nombre_dose  group by PASS;

-- 10) Ajouter une colonne Age dans la table client et insérer des valeurs dans la table Name aléatoirement

alter table NAME1 add column age int(20);

update NAME1 set age = floor(24 + rand() * 25) where ID_pos<=10;

select*from NAME1;

-- 11) Ajouter une colonne sexe dans la table client et insérer des valeurs dans la table VACCINAL aléatoirement

alter table NAME1 add column sexe int(20);

# Homme = 1 et femme = 2 #
update NAME1 set sexe = floor(1 + rand() * 2) where ID_pos<=10;

-- 12) Changer le nom de CléVAC en identifiant.

alter table VACCINAL change column cléVAC Identifiant int;

select*from VACCINAL;

-- 13) Créer une variable classe qui donne des classes d’âge ([0-30],[30,60],[60,90])

# code pour affiher 
select * from NAME1 where age between 0 and 30;
select * from NAME1 where age between 30 and 60;
select* from NAME1 where age between 60 and 90;

# code pour illustrer :
Alter table NAME1
ADD CLASSE varchar(20);

select * from NAME1;
UPDATE NAME1 SET CLASSE = CASE
	when age >= 0 and age<=30 then "[0-30]"
    when age >= 30 and age<=60 then "[30,60]"
	when age >= 60 and age<=90 then "[60,90]"
    else "Non défini"
	END;

-- 14) Définissez le max et le min des doses dans la table VACCINAL

select  max(Nombredose)as max,min(Nombredose) as min, Dose
from Vaccinal
group by Dose;

-- 15) Créer la colonne Name1 qui met en majuscule le nom (vous pouvez les créer une nouvelle table pour répondre à cette question)

create table VACCINAL2 as 
select*, upper(NOM) as NAME1 from VACCINAL;

select*from VACCINAL2;

-- 16) Créer la colonne surname qui met en minuscule le prénom

create table VACCINAL3
select*, lower(Prénom) as surname from VACCINAL2;

select*from VACCINAL3;

-- 17) Créer la colonne come qui est la concaténation du nom et du prénom (vous pouvez les créer une nouvelle table pour répondre à cette question)

CREATE table Concaténation
select *, concat(NAME1, ' ',surname) as come from VACCINAL3;

select*from concaténation;

-- 18) Créer la colonne prod qui reprend les 5 dernières lettres du prénom (utiliser la fonction substr)

Alter table concaténation
ADD column prod varchar(20);

update concaténation set prod = substr(Prénom, -5);

-- 19) Faites une mise à jour de la table NAME et rajouter 100 euros  la subvention des 5 premières lignes

Update NAME1 set subvention = subvention+100 limit 5;

select*from NAME1;

-- 20)  Faire une jointure de la table VACCINAL et NAME (FULL dans une table nommé VACCINATION)

create table VACCINATION as 
SELECT * FROM concaténation FULL JOIN NAME1 ON identifiant =ID_pos;
 
select*from vaccination;

-- 21) Bonus : Vérifier qu’il n’ait pas de doublons 

select count(Identifiant) as Doublon, Identifiant from vaccination group by Identifiant;

# Il n'y a pas de doublons car il y a des 1 partout#