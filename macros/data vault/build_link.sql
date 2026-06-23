{% macro build_link(source_model, keys, link_name) %}

select distinct
    {{ hash_key(keys) }} as hk_{{ link_name }},

    {% for key in keys %}
        {{ hash_key([key]) }} as hk_{{ key }}{% if not loop.last %},{% endif %}
    {% endfor %},

    current_timestamp    as load_date,
    '{{ source_model }}' as record_source

from {{ ref(source_model) }}

{% endmacro %}

{#
    Anwendung:
    {{ build_link(
    'stg_evi__contract',
    ['customer_pk', 'contract_pk'],
    'customer_contract'
) }}
#}