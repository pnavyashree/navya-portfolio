-- How to create an empty table from an existing table ?

CREATE TABLE new_table AS
SELECT *
FROM existing_table -- copies all columns.
WHERE 1=0; -- ensures no rows are copied, so the new table is empty


-- How to fetch common records from two tables ?

SELECT t1.*
FROM table1 t1
INNER JOIN table2 t2
ON t1.emp_id = t2.emp_id;

-- OR

SELECT *
FROM employees_2024
WHERE emp_id IN (
    SELECT emp_id
    FROM employees_2025
);


-- How to fetch alternate records from a table ?

WITH num AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY emp_id) AS rn
    FROM employees
)
SELECT *
FROM num
WHERE rn % 2 = 1;  -- change to 0 for even rows


-- How to select unique records from a table ?

SELECT DISTINCT name
FROM employees;


-- Which operator is used in query for pattern matching ? 

-- The operator used in SQL for pattern matching is the LIKE operator.

SELECT column1, column2
FROM table_name
WHERE column_name LIKE 'pattern';


-- What is the command used to fetch the first five characters of the string?

-- The exact function depends on the database you are using, but the most common ones are SUBSTRING (or SUBSTR) and LEFT
/* column_name → the column containing the string

1 → starting position (first character)

5 → number of characters to extract */

SELECT SUBSTRING(column_name, 1, 5) AS first_five_chars
FROM table_name;

-- LEFT(column_name, 5) → takes the first 5 characters from the left.

SELECT LEFT(column_name, 5) AS first_five_chars
FROM table_name;

-- Assuming two tables
-- SQL query to fetch records that are present in one table, but not in another table.

SELECT *
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM employees_projects e2
    WHERE e2.emp_id = e1.emp_id
);


-- Query to fetch all the employees who are not working for any of the projects.

SELECT *
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_projects p
    WHERE p.employee_id = e.employee_id
);


-- Query to fetch all the employees from the employee details table who joined in the year 2020

SELECT *
FROM EmployeeDetails
WHERE YEAR(STR_TO_DATE(DateOfJoining, '%m/%d/%Y')) = 2020;


-- All the employee from the Employee Details Table, those who have salary record in the Employee Salary Table.

SELECT e.*
FROM EmployeeDetails e
INNER JOIN EmployeeSalary s
    ON e.EmpId = s.EmpId;


-- Write a SQL query to fetch project-wise count of an employee.

SELECT Project, COUNT(EmpId) AS EmployeeCount
FROM EmployeeSalary
GROUP BY Project;


-- Fetch employee names and salary, even if the salary value is not present for the employee.

SELECT e.FullName, s.Salary
FROM EmployeeDetails e
LEFT JOIN EmployeeSalary s
    ON e.EmpId = s.EmpId;


-- Write a SQL query to fetch all the employees who are also managers.

SELECT e.*
FROM EmployeeDetails e
WHERE e.EmpId IN (
    SELECT ManagerId
    FROM EmployeeDetails
);


-- Write a SQL query to fetch duplicate records from employee details.

SELECT *
FROM EmployeeDetails
WHERE EmpId IN (
    SELECT EmpId
    FROM EmployeeDetails
    GROUP BY EmpId
    HAVING COUNT(*) > 1
);


-- SQL query to fetch only odd rows from the table.

SELECT *
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY EmpId) AS rn, *
    FROM EmployeeDetails
) t
WHERE rn % 2 = 1;


-- Write a query to find the third highest salary from a table without top or limit keyword.

SELECT Salary AS ThirdHighestSalary
FROM (
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employee
) AS RankedSalaries
WHERE SalaryRank = 3;


-- Query to get second highest salary among all the employees.

SELECT MAX(Salary) AS SecondHighestSalary
FROM Employee
WHERE Salary < (SELECT MAX(Salary) FROM Employee);


-- Write a SQL query to find maximum salary and department name from each department.

SELECT Department, MAX(Salary) AS MaxSalary
FROM Employee
GROUP BY Department;


-- Find records from Table A that are not present in Table B without using NOT IN operator

SELECT A.*
FROM TableA A
LEFT JOIN TableB B
    ON A.id = B.id
WHERE B.id IS NULL;

-- OR

SELECT *
FROM TableA A
WHERE NOT EXISTS (
    SELECT 1
    FROM TableB B
    WHERE A.id = B.id
);


-- Write SQL query to find employees that have same name and email

SELECT Name, Email, COUNT(*) AS CountOfDuplicates
FROM Employee
GROUP BY Name, Email
HAVING COUNT(*) > 1;


-- Write a SQL query to find maximum salary from each department

SELECT Department, MAX(Salary) AS MaxSalary
FROM Employee
GROUP BY Department;


-- Write SQL query to get the nth highest salary among all the employees.

WITH RankedSalaries AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employee
)
SELECT Salary AS NthHighestSalary
FROM RankedSalaries
WHERE SalaryRank = N;


-- How can you find 10 employees with odd number as employee ID?

SELECT *
FROM Employee
WHERE EmployeeID % 2 = 1
LIMIT 10;


-- Write a SQL query to get the names of employees whose date of birth is between 01.01.1990 to 31.12.2000

SELECT Name
FROM Employee
WHERE DOB BETWEEN '1990-01-01' AND '2000-12-31';


-- Write the SQL query to get the quarter from the date

SELECT DATEPART(QUARTER, DateColumn) AS Quarter
FROM SampleTable;


-- Write query to find employees with duplicate email.

SELECT Email, COUNT(*) AS CountEmail
FROM Employee
GROUP BY Email
HAVING COUNT(*) > 1;


-- Write SQL query to get employee name, manager ID, and number of employees in the department.

SELECT 
    e.Name,
    e.Manager_ID,
    e.Department,
    d.DeptCount
FROM Employee e
JOIN (
    SELECT Department, COUNT(*) AS DeptCount
    FROM Employee
    GROUP BY Department
) d
ON e.Department = d.Department;


-- How can we retrieve alternate records from a table in Oracle?

