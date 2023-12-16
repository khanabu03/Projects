Select * From Bank_loan_data

Select count(id) AS Total_Applications from Bank_loan_data

Select count(id) AS Month_To_Date_Applications from Bank_loan_data
Where Month(issue_date) = 12 AND Year(issue_date) = 2021

Select count(id) AS Previous_Month_To_Date_Applications from Bank_loan_data
Where Month(issue_date) = 11 AND Year(issue_date) = 2021
--(MTD-PMTD)/PMTD to find month to date applications
Select sum(loan_amount) AS Total_Amounnt_Loaned from Bank_loan_data

Select sum(loan_amount) AS Total_Month_To_date_Amounnt_Loaned from Bank_loan_data
Where Month(issue_date) = 12 AND Year(issue_date) = 2021

Select sum(loan_amount) AS Previous_Total_Month_To_date_Amounnt_Loaned from Bank_loan_data
Where Month(issue_date) = 11 AND Year(issue_date) = 2021

Select sum(total_payment) as Total_amount_Received from Bank_loan_data

Select sum(total_payment) as Total_MTD_amount_Received from Bank_loan_data
Where Month(issue_date) = 12 AND Year(issue_date) = 2021

Select sum(total_payment) as Total_PMTD_amount_Received from Bank_loan_data
Where Month(issue_date) = 11 AND Year(issue_date) = 2021

Select round(avg(int_rate),4)*100 as Average_INterest_Rate from Bank_loan_data
--use round(function, 2/4) to round up the decimal to required points

Select round(avg(int_rate),4)*100 as MTD_Average_INterest_Rate from Bank_loan_data
Where Month(issue_date) = 12 AND Year(issue_date) = 2021

Select round(avg(int_rate),4)*100 as PMTD_Average_INterest_Rate from Bank_loan_data
Where Month(issue_date) = 11 AND Year(issue_date) = 2021

Select round(AVG(dti),4)*100 AS AVerage_dti from Bank_loan_data

Select round(AVG(dti),4)*100 AS MTD_AVerage_dti from Bank_loan_data
Where Month(issue_date) = 12 AND Year(issue_date) = 2021

Select round(AVG(dti),4)*100 AS PMTD_AVerage_dti from Bank_loan_data
Where Month(issue_date) = 11 AND Year(issue_date) = 2021

Select loan_status from Bank_loan_data

Select (count(case when loan_status = 'Fully Paid' OR loan_status = 'Current' Then id END)*100 / count(id)) AS good_loan_pct
From Bank_loan_data

Select count(id) AS good_loan_applications from Bank_loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current'

Select sum(loan_amount) AS good_loan_funded from Bank_loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current' 

Select sum(total_payment) AS good_loan_received from Bank_loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current' 

Select (count(case when loan_status = 'Charged Off' Then id END)*100 / count(id)) AS bad_loan_pct
From Bank_loan_data

Select count(id) AS bad_loan_applications from Bank_loan_data
where loan_status = 'Charged Off'

Select sum(loan_amount) AS bad_loan_funded from Bank_loan_data
where loan_status = 'Charged Off'

Select sum(total_payment) AS bad_loan_received from Bank_loan_data
where loan_status = 'Charged Off'

Select loan_status, 
count(id) AS Total_Applications, 
SUM(total_payment) AS Totoal_AMount_Received, 
SUM(loan_amount) AS Total_Funded_Amount, 
AVG(int_rate * 100) AS Interest_Rate,
AVG(dti * 100) AS DTI
From Bank_loan_data
Group By loan_status
--loan status details for each kind
Select loan_status,
SUM(total_payment) AS MTD_Total_received_Amount,
SUM(loan_amount) AS MTD_Total_Funded_Amt
From Bank_loan_data
Where Month(issue_date) = 12
Group By loan_status

Select 
Month(issue_date) AS Month_Number,
Datename(Month, issue_date),
count(id) as Total_Applications,
SUM(loan_amount) as Total_Funded_amount,
SUM(total_payment) as Total_Received_Amt
From Bank_loan_data
Group By Month(issue_date), Datename(Month, issue_date)
Order By Month(issue_date) 

Select 
address_state,
count(id) as Total_Applications,
SUM(loan_amount) as Total_Funded_amount,
SUM(total_payment) as Total_Received_Amt
From Bank_loan_data
Group By address_state
Order By count(id) DESC

Select 
term,
count(id) as Total_Applications,
SUM(loan_amount) as Total_Funded_amount,
SUM(total_payment) as Total_Received_Amt
From Bank_loan_data
Group By term
Order By term DESC

Select 
emp_length,
count(id) as Total_Applications,
SUM(loan_amount) as Total_Funded_amount,
SUM(total_payment) as Total_Received_Amt
From Bank_loan_data
Group By emp_length
Order By emp_length DESC


Select 
purpose,
count(id) as Total_Applications,
SUM(loan_amount) as Total_Funded_amount,
SUM(total_payment) as Total_Received_Amt
From Bank_loan_data
Group By purpose
Order By count(id) DESC

Select 
home_ownership,
count(id) as Total_Applications,
SUM(loan_amount) as Total_Funded_amount,
SUM(total_payment) as Total_Received_Amt
From Bank_loan_data
Group By home_ownership
Order By count(id) DESC

