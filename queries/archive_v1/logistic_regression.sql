#standardSQL
-- 1. Create Logistic Regression Model with Data Splitting
CREATE OR REPLACE MODEL `medical_ml.logistic_regression_model`
OPTIONS
  (model_type='logistic_reg',
   input_label_cols=['label']) AS
SELECT
  CASE 
    WHEN PC.HPSA_Shortage > 0 THEN 'Shortage' 
    ELSE 'No_Shortage' 
  END AS label,
  PC.HPSA_Score AS Score
FROM
  `bigquery-public-data.sdoh_hrsa_shortage_areas.hpsa_primary_care` AS PC
WHERE
  PC.HPSA_Score IS NOT NULL 
  AND PC.HPSA_Shortage IS NOT NULL
  AND MOD(ABS(FARM_FINGERPRINT(CAST(PC.HPSA_Name AS STRING))), 10) < 8;

-- 2. Evaluate Model on Unseen Test Data
SELECT * FROM 
ML.EVALUATE(MODEL `medical_ml.logistic_regression_model`,(
SELECT
  CASE 
    WHEN PC.HPSA_Shortage > 0 THEN 'Shortage' 
    ELSE 'No_Shortage' 
  END AS label,
  PC.HPSA_Score AS Score
FROM
  `bigquery-public-data.sdoh_hrsa_shortage_areas.hpsa_primary_care` AS PC
WHERE
  PC.HPSA_Score IS NOT NULL 
  AND PC.HPSA_Shortage IS NOT NULL
  AND MOD(ABS(FARM_FINGERPRINT(CAST(PC.HPSA_Name AS STRING))), 10) >= 8));