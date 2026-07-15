select

    PK as customer_pk,
    NAME1 as customer_nachname,
    PERSONPK as person_pk

from {{ source('evi_raw', 'CUSTOMER') }}