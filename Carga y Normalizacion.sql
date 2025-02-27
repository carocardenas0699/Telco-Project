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
                 
                 
####################### NORMALIZACION #######################

######## DEMOGRAPHICS ##############

SELECT * FROM demographics;

# Customer_ID
SELECT DISTINCT Customer_ID FROM demographics; # All unique codes

# Count
SELECT Count, COUNT(*) FROM demographics GROUP BY Count;
ALTER TABLE demographics DROP COLUMN Count;

# Gender Normalization
SELECT DISTINCT Gender FROM demographics;
UPDATE demographics SET Gender = 'F' WHERE Gender = 'Female';
UPDATE demographics SET Gender = 'M' WHERE Gender = 'Male';

# Age statistics
SELECT Age, COUNT(*) FROM demographics GROUP BY Age;
SELECT MIN(Age), MAX(Age), AVG(Age) FROM demographics; # Min: 19, Max: 119, Avg: 47.47 
SELECT COUNT(*) FROM demographics WHERE Age > 80; # 110 Rows

# Under 30
SELECT DISTINCT Under_30 FROM demographics;

# Sr_Citizen
SELECT DISTINCT Sr_Citizen FROM demographics;

# Married
SELECT DISTINCT Married FROM demographics;

# Depend
SELECT DISTINCT Depend FROM demographics;

# Num_Depend
SELECT Num_Depend, COUNT(*) FROM demographics GROUP BY Num_Depend;
SELECT MIN(Num_Depend), MAX(Num_Depend), AVG(Num_Depend) FROM demographics; # Min: 0, Max: 9, Avg: 0.4687

######## LOCATION ##############

SELECT * FROM location;

# Customer_ID
SELECT DISTINCT Customer_ID FROM location; # All unique codes

# Count
SELECT Count, COUNT(*) FROM location GROUP BY Count;
ALTER TABLE location DROP COLUMN Count;

# Country
SELECT DISTINCT Country FROM location;
ALTER TABLE location DROP COLUMN Country;

# State
SELECT DISTINCT State FROM location;
ALTER TABLE location DROP COLUMN State;

# Country
SELECT DISTINCT City FROM location;

ALTER TABLE location MODIFY COLUMN Latitude DECIMAL(13,10);
ALTER TABLE location MODIFY COLUMN Longitude DECIMAL(13,10);