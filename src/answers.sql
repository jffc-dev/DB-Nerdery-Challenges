-- Your answers here:

CREATE OR REPLACE FUNCTION calculate_user_balances()
RETURNS TABLE (
    user_id UUID,
    name TEXT,
    email TEXT,
    total_balance NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH account_initial_balances AS (
        SELECT
            a.user_id,
            a.id AS account_id,
            a.mount AS initial_balance
        FROM
            accounts a
    ),
    account_balances AS (
        SELECT
            a.user_id,
            a.account_id,
            a.initial_balance + 
            COALESCE(SUM(
                CASE
                    WHEN m.account_to = a.account_id THEN m.mount
                    WHEN m.account_from = a.account_id THEN -m.mount
                    ELSE 0
                END
            ), 0) AS balance
        FROM
            account_initial_balances a
        LEFT JOIN
            movements m ON a.account_id = m.account_to OR a.account_id = m.account_from
        GROUP BY
            a.user_id, a.account_id, a.initial_balance
    )
    SELECT
        u.id,
        u.name,
        u.email,
        SUM(ab.balance)::NUMERIC AS total_balance
    FROM
        users u
    JOIN
        account_balances ab ON u.id = ab.user_id
    GROUP BY
        u.id, u.name, u.email;
END;
$$ LANGUAGE plpgsql;

-- 1
SELECT
	type,
	SUM(mount)
FROM
	accounts
GROUP BY
	type;


-- 2
SELECT 
    COUNT(*) AS user_count
FROM (
    SELECT 
        u.id
    FROM 
        users u
    JOIN 
        accounts a ON u.id = a.user_id
    WHERE 
        a.type = 'CURRENT_ACCOUNT'
    GROUP BY 
        u.id
    HAVING 
        COUNT(a.id) >= 2
) AS multi_account_users;


-- 3
SELECT 
	id,
	type,
	mount
FROM
	accounts
ORDER BY
	mount DESC
LIMIT 5;


-- 4
SELECT
    name,
    email,
    total_balance
FROM
    calculate_user_balances()
ORDER BY
    total_balance DESC
LIMIT 3;


-- 5


-- 6
SELECT
    m.id AS movement_id,
    m.type AS movement_type,
    m.account_from,
    m.account_to,
    m.mount,
    m.created_at AS movement_created_at,
    m.updated_at AS movement_updated_at,
    u.id AS user_id,
    u.name AS user_name,
    u.last_name AS user_last_name,
    u.email AS user_email,
    u.date_joined AS user_date_joined,
    u.created_at AS user_created_at,
    u.updated_at AS user_updated_at
FROM
    movements m
LEFT JOIN
    accounts a ON m.account_from = a.id OR m.account_to = a.id
LEFT JOIN
    users u ON a.user_id = u.id
WHERE
    a.id = '3b79e403-c788-495a-a8ca-86ad7643afaf';


-- 7
SELECT
    name,
    email,
    total_balance
FROM
    calculate_user_balances()
ORDER BY
    total_balance DESC
LIMIT 1;


--8
SELECT
    m.id AS movement_id,
    m.type AS movement_type,
    m.account_from,
    m.account_to,
    m.mount,
    m.created_at AS movement_created_at,
    m.updated_at AS movement_updated_at,
	a.id AS account_id,
    a.type AS account_type
FROM
    movements m
JOIN
    accounts a ON m.account_from = a.id OR m.account_to = a.id
JOIN
    users u ON a.user_id = u.id
WHERE
    u.email = 'Kaden.Gusikowski@gmail.com'
ORDER BY
    a.type,
    m.created_at;

