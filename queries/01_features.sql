#standardSQL
-- Step 1: one row per shortage area (HPSA), context features only.
--
-- Target: HPSA_Score (HRSA's 0-25 priority score) and high_need (score in the top quarter of the
-- training split). Left out on purpose, because HRSA uses them to compute the score or the
-- designation: HPSA_Shortage, HPSA_FTE, population-to-provider ratios, poverty share, travel time
-- and population counts. The old v1 models used HPSA_Score and HPSA_Shortage to predict each
-- other, which is leakage (see queries/archive_v1/).
--
-- Split: 80/20 by a hash of HPSA_Name, so every row of one area lands on the same side.
-- The Kaggle notebook runs only the SELECT below the marker line.
CREATE SCHEMA IF NOT EXISTS `medical_ml` OPTIONS (location = 'US');
CREATE OR REPLACE TABLE `medical_ml.hpsa_features` AS
-- SELECT_STARTS_HERE
WITH rows_in AS (
  SELECT *
  FROM `bigquery-public-data.sdoh_hrsa_shortage_areas.hpsa_primary_care`
  WHERE HPSA_Score IS NOT NULL
    AND HPSA_Name IS NOT NULL
    AND LOWER(HPSA_Status) = 'designated'
),
per_area AS (
  SELECT
    HPSA_Name AS hpsa_name,
    MAX(HPSA_Score) AS hpsa_score,
    MAX(Primary_HHS_Region_Name) AS hhs_region,
    MAX(Primary_State_Abbreviation) AS state,
    MAX(Rural_Status) AS rural_status,
    MAX(Designation_Type) AS designation_type,
    MAX(HPSA_Population_Type) AS population_type,
    MAX(Metropolitan_Indicator) AS metro_indicator,
    IF(MOD(ABS(FARM_FINGERPRINT(HPSA_Name)), 10) < 8, 'train', 'test') AS split
  FROM rows_in
  GROUP BY HPSA_Name
),
cut AS (
  SELECT APPROX_QUANTILES(hpsa_score, 4)[OFFSET(3)] AS q75
  FROM per_area
  WHERE split = 'train'
)
SELECT p.*, IF(p.hpsa_score >= cut.q75, 1, 0) AS high_need
FROM per_area AS p
CROSS JOIN cut;
