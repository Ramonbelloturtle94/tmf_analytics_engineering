
-- Use the `ref` function to select from other models

{{ config(materialized='table') }}

select 1 as id