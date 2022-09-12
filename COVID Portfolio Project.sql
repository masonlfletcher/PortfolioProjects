
-- Total Cases, Total Deaths, Population of Afghanistan

Select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
order by 1,2


-- Looking at Total Cases vs. Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
order by 1,2

-- Looking at Total Cases vs. Total Deaths USA

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
where location like '%States%'
order by 1,2

-- Looking at Total Cases vs Population

select location, date, total_cases, population, (total_cases/population)*100 as Infected_Population_Percentage
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
where location like '%States%'
order by 1,2


-- Looking at countries with highest infection rate compared to population

Select location, MAX(total_cases) as HighInfectionCount, population, MAX((total_cases/population))*100 as Infected_Population_Percentage
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
group by population, location
order by 1,2

-- Looking at countries with highest infection rate compared to population
select location, MAX(total_cases) as HighestInfectionCount, population, MAX(total_cases/population)*100 as Infected_Population_Percentage
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
group by population, location
order by 4 DESC

-- Total Death Count by country

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
where continent is not NULL 
Group BY location
order by TotalDeathCount desc

-- Total Death Count by Continent

select location, MAX(Cast(Total_deaths as int)) as TotalDeathCount
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
where continent is null
group by location
order by TotalDeathCount desc

-- Global Numbers

select date, sum(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
where continent is not null
group by date
order by 1,2

-- Global death percent as of 09/02/2022

select sum(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
where continent is not null
order by 1,2

-- Preliminary Join of Deaths and Vaccinations Tables

Select * 
from dbo.Covid_Deaths_Table as dea
join dbo.Covid_Vaccinations_Table as vac
on dea.location = vac.location
and dea.date = vac.date


-- Total Population vs. Vaccinations

-- Use CTE (Common Table Expressions) 

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations))
OVER (Partition by dea.location order by dea.date ) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/dea.population)*100
from dbo.Covid_Deaths_Table as dea
join dbo.Covid_Vaccinations_Table as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not NULL 
--order by 2,3
)
Select *, (Rolling_People_Vaccinated/Population)*100 as RPV_Percentage
from PopvsVac


-- Temp Table

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_People_Vaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations))
OVER (Partition by dea.location order by dea.date ) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/dea.population)*100
from dbo.Covid_Deaths_Table as dea
join dbo.Covid_Vaccinations_Table as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not NULL 
--order by 2,3

Select *, (Rolling_People_Vaccinated/Population)*100 as RPV_Percentage
from #PercentPopulationVaccinated


-- Creating View to store data for visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations))
OVER (Partition by dea.location order by dea.date ) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/dea.population)*100
from dbo.Covid_Deaths_Table as dea
join dbo.Covid_Vaccinations_Table as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not NULL 
--order by 2,3

Select *
from PercentPopulationVaccinated

Create View 
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Portfolio_Project_Covid_Data..Covid_Deaths_Table
where location like '%States%'
order by 1,2