-- Step 1 - Query 1
Excel. USE LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE;
GO

SELECT
    DATEPART(WEEK, CAST(transaction_date AS DATE)) AS Week,
    marketplace,
    city_name,
    card_bin,
    card_type,
    COUNT(DISTINCT transaction_id) AS trip_count,
    SUM(CAST(gb AS DECIMAL(18, 2))) AS GBs,
    COUNT(DISTINCT CASE WHEN chargeback_count > 0 THEN transaction_id ELSE NULL END) AS chargeback_count,
    SUM(CASE WHEN chargeback_count > 0 THEN CAST(chargeback_amount_usd AS DECIMAL(18, 2)) ELSE 0 END) AS chargeback_amount_usd,
    COUNT(DISTINCT CASE WHEN unsettled_trip_count > 0 THEN transaction_id ELSE NULL END) AS unsettled_trip_count,
    SUM(CASE WHEN unsettled_trip_count > 0 THEN CAST(unsettled_trip_amount_usd AS DECIMAL(18, 2)) ELSE 0 END) AS unsettled_trip_amount_usd
FROM
    LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE
WHERE
    CAST(transaction_date AS DATE) BETWEEN '2013-01-02' AND '2013-05-31'
    AND marketplace = 'personal_transport'
    AND city_name IN ('Gotham City')
GROUP BY
    DATEPART(WEEK, CAST(transaction_date AS DATE)), marketplace, city_name, card_bin, card_type;

-- Step 3 - Query 2
SELECT
    transaction_date AS datestr,
    transaction_date AS date,
    marketplace,
    transaction_id AS trip_uuid,
    card_type,
    card_bin AS card_category,
    gb AS bill_amount_usd,
    unsettled_trip_count AS is_unsettled,
    chargeback_count AS is_chargeback
FROM
    LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE
WHERE
    transaction_date BETWEEN '2013-01-02' AND '2013-05-31';

-- Consider how the trends move for both fraud indicators, chargebacks and unsettled trips
USE LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE;
GO

SELECT
    DATEPART(WEEK, CAST(transaction_date AS DATE)) AS Week,
    marketplace,
    city_name,
    card_bin,
    card_type,
    COUNT(transaction_id) AS trip_count,
    SUM(TRY_CAST(gb AS DECIMAL(18, 2))) AS total_gbs,
    COUNT(CASE WHEN chargeback_count > 0 THEN transaction_id ELSE NULL END) AS chargeback_count,
    SUM(CASE WHEN chargeback_count > 0 THEN TRY_CAST(chargeback_amount_usd AS DECIMAL(18, 2)) ELSE 0 END) AS chargeback_amount_usd,
    COUNT(CASE WHEN unsettled_trip_count > 0 THEN transaction_id ELSE NULL END) AS unsettled_trip_count,
    SUM(CASE WHEN unsettled_trip_count > 0 THEN TRY_CAST(unsettled_trip_amount_usd AS DECIMAL(18, 2)) ELSE 0 END) AS unsettled_trip_amount_usd
FROM
    LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE
WHERE
    CAST(transaction_date AS DATE) BETWEEN '2013-01-02' AND '2013-05-31'
GROUP BY
    DATEPART(WEEK, CAST(transaction_date AS DATE)), marketplace, city_name, card_bin, card_type
ORDER BY
    Week;

-- Are there any reasons that could explain these movements?
USE LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE;
GO

SELECT
    transaction_date,
    marketplace,
    city_name,
    card_bin,
    card_type,
    transaction_id,
    gb,
    chargeback_count,
    chargeback_amount_usd,
    unsettled_trip_count,
    unsettled_trip_amount_usd
FROM
    LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE
WHERE
    DATEPART(WEEK, CAST(transaction_date AS DATE)) = 4
    AND CAST(transaction_date AS DATE) BETWEEN '2013-01-02' AND '2013-05-31'
ORDER BY
    transaction_date;

