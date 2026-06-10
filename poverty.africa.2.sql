USE [Africa Poverty]


select * from African_Poverty_Indicators

EXEC sp_rename 
    '[dbo].[African Poverty Indicators.2]',
    'African_Poverty_Indicators';

EXEC sp_rename 'African_Poverty_Indicators.column1', 'Country_Name', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column2', 'Country_Code', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column3', 'Indicator_Name', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column4', 'Indicator_Code', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column5', 'Region', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column6', '2000', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column7', '2001', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column8', '2002', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column9', '2003', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column10', '2004', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column11', '2005', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column12', '2006', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column13', '2007', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column14', '2008', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column15', '2009', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column16', '2010', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column17', '2011', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column18', '2012', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column19', '2013', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2015]', '2014', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2016]', '2015', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2017]', '2016', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2018]', '2017', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2019]', '2018', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2020]', '2019', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2021]', '2020', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2022]', '2021', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2023]', '2022', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2024]', '2023', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.[2025]', '2024', 'COLUMN';
EXEC sp_rename 'African_Poverty_Indicators.column31', '2025', 'COLUMN';

SELECT TOP 5 *
FROM African_Poverty_Indicators;

DELETE FROM African_Poverty_Indicators
WHERE Country_Name = 'Country Name';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'African_Poverty_Indicators'
ORDER BY ORDINAL_POSITION;


CREATE VIEW vw_African_Poverty_Indicators_Long AS

SELECT
    Country_Name,
    Country_Code,
    Indicator_Name,
    Indicator_Code,
    Region,
    [Year],
    Value
FROM
(
    SELECT
        Country_Name,
        Country_Code,
        Indicator_Name,
        Indicator_Code,
        Region,
        [2000],[2001],[2002],[2003],[2004],
        [2005],[2006],[2007],[2008],[2009],
        [2010],[2011],[2012],[2013],[2014],
        [2015],[2016],[2017],[2018],[2019],
        [2020],[2021],[2022],[2023],[2024],[2025]
    FROM African_Poverty_Indicators
) AS SourceTable

UNPIVOT
(
    Value FOR [Year] IN
    (
        [2000],[2001],[2002],[2003],[2004],
        [2005],[2006],[2007],[2008],[2009],
        [2010],[2011],[2012],[2013],[2014],
        [2015],[2016],[2017],[2018],[2019],
        [2020],[2021],[2022],[2023],[2024],[2025]
    )
) AS UnpivotedData;


SELECT
    Country_Name,
    [2024] AS Poverty_Rate
FROM African_Poverty_Indicators
WHERE Indicator_Code = 'SI.POV.UMIC'
ORDER BY Poverty_Rate DESC;


SELECT TOP 20
    Country_Name,
    Indicator_Name,
    Indicator_Code,
    [2024]
FROM African_Poverty_Indicators
WHERE Indicator_Code = 'SI.POV.UMIC';

SELECT
    Indicator_Name,
    Indicator_Code,
    MAX([2000]) AS Max_2000,
    MAX([2008]) AS Max_2008,
    MAX([2018]) AS Max_2018,
    MAX([2024]) AS Max_2024
FROM  African_Poverty_Indicators
GROUP BY
    Indicator_Name,
    Indicator_Code
ORDER BY Max_2024 DESC;	

SELECT
    Country_Name,
    Country_Code,
    Indicator_Name,
    Indicator_Code,
    Region,
    [Year],

    CASE
        WHEN Indicator_Code LIKE 'SI.POV.%'
          OR Indicator_Code LIKE 'SI.DST.%'
        THEN CAST(Value AS DECIMAL(18,2))/10.0

        ELSE CAST(Value AS DECIMAL(18,2))
    END AS Clean_Value

INTO African_Poverty_Indicators_Clean

FROM vw_African_Poverty_Indicators_Long;

SELECT TOP 20
    Country_Name,
    Indicator_Code,
    [Year],
    Clean_Value
FROM African_Poverty_Indicators_Clean
WHERE Country_Name = 'Angola'
AND Indicator_Code = 'SI.POV.UMIC'
ORDER BY [Year];


SELECT
    Country_Name,
    Country_Code,
    Indicator_Name,
    Indicator_Code,
    Region,
    [Year],

    CASE
        WHEN Clean_Value = 0 THEN NULL
        ELSE Clean_Value
    END AS Clean_Value

INTO African_Poverty_Indicators_Final

FROM African_Poverty_Indicators_Clean;

SELECT
    Country_Name,
    Indicator_Code,
    [Year],
    Clean_Value
FROM African_Poverty_Indicators_Final
WHERE Country_Name='Angola'
AND Indicator_Code='SI.POV.UMIC'
ORDER BY [Year];


