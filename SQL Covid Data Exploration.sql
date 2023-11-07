--SELECT *
--FROM PortfolioProject..CovidVaccinations$
--order by 3,4
--SELECT *
--FROM PortfolioProject..CovidDeaths$
--order by 3,4
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
order by 1,2

--comparing total cases vs total deaths
--likelihood of catching covid

SELECT location, date, total_cases,total_deaths, CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_deaths) / CONVERT(DECIMAL(18, 2), total_cases)))*100 as [DeathPercentage]
FROM PortfolioProject..CovidDeaths$
WHERE location like 'India'
order by 1,2

--comparing population to total cases
--finding percentage of people that got covid


SELECT location, date, population,total_cases, CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_cases) / CONVERT(DECIMAL(18, 2), population)))*100 as [PercentageAffected]
FROM PortfolioProject..CovidDeaths$
WHERE location like 'India'
order by 1,2

--comparing countries with highest infection rate to total population

SELECT location, population, MAX(total_cases) as HighestInfectionRate, MAX(CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_cases) / CONVERT(DECIMAL(18, 2), population))))*100 as [PercentageAffected]
FROM PortfolioProject..CovidDeaths$
--WHERE location like 'India'
Group by location, population
order by PercentageAffected desc

--finding countries with highest death count by population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--WHERE location like 'India'
Where continent is not NULL
Group by location
order by TotalDeathCount desc

--comparing by continents 

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--WHERE location like 'India'
Where continent is not NULL
Group by continent
order by TotalDeathCount desc

--Searching globally

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
--WHERE location like 'India'
Where continent is not NULL
--Group by date
order by 1,2

--finding out population to vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingCount 
From PortfolioProject..CovidDeaths$ dea
 JOIN PortfolioProject..CovidVaccinations$ vac
     On dea.location = vac.location
	 AND dea.date = vac.date
where dea.continent is not null
order by 2,3

--Using CTE

With PopVsVac (continent, location, date, population, new_vaccinations, RollingCount)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingCount 
From PortfolioProject..CovidDeaths$ dea
 JOIN PortfolioProject..CovidVaccinations$ vac
     On dea.location = vac.location
	 AND dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select*, (RollingCount/population)*100
From PopVsVac 

--Using temp table

DROP Table if exists #PopulationPerecentagesVaccinated
Create Table #PopulationPerecentagesVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingCount numeric
)

Insert into #PopulationPerecentagesVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingCount 
From PortfolioProject..CovidDeaths$ dea
 JOIN PortfolioProject..CovidVaccinations$ vac
     On dea.location = vac.location
	 AND dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select*, (RollingCount/population)*100
From #PopulationPerecentagesVaccinated 

--Creating view

Create View PopulationPerecentagesVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingCount 
From PortfolioProject..CovidDeaths$ dea
 JOIN PortfolioProject..CovidVaccinations$ vac
     On dea.location = vac.location
	 AND dea.date = vac.date
where dea.continent is not null
--order by 2,3