from sqlalchemy import create_engine, text
import pandas as pd


#  DB CONNECTION

engine = create_engine(
    "mysql+mysqlconnector://root:root@localhost/food_delivery_db"
)


#  LOAD CSV

df = pd.read_csv(
    r"D:\Tamil Files\Guvi\online_food_delivery_analysis\data_processed\food_orders_features.csv"
)


# BASIC NULL HANDLING (SAFE)

df['City'] = df['City'].fillna('Unknown')
df['Cancellation_Reason'] = df['Cancellation_Reason'].fillna('Not Cancelled')
df['Delivery_Rating'] = df['Delivery_Rating'].fillna(0)


# CLEAN TABLES (DEV MODE)

with engine.connect() as conn:
    conn.execute(text("SET FOREIGN_KEY_CHECKS = 0"))
    conn.execute(text("TRUNCATE TABLE orders"))
    conn.execute(text("TRUNCATE TABLE customers"))
    conn.execute(text("TRUNCATE TABLE restaurants"))
    conn.execute(text("TRUNCATE TABLE delivery_partners"))
    conn.execute(text("SET FOREIGN_KEY_CHECKS = 1"))


# CUSTOMERS TABLE

df_customers = (
    df[['Customer_ID','Customer_Age','Age_Group','Customer_Gender','City']]
    .drop_duplicates(subset=['Customer_ID'])
)

df_customers.columns = [
    'Customer_ID','Customer_Age','Age_Group','Gender','City'
]

# Optional safety check
print("Duplicate customers:", df_customers['Customer_ID'].duplicated().sum())

df_customers.to_sql(
    'customers',
    engine,
    if_exists='append',
    index=False
)


print(" Customers loaded")


#  RESTAURANTS TABLE

df_rest = (
    df[['Restaurant_ID','Restaurant_Name','Cuisine_Type','Restaurant_Rating','City']]
    .drop_duplicates(subset=['Restaurant_ID'])
)

print("Duplicate restaurants:",
      df_rest['Restaurant_ID'].duplicated().sum())

df_rest.to_sql(
    'restaurants',
    engine,
    if_exists='append',
    index=False
)

print(" Restaurants loaded")



#  DELIVERY PARTNERS TABLE

df_dp = (
    df[['Delivery_Partner_ID','Delivery_Rating']]
    .drop_duplicates(subset=['Delivery_Partner_ID'])
)

df_dp.columns = ['Delivery_Partner_ID','Avg_Rating']

# Safety check (optional but recommended)
print(
    "Duplicate delivery partners:",
    df_dp['Delivery_Partner_ID'].duplicated().sum()
)

df_dp.to_sql(
    'delivery_partners',
    engine,
    if_exists='append',
    index=False
)

print(" Delivery partners loaded")



#  ORDERS (FACT TABLE)

df_orders = df[
    ['Order_ID','Customer_ID','Restaurant_ID','Delivery_Partner_ID',
     'Order_Date','Order_Hour','Order_Day_Type','Peak_Hour',
     'Order_Value','Discount_Applied','Final_Amount',
     'Payment_Mode','Order_Status','Cancellation_Reason',
     'Delivery_Time_Min','Distance_km','Delivery_Rating',
     'Profit_Margin','Profit_Margin_Pct']
]

df_orders.to_sql(
    'orders',
    engine,
    if_exists='append',
    index=False
)

print(" Orders loaded")
print(" ALL DATA LOADED INTO MYSQL SUCCESSFULLY")
