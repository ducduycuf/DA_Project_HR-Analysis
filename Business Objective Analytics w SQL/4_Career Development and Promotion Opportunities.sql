-- 3.1. Understand how career progression varies across departments and job roles.
select 
	Department,
	JobRole,
	AVG(YearsAtCompany) as AvgYearsAtCompany,
	AVG(YearsInCurrentRole) AS AvgYearsInCurrentRole,
    AVG(YearsSinceLastPromotion) AS AvgYearsSinceLastPromotion
from Attrition
group by Department, JobRole
order by Department, JobRole

select * from Attrition


-- 3.2. Time to Promotion Analysis by Gender and Job Role
select Gender,
       JobRole,
       AVG(YearsSinceLastPromotion) AS AvgYearsToPromotion
from Attrition
group by Gender, JobRole
order by Gender, JobRole;


-- 3.3. Identify different employee segments based on development needs and career aspirations.
with DevelopmentNeeds as (
    select
        EmployeeNumber,
        JobRole,
        Department,
        JobSatisfaction,
        TrainingTimesLastYear,
        case 
            when JobSatisfaction = 2 AND TrainingTimesLastYear < 2 then 'High Need'
            when JobSatisfaction = 3 AND TrainingTimesLastYear < 4 then 'Medium Need'
            else 'Low Need'
        end as DevelopmentNeed
    from Attrition
)
select
	JobRole,
    Department,
    DevelopmentNeed,
    count(*) as EmployeeCount
from DevelopmentNeeds
group by JobRole, Department, DevelopmentNeed
order by JobRole, Department, DevelopmentNeed