# Pansbooking Analysis

## Overview of Project

### Purpose
Pansbooking is an online travel platform that promotes hotel rooms to consumers through the automated chat-bot channels. They constantly strive to make business
changes at each stage of business funnel that help users find the best deal in the easiest way possible.
Pansbooking likes to track of customers throughout customer lifetime to understand how they use the platform over time. This also helps us understand the customer journey, retention, frequency, and LTV.

## Analysis and Challenges

### Analysis Focus
Pansbooking's business is dependent on customers joining the platform, and its profits depends on customers using and returning to the platform for bookings. Thus, Pansbooking's business focus should be on customer acquisition and retention. Since the cohort data for new customers is inconsistent after Jan 2020, the acquisition analysis will be only on customer's journey in 2019.

### New Customers' first booking
Generally new customers come into the platform and find a booking, some customers however will purchase these bookings and cancel the booking after. These bookings are unsuccessful because the customer probably found a better deal elsewhere. 
On the visualization, it is shown that the acquisition of users have increased over time in 2019, however 10-20% of those new users do not commit to their booking.

![new_customer_first_booking](https://user-images.githubusercontent.com/67567087/148623930-c9029f1a-e5fb-4b77-8f14-8795fd9efb8b.PNG)

### Analysis of New Customer Retension 
As above, some new customers will not be committed to their first purchase and these customers are still valuable if they come back and use the platform over time, whereas some new customers do not make committed first purchases and also do not come back.
The visualization shows that this pattern for Snaptravel is decreasing over time in 2019 with ~5% churn

![new_customer_retention](https://user-images.githubusercontent.com/67567087/148624047-c1df286c-bd65-461c-bd92-86526899abe4.PNG)

### Returning Customers vs New Customers
For customers who successfully make purchases and not cancel, we show the booking commitment over time in 2019
We can see that there is a good increase in bookings on the platform over time, with the majority being new customers and returning customers increasing over time
Due to the limitations of the data, it is hard to tell if the dip in March and the rise in November is due to seasonality

![returning_vs_new](https://user-images.githubusercontent.com/67567087/148624157-0a4fffee-9a88-42ea-9cc3-1d1fd413ca82.PNG)

### What happened after the first booking?
Normally new customers will return after a specific amount of time. In our analysis, we found that most customers actually return for their second purchase within the month
The second majority occurs from half year to full year
These two findings shows that the majority of customers are probably business travellers, with the second majority being average vacationers

![afterfirstbooking](https://user-images.githubusercontent.com/67567087/148624240-ddfb6341-f2e4-4e34-8fc7-9f6b05445469.PNG)

### Cohort Analysis
The following visualization shows a customer’s journey from first successful purchase to the next successful purchase.
We wanted to show where our customers are after first joining snaptravel, do they still remain in the platform or have the majority of them never return
We found that out of the 4733 new customers in 2019, 776 returned (16%)

![cohort](https://user-images.githubusercontent.com/67567087/148624315-27fa0869-7643-4d44-b1eb-2aa63a82c62b.PNG)

## Limitations & Additional info needed 

### Limitations
  - There are customers with 1 transaction that have completed date, updated date, and first booking date the same, but is not labelled as a new customer
  - Although the transactions are ranging from Jan 2019 to Jan 2021, there are customers with first booking date within this time period, but the first booking is not within the    data
### To further the analysis, we would want:
  - 1) Purpose of travel
  - 2)Geographical data (origin, destination, routing)
  - 3)Booking class (queen size bed, king size bed, how many beds)
  - 4)Demographic data if available



