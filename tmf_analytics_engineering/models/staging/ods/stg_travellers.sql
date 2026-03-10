select
    traveller_id,
    name,
    dob,
    gender,
    city
from {{ source('oms_training', 'TRAVELLERS') }}