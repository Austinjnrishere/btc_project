{% test assert_valid_btc_address(model, column_name) %}

    select *
    from {{ model }}
    where NOT (
        {{ column_name }} LIKE '1%' OR
        {{ column_name }} LIKE '3%' OR
        {{ column_name }} LIKE 'bc1%'
    )

{% endtest %}

-- this test checks if the given column contains valid Bitcoin addresses. 
-- Valid Bitcoin addresses start with '1', '3', or 'bc1'. If any address does not match these patterns,
-- it will be flagged as invalid.