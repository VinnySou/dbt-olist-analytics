{% macro monetary_values_differ(value_a, value_b, tolerance=0.01) %}
{#
    Expressão booleana reutilizável pra comparar dois valores monetários com
    tolerância de arredondamento. Usada nos testes singulares que comparam um
    total agregado de um jeito (ex.: soma de item) com o mesmo total agregado
    de outro jeito (ex.: payment_value do pedido) — sem essa macro, cada teste
    repetia o mesmo `abs(a - b) > 0.01` em SQL solto.
#}
abs({{ value_a }} - {{ value_b }}) > {{ tolerance }}
{% endmacro %}
