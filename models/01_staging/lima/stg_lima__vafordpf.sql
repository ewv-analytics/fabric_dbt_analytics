select *
from {{ source('lima_raw', 'VAFORDPF') }}
