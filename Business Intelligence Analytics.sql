USE data_assignment;

CREATE TABLE customer_data(
Cust_Id VARCHAR(100),
CUSTOMER_DATE VARCHAR(100),
Week VARCHAR(100),
Cust_Profession VARCHAR(100),
Day	VARCHAR(100),
Month VARCHAR(100),
Year VARCHAR(100),
Time VARCHAR(100),
combine_value VARCHAR(100),
customer_created_date DATE);

LOAD DATA INFILE 'C:/ProgramData/MySQL/Case_Study_Customer_Data.csv'
INTO TABLE customer_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM customer_data LIMIT 8000;


CREATE TABLE order_data(
Order_No Varchar(100),
Cust_ID	Varchar(100),
order_date_time Varchar(100),	
Order_Status Varchar(100),
Order_Amount INT,
month_name Varchar(100),
Day_no	Varchar(100),
Year_no Varchar(100),
time_no Varchar(100),
am_pm Varchar(100),
combine_data Varchar(100),
Order_date DATE);

LOAD DATA INFILE 'C:/ProgramData/MySQL/Case_Study_Orders_Data.csv'
INTO TABLE order_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT * FROM order_data LIMIT 8000;

-- Objective
-- Question1 Monthly Revenue, Users, and Revenue per User

SELECT
    DATE_FORMAT(o.Order_date, '%Y-%m') AS Month,
    COUNT(DISTINCT c.Cust_ID) AS Total_Users,
    SUM(CASE WHEN o.Order_Status = 'Won' THEN o.Order_Amount ELSE 0 END) AS Total_Revenue,
    SUM(CASE WHEN o.Order_Status = 'Won' THEN o.Order_Amount ELSE 0 END) / COUNT(DISTINCT c.Cust_ID) AS Revenue_Per_User
FROM
    order_data o
JOIN
    customer_data c ON o.Cust_ID = c.Cust_ID
WHERE
    c.customer_created_date >= '2021-01-01' AND c.customer_created_date <= '2021-06-30'
GROUP BY
     DATE_FORMAT(o.Order_Date, '%Y-%m')
ORDER BY
    Month;

-- Question 2 

SELECT
    DATE_FORMAT(o.Order_Date, '%Y-%m') AS Month,
    c.Cust_Profession,
    COUNT(DISTINCT c.Cust_ID) AS Users_Placed_Order,
    COUNT(DISTINCT CASE WHEN o.Order_Status = 'Won' THEN c.Cust_ID END) AS Users_Converted
FROM
    order_data o
JOIN
    customer_data c ON o.`Cust_ID` = c.`Cust_ID`
WHERE
    c.`customer_created_date` BETWEEN '2021-01-01' AND '2021-06-30'
GROUP BY
    DATE_FORMAT(o.Order_Date, '%Y-%m'),
    c.Cust_Profession
ORDER BY
    Month, c.Cust_Profession;


-- Question 3 Cohort Analysis


-- Cohort Analysis
SELECT
    DATE_FORMAT(c.customer_created_date, '%Y-%m') AS Cohort_Month,
    DATE_FORMAT(o.Order_date, '%Y-%m') AS Purchase_Month,
    COUNT(DISTINCT c.Cust_ID) AS Users,
    COUNT(DISTINCT CASE WHEN o.Order_Status = 'Won' THEN o.Cust_ID END) AS Converting_Users
FROM
    customer_data c
LEFT JOIN
    order_data o ON c.Cust_ID = o.Cust_ID
WHERE
    c.customer_created_date >= '2021-01-01' AND c.customer_created_date <= '2021-06-30' AND
    o.Order_Date >= c.customer_created_date  
GROUP BY
    Cohort_Month, Purchase_Month
ORDER BY
    Cohort_Month, Purchase_Month;
    
    -- This data allows us to analyze how the number of users making purchases varies over different months for each cohort.