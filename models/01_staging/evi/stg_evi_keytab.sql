{{ config(materialized='view') }}

select

    pk           as key_value,
    keyrange,
    keyname,
    displayname,
    parentpk

from {{ source('bronze_evi', 'S_KEYTAB') }}

where active = 1
and pgs='E126'