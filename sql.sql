SELECT * FROM `Facilities` 
WHERE membercost > 0

--Q1

;

select count(*) as "No Fee Facilities" from `Facilities`
WHERE membercost = 0

--Q2

;

select facid, name, membercost, monthlymaintenance from `Facilities`
where membercost > 0 
and membercost < (monthlymaintenance/5)

--Q3

;

select * from Facilities
where facid IN (1, 5)

--Q4

;

select name from Facilities
where expense_label IN ('cheap', 'expensive')
and monthlymaintenance > 100

--Q5

;

select firstname, surname from `Members`

--Q6
;

select concat(firstname, " ", surname) "Name", f.name
from `Members` m
inner join Bookings b on m.memid = b.memid
inner join Facilities f on f.facid = b.facid
where b.facid IN
(select facid from `Facilities` where name LIKE 'Tennis%')
group by firstname, surname, f.name

--Q7

;


SELECT b.bookid, b.facid, b.memid, b.slots, f.name,
  CASE
    WHEN b.memid = 0 THEN f.guestcost * b.slots
    ELSE f.membercost * b.slots
  END AS cost,
  CONCAT(m.firstname, " ", m.surname) AS "Member Name"
FROM Bookings b
INNER JOIN Members m ON m.memid = b.memid
INNER JOIN Facilities f ON f.facid = b.facid
WHERE DATE(b.starttime) = '2012-09-14'
GROUP BY b.bookid, b.facid, b.memid, b.slots, f.name, CONCAT(m.firstname, " ", m.surname)
HAVING SUM(cost) > 30
ORDER BY cost DESC

--Q8

;

with cte as
(SELECT b.bookid, b.facid, b.memid, b.slots, f.name,
  CASE
    WHEN b.memid = 0 THEN f.guestcost * b.slots
    ELSE f.membercost * b.slots
  END AS cost,
  CONCAT(m.firstname, " ", m.surname) AS "Member Name"
FROM Bookings b
INNER JOIN Members m ON m.memid = b.memid
INNER JOIN Facilities f ON f.facid = b.facid
WHERE DATE(b.starttime) = '2012-09-14'
GROUP BY b.bookid, b.facid, b.memid, b.slots, f.name, CONCAT(m.firstname, " ", m.surname)
ORDER BY cost DESC)
select * from cte
where cost > 30
--Q9

;

 WITH cte AS (
    SELECT f.name AS Facility, f.guestcost, f.membercost, b.bookid, b.slots,
           m.firstname || " " || m.surname AS Name,
           CASE
               WHEN b.memid = 0 THEN f.guestcost * b.slots
               ELSE f.membercost * b.slots
           END AS revenue
    FROM Bookings b
    INNER JOIN Members m ON m.memid = b.memid
    INNER JOIN Facilities f ON f.facid = b.facid
)
SELECT Facility, SUM(revenue)
FROM cte
GROUP BY Facility
HAVING SUM(revenue) < 1000
ORDER BY revenue DESC

--Q10

;

SELECT m.memid, concat(m.firstname, " ", m.surname), m.recommendedby, 
 case when rec.RecName LIKE "GUEST%" THEN ""
 else rec.RecName
 end "Recommender"
 from Members m 
 inner join (select m.memid, concat(m.firstname, " ", m.surname) "RecName" from Members m) rec on rec.memid = m.recommendedby


--Q11

;

WITH cte AS (
    SELECT f.name AS Facility,
           m.firstname || " " || m.surname AS Name,
           b.bookid, m.memid
    FROM Bookings b
    INNER JOIN Members m ON m.memid = b.memid
    INNER JOIN Facilities f ON f.facid = b.facid
    WHERE m.memid > 0
)
SELECT Name, COUNT(bookid) AS Bookings
FROM cte
GROUP BY Name
ORDER BY Name;

--Q12

;

WITH cte AS (
    SELECT f.name AS Facility,
           CASE
               WHEN strftime('%m', b.starttime) = '07' THEN 'July'
               WHEN strftime('%m', b.starttime) = '08' THEN 'August'
               ELSE 'September'
           END AS Month,
           b.bookid, m.memid
    FROM Bookings b
    INNER JOIN Members m ON m.memid = b.memid
    INNER JOIN Facilities f ON f.facid = b.facid
    WHERE m.memid > 0
)
SELECT Month, COUNT(bookid) AS Bookings
FROM cte
GROUP BY Month
ORDER BY Month


--Q13

;