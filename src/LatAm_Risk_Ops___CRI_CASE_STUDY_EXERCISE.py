import pandas as pd

file_path = file_path = r"C:\Users\thonyalope\Documents\GitHub\LatAm_Risk_Ops___CRI_CASE_STUDY_EXERCISE\data\Business_Case__LatAm_Risk_Ops_-_CRI.xlsx"

excel_data = pd.ExcelFile(file_path)

sheet_names = excel_data.sheet_names
print(sheet_names)

# Load the data from the Database sheet
database_df = pd.read_excel(file_path, sheet_name='Database ', header=1)

database_df = database_df.loc[:, ~database_df.columns.str.contains('^Unnamed')]

missing_values = database_df.isnull().sum()
print("Missing values:\n", missing_values)
print("\nData types:\n", database_df.dtypes)

database_df = database_df.dropna(subset=['city_name'])

database_df = database_df.drop_duplicates()

database_df['city_name'] = database_df['city_name'].str.strip().str.title()
database_df['card_type'] = database_df['card_type'].str.strip().str.upper()

print(database_df.head())
print(database_df.describe(include='all'))