-- How would you describe the fraud rate in the region?
USE LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE;
GO

SELECT
    DATEPART(WEEK, CAST(transaction_date AS DATE)) AS Week,
    COUNT(DISTINCT transaction_id) AS total_transactions,
    COUNT(DISTINCT CASE WHEN chargeback_count > 0 THEN transaction_id ELSE NULL END) AS fraudulent_transactions,
    (COUNT(DISTINCT CASE WHEN chargeback_count > 0 THEN transaction_id ELSE NULL END) * 1.0 / COUNT(DISTINCT transaction_id)) * 100 AS fraud_rate_percentage,
    COUNT(DISTINCT CASE WHEN unsettled_trip_count > 0 THEN transaction_id ELSE NULL END) AS unsettled_transactions,
    (COUNT(DISTINCT CASE WHEN unsettled_trip_count > 0 THEN transaction_id ELSE NULL END) * 1.0 / COUNT(DISTINCT transaction_id)) * 100 AS unsettled_rate_percentage
FROM
    LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE
WHERE
    CAST(transaction_date AS DATE) BETWEEN '2013-01-02' AND '2013-05-31'
GROUP BY
    DATEPART(WEEK, CAST(transaction_date AS DATE))
ORDER BY
    Week;

-- Do you observe any concentration or urgent time frames that require a deep dive?
USE LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE;
GO

SELECT
    DATEPART(WEEK, CAST(transaction_date AS DATE)) AS Week,
    COUNT(DISTINCT transaction_id) AS total_transactions,
    COUNT(DISTINCT CASE WHEN chargeback_count > 0 THEN transaction_id ELSE NULL END) AS total_chargebacks,
    (COUNT(DISTINCT CASE WHEN chargeback_count > 0 THEN transaction_id ELSE NULL END) * 1.0 / COUNT(DISTINCT transaction_id)) * 100 AS chargeback_rate,
    COUNT(DISTINCT CASE WHEN unsettled_trip_count > 0 THEN transaction_id ELSE NULL END) AS total_unsettled,
    (COUNT(DISTINCT CASE WHEN unsettled_trip_count > 0 THEN transaction_id ELSE NULL END) * 1.0 / COUNT(DISTINCT transaction_id)) * 100 AS unsettled_rate
FROM
    LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE
WHERE
    CAST(transaction_date AS DATE) BETWEEN '2013-01-02' AND '2013-05-31'
GROUP BY
    DATEPART(WEEK, CAST(transaction_date AS DATE))
ORDER BY
    chargeback_rate DESC, unsettled_rate DESC;

-- How would you document/support the need to perform an investigation?
USE LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE;
GO

SELECT
    DATEPART(WEEK, CAST(transaction_date AS DATE)) AS Week_Number,
    transaction_date,
    marketplace,
    city_name,
    card_bin,
    card_type,
    COUNT(transaction_id) AS Number_of_Trips,
    SUM(CAST(gb AS DECIMAL(18, 2))) AS Total_Gross_Billings,
    SUM(CAST(chargeback_amount_usd AS DECIMAL(18, 2))) AS Total_Chargeback_Amount,
    SUM(CASE WHEN chargeback_count > 0 THEN 1 ELSE 0 END) AS Number_of_Chargebacks,
    SUM(CAST(unsettled_trip_amount_usd AS DECIMAL(18, 2))) AS Total_Unsettled_Amount,
    SUM(CASE WHEN unsettled_trip_count > 0 THEN 1 ELSE 0 END) AS Number_of_Unsettled_Trips
FROM
    LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE
WHERE
    CAST(transaction_date AS DATE) BETWEEN '2013-04-01' AND '2013-04-28'
    AND marketplace = 'personal_transport'
    AND city_name IN ('Gotham City', 'Metropolis')
GROUP BY
    DATEPART(WEEK, CAST(transaction_date AS DATE)), marketplace, city_name, card_bin, card_type
ORDER BY
    Week_Number, city_name, card_type;