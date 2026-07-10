select

    CUSTOMERID,
    CUSTOMERNAME,
    CUSTOMERSTATUS

from {{ source('evi_raw', 'C12CUSTOMER') }}