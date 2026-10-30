UPDATE game_config_versions AS config
SET payload = jsonb_set(
  config.payload,
  '{items}',
  COALESCE(
    (
      SELECT jsonb_agg(
        CASE
          WHEN item.value->>'code' IN ('exp_boost', 'less_compensation', 'gain_more')
            THEN jsonb_set(item.value, '{maxStock}', '5'::jsonb, true)
          ELSE item.value
        END
        ORDER BY item.ordinality
      )
      FROM jsonb_array_elements(config.payload->'items') WITH ORDINALITY AS item(value, ordinality)
    ),
    '[]'::jsonb
  ),
  true
)
WHERE config.version = 2
  AND jsonb_typeof(config.payload->'items') = 'array';
