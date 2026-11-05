#standardSQL
-- 1. Create Linear Regression Model with Train-Test Split (80% Training Data)
CREATE OR REPLACE MODEL `medical_ml.linear_regression_model`
OPTIONS
  (model_type='linear_reg',
   input_label_cols=['label']) AS
SELECT
  DH.HPSA_Shortage AS label,
  DH.HPSA_Score AS Score
FROM
  `bigquery-public-data.sdoh_hrsa_shortage_areas.hpsa_dental_health` AS DH
WHERE
  DH.HPSA_Score IS NOT NULL 
  AND DH.HPSA_Shortage IS NOT NULL
  AND MOD(ABS(FARM_FINGERPRINT(CAST(DH.HPSA_Name AS STRING))), 10) < 8;

-- 2. Evaluate Model on Unseen Test Data (20% Test Data)
SELECT * FROM 
ML.EVALUATE(MODEL `medical_ml.linear_regression_model`,(
SELECT
  DH.HPSA_Shortage AS label,
  DH.HPSA_Score AS Score
FROM
  `bigquery-public-data.sdoh_hrsa_shortage_areas.hpsa_dental_health` AS DH
WHERE
  DH.HPSA_Score IS NOT NULL 
  AND DH.HPSA_Shortage IS NOT NULL
  AND MOD(ABS(FARM_FINGERPRINT(CAST(DH.HPSA_Name AS STRING))), 10) >= 8));

-- 3. Run Predictions on Test Set
SELECT label, predicted_label 
FROM ML.PREDICT(MODEL `medical_ml.linear_regression_model`,(
SELECT
  DH.HPSA_Shortage AS label,
  DH.HPSA_Score AS Score
FROM
  `bigquery-public-data.sdoh_hrsa_shortage_areas.hpsa_dental_health` AS DH
WHERE
  DH.HPSA_Score IS NOT NULL 
  AND DH.HPSA_Shortage IS NOT NULL
  AND MOD(ABS(FARM_FINGERPRINT(CAST(DH.HPSA_Name AS STRING))), 10) >= 8));