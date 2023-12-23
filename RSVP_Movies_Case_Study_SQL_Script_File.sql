USE imdb;

SHOW VARIABLES LIKE 'sql_mode';
SET sql_mode = '';

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
 
-- --------------------------------------------------------------------------------------------------------------------------------
-- SEGMENT 1 : 
-- --------------------------------------------------------------------------------------------------------------------------------

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Total_rows_Movie = 7997
SELECT COUNT(*) AS Total_rows_Movie FROM movie ;

-- Total_rows_genre = 14662
SELECT COUNT(*) AS Total_rows_genre FROM genre ;

-- Total_rows_names = 25735
SELECT COUNT(*) AS Total_rows_names FROM names ;

-- Total_rows_ratings = 7997
SELECT COUNT(*) AS Total_rows_ratings FROM ratings ;

-- Total_rows_role_mapping = 15615
SELECT COUNT(*) AS Total_rows_role_mapping FROM role_mapping ;

-- Total_rows_director_mapping = 3867
SELECT COUNT(*) AS Total_rows_director_mapping FROM director_mapping ;


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Four columns - Country (20), Worldwide gross income (3724), Languages(194), Production company(528) have null values

SELECT SUM(CASE 
				WHEN id IS NULL THEN 1 
                ELSE 0 
		   END) AS id_null_count, 
	   SUM(CASE 
				WHEN title IS NULL THEN 1 
                ELSE 0 
		   END) AS title_null_count, 
		SUM(CASE 
				WHEN year IS NULL THEN 1 
                ELSE 0 
			END) AS year_null_count, 
	   SUM(CASE 
				WHEN date_published IS NULL THEN 1 
                ELSE 0 
			END) AS date_published_null_count, 
	   SUM(CASE 
				WHEN duration IS NULL THEN 1 
                ELSE 0 
			END) AS duration_null_count,
	   SUM(CASE 
				WHEN country IS NULL THEN 1 
                ELSE 0 
			END) AS country_null_count,
	   SUM(CASE 
				WHEN worlwide_gross_income IS NULL THEN 1 
                ELSE 0 
			END) AS worlwide_gross_income_null_count,
	   SUM(CASE 
				WHEN languages IS NULL THEN 1 
                ELSE 0 
			END) AS languages_nulls,
	   SUM(CASE 
				WHEN production_company IS NULL THEN 1 
                ELSE 0 
			END) AS production_company_nulls 
FROM movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year.
 
-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total Movies per year -- 2017 - 3052 
--                          2018 - 2944
--                          2019 - 2001
-- Highest number of movies were released in 2017

SELECT year AS Year, 
	   COUNT(id) AS number_of_movies 
FROM movie 
GROUP BY Year
ORDER BY Year;

-- Top three months are March, September, January
SELECT MONTH(date_published) AS month_num, 
	   COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


-- Total 1059 movies were produced by either INDIA or USA in the year 2019.

SELECT year AS Year,
	   COUNT(id) AS Movies_count
FROM movie
WHERE (country like '%INDIA%' OR 
	  country like '%USA%') AND 
      year = 2019;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


-- Total 13 unique genres are present in the dataset.

SElECT DISTINCT(genre) AS Unique_Genre_Names
FROM genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- 'DRAMA' (total movie count = 4285) had the highest number of movies produced overall.

SELECT genre AS Genre_Name,
	   COUNT(m.id) as Movie_count
FROM genre AS g
	 INNER JOIN movie AS m
     ON g.movie_id = m.id
GROUP BY Genre_Name
ORDER BY Movie_count DESC;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Total 3289 movies belong to only one genre

WITH single_genre AS (
	SELECT movie_id, COUNT(genre) AS movie_genre_count
	FROM genre 
	GROUP BY movie_id
	HAVING movie_genre_count = 1
    )
SELECT COUNT(movie_id) AS single_genre_movie_count
FROM single_genre;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Action with average duration 112.88 mins is on top of the list following by Romance with 109.53 mins.

SELECT genre AS genre,
	   ROUND(AVG(m.duration),2) AS avg_duration
FROM genre AS g 
	 INNER JOIN movie AS m 
	 ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Thriller movies has rank 3 with total 1484 movies produced in that genre.

SELECT genre AS Genre_Name,
	   COUNT(m.id) as Movie_count,
       RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank 
FROM genre AS g
	 INNER JOIN movie AS m
     ON g.movie_id = m.id
