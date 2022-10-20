

--Select Data on which we are going to work
Select location, date,total_cases, new_cases, total_deaths, population
from Project..CovidDeaths
Where continent is not null     --In data we have some null continents, that's why we have to use this clause to avoid errors in results

--Total Deaths vs Total Cases Ratio
--Shows the likelihood of dying if you contract covid in your country
Select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Project..CovidDeaths
Where location like 'Paks%'
and continent is not null
order by 1

--Looking at the total cases vs the population
--Shows What population got COVID

Select location,date, total_cases, population, (total_cases/population)*100 as total_cases_percentage
from Project..CovidDeaths
--Where location like 'Pak%'
Where continent is not null
order by 1


-- Looking at the countries with highest infection rate in terms of Population

Select location,  population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as total_cases_percentage
from Project..CovidDeaths
--Where location like 'Pak%'
Where continent is not null
Group by location, population
order by total_cases_percentage desc



--Showing the countries with highest death count over population
-- As total_deaths is nvarchar255, so we have to cast it as integer in order to perform calculations

Select location, MAX(cast(total_deaths as int)) as TotalDeaths_Count
from Project..CovidDeaths
--Where location like 'Pak%'
Where continent is not null
Group by location
order by TotalDeaths_Count desc


--LET"S BREAK THINGS BY CONTINENT

Select continent, MAX(cast(total_deaths as int)) as TotalDeaths_Count
from Project..CovidDeaths
--Where location like 'Pak%'
Where continent is not null
Group by continent
order by TotalDeaths_Count desc


--Showing the continents with highest death counts

Select continent, MAX(cast(total_deaths as int)) as TotalDeaths_Count
from Project..CovidDeaths
--Where location like 'Pak%'
Where continent is not null
Group by continent
order by TotalDeaths_Count desc



-- GLOBAL NUMBERS by Dates


Select date, SUM(new_cases) as Total_New_Cases, SUM(CAST(new_deaths as Int)) as Total_New_Deaths, (SUM(Cast(new_deaths as int))/SUM(new_cases))*100 as Death_percentage
FROM Project..CovidDeaths
Where continent is not NULL
Group by date
Order by 1


--Total Global Number

Select SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as Int)) as Total_Deaths, (SUM(Cast(new_deaths as int))/SUM(new_cases))*100 as Death_percentage
FROM Project..CovidDeaths
Where continent is not NULL
Order by 1


--COVID VACCINATION TABLE

SELECT *
FROM Project..CovidDeaths


--Let's Join the both CovidDeaths and CovidVaccinations Tables

Select *
FROM Project..CovidDeaths as D
Join Project..CovidVaccinations as v
on D.location = V.location
and D.date = V.date


--Looking at the total population vs new_vaccinations

Select D. continent, D.location, D.date, D.population,  V.new_vaccinations
, SUM(Cast(V.new_vaccinations as INT)) OVER (Partition by D.location order by D.location, D.date) as Rolling_People_vaccinated
From Project..CovidDeaths as D
join Project..CovidDeaths as V
on D.location = V.location
and D.date = V.date
Where D.continent is not null
order by 1,2,3


--Creat CTE

With PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_vaccination)
as (
Select D. continent, D.location, D.date, D.population,  V.new_vaccinations
, SUM(Cast(V.new_vaccinations as INT)) OVER (Partition by D.location order by D.location, D.date) as Rolling_People_vaccinated
From Project..CovidDeaths as D
join Project..CovidDeaths as V
on D.location = V.location
and D.date = V.date
Where D.continent is not null
--order by 1,2,3
)

Select * , (Rolling_People_vaccination/population)*100 as Percentage_of_population_vaccinated
From PopvsVac



--Create View to store Code

CREATE View Percentage_Population_vaccinated as
Select D. continent, D.location, D.date, D.population,  V.new_vaccinations
, SUM(Cast(V.new_vaccinations as INT)) OVER (Partition by D.location order by D.location, D.date) as Rolling_People_vaccinated
From Project..CovidDeaths as D
join Project..CovidDeaths as V
on D.location = V.location
and D.date = V.date
Where D.continent is not null
--order by 1,2,3