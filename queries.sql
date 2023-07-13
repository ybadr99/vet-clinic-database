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
-- How many animals are there?
SELECT count(*) FROM animals;
-- How many animals have never tried to escape?
SELECT count(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT avg(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, COUNT(*) AS escape_count
FROM animals
WHERE escape_attempts > 0;
-- What is the minimum and maximum weight of each type of animal?
SELECT max(weight_kg),min(weight_kg),species FROM animals group by species;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT avg(escape_attempts),species FROM animals WHERE date_of_birth > '1999-1-1' and date_of_birth > '2000-1-1'  group by species;


-- [] JOIN queries :
-- What animals belong to Melody Pond?
SELECT * FROM animals INNER JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name='Melody Pond';
-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.* FROM animals
LEFT JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name AS owner_name , animals.name AS animal_name
FROM owners
INNER JOIN animals ON owners.id = animals.owner_id; 
-- How many animals are there per species?
SELECT species.name, count(*) FROM animals
INNER JOIN species ON animals.species_id = species.id GROUP BY species.name;
-- List all Digimon owned by Jennifer Orwell.
SELECT * FROM animals 
INNER JOIN owners ON animals.owner_id = owners.id
INNER JOIN species ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT * FROM animals 
INNER JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
-- Who owns the most animals?
SELECT owners.full_name, COUNT(*) FROM animals 
INNER JOIN owners ON animals.owner_id = owners.id GROUP BY owners.full_name;