GROUP BY Genre_Name
ORDER BY Movie_count DESC;

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- ---------------------------------------------------------------------------------------------------------------------------------
-- SEGMENT 2:
-- ---------------------------------------------------------------------------------------------------------------------------------

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- min avg rating = 1.0
-- max avg rating = 10.0
-- min total votes = 100
-- max total votes = 725138
-- min median rating = 1
-- max median rating = 10

SELECT MIN(avg_rating) AS min_avg_rating,
	   MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
	   MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
	   MAX(median_rating) AS max_median_rating
        
FROM ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- top ten movies are as follows ,
-- Kirket, Love in Kilnerry, Gini Helida Kathe, Runam, Fan, Android Kunjappan Version 5.25, Yeh Suhaagraat Impossible, Safe, The Brighton Miracle, Shibu
WITH movie_ranks AS (
		SELECT m.title AS title,
			   r.avg_rating AS avg_rating,
			   DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
		FROM ratings AS r
			 INNER JOIN movie AS m 
			 ON m.id = r.movie_id
		)
     SELECT * 
     FROM movie_ranks 
     WHERE movie_rank <= 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Most of the movies have median rating either 6, 7 or 8. 
-- Total 1975 movies with 6 median ratings
-- 2257 movies with 7 median ratings
-- 1030 movies with 8 median ratings

SELECT r.median_rating AS median_rating,
		COUNT(m.id) AS movie_count
FROM ratings AS r
		INNER JOIN movie AS m
		ON m.id = r.movie_id
GROUP BY median_rating
ORDER BY median_rating;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

-- Dream warrior pictures and National Theatre Live has produced same 3 hit movies with average rating more than 8.

SELECT production_company AS production_company,
		COUNT(id) AS movie_count,
		DENSE_RANK() OVER (ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM movie AS m
		INNER JOIN ratings AS r
		ON r.movie_id = m.id
WHERE r.avg_rating > 8  
		AND production_company IS NOT NULL
GROUP BY production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes

WITH movies_released_march17_USA AS 
		( SELECT g.genre AS genre, m.id AS movie_id
		  FROM genre AS g
				INNER JOIN movie AS m
				ON m.id = g.movie_id
				INNER JOIN ratings AS r
				ON r.movie_id = m.id
		  WHERE m.year = 2017 
				AND MONTH(date_published) = 3 
				AND country LIKE '%USA%' 
				AND r.total_votes > 1000
		)
SELECT genre ,
		COUNT(movie_id) AS movie_count
FROM movies_released_march17_USA
GROUP BY genre
ORDER BY movie_count DESC;
                                        
                                        
-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
               
-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.
-- All the movies belong to the top 3 genres.
    
-- using Average rating      
SELECT title AS title,
       avg_rating AS avg_rating,
       genre AS genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
GROUP BY title
ORDER BY avg_rating DESC;


-- using Median rating 
SELECT title AS title,
       median_rating AS median_rating,
       genre AS genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  median_rating > 8
       AND title LIKE 'THE%'
GROUP BY title
ORDER BY median_rating DESC;


-- ---------------------------------------------------------------------------------------------------------------------------------
-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- Total 361 movies were released between 1 April 2018 and 1 April 2019 with a median rating of 8.

SELECT median_rating AS median_rating , 
		COUNT(id) AS movie_count
FROM movie AS m
		INNER JOIN ratings AS r
		ON r.movie_id = m.id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
		AND median_rating = 8
GROUP BY median_rating;


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- German movies has total votes = 106710 and Italy has total votes = 77965. so, answer is yes. 
SELECT country AS Country, 
	   SUM(total_votes) AS total_votes
FROM movie AS m
	 INNER JOIN ratings AS r 
     ON m.id=r.movie_id
WHERE country = 'Germany' 
	  OR country = 'Italy'
GROUP BY country;


/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- ---------------------------------------------------------------------------------------------------------------------------------
-- SEGMENT 3:
-- ---------------------------------------------------------------------------------------------------------------------------------

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Columns height, date of birth and known for movies have null values.
-- Name column does not have any null values.
SELECT SUM(CASE 
				WHEN name IS NULL THEN 1 
                ELSE 0 
		   END) AS name_nulls, 
		SUM(CASE 
				WHEN height IS NULL THEN 1 
                ELSE 0 
			END) AS height_nulls, 
	   SUM(CASE 
				WHEN date_of_birth IS NULL THEN 1 
                ELSE 0 
			END) AS date_of_birth_nulls, 
	   SUM(CASE 
				WHEN known_for_movies IS NULL THEN 1 
                ELSE 0 
			END) AS known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose movies have an average rating > 8

WITH top_3_genres AS (
	SELECT g.genre AS genre,
			COUNT(m.id) AS movies_count
	FROM genre AS g
		INNER JOIN movie AS m
		ON m.id = g.movie_id
		INNER JOIN ratings AS r
		ON m.id = r.movie_id
	WHERE avg_rating > 8
	GROUP BY genre 
	ORDER BY movies_count DESC LIMIT 3
	)
SELECT name AS director_name,
		COUNT(d.movie_id) AS movie_count
FROM names AS n
	INNER JOIN director_mapping AS d
    ON d.name_id = n.id
    INNER JOIN movie AS m
    ON m.id = d.movie_id
    INNER JOIN ratings AS r
    ON r.movie_id = m.id
    INNER JOIN genre AS g
    ON g.movie_id = m.id
WHERE  avg_rating > 8 AND g.genre IN (SELECT genre FROM top_3_genres)
GROUP BY  name
ORDER BY  movie_count DESC 
LIMIT 3 ;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

 -- ---------------------------------------------------------------------------------------------------------------------------------
-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Top 2 actors are Mammootty and Mohanlal with median value of their movies is >= 8.

SELECT DISTINCT name AS actor_name, 
	            COUNT(r.movie_id) AS movie_count
FROM ratings AS r
	INNER JOIN role_mapping AS rm
	ON rm.movie_id = r.movie_id
	INNER JOIN names AS n
	ON rm.name_id = n.id
WHERE rm.category = 'actor' AND r.median_rating >= 8 
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2; 

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

 -- ---------------------------------------------------------------------------------------------------------------------------------
-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- top three production houses are Marvel Studios, Twentieth Century Fox, Warner Bros. 

SELECT m.production_company,
	   SUM(r.total_votes) AS vote_count,
       DENSE_RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie AS m
	  INNER JOIN ratings AS r
      ON m.id = r.movie_id
GROUP BY production_company
ORDER BY vote_count DESC 
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

 -- ---------------------------------------------------------------------------------------------------------------------------------
-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. 
-- If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.

SELECT n.name AS actor_name,
		SUM(r.total_votes) AS total_votes,
        COUNT(m.id) AS movie_count,
        ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes),2) AS actor_avg_rating,
        RANK() OVER (ORDER BY SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes) DESC) AS actor_rank
		
