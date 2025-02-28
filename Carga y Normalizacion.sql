# CREATE DATABASE Telco;
USE Telco;

# DROP TABLE demographics;
CREATE TABLE demographics(Customer_ID VARCHAR(50), 
						  Count TINYINT,
                          Gender VARCHAR(50),
                          Age INT,
                          Under_30 VARCHAR(50),
                          Sr_Citizen VARCHAR(50),
                          Married VARCHAR(50),
                          Depend VARCHAR(50),
                          Num_Depend TINYINT);
                          
# DROP TABLE location;
CREATE TABLE location(Customer_ID VARCHAR(50), 
					  Count TINYINT,
                      Country VARCHAR(50),
                      State VARCHAR(50),
                      City VARCHAR(50),
                      Zip_Code INT,
                      Latitude VARCHAR(255),
                      Longitude VARCHAR(255));
                      
# DROP TABLE population;
CREATE TABLE population(ID INT, 
                        Zip_Code INT,
                        Popu INT);
                        
# DROP TABLE services;
CREATE TABLE services(Customer_ID VARCHAR(50), 
					  Count TINYINT,
                      Quart VARCHAR(50),
                      Referred_Friend VARCHAR(50),
                      Num_Referrals INT,
                      Tenure_Months INT,
                      Offer VARCHAR(50),
                      Phone_Service VARCHAR(50), 
                      Avg_Long_Dist_Charge VARCHAR(50),
                      Multi_Lines VARCHAR(50),
                      Internet_Service VARCHAR(50),
                      Internet_Type VARCHAR(50),
                      Avg_Month_GB_Download INT,
                      Online_Security VARCHAR(50),
                      Online_Backup VARCHAR(50),
                      Device_Protection VARCHAR(50),
                      Premium_Tech_Support VARCHAR(50),
                      Streaming_TV VARCHAR(50),
                      Streaming_Movies VARCHAR(50),
                      Streaming_Music VARCHAR(50),
                      Unlimited_Data VARCHAR(50),
                      Contract VARCHAR(50),
                      Paperless_Bill VARCHAR(50),
                      Payment_Meth VARCHAR(50),
                      Monthly_Charge VARCHAR(50),
                      Total_Charges VARCHAR(50),
                      Total_Refunds VARCHAR(50),
                      Total_Extra VARCHAR(50),
                      Total_Long_Dist_Charge VARCHAR(50),
                      Total_Revenue VARCHAR(50));
                      
# DROP TABLE status;
CREATE TABLE status(Customer_ID VARCHAR(50), 
                    Count TINYINT,
                    Quart VARCHAR(50),
                    Customer_Status VARCHAR(50),
                    Churn_Label VARCHAR(50),
                    Churn_Value INT,
                    Churn_Categ VARCHAR(50),
                    Churn_Reason VARCHAR(225));
                    
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TELCO\\Telco_customer_churn_demographics.csv'
INTO TABLE demographics
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TELCO\\Telco_customer_churn_location.csv'
INTO TABLE location
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TELCO\\Telco_customer_churn_population.csv'
INTO TABLE population
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TELCO\\Telco_customer_churn_services.csv'
INTO TABLE services
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TELCO\\Telco_customer_churn_status.csv'
INTO TABLE status
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 
                 
                 
#################################### NORMALIZACION #########################################################

######## DEMOGRAPHICS ######################################################################

SELECT * FROM demographics;

# Customer_ID
SELECT DISTINCT Count(Customer_ID) FROM demographics; # All unique codes

# Count
SELECT Count, COUNT(*) FROM demographics GROUP BY Count; # All "1"
ALTER TABLE demographics DROP COLUMN Count;

# Gender Normalization
SELECT Gender, COUNT(*) FROM demographics GROUP BY Gender; # Female: 3488, Male: 3555
UPDATE demographics SET Gender = 'F' WHERE Gender = 'Female';
UPDATE demographics SET Gender = 'M' WHERE Gender = 'Male';

# Age statistics
ALTER TABLE demographics MODIFY COLUMN Age INT;
SELECT Age, COUNT(*) FROM demographics GROUP BY Age;
SELECT MIN(Age), MAX(Age), AVG(Age) FROM demographics; # Min: 19, Max: 119, Avg: 47.47 
SELECT COUNT(*) FROM demographics WHERE Age > 100; # 109 Rows

# Under 30
SELECT Under_30, COUNT(*) FROM demographics GROUP BY Under_30; # Yes: 1401, No: 5642
UPDATE demographics SET Under_30 = 1 WHERE Under_30 = 'Yes';
UPDATE demographics SET Under_30 = 0 WHERE Under_30 = 'No';

