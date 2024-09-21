-- 2.1. Find the overall attrition rate
select
	COUNT(case when Attrition = 'Yes' then 1 else null end) * 100.0  / COUNT(*) as Attrition_Rate
from Attrition

-- 2.2. Find the attrition rate by age group
select
	Age,
	COUNT(case when Attrition = 'Yes' then 1 else null end) * 100.0  / COUNT(*) as Attrition_Rate
from Attrition
group by Age
order by Attrition_Rate desc


-- 2.3. Average attrition rate by gender
select
	Gender,
	COUNT(case when Attrition = 'Yes' and YearsAtCompany > 2 then 1 else null end) * 100.0  / COUNT(*) as Attrition_Rate
from Attrition
group by Gender
order by Attrition_Rate desc


-- 2.4. Average attrition rate by department
select
	Department,
	COUNT(case when Attrition = 'Yes' and YearsAtCompany > 2 then 1 else null end) * 100.0  / COUNT(*) as Attrition_Rate
from Attrition
group by Department
order by Attrition_Rate desc


-- 2.5. Average attrition rate by job level
--- The job level is the employee's job level, from entry-level (1) to senior positions (5).
--- Consider only employees with 2 years above (2 years' service rule)
select
	JobLevel,
	COUNT(case when Attrition = 'Yes' and YearsAtCompany > 2 then 1 else null end) * 100.0  / COUNT(*) as Attrition_Rate
from Attrition
group by JobLevel
order by Attrition_Rate desc

-- 2.6. Ranking Employees by Attrition Risk using Multiple Factors
with Attrition_Rank as
	(
	select 
		EmployeeNumber,
		JobRole,
		OverTime,
		JobSatisfaction, 
		WorkLifeBalance,
		DENSE_RANK() over(order by 
			case 
				when OverTime = 'Yes' then 1 else null 
			end desc, 
			JobSatisfaction, 
			WorkLifeBalance) as Attrition_Rank
	from Attrition
)
select * 
from Attrition_Rank
where Overtime = 'Yes'
order by Attrition_Rank


-- 2.7. Attrition by Distance from Home and Satisfaction
--- find the AttritionRate and the EmployeeNumbers equivalently (use string_agg() to concate)
with Attrition_cal as 
	(
	select 
		DistanceFromHome,
		JobSatisfaction,
		COUNT(*) as Count_Employee,
		COUNT(case when Attrition = 'Yes' then 1 else null end) as AttritionCount,
		STRING_AGG(EmployeeNumber, ', ') as EmployeeNumbers 
	from Attrition
	group by DistanceFromHome, JobSatisfaction
)
select 
	DistanceFromHome,
	JobSatisfaction,
	Count_Employee,
	AttritionCount,
	(AttritionCount * 100.0 / Count_Employee) as AttritionRate,
	EmployeeNumbers
from Attrition_cal
order by AttritionRate desc
