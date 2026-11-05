#standardSQL
-- Step 2: BigQuery ML linear regression for HPSA_Score from context features, against a mean baseline.
CREATE OR REPLACE MODEL `medical_ml.hpsa_score_linear`
OPTIONS (model_type = 'linear_reg', input_label_cols = ['hpsa_score'], data_split_method = 'NO_SPLIT') AS
SELECT hpsa_score, hhs_region, state, rural_status, designation_type, population_type, metro_indicator
FROM `medical_ml.hpsa_features`
WHERE split = 'train';

-- Test metrics (areas the model never saw)
SELECT 'linear_reg' AS model, *
FROM ML.EVALUATE(MODEL `medical_ml.hpsa_score_linear`, (
  SELECT hpsa_score, hhs_region, state, rural_status, designation_type, population_type, metro_indicator
  FROM `medical_ml.hpsa_features`
  WHERE split = 'test'));

-- Baseline: predict the training mean for every test area
WITH mu AS (SELECT AVG(hpsa_score) AS m FROM `medical_ml.hpsa_features` WHERE split = 'train')
SELECT
  'train_mean_baseline' AS model,
  AVG(ABS(f.hpsa_score - mu.m)) AS mean_absolute_error,
  AVG(POW(f.hpsa_score - mu.m, 2)) AS mean_squared_error,
  COUNT(*) AS test_areas
FROM `medical_ml.hpsa_features` AS f
CROSS JOIN mu
WHERE f.split = 'test';
