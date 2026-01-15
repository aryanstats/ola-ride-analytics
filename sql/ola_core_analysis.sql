-- =====================================================
-- OLA Ride Data Analysis | Bengaluru | December 2025
-- Author: Aryan Harsh
-- =====================================================

create database Ola;
use ola;

-- ================================
-- 1. Booking Performance (KPIs)
-- ================================

-- Total bookings
select COUNT(*) AS total_bookings
from bookings;

-- Success rate (%)
select Round(sum(case when booking_status = 'Successful' then 1 else 0 End)*100.0 / Count(*), 2) as success_rate_percentage
from bookings;

-- Booking status breakdown
select booking_status, count(*) as total_bookings
from bookings
group by booking_status;

-- ================================
-- 2. Revenue Analysis
-- ================================

-- Total revenue
select sum(booking_value) as Total_revenue
from bookings
where booking_status = 'Successful';

-- Average booking value

select round(avg(booking_value), 2) as avg_booking_value
from bookings
where booking_status = 'Successful';

-- Revenue by vehicle type
select vehicle_type, round(sum(booking_value), 2) as total_revenue
from bookings
where booking_status = 'Successful'
group by vehicle_type
order by total_revenue desc;

-- ================================
-- 3. Time-Based Analysis
-- ================================

-- Daily booking trend
select booking_date, count(*) as total_bookings
from bookings
group by booking_date
order by booking_date;

-- Weekend vs Weekday performance
select 
	case
		when dayofweek(booking_date) in (1,7) then 'Weekend'
        else 'Weekday'
	end as day_type,
    count(*) as total_rides,
    round(avg(booking_value), 2) as avg_booking_value
from bookings
where booking_status = 'Successful'
group by day_type;

-- ================================
-- 4. Cancellation Analysis
-- ================================

-- Customer cancellation reasons
SELECT 
    customer_cancel_reason,
    COUNT(*) AS total_cancellations
FROM bookings
WHERE booking_status = 'Cancelled by Customer'
GROUP BY customer_cancel_reason
ORDER BY total_cancellations DESC;

-- Driver cancellation reasons
SELECT 
    driver_cancel_reason,
    COUNT(*) AS total_cancellations
FROM bookings
WHERE booking_status = 'Cancelled by Driver'
GROUP BY driver_cancel_reason
ORDER BY total_cancellations DESC;

-- Incomplete ride percentage
SELECT 
    ROUND(
        SUM(CASE WHEN booking_status = 'Incomplete' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS incomplete_ride_percentage
FROM bookings;

-- ================================
-- 5. Service Quality & Demand
-- ================================

-- Driver ratings by ride distance
SELECT
    CASE
        WHEN ride_distance < 5 THEN 'Short'
        WHEN ride_distance BETWEEN 5 AND 15 THEN 'Medium'
        ELSE 'Long'
    END AS ride_distance_type,
    ROUND(AVG(driver_rating), 2) AS avg_driver_rating
FROM bookings
WHERE booking_status = 'Successful'
GROUP BY ride_distance_type;

-- Top 10 pickup locations
SELECT 
    pickup_location,
    COUNT(*) AS total_rides
FROM bookings
GROUP BY pickup_location
ORDER BY total_rides DESC
LIMIT 10;


