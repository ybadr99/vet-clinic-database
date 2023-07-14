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
LEFT JOIN animals ON owners.id = animals.owner_id; 
-- How many animals are there per species?
SELECT species.name, COUNT(*) FROM animals
INNER JOIN species ON animals.species_id = species.id
INNER JOIN owners ON animals.owner_id = owners.id
GROUP BY species.name;
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




-- Who was the last animal seen by William Tatcher?
SELECT animals.name from animals 
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'William Tatcher' ORDER BY date_of_visit DESC LIMIT 1;
-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animals.name) from animals 
INNER JOIN visits ON animals.id = visits.animal_id
INNER JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'Stephanie Mendez';
-- List all vets and their specialties, including vets with no specialties.
SELECT * FROM vets 
LEFT JOIN specializations ON specializations.vets_id = vets.id
LEFT JOIN species ON species.id = specializations.species_id;
-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name from animals 
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'Stephanie Mendez' AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';
-- What animal has the most visits to vets?
SELECT animals.name,  COUNT(visits.animal_id) AS visit_count FROM visits
JOIN animals ON animals.id = visits.animal_id GROUP BY animals.name ORDER BY visit_count DESC LIMIT 1;
-- Who was Maisy Smith's first visit?
SELECT animals.name from animals 
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name LIKE 'Maisy%' ORDER BY date_of_visit ASC LIMIT 1;
-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.*, vets.*, date_of_visit FROM visits
JOIN animals ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vets_id ORDER BY date_of_visit DESC LIMIT 1;
-- How many visits were with a vet that did not specialize in that animal's species?
SELECT * FROM visits 
LEFT JOIN vets ON vets.id = visits.vets_id
LEFT JOIN specializations ON specializations.vets_id = vets.id;


SELECT * FROM vets 
LEFT JOIN specializations ON specializations.vets_id = vets.id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.