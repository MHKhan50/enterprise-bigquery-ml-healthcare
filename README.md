# Enterprise BigQuery ML: Healthcare Shortage Area Analytics

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23272224.svg)](https://doi.org/10.5281/zenodo.23272224)

An end-to-end cloud-native Machine Learning framework built using **Google Cloud BigQuery ML** and **Standard SQL** to predict and analyze Health Professional Shortage Areas (HPSA).

---

## Project Overview
Identifying underserved medical areas is critical for effective resource allocation. This project processes healthcare shortage data at scale using Google Cloud's data warehouse capabilities, implementing supervised learning models entirely within BigQuery without data extraction overhead.

---

## Architecture & Data Workflow
1. **Data Ingestion:** Public SDOH HRSA shortage datasets (`bigquery-public-data.sdoh_hrsa_shortage_areas`).
2. **Feature Engineering & Splitting:** Hashing-based deterministic sampling (`FARM_FINGERPRINT`) to isolate **80% Training** and **20% Unseen Test** evaluation datasets.
3. **Model Development:**
   - **Linear Regression:** Predicting continuous shortage indicators.
   - **Logistic Regression:** Binary classification for critical shortage zones.

---

## Repository Structure
```text
enterprise-bigquery-ml-healthcare/
├── queries/
│   ├── linear_regression.sql     # Linear Regression model script
│   └── logistic_regression.sql   # Logistic Regression classification script
└── screenshots/                  # Model performance & execution screenshots

## Author
**Muzammal Hussain** - Software Engineer  
GitHub: [@MHKhan50](https://github.com/MHKhan50)

---

## Citation
If you use this repository or code, please cite it as follows:

```bibtex
@software{hussain_2026_23272224,
  author       = {Hussain, Muzammal},
  title        = {Enterprise BigQuery ML: Healthcare Shortage Area Analytics},
  month        = oct,
  year         = 2026,
  publisher    = {Zenodo},
  version      = {1.0.0},
  doi          = {10.5281/zenodo.23272224},
  url          = {[https://doi.org/10.5281/zenodo.23272224](https://doi.org/10.5281/zenodo.23272224)}
}
