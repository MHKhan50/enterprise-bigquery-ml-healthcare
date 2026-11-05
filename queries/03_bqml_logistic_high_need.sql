#standardSQL
-- Step 3: BigQuery ML logistic regression for high_need (top quarter of HPSA_Score), against a
-- majority-class baseline.
CREATE OR REPLACE MODEL `medical_ml.hpsa_high_need_logistic`
OPTIONS (model_type = 'logistic_reg', input_label_cols = ['high_need'], data_split_method = 'NO_SPLIT') AS
SELECT high_need, hhs_region, state, rural_status, designation_type, population_type, metro_indicator
FROM `medical_ml.hpsa_features`
WHERE split = 'train';

-- Test metrics (precision, recall, accuracy, f1, log_loss, roc_auc)
SELECT 'logistic_reg' AS model, *
FROM ML.EVALUATE(MODEL `medical_ml.hpsa_high_need_logistic`, (
  SELECT high_need, hhs_region, state, rural_status, designation_type, population_type, metro_indicator
  FROM `medical_ml.hpsa_features`
  WHERE split = 'test'));

-- Baseline: always predict the most common training class (ROC AUC of a constant is 0.5)
WITH maj AS (
  SELECT IF(AVG(high_need) >= 0.5, 1, 0) AS c FROM `medical_ml.hpsa_features` WHERE split = 'train'
)
SELECT
  'majority_baseline' AS model,
  AVG(IF(f.high_need = maj.c, 1, 0)) AS accuracy,
  AVG(f.high_need) AS high_need_share_test,
  COUNT(*) AS test_areas
FROM `medical_ml.hpsa_features` AS f
CROSS JOIN maj
WHERE f.split = 'test';
