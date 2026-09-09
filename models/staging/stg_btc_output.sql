WITH flattened_output AS (

{{config(materialized='incremental', incremental_strategy='append')}}

select
tx.hash_key,
tx.block_number,
tx.block_timestamp,
tx.is_coinbase,
f.value:address::STRING as output_address,
f.value:value::FLOAT as output_value

from {{ ref('stg_btc')}} tx,

LATERAL FLATTEN(input => outputs) f

WHERE f.value:address is not null

-- This model flattens the outputs array from stg_btc so that each output (address + value)
-- appears on its own row.
{% if is_incremental() %}

and tx.block_timestamp >= (select max(block_timestamp) from {{ this }})

{% endif %}
)

select 
hash_key,
block_number,
block_timestamp,
is_coinbase,
output_address,
output_value

from flattened_output