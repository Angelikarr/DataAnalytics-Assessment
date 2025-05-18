# DataAnalytics-Assessment

## Introduction

This is an SQL project focusing on analyzing customer savings and investment behaviour and overall engagement.

## Overview of Database Schema

schema name "adashi_staging"

## Tables used

users_customuser: This table contains customer demographic and contact information.

savings_savingsaccount: This table contains records of deposit transactions.

plans_plan: This table contains records of plans created by customers.

## Relationships between the Tables

plan.owner_id is a foreign key to the ID primary key in the users table

savings_savingsaccount.plan_id is a foreign key to the ID primary key in the plans table

## Important things to note;

savings_plan : is_regular_savings = 1

investment_plan: is_a_fund = 1

confirmed_amount is the field for value of inflow

amount_withdrawn is the field for value of withdrawal

all amount fields are in kobo


## Questions and SQL Queries

## 1. High-Value Customers with Multiple Products

Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

Approach:

i) Identify customers-

I need the customers names and that was selected from the users_customuser table. For simplicity, I concatenated the first name and last name to put them in one column.

ii) The customers identified needs to have at least one funded savings and one funded investment plan --

To ensure each customer had at least one funded savings plan and one funded investment plan, I joined the plan_plans table to the users table using u.id = p.owner_id.

I got the count distinct of the number of savings plans using p.is_regular_savings = 1 and the count distinct of the number of investment plans using p.is_a_fund = 1.

iii)Sort records by total deposits:

Total deposits here refers to the inflow of money. This information exist in the savings_savingaccount table, hence the reason to join the savings_savingsaccount table.

JOIN savings_savingsaccount s ON p.id = s.plan_id (noting that u.id = p.owner_id in the plans_plan table)

Money inflow is represented by the 'confirmed amount' coluumn which is in kobo.To get the total deposits, I sumed all confirmed deposits for the user’s plans and divided by 100 and round up the number to 2 decimal places. This converts the kobo to Naira making it more standard.

Because the tables were joined and the concept of joins returns all matching records, I had to filter the accounts with no deposits to get the exact number of times there was a deposit.

I grouped the output by user ID and full name to calculate the savings count, investment count, and total deposits per user.

The businesess needs to identify customers that have at least one funded savings, this means users must have both types of plans to appear in the results. To do this, I had to filter to users who had savings and investments greater or equal to 1 using the HAVING function.

## 2. Transaction Frequency Analysis

Task: Calculate the average number of transactions per customer per month and categorize them:

"High Frequency" (≥10 transactions/month)

"Medium Frequency" (3-9 transactions/month)

"Low Frequency" (≤2 transactions/month)

Approach:

i) Identify customers and their monthly transaction:

Firstly,I needed to identify individual customers and how frequently they perform transactions each month. The savings_savingsaccount table contains transaction details, including transaction dates and ownership.

To extract transactions done in a month, I grouped transactions by owner_id and formatted the transaction_date field.

To obtain the number of transactions per user each month, I used: COUNT(\*) AS monthly_txn_count.To ensure the output had only valid transactions, I discarded any records with missing dates and wrapped the result set in a CTE named user_monthly_txn. With the monthly user transaction known, next is to get the average of these monthly transactions.

Using the result from user_monthly_txn, I calculated the average monthly transaction count per user grouped by the owner_id in a second CTE named user_avg_txn.

iii) Categorize users based on frequency of transactions

I created a third CTE user_segment to classify users into frequency category based on their average monthly transactions.

Using a CASE statement, I segmented users into:

High Frequency: users averaging 10 or more transactions per month

Medium Frequency: users averaging 3 to 9 transactions

Low Frequency: users with less than 3 average transactions

iv)Filter segments to focus on High frequency and meduim customers only:The user_segment CTE pre-categorized users into High, Medium, and Low Frequency groups based on their average monthly transactions. I filtered the query to show the count of users in high and meduim groups and their average transactions per month rounded to 2 decimal places.

## 3. Account Inactivity 

Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .

Approach:

i) Identify savings and investment plans that have had no deposit inflow in the last year:

First thing I identifed users with inactive Savings Plans by calculating how many days have passed since that last deposit.

To clearly identify whether the inactive plan is a savings or investment plan when results are combined I added a column to label the plan type as 'Savings' for the first query and 'Investment' for the second query.

To focus only on plans that are active types (savings or investments) and exclude transactions that aren’t actual deposits, I joined the plans_plan table to select only savings (p.is_regular_savings = 1) or investment plans (p.is_a_fund = 1) and filter deposits with positive amounts (confirmed_amount > 0).

Grouped by plan and owner so that the MAX transaction date is calculated per plan

I used HAVING clause to keep only plans with a last deposit that was more than 365 days ago for the investment plan.

I used UNION to merge the savings and investment plans outcomes into a single output.

## 4. Customer Lifetime Value (CLV) Estimation
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest

Approach:
i)Calculated the customer account tenure and total transactions made by a customer: I need the customers names and that was selected from the users_customuser table. 
For simplicity, I concatenated the first name and last name to put them in one column.
ii) Calculated tenure in months from their join date to today.
iii) Count total deposit transactions per customer.
iv) Calculated estimated CLV by:
   -Finding monthly transaction frequency,
   -I estimated annual activity by multiplying the monthly frequency by 12.
   -Multiplied by 0.001 to get the average profit per transaction
   -Converted Kobo to Naira by dividing by 100 and rounding to two decimals.
v) Joined user data with savings transactions to combine customer information with their savings transactions
vi) Filtered to include only deposits with positive amounts.
viii) Grouped by customer to aggregate data and order by CLV descending to ensure highest-value customers first.

## Challenges/Limitations:
Database got disconnected often while running the query, to solve this, I increased the run time to 200 seconds


