{% macro keytab_displayname(field, keyrange) %}

(
    select displayname
    from {{ ref('stg_evi_keytab') }}
    where key_value = {{ field }}
      and keyrange = '{{ keyrange }}'
)

{% endmacro %}


{#
Anwendung z.B.:

select

    customerpk,
    

    
    custtypekey,

    {{ keytab_displayname(
        'custtypekey',
        'KUNDENSTATUS'
    ) }} as kundenstatus

from customer
#}