--ASSUMPTIONS:

--1. Looking for Service that prompts first **Clinical** Service after initial service completion (days_diff = 0).
--2. 3 months = 91 days.
--3. For members having a total of 2 service events, second event is a clinical one (Is Clinical = 'Y'). (This can be ambigious based on column ordering -- if Service Type is ordered alphabetically, can cause first service event to be Clinical and second event to not be).
--4. For members with more than 2 service events, there is at least one clinical event and it is not the first service event.
--5. For members who have multiple service events in one day (days_diff = 0 for all service events), at least one clinical event happened. And this is assumed to be after the first event. This is hard to tell since service completion dates are not broken down to hour/minute granularity. 

--Given assumptions, results may be bloated. So Service Type deemed to be most frequent service completed prior to a member choosing a clinical service may be an exagerration. 

--FILTERING STRATEGY:

--1. Get relevant columns: Member ID, Service Type, Is Clinical (Yes / No), Service Completed At Date.
--2. Order by Member ID (to group service events by member) and Service Completed At Date (from top to bottom: oldest to most recent service completed).
--3. Add days_diff column to get difference between first service completion date and subsequent service completion dates.
--4. Remove all members who have single service completion events.
--5. Filter table by getting rows that are (days_diff = 0) OR (Is Clinical (Yes / No) = 'Yes' and days_diff <=91).
--6. Now, filter out any members that have one remaining service completion event. (Subsequent events were all outside 91 day window).
--7. Filter table out by days_diff = 0.
--8. Group Service Types and get initial_service_completion_count of each Service Type.
--9. Order Frequency in descending order (highest count on top).
--10. Service Type most predictive for member returning within 91 days to complete Clinical service is at the top of the result.



--SOLUTION:

select sub7."Service Type", count(*) as Initial_Service_Completion_Count
from(select sub6."Member ID", sub6."Service Type", sub6."Is Clinical (Yes / No)", sub6."Service Completed At Date", sub6."days_diff"
from (select *
from (select *, count(*) over (partition by sub4."Member ID") as mem_cnt
from (select*
from (select *
from (select *, count(*) over (partition by sub1."Member ID") as services_cnt
from (select s."Member ID", s."Service Type", s."Is Clinical (Yes / No)", s."Service Completed At Date",
s."Service Completed At Date"-first_value(s."Service Completed At Date") over (partition by s."Member ID" order by s."Service Completed At Date") as days_diff
from services s
order by 1,4) sub1) sub2
where services_cnt>1) sub3
where sub3."Is Clinical (Yes / No)" = 'Yes' 
and sub3.days_diff <=91
or (sub3.days_diff = 0)
order by 1,5) sub4) sub5
where mem_cnt>1) sub6
where sub6.days_diff = 0
order by 1,4) sub7
group by 1
order by 2 desc;



--CONCLUSION:

--It turns out that Provider Match is the most popular service completion leading to subsequent clinical service completion event within 3 months. This makes sense since members matched to doctors are already experiencing a clinical service. So it being a gateway to other clinical services is not suprising.

--Product/Process Change to increase number of people who will complete a clinical service after using product:
--Given result, I would work on increasing Provider Match service by changing web user experience. Currently, when website is loaded, one button "Get Started" is only indicator to start using services. Having a bigger button, more color contrast in button/webpage along with features involved in Provider Match included in initial page load would probably help in increasing clinical service completions.

--Experimental design:

--Assumption about user experience: Most are mobile users in general. However, with WFH societal change, let's assume that traffic has increased significantly on web. So time to leverage increased web traffic for increased conversions to clinical services is now! Another assumption is that low web usage is due to poor user interface (content-what is offered is not clear immediately, visually-what is offered is hard for eyes to catch-color contrasts/interactivity).

--I would guide the team by setting up the following:

--Null Hypothesis: There is no difference in mean number of Provider Match service completions due to current webpage design. (Control Group)
--Alternative Hypothesis: There is a difference in mean number of Provider Match service completions due to altered webpage design. (Treatment Group)
--
--Key Measure: Provider Match clinical service completions
--
--Experiment design that I could use to confirm hypothesis that my chosen Key Measure is different in the Treatment group.
--
--    a. Classic A/B Testing: to confirm hypothesis that chosen Key Measure is different in Treatment group/to evaluate treatment effects
--    b. Make sure have randomized groups for Control group and Treatment group
--    c. When determining Sample Size: 
--    	i. Need to make sure it is large enough to yield high statistical power
--    	ii. Use Wald's T-test for 2 independent samples with Bernoulli distribution
--    d. Data Pre-Processing: 
--        i. ratio between Control and Treatment groups not significantly different 
--        ii. Check Metric: What type? This determines hypothesis testing process type
--            1) Continuous
--            2) Ratio
--            3) Proportional
--        iii. How long to run the test: Usually at least a week. However to be precise, need to run test until complete required sample size.
--        iv. Outlier Detection/Variance Reduction/Pre-Experiment Bias (Need to be sensitive to these so that they do not pollute dataset)
--    e. P-Value Calculation (Significance)
--        i. Sample Size can come in different sizes
--            1) Skewed
--            2) Small
--            3) Large
--                a) Based on these, there are different tests that are run:
--                    i) T-test
--                    ii) Chi-Square Test
--    f. Lift (see if there is a significant difference in Treatment group)
--    g. Power Calculation performed in order to see the level of confidence in analysis
--
--Experimental outcomes that constitute success/failure will be based on setting alpha commonly to 0.05 as the cutoff for significance. If the p-value is <0.05, we reject the Null Hypothesis that there is no difference between the means and conclude that a significant difference does exist. This is what I would look for as indication that proposed product change was a success.
--
--However, what would negatively impact the validity of the experiment would be "network effect". The success of the new feature could simply be due to other reasons outside of treatment group. In our example, higher conversion for Provider Match clinical service completion might not be due to website interface change but increase in WFH and/or heightened concern over Covid-19. More and more people want to know whether or not they have it via a health expert's assessment. Validity of A/B tests rest on treatment only affecting behavior of treated users, which is not always the case.
--
--In order to remedy possible network effect consequences, researcher performing experiment could assign treatments randomly based on clusters of users rather than individual users. 