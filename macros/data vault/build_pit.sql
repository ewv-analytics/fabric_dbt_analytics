{% macro build_pit(hub, satellites, date_model='date_dimension', date_column='date_value') %}

select
    hub.hk_{{ hub }},
    d.{{ date_column }},

    {% for sat in satellites %}
        max({{ sat }}.valid_from) as {{ sat }}_valid_from{% if not loop.last %},{% endif %}
    {% endfor %}

from {{ ref('hub_' ~ hub) }} hub
join {{ ref(date_model) }} d
    on 1 = 1

{% for sat in satellites %}
left join {{ ref(sat) }} {{ sat }}
    on hub.hk_{{ hub }} = {{ sat }}.hk_{{ hub }}
   and {{ sat }}.valid_from <= d.{{ date_column }}
{% endfor %}

group by
    hub.hk_{{ hub }},
    d.{{ date_column }}

{% endmacro %}

{#
    Anwendung:
    {{ build_pit(
    'contract',
    ['sat_contract_status', 'sat_contract_finance'],
    'date_dimension',
    'date_value'
    ) }}

    Dabei sind 
    date_dimension = eine Tabelle mit allen Zeitpunkten (Kalender)
    date_value = die Datums-/Zeit-Spalte darin
#}