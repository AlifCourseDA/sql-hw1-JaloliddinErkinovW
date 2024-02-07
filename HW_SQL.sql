-- PART 1
-- 1)
SELECT billingcountry, count(invoiceid) 
FROM invoice 
GROUP BY 1 
ORDER BY 2;

-- 2)
SELECT billingcity, sum(total)
FROM invoice
GROUP BY 1
ORDER BY 2
LIMIT 5;

-- 3)
SELECT c.customerid, c.firstname, c.lastname, sum(i.total) AS total_spent
FROM customer c 
JOIN invoice i 
ON c.customerid = i.customerid 
GROUP BY 1 
ORDER BY 4;

-- 4)
SELECT c.email, c.firstname, c.lastname, g.name AS genre_name
FROM customer c 
JOIN invoice i 
ON c.customerid = i.customerid 
JOIN invoiceline i2 
ON i.invoiceid = i2.invoiceid 
JOIN track t 
ON i2.trackid = t.trackid 
JOIN genre g 
ON t.genreid = g.genreid 
WHERE g.name = 'Rock' AND c.email LIKE 's%';

-- 5)
WITH country_filter AS (
	SELECT i.billingcountry AS inv_country, sum(i.total) AS customer_total
	FROM customer c 
	JOIN invoice i 
	ON c.customerid = i.customerid
	GROUP BY inv_country, c.customerid
),

customer_filter AS (
	SELECT country_filter.inv_country, max(country_filter.customer_total) AS country_max
	FROM country_filter
	GROUP BY country_filter.inv_country
)

SELECT c.country, c.firstname, c.lastname, country_max
FROM customer c 
JOIN customer_filter
ON c.country = customer_filter.inv_country
GROUP BY 1, 2, 3, 4
ORDER BY 4 DESC;

-- PART 2
-- 1)
WITH counter AS (
	SELECT t.trackid AS track, count(pl.trackid) AS frequency
	FROM track t 
	JOIN playlisttrack pl
	ON t.trackid = pl.trackid 
	GROUP BY 1
)

SELECT count(t.trackid), frequency
FROM track t 
JOIN counter
ON t.trackid = counter.track
GROUP BY 2
ORDER BY 2;

-- 2)
SELECT  a.title, sum(i.total) as revenue
FROM album a
JOIN track t
ON a.albumid = t.albumid
JOIN  invoiceline i2
ON t.trackid = i2.trackid
JOIN invoice i
ON i2.invoiceid = i.invoiceid
GROUP  BY 1
ORDER  BY 2 DESC
limit 1;

-- 3)
SELECT  i.billingcountry, sum(i.total) AS county_total_revenue, round(sum(i.total) / (SELECT  sum(i2.total) FROM invoice i2) * 100 , 1) AS country_percent
FROM invoice i  
GROUP BY 1
ORDER BY 2 DESC;

-- 4)
SELECT a.albumid, sum(t.milliseconds) AS album_length, sum(i.total) AS total_revenue
FROM album a 
JOIN track t 
ON a.albumid = t.albumid 
JOIN invoiceline i2
ON t.trackid = i2.trackid 
JOIN invoice i 
ON i2.invoiceid = i.invoiceid 
GROUP BY 1
ORDER BY 2 DESC;

-- 5)
SELECT  t.trackid, count(pl.trackid)  as frequency, sum(i.total) as total_revenue
FROM playlisttrack pl
JOIN track t
ON pl.trackid = t.trackid 
JOIN invoiceline i2
ON t.trackid = i2.trackid 
JOIN invoice i
ON i2.invoiceid = i.invoiceid
GROUP BY 1
ORDER BY 2 DESC;

-- 6)
SELECT year, sum(total_sum) AS year_revenue
FROM (
SELECT date_part('year', invoicedate) as year, sum(total) as total_sum
FROM invoice i
GROUP BY invoicedate
ORDER BY invoicedate )
GROUP BY 1;

--7)
SELECT year, sum(total_sum) AS year_revenue
FROM(
SELECT date_part('year', invoicedate) as year, sum(total) as total_sum
FROM invoice i
GROUP BY 1
ORDER BY 1)
GROUP BY 1;