SELECT TOP 10
    Country_Name,
    Clean_Value AS Poverty_Rate
FROM African_Poverty_Indicators_Final
WHERE Indicator_Code='SI.POV.UMIC'
AND [Year]=2018
ORDER BY Clean_Value DESC;

SELECT TOP 10
    Country_Name,
    Clean_Value AS Gini_Index
FROM African_Poverty_Indicators_Final
WHERE Indicator_Code='SI.POV.GINI'
AND [Year]=2018
ORDER BY Clean_Value DESC;

SELECT 
    Country_Name,
	COUNT(Clean_Value) AS Available_Observations
FROM African_Poverty_Indicators_Final
WHERE Indicator_Code = 'SI.POV.UMIC'
GROUP BY Country_Name
ORDER BY Available_Observations desc;

SELECT
    p.Country_Name,
	p.Clean_Value AS Poverty_Rate,
	g.Clean_Value AS GINI_Index
FROM African_Poverty_Indicators_Final P
INNER JOIN African_Poverty_Indicators_Final G
ON p.Country_Name = g.Country_Name
AND p.[YEAR] = g.[YEAR]
WHERE P.Indicator_Code = 'SI.POV.UMIC'
AND g.Indicator_Code = 'SI.POV.GINI'
AND p.[Year] = 2025;


SELECT
    Country_Name,
    Clean_Value
FROM African_Poverty_Indicators_Final
WHERE Indicator_Code = 'SI.POV.UMIC'
AND [Year] = '2018'
AND Clean_Value IS NOT NULL
ORDER BY Clean_Value DESC;

SELECT
    Country_Name,
    Clean_Value
FROM African_Poverty_Indicators_Final
WHERE Indicator_Code = 'SI.POV.GINI'
AND [Year] = '2018'
AND Clean_Value IS NOT NULL
ORDER BY Clean_Value DESC;


SELECT
    Indicator_Code,
    COUNT(Clean_Value) AS Available_Values_2018
FROM African_Poverty_Indicators_Final
WHERE [Year] = '2018'
GROUP BY Indicator_Code
ORDER BY Available_Values_2018 DESC;



SELECT
    p.Country_Name,
    p.Clean_Value AS Poverty_Rate,
    g.Clean_Value AS Gini_Index
FROM African_Poverty_Indicators_Final p
JOIN African_Poverty_Indicators_Final g
    ON p.Country_Name = g.Country_Name
WHERE p.Indicator_Code = 'SI.POV.UMIC'
AND g.Indicator_Code = 'SI.POV.GINI'
AND p.[Year] = '2018'
AND g.[Year] = '2018'
AND p.Clean_Value IS NOT NULL
AND g.Clean_Value IS NOT NULL
ORDER BY Poverty_Rate DESC;



SELECT
    Country_Name,
    Clean_Value AS Poverty_Rate
FROM African_Poverty_Indicators_Final
WHERE Indicator_Code = 'SI.POV.UMIC'
    AND [Year] = '2018'
    AND Clean_Value IS NOT NULL
ORDER BY Poverty_Rate DESC;

SELECT
    Country_Name,
    Clean_Value AS Gini_Index
FROM African_Poverty_Indicators_Final
WHERE Indicator_Code = 'SI.POV.GINI'
    AND Clean_Value IS NOT NULL
ORDER BY Gini_Index DESC;	


WITH PovertyData AS
(
    SELECT
        Country_Name,
        [Year],
        Clean_Value AS Poverty_Rate,
        ROW_NUMBER() OVER
        (
            PARTITION BY Country_Name
            ORDER BY [Year] DESC
        ) AS rn
    FROM African_Poverty_Indicators_Final
    WHERE Indicator_Code = 'SI.POV.UMIC'
    AND Clean_Value IS NOT NULL
),

GiniData AS
(
    SELECT
        Country_Name,
        [Year],
        Clean_Value AS Gini_Index,
        ROW_NUMBER() OVER
        (
            PARTITION BY Country_Name
            ORDER BY [Year] DESC
        ) AS rn
    FROM African_Poverty_Indicators_Final
    WHERE Indicator_Code = 'SI.POV.GINI'
    AND Clean_Value IS NOT NULL
)

SELECT
    p.Country_Name,
    p.[Year] AS Poverty_Year,
    p.Poverty_Rate,
    g.[Year] AS Gini_Year,
    g.Gini_Index
FROM PovertyData p
INNER JOIN GiniData g
    ON p.Country_Name = g.Country_Name
WHERE p.rn = 1
AND g.rn = 1
ORDER BY p.Poverty_Rate DESC;