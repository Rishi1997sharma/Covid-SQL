--1 Total Cases around the world

Use coviddataset;

UPDATE CovidDeaths$
SET continent = 'Africa'
WHERE location = 'Africa';

UPDATE CovidDeaths$
SET continent = 'Asia'
WHERE location = 'Asia';

UPDATE CovidDeaths$
SET continent = 'Europe'
WHERE location = 'Europe';

UPDATE CovidDeaths$
SET continent = 'Europe'
WHERE location  Like '%Asia%';

UPDATE CovidDeaths$
SET continent = 'Europe'
WHERE location LIKE '%Europe%';

SELECT 
	continent,
	SUM(new_cases + total_cases) AS total_cases, 
	SUM(new_deaths + total_deaths) AS total_deaths,
       CASE 
           WHEN continent = '0' THEN 'Unknown'
           ELSE continent
       END AS ContinentAlias
FROM CovidDeaths$
GROUP BY continent;

--2 Death rate By Different Location

SELECT
	location,
	(SUM(total_deaths)/NULLIF(SUM(total_cases),0))*100 AS death_rate
FROM 
	CovidDeaths$
GROUP BY 
	location
ORDER BY 1;

--3 Total Death by Location

SELECT
	location,
	SUM(new_deaths + total_deaths) AS Total_Deaths
FROM
	CovidDeaths$
GROUP BY
	location
ORDER BY
	location;

--4 Case rise based on Dates

SELECT
	continent,
	location,
	date,
	SUM(new_cases + total_cases) AS Total_cases,
	CASE	
		WHEN
			continent = '0'
			THEN 'unknown'
			ELSE continent
	END AS ContinentAlias
FROM
	CovidDeaths$
GROUP BY 
	continent,
	location,
	date
ORDER BY
	1,2,3;
	
--5 Total Covid test by Country
SELECT
	CD.continent,
	CD.location,
	SUM(CD.new_tests + CD.total_tests) 
FROM CovidDeaths$ AS CD
JOIN coviddataset.dbo.CovidVaccinations$ AS CV
	ON
	CD.continent = CV.continent AND
	CD.location = CV.location AND
	CD.date = CV.date
GROUP BY
	CD.continenT,
	CD.location
ORDER BY
	CD.location;

--6 Toatal Case-to-Death Numbers

SELECT
	CD.location,
	SUM(CD.new_cases) AS Total_cases,
	SUM(CD.new_deaths) AS Total_Deaths,
	(SUM(CD.new_deaths + CD.total_deaths)/NULLIF(SUM(CD.new_cases + CD.total_cases),0))*100 AS Fatality_Rate
FROM CovidDeaths$ AS CD
JOIN
coviddataset.dbo.CovidDeaths$ AS CV
ON
CD.continent = CV.continent AND
CD.location = CD.location AND
CD.date = CV.date
GROUP BY 
CD.location
ORDER BY Fatality_Rate Desc;	

--7 Total Vaccination

SELECT
CD.location,
SUM(CV.total_vaccinations) AS Total_Vacc
FROM
CovidDeaths$ AS CD
JOIN
coviddataset.DBO.CovidVaccinations$ AS CV
ON
CD.location = CV.location AND
CD.date = CV.date
GROUP BY CD.location
ORDER BY CD.location;

--8 Total People hospitalised vs total icu

SELECT
	CD.location,
	SUM(CD.hosp_patients) AS Total_Hospitalization,
	SUM(CD.icu_patients) AS Total_icu
FROM
CovidDeaths$ AS CD
JOIN
coviddataset.DBO.CovidVaccinations$ AS CV
ON
CD.date = CV.date AND
CD.location = CV.location
GROUP BY CD.location
ORDER BY Total_Hospitalization DESC;