{% macro hash_diff(columns) %}
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
    Anwendung (Change Detection):
    
    select
        {{ hash_diff(['status', 'price', 'end_date']) }} as hash_diff
    from {{ ref('stg_evi__contract') }}
#}