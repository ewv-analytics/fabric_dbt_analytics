{% macro dev_date_filter(date_column, days_back_var) %}
    {% if target.name == 'dev' %}
        {{ date_column }} >= dateadd(day, -{{ var(days_back_var) }}, current_timestamp)
    {% else %}
        1 = 1
    {% endif %}
{% endmacro %}


{% macro dev_hash_sample(key_column, modulo_var='dev_sample_modulo', remainder_var='dev_sample_remainder') %}
    {% if target.name == 'dev' %}
        abs(checksum(cast({{ key_column }} as varchar))) % {{ var(modulo_var) }} = {{ var(remainder_var) }}
    {% else %}
        1 = 1
    {% endif %}
{% endmacro %}


{% macro dev_where(conditions) %}
    {% if target.name == 'dev' %}
WHERE
    {%- for condition in conditions %}
        {{ condition }}
        {%- if not loop.last %} AND {% endif %}
    {%- endfor %}
    {% endif %}
{% endmacro %}

{# 
    Anwendung:
        
    SELECT *
    FROM {{ source('bronze', 'br_evi_contract_raw') }}

    {{ dev_where([
        dev_date_filter('CONTSTARTDATE', 'dev_days_back_contract'),
        dev_hash_sample('CONTRACT_PK')
    ]) }}
#}