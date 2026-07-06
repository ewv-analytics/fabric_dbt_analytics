{% macro evi_safe_column_name(value) %}
    {%- set v = value | lower -%}
    {%- set v = v | replace('ä', 'ae') -%}
    {%- set v = v | replace('ö', 'oe') -%}
    {%- set v = v | replace('ü', 'ue') -%}
    {%- set v = v | replace('ß', 'ss') -%}
    {%- set v = v | replace('.', '_') -%}
    {%- set v = v | replace(' ', '_') -%}
    {%- set v = v | replace('-', '_') -%}
    {%- set v = v | replace('/', '_') -%}
    {%- set v = v | replace('(', '') -%}
    {%- set v = v | replace(')', '') -%}
    {%- set v = v | replace('[', '') -%}
    {%- set v = v | replace(']', '') -%}
    {{ return(v) }}
{% endmacro %}


{% macro evi_rename_fields_from_seed(
        source_relation,
        table_name,
        table_alias = 'src',
        haupt_oder_linktabelle = none,
        alias_mode = 'safe',
        free_fields_only = false
    ) %}

    {% set mapping_relation = ref('evi_feldnamen_mapping') %}

    {% if not execute %}

        *

    {% else %}

        {% set columns = adapter.get_columns_in_relation(source_relation) %}

        {% set mapping_sql %}
            select
                upper(Name_des_Felds) as old_column_name,
                Sprechender_Feldname  as speaking_column_name
            from {{ mapping_relation }}
            where upper(Name_der_Tabelle) = upper('{{ table_name }}')

            {% if haupt_oder_linktabelle is not none %}
              and upper(Haupt_oder_Linktabelle) = upper('{{ haupt_oder_linktabelle }}')
            {% endif %}

            {% if free_fields_only %}
              and (
                    upper(Name_des_Felds) like 'FREE%'
                 or upper(Name_des_Felds) like 'F[_]FREE%'
              )
            {% endif %}
        {% endset %}

        {% set mapping_result = run_query(mapping_sql) %}

        {% set rename_map = {} %}

        {% for row in mapping_result.rows %}
            {% do rename_map.update({ row[0]: row[1] }) %}
        {% endfor %}

        {% for column in columns %}

            {% set old_column_name = column.name %}
            {% set lookup_column_name = old_column_name | upper %}

            {% if lookup_column_name in rename_map %}

                {% set speaking_column_name = rename_map[lookup_column_name] %}

                {% if alias_mode == 'quoted' %}

                    {{ table_alias }}.{{ adapter.quote(old_column_name) }}
                        as {{ adapter.quote(speaking_column_name) }}

                {% else %}

                    {{ table_alias }}.{{ adapter.quote(old_column_name) }}
                        as {{ adapter.quote(evi_safe_column_name(speaking_column_name)) }}

                {% endif %}

            {% else %}

                {{ table_alias }}.{{ adapter.quote(old_column_name) }}
                    as {{ adapter.quote(evi_safe_column_name(old_column_name)) }}

            {% endif %}

            {% if not loop.last %},{% endif %}

        {% endfor %}

    {% endif %}

{% endmacro %}


{#
Anwendung z.B.:

{{
    config(
        materialized = 'view'
    )
}}

select
   
    {{
        evi_rename_fields_from_seed(
            source_relation = source('bronze_evi', 'CONTRACT'),
            table_name = 'CONTRACT',
            table_alias = 'src',
            haupt_oder_linktabelle = 'MAIN',
            alias_mode = 'safe',
            free_fields_only = true
        )
    }},

    current_timestamp as load_timestamp,
    'EVI' as source_system

from {{ source('bronze_evi', 'CUSTOMER') }} as src
where src.ACTIVE = 1


#}