FROM names AS n
	INNER JOIN role_mapping AS rm
    ON rm.name_id = n.id
    INNER JOIN movie AS m
    ON m.id = rm.movie_id
    INNER JOIN ratings AS r
    ON r.movie_id = m.id
    
WHERE rm.category = 'actor' AND m.country LIKE '%INDIA%'
GROUP BY name 
HAVING movie_count >= 5
ORDER BY actor_avg_rating DESC;


-- Top actor is Vijay Sethupathi

 -- ---------------------------------------------------------------------------------------------------------------------------------
-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top five actresses in Hindi movies released in India based on their average ratings are 
-- Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

WITH actress_summary AS
		(SELECT n.NAME AS actress_name,
				total_votes,
				Count(r.movie_id) AS movie_count,
				Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM movie AS m
				INNER JOIN ratings AS r
				ON m.id=r.movie_id
				INNER JOIN role_mapping AS rm
				ON m.id = rm.movie_id
				INNER JOIN names AS n
				ON rm.name_id = n.id
           WHERE category = 'ACTRESS'
           AND country = "INDIA"
           AND languages LIKE '%HINDI%'
           GROUP BY NAME
           HAVING movie_count >= 3 
           )
SELECT *,
		Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM actress_summary 
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

 -- ---------------------------------------------------------------------------------------------------------------------------------
/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title AS movie_name,
       r.avg_rating AS Rating,
       (CASE
			WHEN r.avg_rating >= 8 THEN 'Superhit movie'
			WHEN r.avg_rating >= 7 AND r.avg_rating < 8 THEN 'Hit movie'
			WHEN r.avg_rating >= 5 AND r.avg_rating < 7 THEN 'One-time-watch movie'
			WHEN r.avg_rating < 5 THEN 'Flop movie'
        END) AS movie_class
       
