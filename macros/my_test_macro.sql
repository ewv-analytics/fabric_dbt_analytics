    -- macros/my_macro.sql
    {% macro cents_to_euros(column_name, precision=2) %}
        ({{ column_name }} / 100.0)::numeric(18, {{ precision }})
    {% endmacro %}