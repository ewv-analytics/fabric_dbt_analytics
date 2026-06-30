
{% macro keytab_join(
        source_field,
        keyrange,
        alias
) %}

left join {{ ref('stg_evi_keytab') }} {{ alias }}
    on {{ source_field }} = {{ alias }}.key_value
   and {{ alias }}.key_range = '{{ keyrange }}'

{% endmacro %}

{#
Anwendung im Modell z.B.:
{{ keytab_join(
    'customer.custtypekey',
    'KUNDENSTATUS',
    'ks'
) }}

#}