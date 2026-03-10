select
    traveller_id,
    count(*) as booking_count,
    sum(booking_amount) as total_booking_amount
from {{ ref('stg_trip_bookings') }}
group by 1