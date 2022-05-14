--Using DEATHS table
SELECT * FROM Covid_deaths$;

SELECT location,date,total_cases, new_cases, total_deaths, population 
FROM Covid_deaths$
ORDER BY 1,2;

--Finding death rate in % = (deaths/cases)*100
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_rate
FROM Covid_deaths$
WHERE location like '%india%'
Order by 1,2 DESC;

--Cases per population in % = (total cases/population)*100
SELECT location,date,total_cases, total_deaths, (total_cases/population)*100 AS infection_rate,(total_deaths/total_cases)*100 AS death_rate
FROM Covid_deaths$
WHERE location like '%india%'
Order by 1,2;

--Highest infection rate
SELECT location,population,MAX(total_cases)as HighestCase,MAX((total_cases/population)*100) AS infection_rate
FROM Covid_deaths$ WHERE continent is not null
GROUP BY location,population
ORDER BY population DESC;

--Highest death per population
--using cast as int to agg total_deaths which already uses datatype varchar
SELECT location,population,MAX(cast(total_deaths as int)) as TotalDeath, MAX((total_deaths/population)*100) as death_per_population 
FROM Covid_deaths$ WHERE continent is not null 
GROUP BY location,population 
ORDER BY TotalDeath DESC;

--acrossContinent data death data
SELECT location,population,MAX(cast(total_deaths as int)) as TotalDeath
FROM Covid_deaths$ WHERE continent is null 
GROUP BY location,population 
ORDER BY TotalDeath DESC;

--GLobal data
--Overall cases and deaths
SELECT SUM(new_cases) as totalcases, SUM(cast(total_deaths as int)) as totaldeaths, SUM(cast(total_deaths as int))/SUM(new_cases) as deathpercent
FROM Covid_deaths$ WHERE continent is not null
ORDER BY 1;

--date wise case and deaths
SELECT date,SUM(new_cases) as totalcases, SUM(cast(total_deaths as int)) as totaldeaths, SUM(cast(total_deaths as int))/SUM(new_cases) as deathpercent
FROM Covid_deaths$ WHERE continent is not null
GROUP BY date
ORDER BY 1;

-- Death rate per continent
Select continent, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From covid_deaths$
where continent is not null 
GROUP BY continent
order by DeathPercentage desc

--Using VACCINATION table

Select * FROM Covid_vaccination$ 
WHERE continent is not null;

--Percentage vaccinated
--using cast as int to agg new_vaccinations which already uses datatype varchar
SELECT dt.location, SUM(dt.population) as Population, SUM(cast(vc.new_vaccinations as int)) as vaccinated, 
MAX(cast(vc.people_fully_vaccinated as int))/MAX(dt.population)*100 as Vaccine_percent
From Covid_deaths$ as dt
Join Covid_vaccination$ as vc
ON dt.location=vc.location AND dt.date=vc.date
WHERE dt.continent is not null 
Group by dt.location
Order by Vaccine_percent DESC;