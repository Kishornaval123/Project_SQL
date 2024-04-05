Select * from
Portfolio_Project..Deaths
Where continent is not null
order by 3,4


Select * from
Portfolio_Project..Vacine
order by 3,4

--  Select Data that we are going to be using

Select  location,date, total_cases, new_cases, total_deaths,population
from Portfolio_Project..Deaths
order by 1,2


--Looking at Total cases Vs Total Deaths

Select  location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentageofdeath
from Portfolio_Project..Deaths
where location like 'india'
order by 1,2



--Looking at Total Cases Vs Population
--Showing what percenetage of Population got covid

Select  location,date, total_cases, population, (total_cases/population)*100 as percentageofdeath
from Portfolio_Project..Deaths
where location like 'india'
order by 1,2

--Looking at the Countries with Highest Infection rate compare to Population

Select location, population, max(total_cases) as HighestInfectioncount,
max(total_cases/population)*100 as casespercentage 
from Portfolio_Project..Deaths
Group by location,population
order by casespercentage desc

--Showing countries with Highest Death Count per Population


Select location, max(cast (total_deaths as int)) as HighestDeathcount
from Portfolio_Project..Deaths
where continent is not null
Group by location
order by HighestDeathcount desc


--Let's Break Things Down By Continent

Select location, max(cast (total_deaths as int)) as HighestDeathcount
from Portfolio_Project..Deaths
where continent is  null
Group by location
order by HighestDeathcount desc


--Showing Continents with the highest death count per Population

Select location,population, max(cast (total_deaths as int)) as HighestDeathcount
from Portfolio_Project..Deaths
where continent is not null
Group by location,population
order by HighestDeathcount desc


--Global Numbers

Select date, sum(new_cases) as total_cases,sum(cast (new_deaths as int)) as total_deaths, 
sum(cast (new_deaths as int)) /sum(New_cases)*100 as Deathpercentage 
from Portfolio_Project..Deaths
where continent is not null
Group by date
order by 1,2



Select  sum(new_cases) as total_cases,sum(cast (new_deaths as int)) as total_deaths, 
sum(cast (new_deaths as int)) /sum(New_cases)*100 as Deathpercentage 
from Portfolio_Project..Deaths
where continent is not null
order by 1,2

--Join both table 

Select * from
Portfolio_Project..Deaths D
join Portfolio_Project..Vacine V
on D.location= V.location
and D.date = V.date


--Looking to Total Population Vs Vaccinations


Select D.continent,D.location,D.date,D.population,V.new_vaccinations from
Portfolio_Project..Deaths D
join Portfolio_Project..Vacine V
on D.location= V.location
and D.date = V.date
Where D.continent is not null
order by 2,3






Select * from Portfolio_Project..Deaths
WHERE continent like 'asia'



Select D.continent,D.location,D.date,D.population,V.new_vaccinations,
sum(Convert( int, V.new_vaccinations) ) over (partition by D.location order by D.location, D.date)as  RollingPeopleVaccinated
from 
Portfolio_Project..Deaths D
Join Portfolio_Project..Vacine V
on D.location=V.location
and D.date=V.date
Where D.continent is not null
order by 2,3


--Use CTE 

With PopvsVac(continent, Location, date, Population, new_vaccinations,RollingPeopleVaccinated)
 as (
Select D.continent,D.location,D.date,D.population,V.new_vaccinations,
sum(Convert( int, V.new_vaccinations) ) over (partition by D.location order by D.location, D.date)as  RollingPeopleVaccinated
from 
Portfolio_Project..Deaths D
Join Portfolio_Project..Vacine V
on D.location=V.location
and D.date=V.date
Where D.continent is not null
)

Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac



--Temp Table

Drop table if Exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar (255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated
Select D.continent,D.location,D.date,D.population,V.new_vaccinations,
sum(Convert( int, V.new_vaccinations) ) over (partition by D.location order by D.location, D.date)as  RollingPeopleVaccinated
from 
Portfolio_Project..Deaths D
Join Portfolio_Project..Vacine V
on D.location=V.location
and D.date=V.date
Where D.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated




--Creating Views to store data for later visualization

Create View PercentPopulationVaccinated as
Select D.continent,D.location,D.date,D.population,V.new_vaccinations,
sum(Convert( int, V.new_vaccinations) ) over (partition by D.location order by D.location, D.date)as  RollingPeopleVaccinated
from 
Portfolio_Project..Deaths D
Join Portfolio_Project..Vacine V
on D.location=V.location
and D.date=V.date
Where D.continent is not null



Select *
from PercentPopulationVaccinated 



