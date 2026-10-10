# Enterprise BigQuery ML: Healthcare Shortage Area Analytics

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23272224.svg)](https://doi.org/10.5281/zenodo.23272224)

An end-to-end cloud-native Machine Learning framework built using **Google Cloud BigQuery ML** and **Standard SQL** to predict and analyze Health Professional Shortage Areas (HPSA).

Identifying underserved medical areas is critical for effective resource allocation. This project processes healthcare shortage data at scale using Google Cloud's data warehouse capabilities, implementing supervised learning models entirely within BigQuery without data extraction overhead.

> **Status:** this repository preserves the original cloud ML implementation and evaluation pipeline for HPSA analytics.

## Dataset

- **Source:** Public SDOH HRSA shortage datasets (`bigquery-public-data.sdoh_hrsa_shortage_areas`)
- Processes healthcare shortage metrics and demographic indicators at scale using Google Cloud BigQuery.
- The data is queried directly inside BigQuery; no external data download or extraction overhead is required.

## Experiments & Model Workflow

1. **Feature Engineering & Splitting:** Hashing-based deterministic sampling (`FARM_FINGERPRINT`) to isolate training and unseen test evaluation datasets.
2. **Model Development:**
   - **Linear Regression:** Predicting continuous shortage indicators.
   - **Logistic Regression:** Binary classification for identifying critical shortage zones.

## Repository Structure

```text
enterprise-bigquery-ml-healthcare/
├── queries/
│   ├── linear_regression.sql     # Linear Regression model script
│   └── logistic_regression.sql   # Logistic Regression classification script
└── screenshots/                  # Model performance & execution screenshots

## How to run

The queries were developed to run directly within the Google Cloud BigQuery Console, which is the recommended way to execute them.
Open BigQuery in the Google Cloud Console.
Access the public dataset: bigquery-public-data.sdoh_hrsa_shortage_areas.
Run the scripts inside the queries/ folder in order to train and evaluate the models.

## References

Google Cloud BigQuery ML Documentation. Supervised learning in BigQuery ML.
Health Resources and Services Administration (HRSA). Social Determinants of Health (SDOH) Shortage Area Datasets.

## Author

Muzammal Hussain — Software Engineer
GitHub: MHKhan50

## Citation

If you use this code, please cite:
Hussain, M. (2026). Enterprise BigQuery ML: Healthcare Shortage Area Analytics (Version v1.0.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.23272224
