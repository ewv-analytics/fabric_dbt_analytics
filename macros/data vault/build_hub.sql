{% macro build_hub(source_model, business_key, hub_name) %}

select distinct
    {{ hash_key([business_key]) }} as hk_{{ hub_name }},
    {{ business_key }}             as business_key,
    current_timestamp              as load_date,
    '{{ source_model }}'           as record_source

from {{ ref(source_model) }}
where {{ business_key }} is not null

{% endmacro %}

{#
    Anwendung:
    {{ build_hub('stg_evi__customer', 'customer_pk', 'customer') }}
#}