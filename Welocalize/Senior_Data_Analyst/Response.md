1. Describe the tools you used to generate the following results. And, as much as possible, in all subsequent exercises, be prepared to show any "code" or anything else that demonstrates how you completed the exercise.

The tools I used were:
a. My local machine to spin up PostgreSQL Database to store original data file and create transformations.
b. Kaggle notebook to create ipynb.
c. All code is in the same path as this file.

2. Develop and show at least 3 different data visualizations showing how Welocalize performed in terms of OTD rates (how frequently we deliver on time vs. late). Consider how these OTD rates are correlated with other attributes/variables from the dataset. Be prepared to explain how you calculated OTD rates; what the visuals demonstrate; and what are the most important conclusions you drew from the data.

I calculated [OTD/non-OTD rates](https://github.com/mindyng/Take-Homes/blob/master/Welocalize/Senior_Data_Analyst/data_transformations.sql#L54-L60) by doing a sum over rows that had target column as N/Y divided by total deliverables over month and week in year. 
In terms of OTD rates, for majority of 2022, the company was within customer tolerance level of 90% - 95% OTD's. 

![overallpie](pie.png)

We can see here that 90.5% are OTD's (True) and 9.5% (False) need some work. The neighboring graph just shows straight counts for reference. Even though Welocalize made the cut-off for customer acceptance, still room for improvement.

After calculating 
