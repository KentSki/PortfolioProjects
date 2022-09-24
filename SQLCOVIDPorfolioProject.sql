Select *
From [Portolio Project]..coviddeaths
Where continent is not null
order by 3,4

--Select *
--From [Portolio Project]..covidvaccs
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From [Portolio Project]..coviddeaths
order by 1,2


-- Looking at Total Cases vs Total Deaths in United States


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portolio Project]..coviddeaths
Where location like '%states%'
and continent is not null
order by 1,2


-- Looking at Total Case vs Population in United States


Select location, date, population, total_cases, (total_cases/population)*100 as PopulationInfectedPercentage
From [Portolio Project]..coviddeaths
Where location like '%states%'
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PopulationInfectedPercentage
From [Portolio Project]..coviddeaths
--Where location like '%states%'
Group by location, population
order by PopulationInfectedPercentage desc


-- Showing Countries with Highest Death Count per Population

Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From [Portolio Project]..coviddeaths
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc


--SHOWN BY CONTINENT

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From [Portolio Project]..coviddeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) as DeathPercentage
From [Portolio Project]..coviddeaths
--Where location like '%states%'
WHERE continent is not null
--Group By date
order by 1,2


--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, \
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portolio Project]..coviddeaths dea
join [Portolio Project]..covidvaccs vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3



--USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portolio Project]..coviddeaths dea
join [Portolio Project]..covidvaccs vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVAC




--TEMP TABLE




DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portolio Project]..coviddeaths dea
join [Portolio Project]..covidvaccs vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--Creating VIEWs to store data for later visualizations


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portolio Project]..coviddeaths dea
join [Portolio Project]..covidvaccs vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3


Create View PopulationInfectedPercentage as
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PopulationInfectedPercentage
From [Portolio Project]..coviddeaths
--Where location like '%states%'
Group by location, population
--order by PopulationInfectedPercentage desc


Create View CountryDeathCount as
Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From [Portolio Project]..coviddeaths
--Where location like '%states%'
Where continent is not null
Group by location
--order by TotalDeathCount desc


Create View ContinentDeathCount as
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From [Portolio Project]..coviddeaths
--Where location like '%states%'
Where continent is not null
Group by continent
--order by TotalDeathCount desc

Select *
From Percentpopulationvaccinated
