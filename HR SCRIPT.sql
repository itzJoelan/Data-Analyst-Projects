-- HR ANALYTICS CHALLENGE BY ONYX
-- AUTHOR; MC JOELAN D. AGAN
-- DATE: OCTOBER 13, 2024
-- TIME 7:51 AM PACIFIC TIME

USE hr;

-- Total employee, active and resigned
SELECT COUNT(*)
FROM hr;

SELECT
    COUNT(CASE WHEN Resigned = 'FALSE' THEN Employee_id END) AS Active_Employees,
    COUNT(CASE WHEN Resigned = 'TRUE' THEN Employee_id END) AS Resigned_Employees
FROM 
    hr;

-- Employee count by department
SELECT
    Department,
    COUNT(Employee_id) AS Employee_Count
FROM 
    hr
GROUP BY 
    Department;

-- Gender distribution
SELECT Gender,
	COUNT(*) AS Gender_count
FROM hr
GROUP BY Gender;


-- Tenure by age
SELECT 
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE 'Other'
    END AS Age_Group,
    COUNT(Employee_id) AS Employee_Count
FROM 
    hr
GROUP BY 
    Age_Group;

SELECT 
    Age_Group,
    Employee_Count,
    CASE 
		WHEN Age_Group = '18-25' THEN 1
        WHEN Age_Group = '26-35' THEN 2
        WHEN Age_Group = '36-45' THEN 3
        WHEN Age_Group = '46-55' THEN 4
        WHEN Age_Group = '56-65' THEN 5
        ELSE 6
    END AS Sequence
FROM 
    (SELECT 
        CASE
               WHEN Age BETWEEN 18 AND 25 THEN '18-25'
			WHEN Age BETWEEN 26 AND 35 THEN '26-35'
			WHEN Age BETWEEN 36 AND 45 THEN '36-45'
			WHEN Age BETWEEN 46 AND 55 THEN '46-55'
			WHEN Age BETWEEN 56 AND 65 THEN '56-65'
			ELSE 'Other'
        END AS Age_Group,
        COUNT(*) AS Employee_Count
    FROM 
        hr
    GROUP BY 
        Age_Group) AS AgeGroups
ORDER BY 
	Sequence ASC;

-- hire date trend
-- Year
SELECT 
    YEAR(Hire_Date) AS Hire_Year,
    COUNT(*) AS Hires_Count
FROM 
    hr
GROUP BY 
    Hire_Year
ORDER BY 
    Hire_Year ASC;
-- Monthly
SELECT 
    YEAR(Hire_Date) AS Hire_Year, 
    MONTH(Hire_Date) AS Hire_Month, 
    COUNT(*) AS Hires_Count
FROM 
    hr
GROUP BY 
    Hire_Year, Hire_Month
ORDER BY 
    Hire_Year ASC, Hire_Month ASC;
-- Quarterly hire trend
SELECT 
    YEAR(Hire_Date) AS Hire_Year, 
    QUARTER(Hire_Date) AS Hire_Quarter, 
    COUNT(*) AS Hires_Count
FROM 
    hr
GROUP BY 
    Hire_Year, Hire_Quarter
ORDER BY 
    Hire_Year ASC, Hire_Quarter ASC;

-- Years at company
SELECT AVG(Years_at_Company)
FROM hr;

-- Employee Sarisfaction
SELECT ROUND(AVG(Employee_Satisfaction_Score), 4)
FROM hr;

