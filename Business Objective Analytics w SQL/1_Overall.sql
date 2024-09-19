-- 1. How does the number of employees in high-paying roles compare to those in low-paying roles?
with SalaryCategory as
	(
	select 
		case 
			when MonthlyIncome < (select AVG(MonthlyIncome) from Attrition) then 'low'
			when MonthlyIncome >= (select AVG(MonthlyIncome) from Attrition) then 'high'
		end as SalaryCategory
	from Attrition
),
EmployeeCount as
	(
	select 
		SalaryCategory,
		count(*) as EmployeeCount
	from SalaryCategory
	group by SalaryCategory
)
select 
	SalaryCategory,
	EmployeeCount,
	(EmployeeCount * 100.0 / (select count(*) from Attrition)) as Percentage
from EmployeeCount
order by SalaryCategory


-- 2. What is the average salary distribution by job level?
--- this query finds the AvgSalary of each JobLevel and the distribution of workforce correspondingly
with AvgSalary as
	(
	select 
		JobLevel,
		AVG(MonthlyIncome) as AvgSalary,
		count (*) as EmployeeCount
	from Attrition
	group by JobLevel
)
select 
	*,
	(EmployeeCount * 100.0 / (select count(*) from Attrition)) as Percentage
from AvgSalary
order by JobLevel


-- 3. What is the average salary distribution by job role?
with AvgSalary as
	(
	select 
		JobRole,
		AVG(MonthlyIncome) as AvgSalary,
		count (*) as EmployeeCount
	from Attrition
	group by JobRole
)
select 
	*,
	(EmployeeCount * 100.0 / (select count(*) from Attrition)) as Percentage
from AvgSalary
order by Percentage desc