FROM movie AS m
	INNER JOIN genre AS g
	ON g.movie_id = m.id
	INNER JOIN ratings AS r
	ON r.movie_id = m.id
    
WHERE g.genre = 'thriller'
ORDER BY Rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/


 -- ---------------------------------------------------------------------------------------------------------------------------------
-- SEGMENT 4:
 -- ---------------------------------------------------------------------------------------------------------------------------------

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT g.genre AS genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting


 -- ---------------------------------------------------------------------------------------------------------------------------------
-- Let us find top 5 movies of each year with top 3 genres.
-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genres AS (SELECT g.genre AS genre,
							 COUNT(m.id) AS movie_count
					   FROM movie AS m
							INNER JOIN genre AS g
							ON g.movie_id = m.id
						GROUP BY genre
						ORDER BY movie_count DESC
						LIMIT 3),
top_5_movies AS (SELECT g.genre AS genre,
					m.year AS year,
					m.title AS movie_name,
					m.worlwide_gross_income AS worldwide_gross_income,
					DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
			FROM genre AS g
					INNER JOIN movie AS m
					ON m.id = g.movie_id
			WHERE genre IN (SELECT genre FROM top_3_genres) 
			)
SELECT *
FROM top_5_movies    
WHERE movie_rank<=5 
ORDER BY year;


 -- ---------------------------------------------------------------------------------------------------------------------------------
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- 'Star Cinema' and 'Twentieth Century Fox' are top two production houses.

WITH multilingual_movies AS ( SELECT m.id AS movie_id
							  FROM movie AS m
									INNER JOIN ratings AS r
									ON r.movie_id = m.id
                              WHERE POSITION(',' IN languages)>0 AND r.median_rating >= 8 AND production_company IS NOT NULL
                              )
SELECT m.production_company AS production_company,
		COUNT(m.id) AS movie_count,
        DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM multilingual_movies AS mm
		INNER JOIN movie AS m
		ON m.id = mm.movie_id
GROUP BY production_company
LIMIT 2;


 -- ---------------------------------------------------------------------------------------------------------------------------------
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top three actresses are PArvathy Thiruvothu, Susan Brown, Amanda Lawrence

SELECT n.name AS actress_name,
		SUM(r.total_votes) AS total_votes,
		COUNT(m.id) AS movie_count,
		ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actress_avg_rating,
		DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS actress_rank
FROM names AS n
		INNER JOIN role_mapping AS rm
		ON n.id = rm.name_id
		INNER JOIN ratings AS r
		ON rm.movie_id = r.movie_id
        INNER JOIN movie AS m
        ON m.id = r.movie_id
        INNER JOIN genre AS g
        ON g.movie_id = m.id
WHERE r.avg_rating > 8 
		AND g.genre = 'drama' 
		AND rm.category = 'actress'
GROUP BY name
LIMIT 3;


 -- ---------------------------------------------------------------------------------------------------------------------------------
/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_date_diff AS
(
	SELECT dm.name_id AS name_id, 
			n.name AS name, 
			dm.movie_id AS movie_id,
			m.date_published AS date_published, 
			LEAD(m.date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY m.date_published, dm.movie_id) AS next_movie_date
	FROM director_mapping AS dm
			INNER JOIN names AS n 
			ON dm.name_id = n.id 
			INNER JOIN movie AS m 
			ON dm.movie_id = m.id
),
avg_movie_date_diff AS
(
	 SELECT *, 
			ROUND(AVG(DATEDIFF(next_movie_date, date_published))) AS avg_inter_movie_days
	 FROM movie_date_diff
     GROUP BY name_id
 )
SELECT dm.name_id AS director_id,
		n.name AS director_name,
        COUNT(m.id) AS number_of_movies,
        md.avg_inter_movie_days AS avg_inter_movie_days,
        ROUND(AVG(r.avg_rating),2) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m.duration) AS total_movie_duration
        
FROM names AS n
		INNER JOIN director_mapping AS dm
        ON n.id = dm.name_id
        INNER JOIN movie AS m
        ON m.id = dm.movie_id
        INNER JOIN ratings AS r
        ON r.movie_id = m.id
        INNER JOIN avg_movie_date_diff AS md
        ON md.name_id = dm.name_id
GROUP BY director_id
ORDER BY COUNT(m.id) DESC
LIMIT 9;

