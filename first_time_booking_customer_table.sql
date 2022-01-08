
-- to create customer table 
use snaptravel
select a.super_user_id, a.USER_FIRST_BOOKING_DATE, a.orders_booked, a.orders_cancelled, 
	b.orders_booked_after_first, b.orders_cancelled_after_first,
a.first_earn + isnull(b.after_first_earn,0) as total_earned,
count(a.super_user_id) over (partition by month(a.user_first_booking_date), 
		year(a.user_first_booking_date)
			) as new_customer
from
(select super_user_id, [USER_FIRST_BOOKING_DATE],sum([GROSS_REVENUE]) as first_earn, 
	count(case when status = 'cancelled' then 1 end) as orders_cancelled, 
	count(case when status = 'room_booked' then 1  end) as orders_booked
from hotelroom
where completed_date = [USER_FIRST_BOOKING_DATE]
group by super_user_id,[USER_FIRST_BOOKING_DATE] ) a
left join 
(select super_user_id, 
	count(case when status = 'cancelled' then 1 end) as orders_cancelled_after_first, 
	count(case when status = 'room_booked' then 1  end) as orders_booked_after_first,
	sum(gross_revenue) as after_first_earn
from hotelroom
where completed_date <> [user_first_booking_date]
group by super_user_id) b on a.super_user_id = b.super_user_id