# Sr_Citizen
SELECT Sr_Citizen, COUNT(*) FROM demographics GROUP BY Sr_Citizen; # Yes: 1142, No: 5901
UPDATE demographics SET Sr_Citizen = 1 WHERE Sr_Citizen = 'Yes';
UPDATE demographics SET Sr_Citizen = 0 WHERE Sr_Citizen = 'No';

# Married
SELECT Married, COUNT(*) FROM demographics GROUP BY Married; # Yes: 3402, No: 3641
UPDATE demographics SET Married = 1 WHERE Married = 'Yes';
UPDATE demographics SET Married = 0 WHERE Married = 'No';

# Depend
SELECT Depend, COUNT(*) FROM demographics GROUP BY Depend; # Yes: 1627, No: 5416
UPDATE demographics SET Depend = 1 WHERE Depend = 'Yes';
UPDATE demographics SET Depend = 0 WHERE Depend = 'No';

# Num_Depend
ALTER TABLE demographics MODIFY COLUMN Num_Depend INT;
SELECT Num_Depend, COUNT(*) FROM demographics GROUP BY Num_Depend;
SELECT MIN(Num_Depend), MAX(Num_Depend), AVG(Num_Depend), SUM(Num_Depend) FROM demographics; # Min: 0, Max: 9, Avg: 0.4687, Total: 3301
SELECT AVG(Num_Depend) FROM demographics WHERE Depend = 1; # Avg dependents: 2.03

SELECT SUM(Num_Depend) FROM demographics WHERE Depend = 0; # All '0' for No Dependents

######## LOCATION ######################################################################

SELECT * FROM location;

# Customer_ID
SELECT DISTINCT Count(Customer_ID) FROM location; # All unique codes

# Count
SELECT Count, COUNT(*) FROM location GROUP BY Count; # All "1"
ALTER TABLE location DROP COLUMN Count;

# Country
SELECT DISTINCT Country FROM location;
ALTER TABLE location DROP COLUMN Country; # All "United States"

# State
SELECT DISTINCT State FROM location;
ALTER TABLE location DROP COLUMN State; # All "California"

# City
SELECT DISTINCT City FROM location; # 1106 Cities

# ZipCode
SELECT DISTINCT Zip_Code FROM population; # 1671 ZipCodes

# Latitude and Longitude to numeric
ALTER TABLE location MODIFY COLUMN Latitude DECIMAL(13,7);
ALTER TABLE location MODIFY COLUMN Longitude DECIMAL(13,7);

######## POPULATION ######################################################################

SELECT * FROM population; # 1671 rows

# ID
SELECT ID, COUNT(*) FROM population GROUP BY ID; # All unique IDs

# ZipCode
SELECT Zip_Code, COUNT(*) FROM population GROUP BY Zip_Code; # All unique ZipCodes

# Populaltion
ALTER TABLE population MODIFY COLUMN Popu FLOAT;
SELECT MIN(Popu), MAX(Popu), AVG(Popu), SUM(Popu) FROM population; # Min: 11, Max: 105.285, Avg: 20.276,38, Total: 33.881.838

######## SERVICES ######################################################################

SELECT * FROM services;

# Customer_ID
SELECT DISTINCT Count(Customer_ID) FROM services; # All unique codes

# Count
SELECT Count, COUNT(*) FROM services GROUP BY Count; # All "1"
ALTER TABLE services DROP COLUMN Count;

# Quarter
SELECT Quart, COUNT(Quart) FROM services GROUP BY Quart; # All same Quarter
ALTER TABLE services DROP COLUMN Quart;

# Referred a friend
SELECT Referred_Friend, COUNT(*) FROM services GROUP BY Referred_Friend; # Yes: 3222, No: 3821
UPDATE services SET Referred_Friend = 1 WHERE Referred_Friend = 'Yes';
UPDATE services SET Referred_Friend = 0 WHERE Referred_Friend = 'No';

# Num of referrals
ALTER TABLE services MODIFY COLUMN Num_Referrals FLOAT;
SELECT Num_Referrals, COUNT(*) FROM services GROUP BY Num_Referrals;
SELECT MIN(Num_Referrals), MAX(Num_Referrals), AVG(Num_Referrals), SUM(Num_Referrals) FROM services; # Min: 0, Max: 11, Avg: 1.95, Total: 13747
SELECT AVG(Num_Referrals) FROM services WHERE Referred_Friend = 1; # Avg referrals: 4.27

SELECT SUM(Num_Referrals) FROM services WHERE Referred_Friend = 0; # All '0' for No Dependents

# Tenure in months
ALTER TABLE services MODIFY COLUMN Tenure_Months FLOAT;
SELECT Tenure_Months, COUNT(*) FROM services GROUP BY Tenure_Months;
SELECT MIN(Tenure_Months), MAX(Tenure_Months), AVG(Tenure_Months) FROM services; # Min: 1, Max: 72, Avg: 32.39

