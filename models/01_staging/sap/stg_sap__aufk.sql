select *
from {{ source('sap_raw', 'AUFK') }}