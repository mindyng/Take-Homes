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

After calculating OTD %'s, I explored how these looked at the year, monthly, weekly, day in month and day in week levels. The most illuminating seemed to be monthly and weekly since they seemed to show some trends/seasonality. OTD's drop significantly every 10 weeks until appoximately 32nd week of 2022/August.

(Because GitHub could not u/l my screenshots, please refer to this [public Google Doc](https://docs.google.com/document/d/1MdEXpDwYjVkByJ70uL6uILAjrzjf0Ob39TG_9YS1qe0/edit?usp=sharing) to refer to the rest of my visualizations)

It was not suprising that total number of tasks varied much more with deliverables that had non-OTD's. What was more suprising was that when it came total words, average time it took to claim a task and average time it took to start it, these trends were more surprising. The assumption was that non-OTD's had higher amount of words and lingering time with tasks being picked up. However, this seemed to not be the case. It was the tasks that had OTD that had higher volumes of words translated and longer duration times between each process for translation task to kick-start. Please refer to OTD-Deliverables and Non-OTD Deliverables graphs.

The determining factor in what contributed most to OTD was determined by heatmaps that showed how positively or negatively two columns were related to each other. The closer to +1 the more similar they were and the closer to -1 the least similar these columns were to each other. Three heatmaps were run in order to show from requests/deliverables/task level, which columns contributed most to OTD. During some exploratory data analysis, it was found that a project manager could be managing deliverables that are turned in on time and not on time. So singling out project managers was not possible. Another interesting finding was that through crude correlation analysis with pivot tables, found that there were some strong correlations between source (tgl-PH) and target (en-SG) languages leading to non-OTD's. Of course the most illuminating contributor to deliverable having OTD was not how many words or how many tasks were in a deliverable, but the **translator/supplier** who took up the task!

3. 
