"""Offline checks: no leakage columns used as features, one split rule, notebook logic on fake data."""
from __future__ import annotations

import json
import re
from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
Q = ROOT / "queries"
LEAKY = ["HPSA_Shortage", "HPSA_FTE", "Formal_Ratio", "Poverty", "Designation_Population"]


def _notebook_ns() -> dict:
    nb = json.loads((ROOT / "notebooks" / "kaggle_bigquery_hpsa.ipynb").read_text())
    ns: dict = {}
    for cell in nb["cells"]:
        if cell["cell_type"] != "code":
            continue
        src = "".join(cell["source"])
        if "functions" in cell["metadata"].get("tags", []) or "REPO_RAW =" in src:
            exec(src, ns)
    return ns


def _sql_code(name: str) -> str:
    return "\n".join(l for l in (Q / name).read_text().splitlines() if not l.strip().startswith("--"))


def test_feature_sql_has_no_leaky_columns():
    code = _sql_code("01_features.sql")
    for col in LEAKY:
        assert col.lower() not in code.lower(), col


def test_models_use_only_context_features():
    for name in ["02_bqml_linear_score.sql", "03_bqml_logistic_high_need.sql"]:
        code = _sql_code(name)
        assert "hpsa_features" in code and "split = 'train'" in code and "split = 'test'" in code
        assert "NO_SPLIT" in code


def test_one_split_rule():
    code = _sql_code("01_features.sql")
    assert len(re.findall(r"FARM_FINGERPRINT\(HPSA_Name\)\), 10\) < 8", code)) == 1


def test_feature_select_points_at_each_table():
    ns = _notebook_ns()
    text = (Q / "01_features.sql").read_text()
    sel = ns["feature_select"](text, "hpsa_mental_health")
    assert sel.startswith("WITH") and "CREATE" not in sel
    assert "hpsa_mental_health" in sel and "hpsa_primary_care" not in sel


def test_run_models_on_fake_data():
    ns = _notebook_ns()
    rng = np.random.default_rng(0)
    n = 600
    rural = rng.choice(["Rural", "Non-Rural", "Partially Rural"], n)
    score = np.where(rural == "Rural", 17, 11) + rng.normal(0, 2, n)
    df = pd.DataFrame({
        "hpsa_name": [f"area {i}" for i in range(n)], "hpsa_score": score,
        "hhs_region": rng.choice(["Region 1", "Region 2"], n), "state": rng.choice(["AK", "TX"], n),
        "rural_status": rural, "designation_type": "Geographic HPSA", "population_type": None,
        "metro_indicator": "x", "split": np.where(np.arange(n) % 5 == 0, "test", "train"),
    })
    df["high_need"] = (df.hpsa_score >= df[df.split == "train"].hpsa_score.quantile(0.75)).astype(int)
    r = ns["run_models"](df)
    assert r["areas_test"] == 120
    assert r["linear"]["mae"] < r["mean_baseline"]["mae"]
    assert r["logistic"]["roc_auc"] > 0.8
    lo, hi = r["linear"]["mae_gain_vs_mean_ci95"]
    assert lo <= hi
