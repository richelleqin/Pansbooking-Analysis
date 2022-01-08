--NEW CUSTOMER FIRST BOOKING
select a.*, 
	b.after_first_purchase_booked, 
	b.after_first_purcahse_cancelled, 
	(a.first_purchase_GM + isnull(b.after_first_purchase_GM,0)) as total_GM,
	count(a.[SUPER_USER_ID]) over(partition by year(a.[COMPLETED_DATE]), month(a.[COMPLETED_DATE]))
	as new_uers_monthly
	from 
(
select [SUPER_USER_ID], 
	[COMPLETED_DATE],
	count(case when [STATUS] = 'room_booked' then 1 end) as first_purchase_booked,
	count(case when [STATUS] = 'cancelled' then 1 end) as first_purcahse_cancelled,
	sum([GROSS_REVENUE]) as first_purchase_GM
from [dbo].[hotelroom] where [COMPLETED_DATE] = [USER_FIRST_BOOKING_DATE]
group by [SUPER_USER_ID], [COMPLETED_DATE]
) a 
left join 
(
select [SUPER_USER_ID], 
	count(case when [STATUS] = 'room_booked' then 1 end) as after_first_purchase_booked,
	count(case when [STATUS] = 'cancelled' then 1 end) as after_first_purcahse_cancelled,
	sum([GROSS_REVENUE]) as after_first_purchase_GM
from [dbo].[hotelroom] where [COMPLETED_DATE] <> [USER_FIRST_BOOKING_DATE]
group by [SUPER_USER_ID]
) b
on a.[SUPER_USER_ID] = b.[SUPER_USER_ID];

select * into #1 from 
(
select [SUPER_USER_ID], [completed_date_time], [TOTAL_PRICE_USD], [NEW_USER_ORDER] 
from [dbo].[hotelroom] where [STATUS] <> 'cancelled' 
except 
select [SUPER_USER_ID], [completed_date_time], -1* [TOTAL_PRICE_USD], [NEW_USER_ORDER] 
from [dbo].[hotelroom] where [STATUS] = 'cancelled' 
) a;



select a.*, b.new_customers from 
(
select count (distinct [SUPER_USER_ID]) as total_successful_bookings, 
year([completed_date_time]) as year, month([completed_date_time]) as month from #1
group by year([completed_date_time]), month([completed_date_time]) 
) a 
left join 
(
select count (distinct [SUPER_USER_ID]) as new_customers, 
year([completed_date_time]) as year, month([completed_date_time]) as month from #1
where [NEW_USER_ORDER] = '1'
group by year([completed_date_time]), month([completed_date_time])
) b
on a.year = b.year and a.month = b.month 
order by a.year, a.month ;






-- CUSTOMER RETENSION
select count([super_user_id]) as never_come_back, year([USER_FIRST_BOOKING_DATE]) as year, month([USER_FIRST_BOOKING_DATE]) as month
from [dbo].[hotel_customer]
where [orders_booked] = [orders_cancelled] and [orders_booked_after_first] is null 
group by year([USER_FIRST_BOOKING_DATE]), month([USER_FIRST_BOOKING_DATE])
order by year([USER_FIRST_BOOKING_DATE]), month([USER_FIRST_BOOKING_DATE])

-- FOR GRAPH 3 4 5 INCLUDING COHORT

select *, 
row_number() over (partition by super_user_id order by completed_date) as row_num,
datediff(day, 
	lag(completed_date) over (partition by super_user_id order by completed_date), 
	COMPLETED_DATE) as frequency 
from
(select [SUPER_USER_ID], [COMPLETED_DATE],[TOTAL_PRICE_USD]
from hotelroom  
where status <> 'cancelled'
EXCEPT 
select [SUPER_USER_ID], [COMPLETED_DATE], -1*[TOTAL_PRICE_USD]
from hotelroom
where status = 'cancelled') a
order by super_user_id, completed_date