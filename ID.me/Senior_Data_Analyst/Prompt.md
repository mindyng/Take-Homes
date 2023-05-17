# Instructions: 
- ![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) `#f03c15`
- ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `#c5f015`
- ![#1589F0](https://placehold.co/15x15/1589F0/1589F0.png) `#1589F0`

The narrative below presents a hypothetical situation where you are an analytics engineer at a
SAAS startup and poses some scenarios in a chronological order. Use your previous work experience and
judgment to augment the details provided. Build your own narrative around the fictional SAAS company and
your role there, and then detail how you would build an analytics foundation that solves their data needs.
Answers do not need to be isolated to the immediate preceding prompt; you may use previously given
information as well as context from your previous answers.

DogDB is a California based company that has developed a novel NoCATS database and offers a managed,
hosted solution as a monthly SAAS subscription with free, medium ($50/mo), and enterprise tiers ($500/mo).
DogDB is seeing their number of customer accounts skyrocket (“up and to the right”) and have hired you as
the first dedicated analytics engineer to help them understand and scale their data capabilities, in anticipation
of an incipient funding round.

DogDB sells their service through a web-facing rails application. Here, a DogDB customer can sign up for an
account, choose a pricing tier, and configure their NoCATS deployment. The accounting settings and
configurations are stored in a PostgreSQL database.

Currently, DogDB has tables which are sampled below.

<img width="599" alt="customer_accounts" src="https://github.com/mindyng/Take-Homes/assets/12889138/51047266-37fd-4e26-a81e-0ce43648cf76">

<img width="693" alt="customer_interactions" src="https://github.com/mindyng/Take-Homes/assets/12889138/01b45ea2-79f6-454c-84e7-7987b0bee75e">

<img width="550" alt="customer_licenses" src="https://github.com/mindyng/Take-Homes/assets/12889138/17af00d7-c28a-42f4-8bb6-94ef1346c887">

1) Based on the table design above, what are your initial thoughts about DogDB’s data tracking? What are
some of the advantages (if any) of their data models, and what are the shortcomings (if any) you foresee in
DogDB’s future?

Every month, DogDB’s accountant receives a report from the engineering team to assist with accounting.
Customers on the medium tier are charged by credit card, but the accountant must know ahead of time what
the expected charge will be. Customers on the enterprise tier are sent an invoice from DogDB.

2) Describe what the engineering team is most likely doing currently to support accounting in terms of
process. Include the queries they are running if you think you can take a guess at what they are. What are
some of the shortcomings of the current process?

The customer service team has asked one of the data analysts to develop a dashboard to illustrate the
monthly interaction volume of the accounts with the 10 highest number of active developer licenses. They are
looking for various breakdowns by account, month, interaction channel, category, service representative, and
interaction status.

3) You have been tasked with designing a model to provide the data for the analyst. How would you structure
the output? Include the query you would use to create the model.

The analysts have been complaining that one of the view models created before you arrived is taking too long
to run. This view is used in several dashboards across various business departments, and for ad hoc analyses
on a regular basis.

4) What are the troubleshooting steps you would take to identify the problem? Based on experience you’ve
had in the past, develop a hypothetical narrative for identifying what the problem is and then the steps to
address fixing it.

5) Based on what you understand of DogDB so far, what would your first week at DogDB look like? What is
your number one priority to try and change?
