-- Your answers here:
-- 1
SELECT C.name, COUNT(*) FROM states S
INNER JOIN countries C ON S.country_id = C.id
GROUP BY C.id, C.name

-- 2
SELECT COUNT(*) FROM employees WHERE supervisor_id IS NULL

-- 3
SELECT C.name, O.address, count(*) FROM offices O
INNER JOIN countries C ON O.country_id = C.id
LEFT JOIN employees E ON O.id = E.office_id
GROUP BY C.name, O.address
ORDER BY 3 DESC, C.name
LIMIT 5

-- 4
SELECT S.ID, COUNT(*) FROM employees E
INNER JOIN employees S ON E.supervisor_id = S.id
GROUP BY S.id
ORDER BY 2 DESC

-- 5

SELECT count(*) FROM offices O
INNER JOIN states S ON O.state_id = S.id
INNER JOIN countries C ON O.country_id = C.id
WHERE S.name = 'Colorado' AND C.name = 'United States'

-- 6
SELECT O.name, COUNT(e.id) FROM offices O
LEFT JOIN employees E ON O.id = E.office_id
GROUP BY O.ID, O.name
ORDER BY 2 DESC

-- 7
select * from (SELECT O.name, COUNT(E.id) FROM offices O
LEFT JOIN employees E ON O.id = E.office_id
GROUP BY O.id, O.name
ORDER BY 2
LIMIT 1) l
UNION
SELECT * FROM (SELECT O.name, COUNT(E.id) FROM offices O
LEFT JOIN employees E ON O.id = E.office_id
GROUP BY O.id, O.name
ORDER BY 2 DESC
LIMIT 1) H;

-- 8
SELECT E.uuid, CONCAT(E.first_name, ' ', E.last_name) AS full_name, E.email, E.job_title, O.name AS company, C.name AS country, S.name AS state, SU.first_name as boss_name FROM employees E
INNER JOIN offices O ON E.office_id = O.id
INNER JOIN states S ON O.state_id = S.id
INNER JOIN countries C ON O.country_id = C.id
LEFT JOIN employees SU ON E.supervisor_id = SU.id