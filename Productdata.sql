select * from Sheet1$;
exec sp_rename 'Productname','Productdata';

select * from Productdata;

--#1.Identifies products with prices higher than the average price within their category

select [Product ID], [product name],category,price
from productdata
where price > (select avg(price) from  productdata P where p.category=productdata.category)
order by price desc;

select category from productdata
group by category;

--Interpretation
--1.Each of your main categories (Clothing, Electronics, and Home) is represented among these high-priced items.
--This suggests that you offer premium products across your entire product range.
--2.The prices are all very high, clustered around the 999 range. This indicates that these are premium or high-value items in your inventory.

--Suggestions
--1.High-value items may have lower turnover rates, so careful inventory management is crucial to avoid tying up capital.
--2.Conduct a thorough analysis of the pricing of these items to ensure that they are competitive and profitable.
--Consider factors such as cost, demand, and competitor pricing.

--#2.Finding Categories with Highest Average Rating Across Products

SELECT Category, AVG(Rating) AS AverageRating
FROM ProductData
GROUP BY Category
ORDER BY AverageRating DESC;

--Interpretations
--1.From the result, it is seen that HOME category has the highest ratings and that customers are more satisfied by its product.
--2.It can be seen that the customers are consistent beacuse there is close average rating in all the 3 categories.

--suggestions
--1.Investigating what factors are contributing for the high ratings HOME
--2.Although the differences are small, look into why the "Electronics" and "Clothing" categories have slightly lower ratings, we can some 
--feedback fro potential areas of improvement, and also work on marketing and sales effort.
--3.Maintain this level of consistency across all categories

-- #3. Find the most reviewed product in each warehouse.
with RankReviews as(select warehouse,[Product Name],Reviews,
Row_number() over(partition by warehouse order by Reviews desc) as rn
from productdata)
 select warehouse,[product name],reviews
 from rankreviews
 where rn= 1;

--Interpretation
--1.The consistent 99 reviews across all warehouses indicate a very high level of customer engagement with these particular products. 
--2.These products (B and C) serve as excellent benchmarks for understanding what resonates with your customer base.
--3.Analyzing the features, pricing, and marketing of these products can provide valuable insights for improving the performance of other products.

--Suggestions
--1.Closely monitor inventory turnover rates for these products to prevent stockouts.
--2.Develop warehouse-specific marketing campaigns that capitalize on the popularity of these products.
--3.Analyze the placement of these products within each warehouse.Ensure they are prominently displayed and easily accessible to customers.


--#4.Find products that have higher-than-average prices within their category, along with their discount and supplier.
select [product id],[product name],[category],price,discount,supplier
from productdata
where price >(select avg(price) from productdata as subquery
where subquery.category = productdata.category);

--Interpretations
--1.There's a significant price range within the clothing category. 
--This shows that your clothing category contains a wide range of products.
--2.The discount amounts also vary widely.
--This suggests different discounting strategies for different products.

--Suggestions
--1.Consider price adjustments based on market demand and competitor pricing.
--2.Evaluate the effectiveness of current discounting strategies.
--3.Strengthen relationships with high-performing suppliers.
--4.Identify opportunities to increase profitability.

--#5.Query to find the top 2 products with the highest average rating in each category.
with rankedproducts as(
select category,[product name],avg(rating) as averagerating,
row_number() over(partition by category order by avg(rating)desc) as rn
from productdata
group by category,[product name])

select category,[product name],averagerating
from rankedproducts
where rn<=2
order by category,averagerating desc;

--Interpretation
--1.Home category has the highest rating within all category.
--2.Product B appears as a top performer in both the Clothing and Home categories, suggesting it has broad appeal.
--3.The average ratings are relatively close within each category, indicating that while there are top performers, 
--there's not a huge disparity in customer satisfaction.

--Suggestion
--1.Use customer reviews and testimonials to further emphasize their popularity.
--2.Investigate what makes Product B so successful across multiple categories.
--3.Develop category-specific marketing strategies that leverage the strengths of the top-rated products.

--#6.Analysis Across All Return Policy Categories (Count, Avgstock, total stock, weighted_avg_rating, etc.)

select [Return Policy], count(*) as productcount, avg([Stock Quantity]) as averagestock, sum([Stock Quantity]) as Totalstock,
sum(rating*[Stock Quantity]) / sum([Stock Quantity]) as weightedaveragerating
from productdata
group by [Return Policy];


--Interpretation
--1.The average stock levels are quite similar across all three return policy categories,
--indicating a relatively consistent stock management approach.
--2.The 7-day return policy category has the highest product count and total stock. 
--This suggests that a significant portion of your inventory falls under this policy.
--This could indicate a strategy focused on faster inventory turnover for these products.

--Suggestions
--1.Investigate why the 7-day return policy category has the highest product count.Determine if this policy is driving sales or if it's leading to
--higher return rates.Consider if the 7 day return policy is used on fast moving items.
--2.Analyze return rates for each return policy category to identify any trends or patterns.


