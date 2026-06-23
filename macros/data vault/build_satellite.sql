{% macro build_satellite(
    source_model,
    hub_key,
    columns,
    updated_at
) %}

select
    {{ hash_key([hub_key]) }} as hk_{{ hub_key }},

    {% for col in columns %}
        {{ col }}{% if not loop.last %},{% endif %}
    {% endfor %},

    {{ hash_diff(columns) }} as hash_diff,

    {{ updated_at }}         as valid_from,
    cast(null as datetime)   as valid_to,
    current_timestamp        as load_date,
    '{{ source_model }}'     as record_source

from {{ ref(source_model) }}

{% endmacro %}

{# 
    Anwendung:
    {{ build_satellite(
    'stg_evi__contract',
    'contract_pk',
    ['contract_status_key', 'product_type_key_mapped', 'monthly_discount_amount', 'contract_end_date'],
    'updated_at'
) }}
#}