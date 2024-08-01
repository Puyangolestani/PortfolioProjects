SELECT  location , date , total_cases , new_cases,total_deaths ,population
FROM PortfolioProject..CovidNormalProject
ORDER BY 1,2

SELECT  location , date , total_cases , total_deaths ,(NULLIF(total_deaths , 0)/NULLIF(total_cases, 0)) * 100 as DeathPeracentage 
FROM PortfolioProject..CovidNormalProject 
WHERE location like '%states%'
ORDER BY 1,2

SELECT  location , date , total_cases , population ,(NULLIF(total_cases , 0)/NULLIF(population, 0)) * 100 as PercentPouolationInfected
FROM PortfolioProject..CovidNormalProject 
--WHERE location like '%states%'
ORDER BY 1,2

SELECT  location , population ,MAX(total_cases) AS HighestInfectionCount,MAX((NULLIF(total_cases , 0)/NULLIF(population, 0))) * 100 as  PercentPouolationInfected
FROM PortfolioProject..CovidNormalProject 
--WHERE location like '%states%'
GROUP BY location , population
ORDER BY PercentPouolationInfected desc 



--showing countries with highest death
SELECT  location , MAX(total_deaths) AS TotalDatheCount
FROM PortfolioProject..CovidNormalProject 
--WHERE location like '%states%'
Where continent is not null
GROUP BY location 
ORDER BY TotalDatheCount desc 

SELECT *
FROM PortfolioProject..CovidNormalProject
Where continent is not null
ORDER BY 1,2

--lets break things down by continent
SELECT  location , MAX(total_deaths) AS TotalDatheCount
FROM PortfolioProject..CovidNormalProject 

--WHERE location like '%states%'
SELECT continent , MAX(total_deaths) AS TotalDatheCount
FROM PortfolioProject..CovidNormalProject 
Where continent is not null
Group by continent
Order by TotalDatheCount desc 

SELECT location, MAX(total_deaths) AS TotalDatheCount
FROM PortfolioProject..CovidNormalProject 
Where continent is  null
Group by location
Order by TotalDatheCount desc 

--global numbers

SELECT   SUM(new_cases ) as total_cases, SUM(NULLIF(new_deaths , 0 )) as total_death,SUM(NULLIF(new_deaths , 0)) / SUM(new_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidNormalProject 
--WHERE location like '%states%'
WHERE continent is not null
--Group by date
ORDER BY 1,2

--looking at total populations vs vaccinations
SELECT  pro.continent , pro.location ,pro.date ,pro.population , vac.new_vaccinations
,SUM(convert(float ,vac.new_vaccinations )) OVER (Partition BY  pro.location order by pro.location ,pro.date) 
as RollingPeapleVaccination --,(RollingPeapleVaccination /population) * 100
FROM PortfolioProject..CovidNormalProject pro
join PortfolioProject..CovidVaccination  vac
ON pro.location =vac.location 
and pro.date = vac.date
WHERE pro.continent is not null
ORDER BY 2 ,3


--use CTE(to important for me)
WITH PopvsVac(continent , Loacation ,Date , poulation  ,new_vaccinations, RollingPeapleVaccination)
as
(
SELECT  pro.continent , pro.location ,pro.date ,pro.population , vac.new_vaccinations
,SUM(convert(float ,vac.new_vaccinations )) OVER (Partition BY  pro.location order by pro.location ,pro.date) 
as RollingPeapleVaccination --,(RollingPeapleVaccination /population) * 100
FROM PortfolioProject..CovidNormalProject pro
join PortfolioProject..CovidVaccination  vac
ON pro.location =vac.location 
and pro.date = vac.date
WHERE pro.continent is not null
--ORDER BY 2 ,3
)
SELECT *,(RollingPeapleVaccination /poulation) * 100
FROM PopvsVac  

--Temp table

Drop Table if exists #PerecentPopulationVaccination
Create Table #PerecentPopulationVaccination
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime ,
Population numeric,
new_vaccinations numeric ,
RollingPeapleVaccination numeric
)

Insert into #PerecentPopulationVaccination
SELECT  pro.continent , pro.location ,pro.date ,pro.population , vac.new_vaccinations
,SUM(convert(float ,vac.new_vaccinations )) OVER (Partition BY  pro.location order by pro.location ,pro.date) 
as RollingPeapleVaccination --,(RollingPeapleVaccination /population) * 100
FROM PortfolioProject..CovidNormalProject pro
join PortfolioProject..CovidVaccination  vac
ON pro.location =vac.location 
and pro.date = vac.date
--WHERE pro.continent is not null
--ORDER BY 2 ,3
SELECT *,(RollingPeapleVaccination /Population) * 100
FROM  #PerecentPopulationVaccination


--creating view to store data foar later visualization

Create View PerecentPopulationVaccination as
SELECT  pro.continent , pro.location ,pro.date ,pro.population , vac.new_vaccinations
,SUM(convert(float ,vac.new_vaccinations )) OVER (Partition BY  pro.location order by pro.location ,pro.date) 
as RollingPeapleVaccination --,(RollingPeapleVaccination /population) * 100
FROM PortfolioProject..CovidNormalProject pro
join PortfolioProject..CovidVaccination  vac
ON pro.location =vac.location 
and pro.date = vac.date
WHERE pro.continent is not null
--ORDER BY 2 ,3

SELECT *
FROM PerecentPopulationVaccination







