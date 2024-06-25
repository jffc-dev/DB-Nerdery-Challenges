-- Your answers here:
-- 1
SELECT 
    c.name AS name,
    COUNT(s.id) AS count
FROM 
    countries c
LEFT JOIN 
    states s ON c.id = s.country_id
GROUP BY 
    c.id, c.name
ORDER BY
	count ASC;

-- 2
SELECT
	COUNT(e.id) AS employees_without_bosses
FROM
	employees e
WHERE
	supervisor_id IS NULL;

-- 3
SELECT
	c.name AS name,
	o.address,
	COUNT(e.id) AS count
FROM 
	offices o
LEFT JOIN
	employees e ON o.id = e.office_id
LEFT JOIN
	countries c ON o.country_id = c.id
GROUP BY
	c.name, o.id, o.name, o.address
ORDER BY
	count DESC
LIMIT 5;


-- 4
SELECT
	supervisor_id,
	COUNT(id) AS count
FROM 
	employees
WHERE
	supervisor_id IS NOT NULL
GROUP BY
	supervisor_id
ORDER BY
	count DESC
LIMIT 3;

-- 5
WITH colorado_state AS (
    SELECT s.id
    FROM states s
    WHERE s.name = 'Colorado'
      AND s.country_id = (
          SELECT c.id
          FROM countries c
          WHERE c.name = 'United States'
      )
)
SELECT 
	COUNT(id) AS list_of_offices
FROM offices
WHERE state_id = (SELECT id FROM colorado_state);

-- 6
Select
	o.name,
	COUNT(e.id) as count
FROM
	offices o
LEFT JOIN
	employees e ON o.id = e.office_id
GROUP BY
	o.id
ORDER BY
	count DESC;

-- 7
WITH office_counts AS (
    SELECT
        o.id,
        address,
        COUNT(e.id) AS count
    FROM
        offices o
    LEFT JOIN
        employees e ON o.id = e.office_id
    GROUP BY
        o.id
)
(
    SELECT
        address,
        count
    FROM
        office_counts
    ORDER BY
        count DESC
    LIMIT 1
)
UNION ALL
(
    SELECT
        address,
        count
    FROM
        office_counts
	WHERE 
		count > 0
    ORDER BY
        count ASC
    LIMIT 1
);

-- 8
SELECT
	e.uuid,
	e.first_name || ' ' || e.last_name as full_name,
	e.email,
	e.job_title,
	o.name as company,
	c.name as country,
	s.name as state,
	sup.first_name AS boss_name
FROM
	employees e
LEFT JOIN
	offices o ON o.id = e.office_id
LEFT JOIN
	countries c ON c.id = o.country_id
LEFT JOIN
	states s ON s.id = o.state_id
LEFT JOIN
	employees sup ON sup.id = e.supervisor_id;

