-- Count records
select count(1) from green_tripdata_2019 where (lpep_pickup_datetime between '2019-09-18 00:00:00' and '2019-09-18 23:59:59') and (lpep_dropoff_datetime between '2019-09-18 00:00:00' and '2019-09-18 23:59:59');

-- select count(1) from green_tripdata_2019 where date(lpep_pickup_datetime) != date(lpep_dropoff_datetime);

-- select * from green_tripdata_2019 where trip_distance = (
-- 	select max(trip_distance) from green_tripdata_2019 where date(lpep_pickup_datetime) = date(lpep_dropoff_datetime)
-- );

-- select * from green_tripdata_2019 where (lpep_dropoff_datetime - lpep_pickup_datetime) = (
-- 	select max(lpep_dropoff_datetime - lpep_pickup_datetime)
-- 	from green_tripdata_2019
-- 	where date(lpep_pickup_datetime) = date(lpep_dropoff_datetime)
-- ) and date(lpep_pickup_datetime) = date(lpep_dropoff_datetime);


-- Longest trip for each day
select date(lpep_pickup_datetime) as trip_day, max(lpep_dropoff_datetime - lpep_pickup_datetime) as max_int
from green_tripdata_2019
where (date(lpep_dropoff_datetime) = date(lpep_pickup_datetime) and extract(year from lpep_dropoff_datetime) = 2019)
group by trip_day
order by max_int desc
limit 1;


-- Three biggest pick up Boroughs
select borough."Borough", sum(tripdata."total_amount") as total_amount from green_tripdata_2019 tripdata
left join ny_borough_data borough 
-- on tripdata."DOLocationID" = borough."LocationID"
on tripdata."PULocationID" = borough."LocationID"
where (borough."Borough" is not null) and (borough."Borough" != 'Unknown') and date(tripdata."lpep_pickup_datetime") = '2019-09-18'
group by borough."Borough"
order by total_amount desc;

-- select "DOLocationID" from green_tripdata_2019 limit 10;


-- Largest tip
select borough2."Zone", max(tripdata."tip_amount") max_tip from green_tripdata_2019 tripdata
left join ny_borough_data borough
on tripdata."PULocationID" = borough."LocationID"
left join ny_borough_data borough2
on tripdata."DOLocationID" = borough2."LocationID"
where 
	borough."Zone" = 'Astoria' and
	extract(month from tripdata."lpep_pickup_datetime") = 09 and 
	extract(year from tripdata."lpep_pickup_datetime") = 2019
group by borough2."Zone"
order by max_tip desc;
;
