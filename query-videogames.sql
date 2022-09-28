--QUERY TABELLA SINGOLA

-- 1 selezionare tutte le software house americane (3)
SELECT *
FROM software_houses
WHERE country = 'United States';

-- 2 - selezionare tutti i giocatori della citta' di Rogahnland (2)
SELECT *
FROM players
WHERE city = 'Rogahnland';

-- 3- selezionare tutti i giocatori il cui nome finisce per 'a' (200)
SELECT *
FROM players
WHERE name like '%a'; --qualsiasi pattern che finisce con a

-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT *
FROM reviews
WHERE player_id = 800;

--5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT COUNT(id) as 'numero_tornei'
FROM tournaments
WHERE year = 2015;

-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT *
FROM awards
WHERE description like '%facere%';

--7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT videogame_id
FROM category_videogame
WHERE category_id = 2 OR category_id = 6
GROUP BY videogame_id;

-- 8-Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT *
FROM reviews 
WHERE 2<= rating AND rating <= 4;

-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT *
FROM videogames
WHERE release_date BETWEEN '01/01/2020' AND '12/31/2020';

--10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT videogame_id
FROM reviews
WHERE rating >=5
GROUP BY videogame_id;

-- 11-selezionare il numero e la media delle recensioni per il videogioco con ID=442
SELECT COUNT(id) AS numero_reviews,AVG(rating) as voto_medio
FROM reviews
WHERE videogame_id = 412;

-- 12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
SELECT COUNT(id) as numero_videogiochi
FROM videogames
WHERE software_house_id = 1 and release_date BETWEEN '01/01/2018' AND '12/31/2018';

--QUERY GROUP BY
-- 1- Contare quante software house ci sono per ogni paese (3)
SELECT count(id) as numero_software_house,country
FROM software_houses
GROUP BY country;

--2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT COUNT(id) as numero_recensioni
FROM reviews
GROUP BY videogame_id

-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
SELECT pegi_label_id
FROM pegi_label_videogame
GROUP BY pegi_label_id

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT COUNT(*) AS "COUNT", YEAR(videogames.release_date) as "rilascio"
FROM videogames
GROUP BY YEAR(release_date);

-- 5-Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT COUNT(device_videogame.videogame_id) as numero_videogiochi
FROM device_videogame
GROUP BY device_videogame.device_id;

-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT AVG(rating) as media_voto_videogioco 
FROM reviews
GROUP BY videogame_id;

-- QUERY CON JOIN
--1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996) // corretto
SELECT players.id
FROM players 
INNER JOIN reviews
ON players.id = reviews.player_id
GROUP BY players.id;

--2- Selezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226) 
SELECT videogames.name as nome_videogioco
FROM videogames
LEFT JOIN tournament_videogame
ON  videogames.id = tournament_videogame.videogame_id
LEFT JOIN tournaments
ON tournament_videogame.tournament_id = tournaments.id
WHERE tournaments.year = 2016
GROUP BY videogames.name;

-- 3- Mostrare le categorie di ogni videogioco (1718) //corretto
SELECT  videogames.name
FROM videogames
LEFT JOIN category_videogame
ON videogames.id = category_videogame.videogame_id;

--4 Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT software_houses.id , software_houses.city as 'citta', software_houses.name --etc.....
FROM software_houses
LEFT JOIN videogames
ON software_houses.id = videogames.software_house_id
WHERE release_date >= '01/01/20'
GROUP BY software_houses.id, software_houses.city,software_houses.name;

-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55) // da fixare
SELECT awards.name ,videogames.name , software_houses.name
FROM awards
LEFT JOIN award_videogame
ON awards.id = award_videogame.award_id
LEFT JOIN videogames
ON videogames.id = award_videogame.videogame_id
LEFT JOIN software_houses
ON software_houses.id = videogames.software_house_id
GROUP BY awards.name , videogames.name, software_houses.name;


--6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
--SELECT *
--FROM videogames
--LEFT JOIN reviews 
--ON videogames.id = reviews.videogame_id
--WHERE reviews.rating = 4 OR reviews.rating = 5;

--7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT	videogames.name
FROM videogames
LEFT JOIN tournament_videogame
ON videogames.id = tournament_videogame.videogame_id
LEFT JOIN player_tournament
ON tournament_videogame.tournament_id =player_tournament.tournament_id
LEFT JOIN players
ON players.id = player_tournament.player_id
WHERE players.name LIKE 'S%'
GROUP BY videogames.name;

--8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT tournaments.city
FROM videogames
JOIN award_videogame 
    ON videogames.id = award_videogame.videogame_id
JOIN tournament_videogame  
    ON videogames.id = tournament_videogame.videogame_id
JOIN tournaments
    ON tournament_videogame.tournament_id = tournaments.id
JOIN awards
    ON awards.id = award_videogame.award_id
WHERE award_videogame.year = 2018 and awards.name = 'Gioco dell''anno'
GROUP BY tournaments.city;

-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
SELECT *
FROM players
JOIN player_tournament
ON player_tournament.player_id = players.id
JOIN tournaments
ON tournaments.id = player_tournament.tournament_id
JOIN tournament_videogame
ON tournament_videogame.tournament_id = tournaments.id
JOIN videogames
ON tournament_videogame.videogame_id = videogames.id
JOIN award_videogame
ON award_videogame.videogame_id = videogames.id
JOIN awards
ON awards.id = award_videogame.award_id
WHERE tournaments.year = 2019 and awards.name ='Gioco più atteso' and award_videogame.year = 2018;