-- 3.1. Who are the top performers, and are they being fairly compensated?
with RankedCompensation as (
    select 
        EmployeeNumber, JobRole, MonthlyIncome, PerformanceRating, 
        DENSE_RANK() over (partition by JobRole order by PerformanceRating desc, MonthlyIncome desc) AS PerformanceRank
    from 
       Attrition
)
select 
    EmployeeNumber, JobRole, MonthlyIncome, PerformanceRating, PerformanceRank
from 
    RankedCompensation
where 
    PerformanceRank <= 5;	


-- 3.2. Which employees are at risk of leaving due to compensation, satisfaction issues?
with RiskRank as
	(
	select 
		EmployeeNumber, 
		PerformanceRating, 
		MonthlyIncome, 
		JobSatisfaction, 
		DENSE_RANK() over(order by JobSatisfaction asc, MonthlyIncome asc) as RiskRank  --prioritize Employee with lowest JobSatisfaction first, then we consider compensation
	from Attrition
	where Attrition = 'No'
)
select *
from RiskRank
where RiskRank <= 10
order by RiskRank


-- 3.3. Are high-performing employees compensated fairly compared to others in the same role?
with RoleAvgIncome as	
	(
	select
		Department,
		JobRole,
		AVG(MonthlyIncome) as RoleAvgIncome
	from Attrition
	group by Department, JobRole
),
DeptAvgIncome as	
	(
	select
		Department,
		AVG(MonthlyIncome) as DeptAvgIncome
	from Attrition
	group by Department
)
select 
	ri.Department,
	JobRole,
	RoleAvgIncome,
	DeptAvgIncome,
	(RoleAvgIncome - DeptAvgIncome) as IncomeDiff
from DeptAvgIncome di
join RoleAvgIncome ri on ri.Department = di.Department
order by Department


-- 3.4. Top 10 highest-performing but underpaid employees
with AvgIncomeforPerformance as	
	(
	select 
		Department, 
		EmployeeNumber,
		PerformanceRating,
		MonthlyIncome,
		AVG(MonthlyIncome) over(partition by PerformanceRating) as AvgIncomePerPerformance
	from Attrition
)
select
	top 10 Department, 
	EmployeeNumber,
	PerformanceRating,
	MonthlyIncome,
	AvgIncomePerPerformance
from AvgIncomeforPerformance
where MonthlyIncome < AvgIncomePerPerformance
order by PerformanceRating desc, MonthlyIncome
