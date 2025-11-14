import pandas as pd
import numpy as np
import os

# Step 0: Define paths
raw_path = r"C:\healthcare_claims_project\data\raw\claims_raw.xlsx"
staging_folder = r"C:\healthcare_claims_project\data\staging"
output_path = os.path.join(staging_folder, "claims_final.xlsx")

# Create staging folder if it doesn't exist
os.makedirs(staging_folder, exist_ok=True)

# Step 1: Read source data
df = pd.read_excel(raw_path)

# Step 2: Basic cleanup
df.columns = df.columns.str.strip().str.lower()  # clean column names

# Step 3: Apply STM transformations
df["claim_date"] = pd.to_datetime(df["claim_date"], errors="coerce").dt.strftime("%Y-%m-%d")
df["diagnosis_code"] = df["diagnosis_code"].astype(str).str.strip().str.upper()
df["claim_amount"] = df["claim_amount"].round(2)
df["billed_amount"] = df["billed_amount"].round(2)

status_map = {"Approved": 1, "Denied": 0, "Pending": 2}
df["claim_status_code"] = df["claim_status"].map(status_map)

df["region"] = df["region"].str.title()
df["insurance_type"] = df["insurance_type"].str.upper().replace({
    "PPO": "PPO",
    "HMO": "HMO",
    "MEDICARE": "MEDICARE",
    "MEDICAID": "MEDICAID"
})

df["claim_variance"] = df["billed_amount"] - df["claim_amount"]
df["claim_month"] = pd.to_datetime(df["claim_date"]).dt.strftime("%b")
df["is_high_value"] = np.where(df["claim_amount"] > 800, True, False)

# Step 4: Reorder columns
target_columns = [
    "claim_id", "patient_id", "claim_date", "diagnosis_code", "provider_id",
    "claim_amount", "billed_amount", "claim_variance", "claim_status", "claim_status_code",
    "region", "insurance_type", "claim_month", "is_high_value"
]
df_final = df[target_columns]

# Step 5: Write output
df_final.to_excel(output_path, index=False)

print("✅ ETL process completed successfully!")
print(f"Transformed file saved at: {output_path}")