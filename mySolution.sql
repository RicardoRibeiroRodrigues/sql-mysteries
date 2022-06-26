/* Adding here my solution to the puzzle */
SELECT *
  FROM crime_scene_report
 WHERE type = 'murder' AND 
       city = 'SQL City' AND 
       date = '20180115';
       
-- The first witness lives at the last house on "Northwestern Dr".
SELECT *
  FROM person
 WHERE address_street_name = 'Northwestern Dr'
 ORDER BY address_number DESC
 LIMIT 1;
 -- R: 14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949

-- The second witness, named Annabel, lives somewhere on "Franklin Ave".
SELECT *
  FROM person
 WHERE name LIKE 'Annabel %' AND 
       address_street_name = 'Franklin Ave';
-- R: 16371	Annabel Miller	490173	103	Franklin Ave	318771143

-- Finding the interview transcript of the witnesses
SELECT p.name,
       i.transcript
  FROM interview i
       JOIN
       person p ON i.person_id = p.id
 WHERE p.id = 16371 OR 
       p.id = 14887;

/* Results
Morty Schapiro    I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
Annabel Miller    I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th. */
-- Finding the killer
SELECT p.name,
       p.id
  FROM get_fit_now_member gfnm
       JOIN
       person p ON gfnm.person_id = p.id
       JOIN
       drivers_license dl ON p.license_id = dl.id
 WHERE gfnm.id LIKE '48Z%' AND 
       dl.plate_number LIKE '%H42W%';
       -- Murderer: Jeremy Bowers	67318
       
INSERT INTO solution VALUES (1, "Jeremy Bowers");
SELECT value FROM solution;

-- Finding out the real villain behind the crime
SELECT p.name,
       i.transcript
  FROM interview i
       JOIN
       person p ON i.person_id = p.id
 WHERE p.id = 67318;
-- Transcript: "I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5"" (65"") or 5'7"" (67""). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017."
SELECT name, annual_income as income, 
gender, eye_color as eyes, hair_color as hair, height, p.id
FROM income i
JOIN person p
  ON i.ssn = p.ssn 
JOIN drivers_license dl
  ON p.license_id = dl.id
WHERE gender = 'female' AND 
    hair_color = 'red' AND 
    dl.car_model = 'Model S' AND
    height BETWEEN 65 AND 67;

-- Two suspects: (Red Korb, id: 78881) and (Miranda Priestly, id: 99716).

-- Seeing if any of those two checked in on SQL Symphony Concert 3 times in December 2017 on facebook.
SELECT name, date
FROM facebook_event_checkin fec
JOIN person p
    ON fec.person_id = p.id
WHERE fec.event_name = 'SQL Symphony Concert' AND
p.id = 78881 OR p.id = 99716;

-- Miranda Priestly checked in 3 times in december on SQL symphony, her hair color, income and car model matches. She must have hired the murder.   
INSERT INTO solution VALUES (1, "Miranda Priestly");
SELECT value FROM solution;