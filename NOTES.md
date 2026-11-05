# Notes (5 Nov 2026 Kaggle run)

1. Dental gave the strongest signal (R² 0.58, AUC 0.91) and mental health the weakest (R² 0.28, AUC 0.82). I did not measure feature importance, so the reason is open. One guess is that mental health need depends more on local factors these coarse features do not include. About 72% of the variance in the mental health score is left unexplained.

2. Version 1 used HPSA_Score to predict shortage, and HRSA computes both from the same designation calculation, so the model was learning a definition. I do not have v1's numbers in this run. The v2 numbers are lower but believable: the formula inputs are left out, each area is one row, and every model is compared with a baseline on areas it never saw.

3. Next check: run again without Type_Desc. Some designation types, such as high-needs geographic, are partly defined by need, so this feature may carry part of the score's own logic. If dental AUC drops a lot without it, that part of the signal was not independent.
