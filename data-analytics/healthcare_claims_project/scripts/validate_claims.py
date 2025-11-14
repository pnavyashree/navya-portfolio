import pandas as pd
import numpy as np

# Paths
raw_path = r"C:\healthcare_claims_project\data\raw\claims_raw.xlsx"
final_path = r"C:\healthcare_claims_project\data\staging\claims_final.xlsx"

# Load files
raw = pd.read_excel(raw_path)
final = pd.read_excel(final_path)

print("✅ Loaded raw and final files.\n")

# 1️⃣ Check row counts
print(f"Raw rows: {len(raw)}")
print(f"Final rows: {len(final)}\n")

# 2️⃣ Check columns
target_columns = [
    "claim_id", "patient_id", "claim_date", "diagnosis_code", "provider_id",
    "claim_amount", "billed_amount", "claim_variance", "claim_status", "claim_status_code",
    "region", "insurance_type", "claim_month", "is_high_value"
]
print("Columns in final file:")
print(final.columns.tolist())
print("\nColumn order correct:", final.columns.tolist() == target_columns, "\n")

# 3️⃣ Check for missing values
print("Missing values in final file:")
print(final.isnull().sum(), "\n")

# 4️⃣ Spot check transformations
# claim_variance
final['calc_variance'] = final['billed_amount'] - final['claim_amount']
variance_check = (final['claim_variance'] == final['calc_variance']).all()
print("Claim variance correct for all rows:", variance_check)

# claim_status_code mapping
status_map = {"Approved": 1, "Denied": 0, "Pending": 2}
status_check = (final['claim_status_code'] == final['claim_status'].map(status_map)).all()
print("Claim status codes correct:", status_check)

# is_high_value
high_value_check = (final['is_high_value'] == (final['claim_amount'] > 800)).all()
print("High value flag correct:", high_value_check)

# claim_month format
month_check = final['claim_month'].apply(lambda x: x.isalpha()).all()
print("Claim month format valid:", month_check, "\n")

# 5️⃣ Summary statistics
print("Claim amount stats (raw):")
print(raw['claim_amount'].describe())
print("\nClaim amount stats (final):")
print(final['claim_amount'].describe())
