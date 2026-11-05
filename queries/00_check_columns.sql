#standardSQL
-- Step 0: list the real columns of the three HPSA tables before training.
-- Every column used in 01_features.sql must appear here.
SELECT table_name, column_name, data_type
FROM `bigquery-public-data.sdoh_hrsa_shortage_areas.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN ('hpsa_primary_care', 'hpsa_dental_health', 'hpsa_mental_health')
ORDER BY table_name, ordinal_position;
