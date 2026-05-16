# Code to ingest the Nurse Sample Data into Python
# Import packages
import pandas as pd

# Import CSV files
df_nurses = pd.read_csv("Nurses Table.csv")
df_shifts = pd.read_csv("Status Table.csv")

# Check CSVs have been imported correctly
print(df_nurses)
print(df_shifts)

# Drop empty columns
df_shifts_clean = df_shifts.dropna(axis=1, how='all')
df_shifts_clean = df_shifts_clean.drop(columns=['Unnamed: 11'])
print(df_shifts_clean)

# Date conversion
df_shifts_clean['Date'] = pd.to_datetime(df_shifts_clean["Date"] + ' 2026', format='%d-%b %Y')
df_shifts_clean['Date'] = df_shifts_clean['Date'].dt.strftime('%Y-%m-%d')

# Print first 10 rows of Shifts
print(df_shifts_clean.head(10))
print(df_shifts_clean.dtypes)

# Print first 10 rows of Nurses
print(df_nurses.head(10))
print(df_nurses.dtypes)

# Exporting to CSVs
df_nurses.to_csv('nurses_clean.csv', index=False)
df_shifts_clean.to_csv('shift_clean.csv', index=False)