-- Resignation rate
SELECT 
    (SUM(CASE WHEN Resigned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Resignation_Rate_Percentage
FROM 
    hr;

-- Monthly resignation rate
SELECT 
    YEAR(Hire_Date) AS Year,
    (SUM(CASE WHEN Resigned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Resignation_Rate_Percentage
FROM 
    hr
GROUP BY 
    YEAR(Hire_Date)
ORDER BY 
    Year ASC;

SELECT 
    YEAR(Hire_Date) AS Year, 
    MONTH(Hire_Date) AS Month, 
    (SUM(CASE WHEN Resigned = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Resignation_Rate_Percentage
FROM 
    hr
GROUP BY 
    YEAR(Hire_Date), MONTH(Hire_Date)
ORDER BY 
    Year ASC, Month ASC;

-- Total overtime work hours
SELECT SUM(Overtime_hours)
FROM hr;

-- Rmote work frequency
SELECT Employee_id,
	AVG(Remote_Work_Frequency)
FROM hr
GROUP BY Employee_id;

-- Training hours 
SELECT Department,
	SUM(Training_Hours)
FROM hr
GROUP BY Department;

-- Sick days
SELECT AVG(Sick_Days)
FROM hr;

-- Years at Company
SELECT
        Years_At_Company,
             CASE
		WHEN Years_At_Company < 1 THEN '0'
        WHEN Years_At_Company  BETWEEN 1 AND 2 THEN '1-2'
        WHEN Years_At_Company BETWEEN 3 AND 4 THEN '3-4'
        WHEN Years_At_Company BETWEEN 5 AND 6 THEN '5-6'
        WHEN Years_At_Company BETWEEN 7 AND 8 THEN '7-8'
        WHEN Years_At_Company BETWEEN 9 AND 10 THEN '9-10'
        ELSE 'Other'
    END AS Years_Stay, 
    COUNT(Employee_id) AS Employee_Count
FROM hr
GROUP BY Years_At_Company;

-- Average Performance score by department, job title and years at company
SELECT AVG(Performance_Score) AS avg_perf_score,
	Department,
    Job_Title,
				CASE
			WHEN Years_At_Company < 1 THEN '0'
			WHEN Years_At_Company  BETWEEN 1 AND 2 THEN '1-2'
			WHEN Years_At_Company BETWEEN 3 AND 4 THEN '3-4'
			WHEN Years_At_Company BETWEEN 5 AND 6 THEN '5-6'
			WHEN Years_At_Company BETWEEN 7 AND 8 THEN '7-8'
			WHEN Years_At_Company BETWEEN 9 AND 10 THEN '9-10'
			ELSE 'Other'
		END AS Years_Stay, 
		COUNT(Employee_id) AS Employee_Count
FROM hr
GROUP BY Department, 
	Job_Title, 
	Years_Stay
ORDER BY avg_perf_score DESC;

-- Count of employees falling under each Performance score category ( Exceeds, Fully Meets,Meets Most, Needs Improvement, PIP)
SELECT
	CASE 
		WHEN Performance_Score = 5 THEN "Exceeds Expectations"
		WHEN Performance_Score = 4 THEN "Fully Meets Expectations"
		WHEN Performance_Score = 3 THEN "Most Meets Expectations"
		WHEN Performance_Score = 2 THEN "Needs Improvement"
		WHEN Performance_Score = 1 THEN "Unsatisfactory/PIP"
    END AS Performance_Category,
    COUNT(Employee_id) AS Employee_Count
FROM hr
GROUP BY Performance_Category
ORDER BY EMployee_Count DESC;

-- Average Monthly Salary by Job title and department
SELECT 
    AVG(Monthly_Salary) AS avg_salary, Job_Title, Department
FROM
    hr
GROUP BY Job_Title , Department;

-- Total Salary by Department
SELECT Department, SUM(Monthly_Salary) AS Total_Salary
FROM hr
GROUP BY Department
HAVING SUM(Monthly_Salary) > (SELECT AVG(Monthly_Salary) FROM hr);

-- Salary Percentage
SELECT 
    Department, 
    Job_Title, 
    (Monthly_Salary / 
        (SELECT SUM(Monthly_Salary) 
         FROM hr  
         WHERE hr.Department = hr.Department 
           AND hr.Job_Title = hr.Job_Title)
    ) * 100 AS Salary_Percentage
FROM hr
GROUP BY Department, Job_Title, Monthly_Salary
ORDER BY Department, Job_Title;

SELECT SUM(Salary_Percentage)
FROM hr;

-- 
WITH TotalSalaries AS (
    SELECT 
        Department, 
        Job_Title, 
        SUM(Monthly_Salary) AS Total_Monthly_Salary
    FROM hr
    GROUP BY Department, Job_Title
)
SELECT 
    hr.Department, 
    hr.Job_Title, 
    SUM((hr.Monthly_Salary / TotalSalaries.Total_Monthly_Salary) * 100) AS Total_Salary_Percentage
FROM hr
JOIN TotalSalaries 
    ON hr.Department = TotalSalaries.Department 
    AND hr.Job_Title = TotalSalaries.Job_Title
GROUP BY hr.Department, hr.Job_Title
ORDER BY hr.Department, hr.Job_Title;

-- Salary Comparison across Education level
SELECT AVG(Monthly_Salary) AS avg_salary,
	Education_Level
FROM hr
GROUP BY Education_Level;

SELECT SUM(Monthly_Salary) AS avg_salary,
	Education_Level
FROM hr
GROUP BY Education_Level;

-- Total OT by department, avg overtime per employee
SELECT AVG(Overtime_Hours) AS avg_ot,
	Employee_ID,
    SUM(Overtime_Hours) AS Total_OT,
    Department
FROM hr
GROUP BY Department, Employee_ID;

-- Work hours per week and prjects handled
SELECT AVG(Work_Hours_Per_Week) AS avg_work,
	Department,
    Job_Title,
	SUM(Projects_Handled) AS Total_projects
FROM hr
GROUP BY Department, Job_Title;

-- Resignation Rate By Department
SELECT COUNT(Resigned = 'TRUE'),
	Department,
    Job_Title
FROM hr
GROUP BY Department,
	Job_Title;

SELECT 
    Department,
    Job_Title,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Resigned = 'TRUE' THEN 1 ELSE 0 END) AS Resigned_Count,
    (SUM(CASE WHEN Resigned = 'TRUE' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) * 100 AS Resignation_Rate
FROM 
    hr
GROUP BY 
    Department,
    Job_Title;

-- Promotion  rate by Department, years at company and job title
SELECT 
    Department,
    Job_Title,
    Years_At_Company,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Promotions > 0 THEN 1 ELSE 0 END) AS Promoted_Employees,
    (SUM(CASE WHEN Promotions > 0 THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) * 100 AS Promotion_Rate
FROM 
    hr
GROUP BY 
    Department,
    Job_Title,
    Years_At_Company;

-- Training hours comparison with performance score and promotions
SELECT 
    CASE 
        WHEN Promotions > 0 THEN 'Promoted' 
        ELSE 'Not Promoted' 
    END AS Promotion_Status,
    AVG(Training_Hours) AS Avg_Training_Hours,
    COUNT(*) AS Total_Employees
FROM 
    hr
GROUP BY 
    Performance_Score,
    Promotion_Status
ORDER BY 
    Performance_Score, 
    Promotion_Status;

-- Average Employee Satisfaction Score by department, job title and remote work frequency
SELECT 
    Department,
    Job_Title,
    Remote_Work_Frequency,
    AVG(Employee_Satisfaction_Score) AS Avg_Satisfaction_Score,
    COUNT(*) AS Total_Employees
FROM 
    hr
GROUP BY 
    Department,
    Job_Title,
    Remote_Work_Frequency
ORDER BY 
    Department, 
    Job_Title, 
    Remote_Work_Frequency;

-- Satisfaction score correlation to sick days and overtime hours
SELECT 
    (SUM((Employee_Satisfaction_Score - avg_satisfaction) * (Sick_Days - avg_sick_days)) / 
     (SQRT(SUM(POW(Employee_Satisfaction_Score - avg_satisfaction, 2)) * SUM(POW(Sick_Days - avg_sick_days, 2))))) AS Correlation_Satisfaction_SickDays,
    
    (SUM((Employee_Satisfaction_Score - avg_satisfaction) * (Overtime_Hours - avg_overtime_hours)) / 
     (SQRT(SUM(POW(Employee_Satisfaction_Score - avg_satisfaction, 2)) * SUM(POW(Overtime_Hours - avg_overtime_hours, 2))))) AS Correlation_Satisfaction_OvertimeHours
FROM 
    (SELECT 
        Employee_Satisfaction_Score,
        Sick_Days,
        Overtime_Hours,
        AVG(Employee_Satisfaction_Score) OVER () AS avg_satisfaction,
        AVG(Sick_Days) OVER () AS avg_sick_days,
        AVG(Overtime_Hours) OVER () AS avg_overtime_hours
     FROM hr
    ) AS subquery;

-- Remote work frequency vs performance score and satisfaction score
SELECT 
    Remote_Work_Frequency,
    AVG(Employee_Satisfaction_Score) AS Avg_Satisfaction_Score,
    AVG(Performance_Score) AS Avg_Performance_Score,
    COUNT(*) AS Total_Employees
FROM 
    hr
GROUP BY 
    Remote_Work_Frequency
ORDER BY 
    Remote_Work_Frequency;

-- Emplpoyees work remotely more often have higher satisfaction or performance
SELECT 
    Remote_Work_Frequency,
    AVG(Employee_Satisfaction_Score) AS Avg_Satisfaction_Score,
    AVG(Performance_Score) AS Avg_Performance_Score,
    COUNT(*) AS Total_Employees
FROM 
    hr
GROUP BY 
    Remote_Work_Frequency
ORDER BY 
    Remote_Work_Frequency;







