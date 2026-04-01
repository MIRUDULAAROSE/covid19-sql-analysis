SELECT * FROM [Portfolio project]..CovidDeaths
WHERE CONTINENT IS NOT NULL 

SELECT * FROM [Portfolio project]..CovidVaccines

-- select data column from coviddeath table --
SELECT location, date, total_cases, new_cases, total_deaths, population FROM [Portfolio project]..CovidDeaths
WHERE CONTINENT IS NOT NULL 
ORDER BY 1,2

-- looking at total cases vs total deaths --

SELECT location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage FROM [Portfolio project]..CovidDeaths
WHERE LOCATION LIKE '%STATES%' -- For unitedstates --
ORDER BY 1,2

-- looking at the total cases vs population --
-- shows what percentage of population got covid--
SELECT location, date,  population, total_cases, (total_cases/population)*100 as Covidpopulation FROM [Portfolio project]..CovidDeaths
WHERE LOCATION LIKE '%STATES%' -- For unitedstates --
ORDER BY 1,2

-- what country has highest infection rate wrt population --
SELECT location,  population, MAX(total_cases) as Highestinfectioncount, Max((total_cases/population))*100 as PercentpopulationInfected FROM [Portfolio project]..CovidDeaths
-- where location like states --
Group by location, population
ORDER BY PercentpopulationInfected desc -- desc means descending--

-- showing the countries with highest death count per population --
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount FROM [Portfolio project]..CovidDeaths
WHERE CONTINENT IS NOT NULL 
Group by location
ORDER BY TotalDeathCount  desc --desc means descending--

-- LETS BREAK THIS DOWN BY CONTINENT --

-- showing the continent with the highest death count per percentage --
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount FROM [Portfolio project]..CovidDeaths
WHERE CONTINENT IS not NULL 
Group by continent
ORDER BY TotalDeathCount  desc   --desc means descending--



-- global numbers grouprd by date --
SELECT date, SUM(new_cases)as totalcases,  sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage FROM [Portfolio project]..CovidDeaths
WHERE CONTINENT IS NOT NULL
GROUP BY DATE
ORDER BY 1,2

-- total global numbers --
SELECT SUM(new_cases)as totalcases,  sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage FROM [Portfolio project]..CovidDeaths
WHERE CONTINENT IS NOT NULL
ORDER BY 1,2

-- Joining both tables --
SELECT *
 FROM [dbo].[CovidDeaths] DEA
JOIN [dbo].[CovidVaccines] VAC
   ON DEA.LOCATION = VAC.LOCATION 
   AND DEA.DATE = VAC.DATE

-- LOOKING AT TOTAL POPULATION VS VACCINATIONS- -
SELECT DEA.CONTINENT, DEA.LOCATION, DEA.DATE, DEA.POPULATION, VAC.NEW_VACCINATIONS,
SUM(cast(VAC.NEW_VACCINATIONS as int)) OVER (Partition BY DEA.LOCATION ORDER BY DEA.LOCATION, DEA.DATE) AS ROLLINGPEOPLEVACCINATED
 FROM [dbo].[CovidDeaths] DEA
JOIN [dbo].[CovidVaccines] VAC
   ON DEA.LOCATION = VAC.LOCATION
   AND DEA.DATE = VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL
ORDER BY 2,3

-- USE CTE
WITH PopvsVac (CONTINENT, LOCATION, DATE, POPULATION, NEW_VACCINATIONS, ROLLINGPEOPLEVACCINATED)
AS 
(
SELECT DEA.CONTINENT, DEA.LOCATION, DEA.DATE, DEA.POPULATION, VAC.NEW_VACCINATIONS,
SUM(cast(VAC.NEW_VACCINATIONS as int)) OVER (Partition BY DEA.LOCATION ORDER BY DEA.LOCATION, DEA.DATE) AS ROLLINGPEOPLEVACCINATED
 FROM [dbo].[CovidDeaths] DEA
JOIN [dbo].[CovidVaccines] VAC
   ON DEA.LOCATION = VAC.LOCATION
   AND DEA.DATE = VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL 
)
SELECT *, (ROLLINGPEOPLEVACCINATED/POPULATION)*100 FROM Popvsvac

-- TEMP TABLE

IF OBJECT_ID('tempdb..#PERCENTPOPULATIONVACCINATED', 'U') IS NOT NULL
BEGIN
    DROP TABLE #PERCENTPOPULATIONVACCINATED;
END
CREATE TABLE #PERCENTPOPULATIONVACCINATED
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PERCENTPOPULATIONVACCINATED
SELECT DEA.CONTINENT, DEA.LOCATION, DEA.DATE, DEA.POPULATION, VAC.NEW_VACCINATIONS,
SUM(cast(VAC.NEW_VACCINATIONS as int)) OVER (Partition BY DEA.LOCATION ORDER BY DEA.LOCATION, DEA.DATE) AS ROLLINGPEOPLEVACCINATED
 FROM [dbo].[CovidDeaths] DEA
JOIN [dbo].[CovidVaccines] VAC
   ON DEA.LOCATION = VAC.LOCATION
   AND DEA.DATE = VAC.DATE
-- WHERE DEA.CONTINENT IS NOT NULL 

SELECT *, (ROLLINGPEOPLEVACCINATED/POPULATION)*100 FROM #PERCENTPOPULATIONVACCINATED

-- Creating view to store data for later visulizations

CREATE VIEW PERCENTPOPULATIONVACCINATED AS
SELECT DEA.CONTINENT, DEA.LOCATION, DEA.DATE, DEA.POPULATION, VAC.NEW_VACCINATIONS,
SUM(cast(VAC.NEW_VACCINATIONS as int)) OVER (Partition BY DEA.LOCATION ORDER BY DEA.LOCATION, DEA.DATE) AS ROLLINGPEOPLEVACCINATED
 FROM [dbo].[CovidDeaths] DEA
JOIN [dbo].[CovidVaccines] VAC
   ON DEA.LOCATION = VAC.LOCATION
   AND DEA.DATE = VAC.DATE
 WHERE DEA.CONTINENT IS NOT NULL 

 SELECT * FROM PERCENTPOPULATIONVACCINATED