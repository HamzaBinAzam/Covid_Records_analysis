
-- Relation Between Total Cases and Total Death
SELECT *
From Project..CovidDeaths

SELECT SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as INT)) as Total_Deaths , (SUM(CAST(new_deaths as INT))/SUM(new_cases))*100 as Death_Percentage
From Project..CovidDeaths
Where continent is  not NULL


--Total Death Count by Location
SELECT location, SUM(Cast(new_deaths as INT)) as Total_Death_Count
FROM Project..CovidDeaths
WHERE continent is null
and location not in ('World','International','European Union')
Group by location
order by Total_Death_Count desc;


--Population Infect in various Location

SELECT location, population, MAX(total_cases) as Highes_infection_count, MAX(total_cases/population)*100 as Percent_Population_Infected
From Project..CovidDeaths
Group by location, population
order by percent_population_infected desc;



--Population Infect in various Location with Date
SELECT location, population, date, MAX(total_cases) as Highes_infection_count, MAX(total_cases/population)*100 as Percent_Population_Infected
From Project..CovidDeaths
Group by location, population, date
order by percent_population_infected desc;