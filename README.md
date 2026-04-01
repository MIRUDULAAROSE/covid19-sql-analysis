COVID-19 Data Analysis (SQL + Excel)
1. Problem Statement
Analyze COVID-19 deaths and vaccination data to understand global trends, mortality rates, and the impact of vaccinations.
2. Tools Used
- Excel (Data Cleaning)
- SQL (Data Analysis)
3. Process
- Collected COVID-19 dataset  
- Cleaned and prepared data using Excel  
- Imported dataset into SQL  
- Wrote SQL queries to analyze cases, deaths, and vaccination trends  
4. Data Cleaning Steps
- Removed null and missing values  
- Standardized column names  
- Converted data types (dates, numerical values)  
- Filtered irrelevant records  
 📊 Business Questions Answered
- How did COVID-19 death rates vary across countries?  
- What is the relationship between vaccinations and death rates?  
- Which countries had the highest infection and mortality rates?  
🧾 Sample SQL Queries
SELECT location, MAX(total_cases) AS TotalCases
FROM covid_data
GROUP BY location
ORDER BY TotalCases DESC;
