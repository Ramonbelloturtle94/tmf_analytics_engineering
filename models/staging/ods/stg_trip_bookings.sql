select
    traveller_id,
    traveller_name,
    booking_id,
    booking_amount
from {{ source('oms_training', 'TRIP_BOOKINGS') }}