# Offer
SELECT Offer, COUNT(*) FROM services GROUP BY Offer; # A: 520, B: 824, C: 415, D: 602, E: 805, None: 3877
SELECT * FROM services WHERE Offer = 'None';

# Phone Service
SELECT Phone_Service, COUNT(*) FROM services GROUP BY Phone_Service; # Yes: 6361, No: 682
UPDATE services SET Phone_Service = 1 WHERE Phone_Service = 'Yes';
UPDATE services SET Phone_Service = 0 WHERE Phone_Service = 'No';

# Avg Monthly Long Distance Charges
ALTER TABLE services MODIFY COLUMN Avg_Long_Dist_Charge FLOAT;
SELECT Avg_Long_Dist_Charge, COUNT(*) FROM services GROUP BY Avg_Long_Dist_Charge; # 0: 682
SELECT MIN(Avg_Long_Dist_Charge), MAX(Avg_Long_Dist_Charge), AVG(Avg_Long_Dist_Charge) FROM services; # Min: 0, Max: 49.99, Avg: 22.96

# Multiple lines
SELECT Multi_Lines, COUNT(*) FROM services GROUP BY Multi_Lines; # Yes: 2971, No: 4072
UPDATE services SET Multi_Lines = 1 WHERE Multi_Lines = 'Yes';
UPDATE services SET Multi_Lines = 0 WHERE Multi_Lines = 'No';

# Internet Service
SELECT Internet_Service, COUNT(*) FROM services GROUP BY Internet_Service; # Yes: 5517, No: 1526
UPDATE services SET Internet_Service = 1 WHERE Internet_Service = 'Yes';
UPDATE services SET Internet_Service = 0 WHERE Internet_Service = 'No';

# Internet type
SELECT Internet_Type, COUNT(*) FROM services GROUP BY Internet_Type; # DSL: 1652, Fiber Optic: 3035, Cable: 830, None: 1526
SELECT * FROM services WHERE Offer = Internet_Type;

# Avg Monthly GB Download
ALTER TABLE services MODIFY COLUMN Avg_Month_GB_Download FLOAT;
SELECT Avg_Month_GB_Download, COUNT(*) FROM services GROUP BY Avg_Month_GB_Download; # 0: 1526
SELECT MIN(Avg_Month_GB_Download), MAX(Avg_Month_GB_Download), AVG(Avg_Month_GB_Download) FROM services; # Min: 0, Max: 85, Avg: 20.52

# Online Security
SELECT Online_Security, COUNT(*) FROM services GROUP BY Online_Security; # Yes: 2019, No: 5024
UPDATE services SET Online_Security = 1 WHERE Online_Security = 'Yes';
UPDATE services SET Online_Security = 0 WHERE Online_Security = 'No';

# Online Backup
SELECT Online_Backup, COUNT(*) FROM services GROUP BY Online_Backup; # Yes: 2429, No: 4614
UPDATE services SET Online_Backup = 1 WHERE Online_Backup = 'Yes';
UPDATE services SET Online_Backup = 0 WHERE Online_Backup = 'No';

# Device Protection Plan
SELECT Device_Protection, COUNT(*) FROM services GROUP BY Device_Protection; # Yes: 2422, No: 4621
UPDATE services SET Device_Protection = 1 WHERE Device_Protection = 'Yes';
UPDATE services SET Device_Protection = 0 WHERE Device_Protection = 'No';

# Premium Tech Support
SELECT Premium_Tech_Support, COUNT(*) FROM services GROUP BY Premium_Tech_Support; # Yes: 2044, No: 4099
UPDATE services SET Premium_Tech_Support = 1 WHERE Premium_Tech_Support = 'Yes';
UPDATE services SET Premium_Tech_Support = 0 WHERE Premium_Tech_Support = 'No';

# Streaming TV
SELECT Streaming_TV, COUNT(*) FROM services GROUP BY Streaming_TV; # Yes: 2707, No: 4336
UPDATE services SET Streaming_TV = 1 WHERE Streaming_TV = 'Yes';
UPDATE services SET Streaming_TV = 0 WHERE Streaming_TV = 'No';

# Streaming Movies
SELECT Streaming_Movies, COUNT(*) FROM services GROUP BY Streaming_Movies; # Yes: 2732, No: 4311
UPDATE services SET Streaming_Movies = 1 WHERE Streaming_Movies = 'Yes';
UPDATE services SET Streaming_Movies = 0 WHERE Streaming_Movies = 'No';

# Unlimited Data
SELECT Unlimited_Data, COUNT(*) FROM services GROUP BY Unlimited_Data; # Yes: 4745, No: 2298
UPDATE services SET Unlimited_Data = 1 WHERE Unlimited_Data = 'Yes';
UPDATE services SET Unlimited_Data = 0 WHERE Unlimited_Data = 'No';

