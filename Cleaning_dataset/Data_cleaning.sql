CREATE TABLE unclean_data(movie_title varchar(50), num_critics_for_reviews int, duration int, DIRECTOR_facebook_likes int, actor_3_facebook_likes int, ACTOR_1_facebook_likes int, gross int, num_voted_users int, Cast_Total_facebook_likes int,
facenumber_in_poster int, num_user_for_reviews int, budget int, title_year int, ACTOR_2_facebook_likes int, imdb_score int);

INSERT INTO unclean_data(movie_title, num_critics_for_reviews , duration, DIRECTOR_facebook_likes, actor_3_facebook_likes, ACTOR_1_facebook_likes, gross, num_voted_users, Cast_Total_facebook_likes,
facenumber_in_poster, num_user_for_reviews, budget, title_year, ACTOR_2_facebook_likes, imdb_score) VALUES('Avatar?ÿ',723,178,10,855,1000,760505847,886204,4834,NULL,3054,237000000,2009,936,7.9);

INSERT INTO unclean_data(movie_title, num_critics_for_reviews , duration, DIRECTOR_facebook_likes, actor_3_facebook_likes, ACTOR_1_facebook_likes, gross, num_voted_users, Cast_Total_facebook_likes,
facenumber_in_poster, num_user_for_reviews, budget, title_year, ACTOR_2_facebook_likes, imdb_score)
VALUES("Pirates of the Caribbean: At World's End?ÿ",302,NULL,563,1000,40000,309404152,471220,48350,NULL,1238,300000000,2007,5000, 7.1),
("Spectre?ÿ",602,148,20,161,11000,200074175,275868,11700,1,994,245000000,2015,393,6.8),
("The Dark Knight Rises?ÿ",813,NULL,22000,23000,27000,448130642,1144337,106759,NULL,2701,250000000,2012,23000,8.5),
("John Carter?ÿ",462,132,"475",530,640,73058679,212204,1873,1,738,263700000,2012,632,6.6),
("Spider-Man 3?ÿ",392,156,23,4000,24000,336530303,383056,46055,NULL,1902,258000000,2007,11000,6.2),
("Tangled?ÿ",324,NULL,15,284,799,200807262,294810,NULL,1,387,260000000,2010,553,7.8),
("Avengers: Age of Ultron?ÿ",635,141,10,19000,26000,458991599,462669,92000,4,1117,250000000,2015,21000,7.5),
("Avengers: Age of Ultron?ÿ",635,141,10,19000,26000,458991599,462669,92000,4,1117,250000000,2015,21000,7.5),
("Harry Potter and the Half-Blood Prince?ÿ",375,153,282,10000,25000,301956980,321795,58753,3,973,250000000,2009,11000,7.5),
("Batman v Superman: Dawn of Justice?ÿ",673,183,NULL,2000,15000,330249062,NULL,24450,NULL,3018,250000000,2016,NULL,6.9),
("Superman Returns?ÿ",434,169,NULL,903,18000,200069408,240396,NULL,2,2367,209000000,2006,10000,6.1),
("Quantum of Solace?ÿ",403,106,395,393,451,168368427,330784,2023,1,1243,200000000,2008,412,6.7),
("Pirates of the Caribbean: Dead Man's Chest?ÿ",313,151,563,1000,40000,423032628,522040,48486,2,1832,225000000,2006,5000,7.3);

	



SELECT * FROM unclean_data;

CREATE TABLE clean_data(
SELECT * FROM unclean_data);

SELECT * FROM clean_data;

-- REMOVING THE DUPLICATE ROWS FORM THE TABLE

WITH duplicate_cte AS(
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY movie_title, num_critics_for_reviews , duration, DIRECTOR_facebook_likes, actor_3_facebook_likes, ACTOR_1_facebook_likes, gross, num_voted_users, Cast_Total_facebook_likes,
facenumber_in_poster, num_user_for_reviews, budget, title_year, ACTOR_2_facebook_likes, imdb_score) AS row_num
FROM clean_data
)

SELECT * FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `clean_data1` (
  `movie_title` varchar(50) DEFAULT NULL,
  `num_critics_for_reviews` int DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `DIRECTOR_facebook_likes` int DEFAULT NULL,
  `actor_3_facebook_likes` int DEFAULT NULL,
  `ACTOR_1_facebook_likes` int DEFAULT NULL,
  `gross` int DEFAULT NULL,
  `num_voted_users` int DEFAULT NULL,
  `Cast_Total_facebook_likes` int DEFAULT NULL,
  `facenumber_in_poster` int DEFAULT NULL,
  `num_user_for_reviews` int DEFAULT NULL,
  `budget` int DEFAULT NULL,
  `title_year` int DEFAULT NULL,
  `ACTOR_2_facebook_likes` int DEFAULT NULL,
  `imdb_score` int DEFAULT NULL,
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM clean_data1;

INSERT INTO clean_data1(
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY movie_title, num_critics_for_reviews , duration, DIRECTOR_facebook_likes, actor_3_facebook_likes, ACTOR_1_facebook_likes, gross, num_voted_users, Cast_Total_facebook_likes,
facenumber_in_poster, num_user_for_reviews, budget, title_year, ACTOR_2_facebook_likes, imdb_score) AS row_num
FROM clean_data
);


DELETE FROM clean_data1
WHERE row_num > 1;

SELECT * FROM clean_data1
WHERE row_num > 1;


-- STANDARDIZING DATA
SELECT DISTINCT(movie_title), TRIM('?ÿ' FROM movie_title) FROM clean_data1;

UPDATE  clean_data1
SET movie_title = TRIM('?ÿ' FROM movie_title);

SELECT *
FROM clean_data1;
