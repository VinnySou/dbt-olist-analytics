{% macro monetary_diff(value_a, value_b) %}
abs({{ value_a }} - {{ value_b }})
{% endmacro %}

{% macro exceeds_monetary_tolerance(value_a, value_b, tolerance=0.01) %}
{{ monetary_diff(value_a, value_b) }} > {{ tolerance }}
{% endmacro %}
