USE marketing_data;

SELECT *
FROM Customers;


SELECT *
FROM geography;

-- Join customers and geography table

SELECT
	c.CustomerID,
	g.GeographyID,
	c.CustomerName,
	c.Email,
	c.Gender,
	c.Age,
	g.Country,
	g.City
FROM customers c
LEFT JOIN geography g
	ON c.GeographyID = g.GeographyID;


SELECT *
FROM products;

SELECT MAX(Price),AVG(Price), Min(Price)
FROM products;

-- Categorize Products based on Price

SELECT 
	ProductID,
	ProductName,
	Category,
	CASE WHEN Price < 50 THEN 'Low'
		WHEN Price BETWEEN 50 AND 250 THEN 'Medium'
		ELSE 'High'
	END AS PriceCategory
FROM products;


SELECT *
FROM engagement_data;


-- Clean and normalize the engagement_data table

SELECT 
    EngagementID,
    ContentID,
    CampaignID,
    ProductID,
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,
    FORMAT(CAST(EngagementDate AS DATE), 'yyyy-MM-dd') AS EngagementDate,
    LEFT(ViewsClicksCombined,CHARINDEX('-', ViewsClicksCombined)-1) AS Views,
	RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-',ViewsClicksCombined)) AS Clicks,
    Likes
FROM engagement_data;


SELECT *
FROM customer_journey;


-- Deal with duplicate records and clean customer_journey table


WITH DuplicateRecords AS(
	SELECT *, 
		ROW_NUMBER() OVER(PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
		ORDER BY JourneyId) AS Row_Num
	FROM customer_journey
)
SELECT *
FROM DuplicateRecords
WHERE Row_Num >1;


SELECT 
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	UPPER(Stage) AS Stage,
	Action,
	COALESCE(Duration,Avg_Duration) AS Duration
FROM(
	SELECT *, AVG(Duration) OVER(PARTITION BY VisitDate) AS Avg_Duration,
		ROW_NUMBER() OVER(PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
		ORDER BY JourneyId) AS Row_Num
	FROM customer_journey
	) AS sub_query
WHERE Row_Num = 1;


SELECT *
FROM customer_reviews;

-- Clean and standardize customer_review table

SELECT 
	ReviewID,
	CustomerID,
	ProductID,
	ReviewDate,
	Rating,
	REPLACE(ReviewText, '  ',' ') AS ReviewText
FROM customer_reviews;


