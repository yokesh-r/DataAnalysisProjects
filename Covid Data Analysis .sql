select * from
Portfolio_project..CovidDeaths
order by 3,4
-- Percentage of death in India --
select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_percentage, population
from Portfolio_project..CovidDeaths 
where location = 'India'
order by 1,2

-- Infected percentage in India --
select Location, date,population,total_cases,(total_cases/population)*100 as Affected_percentage 
from Portfolio_project..CovidDeaths 
where location = 'India'
order by 1,2

select Location, date,population,total_cases,(total_cases/population)*100 as Affected_percentage 
from Portfolio_project..CovidDeaths 
order by 1,2

select Location,population,date,max(total_cases) as Highest_Infection_Count ,max((total_cases/population))*100 as Infected_percentage 
from Portfolio_project..CovidDeaths 
group by location,population,date
order by Infected_percentage desc

select Location, max(cast(Total_deaths as int)) as Total_deathcount
from Portfolio_project..CovidDeaths
Where continent is not null
Group by location
order by Total_deathcount desc


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from Portfolio_project..CovidDeaths dea
join Portfolio_project..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

With popVSvac (Continent,location,Date,Population,New_Vaccinations,CumsumPeopleVaccinated) as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date)
as CumsumPeopleVaccinated
from Portfolio_project..CovidDeaths dea
join Portfolio_project..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (CumsumPeopleVaccinated/Population)*100 as Vaccinated_percentage
from popVSvac

-- TEMP TABLE
DROP Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
CumsumPeopleVaccinated numeric
)
Insert into PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date)
as CumsumPeopleVaccinated
from Portfolio_project..CovidDeaths dea
join Portfolio_project..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * ,(CumsumPeopleVaccinated/Population)*100 from PercentPopulationVaccinated

select location, sum(cast(new_deaths as int)) as TotalDeathCount
from Portfolio_project..CovidDeaths
where continent is null
and location not in ('World','European Union','International')
group by location
order by TotalDeathCount desc

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio_project..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