# Contract
SELECT Contract, COUNT(*) FROM services GROUP BY Contract; # Month-to-Month: 3610, One Year: 1550, Two Year: 1883

# Paperless Billing
SELECT Paperless_Bill, COUNT(*) FROM services GROUP BY Paperless_Bill; # Yes: 4171, No: 2872
UPDATE services SET Paperless_Bill = 1 WHERE Paperless_Bill = 'Yes';
UPDATE services SET Paperless_Bill = 0 WHERE Paperless_Bill = 'No';

# Payment Method
SELECT Payment_Meth, COUNT(*) FROM services GROUP BY Payment_Meth; # Bank Withdrawal: 3909, Credit Card: 2749, Mailed Check: 385

# Monthly Charge
ALTER TABLE services MODIFY COLUMN Monthly_Charge FLOAT;
SELECT MIN(Monthly_Charge), MAX(Monthly_Charge), AVG(Monthly_Charge), SUM(Monthly_Charge) FROM services; 
# Min: -10, Max: 118.75, Avg: 63.60, Total: 447907.55
SELECT * FROM services WHERE Monthly_Charge < 0; # 120 negatives 

# Total Charges
ALTER TABLE services MODIFY COLUMN Total_Charges FLOAT;
SELECT MIN(Total_Charges), MAX(Total_Charges), AVG(Total_Charges), SUM(Total_Charges) FROM services; 
# Min: 18.8, Max: 8684.8, Avg: 2280.38, Total: 16.060.725,24

# Total Refunds
ALTER TABLE services MODIFY COLUMN Total_Refunds FLOAT;
SELECT MIN(Total_Refunds), MAX(Total_Refunds), AVG(Total_Refunds), SUM(Total_Refunds) FROM services; 
# Min: 0, Max: 49.79, Avg: 1.96, Total: 13819.65

# Total Extra Data Charges
ALTER TABLE services MODIFY COLUMN Total_Extra FLOAT;
SELECT MIN(Total_Extra), MAX(Total_Extra), AVG(Total_Extra), SUM(Total_Extra) FROM services; 
# Min: 0, Max: 150, Avg: 6.86, Total: 48320

# Total Long Distance Charges
ALTER TABLE services MODIFY COLUMN Total_Long_Dist_Charge FLOAT;
SELECT MIN(Total_Long_Dist_Charge), MAX(Total_Long_Dist_Charge), AVG(Total_Long_Dist_Charge), SUM(Total_Long_Dist_Charge) FROM services; 
# Min: 0, Max: 150, Avg: 6.86, Total: 48320

# Total Revenue
ALTER TABLE services MODIFY COLUMN Total_Revenue FLOAT;
SELECT MIN(Total_Revenue), MAX(Total_Revenue), AVG(Total_Revenue), SUM(Total_Revenue) FROM services; 
# Min: 21.36, Max: 11979.3, Avg: 3034.38, Total: 21.371.131,68

######## STATUS ######################################################################

SELECT * FROM status;

# Customer_ID
SELECT DISTINCT Count(Customer_ID) FROM status; # All unique codes

# Count
SELECT Count, COUNT(*) FROM status GROUP BY Count; # All "1"
ALTER TABLE status DROP COLUMN Count;

# Quarter
SELECT Quart, COUNT(Quart) FROM status GROUP BY Quart; # All same Quarter
ALTER TABLE status DROP COLUMN Quart;

# Customer Status
SELECT Customer_Status, COUNT(*) FROM status GROUP BY Customer_Status; # Churned: 1869, Stayed: 4720, Joined: 454

# Churn label
SELECT Churn_Label, COUNT(*) FROM status GROUP BY Churn_Label; # Yes: 1869, No: 5174
UPDATE status SET Churn_Label = 1 WHERE Churn_Label = 'Yes';
UPDATE status SET Churn_Label = 0 WHERE Churn_Label = 'No';

# Churn value
SELECT Churn_Value, COUNT(*) FROM status GROUP BY Churn_Value; # 1: 1869, 0: 5174

# Churn category
SELECT Churn_Categ, COUNT(*) FROM status GROUP BY Churn_Categ; # Dissatisfaction: 303, Price: 211, Other: 200, Attitude: 314, Null: 5174
SELECT * FROM status WHERE Churn_Categ IS NULL OR Churn_Categ = ''; # Null values correspond to Customer_Status = 'Stayed' or 'Joined'
UPDATE status SET Churn_Categ = NULL WHERE Churn_Label = 0;

# Churn reason
SELECT Churn_Reason, COUNT(*) FROM status GROUP BY Churn_Reason; # Null: 5174
UPDATE status SET Churn_Reason = NULL WHERE Churn_Label = 0; # Null values correspond to Customer_Status = 'Stayed' or 'Joined'


