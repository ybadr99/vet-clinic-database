SELECT * FROM animals WHERE name LIKE '%mon';

SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-1-1' AND '2019-1-1';

SELECT * FROM animals WHERE neutered IS TRUE AND escape_attempts < 3;

SELECT name, date_of_birth FROM animals WHERE name NOT in('Agumon','Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered IS TRUE;

SELECT * FROM animals WHERE name != 'Gabumon';

SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

-- update animals
-- 1
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species='';
COMMIT;
-- 2
BEGIN;
DELETE FROM animals;
ROLLBACK;
-- 3
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-1-1';
SAVEPOINT s1;
UPDATE animals SET weight_kg = weight_kg*-1;
ROLLBACK TO s1;
UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg < 0;
COMMIT;
-- 4
SELECT count(*) FROM animals;
SELECT count(*) FROM animals WHERE escape_attempts >= 1;
SELECT avg(weight_kg) FROM animals;
SELECT max(escape_attempts) FROM animals;
SELECT max(weight_kg),min(weight_kg),species FROM animals group by species;
SELECT avg(escape_attempts),species FROM animals WHERE date_of_birth > '1999-1-1' and date_of_birth > '2000-1-1'  group by species;
