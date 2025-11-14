import pandas as pd

df = pd.read_excel(r"C:\healthcare_claims_project\data\staging\claims_final.xlsx")

# Count of claims by status
print(df['claim_status'].value_counts())

# Total billed amount by insurance type
print(df.groupby('insurance_type')['billed_amount'].sum())

# High-value claims count
print(df['is_high_value'].sum())

# Monthly claims count
print(df.groupby('claim_month')['claim_id'].count())
