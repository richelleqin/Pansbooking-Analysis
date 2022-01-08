-- to create hotel_customer table

SELECT a.super_user_id,
       a.user_first_booking_date,
       a.orders_booked,
       a.orders_cancelled,
       b.orders_booked_after_first,
       b.orders_cancelled_after_first,
       a.first_earn + Isnull(b.after_first_earn, 0) AS total_earned,
       Count(a.super_user_id)
         OVER (
           partition BY Month(a.user_first_booking_date),
         Year(a.user_first_booking_date) )          AS new_customer
FROM   (SELECT super_user_id,
               [user_first_booking_date],
               Sum([gross_revenue]) AS first_earn,
               Count(CASE
                       WHEN status = 'cancelled' THEN 1
                     END)           AS orders_cancelled,
               Count(CASE
                       WHEN status = 'room_booked' THEN 1
                     END)           AS orders_booked
        FROM   hotelroom
        WHERE  completed_date = [user_first_booking_date]
        GROUP  BY super_user_id,
                  [user_first_booking_date]) a
       LEFT JOIN (SELECT super_user_id,
                         Count(CASE
                                 WHEN status = 'cancelled' THEN 1
                               END)         AS orders_cancelled_after_first,
                         Count(CASE
                                 WHEN status = 'room_booked' THEN 1
                               END)         AS orders_booked_after_first,
                         Sum(gross_revenue) AS after_first_earn
                  FROM   hotelroom
                  WHERE  completed_date <> [user_first_booking_date]
                  GROUP  BY super_user_id) b
              ON a.super_user_id = b.super_user_id 


--NEW CUSTOMER FIRST BOOKING
SELECT a.*,
       b.after_first_purchase_booked,
       b.after_first_purcahse_cancelled,
       ( a.first_purchase_gm
         + Isnull(b.after_first_purchase_gm, 0) )                            AS
       total_GM,
       Count(a.[super_user_id])
         OVER(
           partition BY Year(a.[completed_date]), Month(a.[completed_date])) AS
       new_uers_monthly
FROM   (SELECT [super_user_id],
               [completed_date],
               Count(CASE
                       WHEN [status] = 'room_booked' THEN 1
                     END)           AS first_purchase_booked,
               Count(CASE
                       WHEN [status] = 'cancelled' THEN 1
                     END)           AS first_purcahse_cancelled,
               Sum([gross_revenue]) AS first_purchase_GM
        FROM   [dbo].[hotelroom]
        WHERE  [completed_date] = [user_first_booking_date]
        GROUP  BY [super_user_id],
                  [completed_date]) a
       LEFT JOIN (SELECT [super_user_id],
                         Count(CASE
                                 WHEN [status] = 'room_booked' THEN 1
                               END)           AS after_first_purchase_booked,
                         Count(CASE
                                 WHEN [status] = 'cancelled' THEN 1
                               END)           AS after_first_purcahse_cancelled,
                         Sum([gross_revenue]) AS after_first_purchase_GM
                  FROM   [dbo].[hotelroom]
                  WHERE  [completed_date] <> [user_first_booking_date]
                  GROUP  BY [super_user_id]) b
              ON a.[super_user_id] = b.[super_user_id];

SELECT *
INTO   #1
FROM   (SELECT [super_user_id],
               [completed_date_time],
               [total_price_usd],
               [new_user_order]
        FROM   [dbo].[hotelroom]
        WHERE  [status] <> 'cancelled'
        EXCEPT
        SELECT [super_user_id],
               [completed_date_time],
               -1 * [total_price_usd],
               [new_user_order]
        FROM   [dbo].[hotelroom]
        WHERE  [status] = 'cancelled') a; 


SELECT a.*,
       b.new_customers
FROM   (SELECT Count (DISTINCT [super_user_id]) AS total_successful_bookings,
               Year([completed_date_time])      AS year,
               Month([completed_date_time])     AS month
        FROM   #1
        GROUP  BY Year([completed_date_time]),
                  Month([completed_date_time])) a
       LEFT JOIN (SELECT Count (DISTINCT [super_user_id]) AS new_customers,
                         Year([completed_date_time])      AS year,
                         Month([completed_date_time])     AS month
                  FROM   #1
                  WHERE  [new_user_order] = '1'
                  GROUP  BY Year([completed_date_time]),
                            Month([completed_date_time])) b
              ON a.year = b.year
                 AND a.month = b.month
ORDER  BY a.year,
          a.month; 






-- CUSTOMER RETENSION
SELECT Count([super_user_id])           AS never_come_back,
       Year([user_first_booking_date])  AS year,
       Month([user_first_booking_date]) AS month
FROM   [dbo].[hotel_customer]
WHERE  [orders_booked] = [orders_cancelled]
       AND [orders_booked_after_first] IS NULL
GROUP  BY Year([user_first_booking_date]),
          Month([user_first_booking_date])
ORDER  BY Year([user_first_booking_date]),
          Month([user_first_booking_date]) 

-- FOR GRAPH 3 4 5 INCLUDING COHORT

SELECT *,
       Row_number()
         OVER (
           partition BY super_user_id
           ORDER BY completed_date)                                AS row_num,
       Datediff(day, Lag(completed_date)
                       OVER (
                         partition BY super_user_id
                         ORDER BY completed_date), completed_date) AS frequency
FROM   (SELECT [super_user_id],
               [completed_date],
               [total_price_usd]
        FROM   hotelroom
        WHERE  status <> 'cancelled'
        EXCEPT
        SELECT [super_user_id],
               [completed_date],
               -1 * [total_price_usd]
        FROM   hotelroom
        WHERE  status = 'cancelled') a
ORDER  BY super_user_id,
          completed_date 