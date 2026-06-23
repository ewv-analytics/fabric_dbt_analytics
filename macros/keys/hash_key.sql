{% macro hash_key(columns) %}
    md5(
        concat(
            {% for col in columns %}
                coalesce(cast({{ col }} as varchar), 'NULL')
                {% if not loop.last %}, '|', {% endif %}
            {% endfor %}
        )
    )
{% endmacro %}

{#
    Anwendung:
        
    select
        {{ hash_key(['customer_id']) }} as hk_customer
    from {{ ref('stg_evi__customer') }}
#}