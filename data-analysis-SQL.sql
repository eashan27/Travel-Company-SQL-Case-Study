select * from booking_table
select * from user_table


/*1*/
select u.segment, count(distinct u.user_id) as no_of_users,
count (case when b.line_of_business='Flight' and b.booking_date between '2022-04-01' and '2022-04-30' then b.user_id end) as users_who_booked_flights_april
from user_table u
left join booking_table b on u.user_id=b.user_id
group by u.segment


/* 2. Users whose first booking was a hotel booking*/
with cte as
(
select *,
rank() over(partition by user_id order by booking_Date) as first_Date
from booking_table

)


select user_id
from cte
where line_of_business='Hotel' and first_date=1


/* 3. Calculate the days between first booking and the last booking of each user */

select user_id, min(booking_date) as first_date, max(booking_date) as last_date,
DATEDIFF(day,min(booking_date),max(booking_date)) as no_of_days
from booking_table
group by user_id


/* 4. Find the number of flights and hotel bookings in each user segments for year 2022 */
select u.segment,
sum(CASE WHEN b.Line_of_Business='Flight' then 1 else 0 end) as flight_bookings,
sum(CASE WHEN b.Line_of_Business='Hotel' then 1 else 0 end) as hotel_bookings
from booking_table b 
join user_table u on b.user_id=u.user_id
where DATEPART(year,b.booking_date)=2022
group by u.segment
