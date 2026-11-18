# Metadata framework

The metadata store is `WH_Control` (Fabric Warehouse). It is deliberately separate from `LH_Source`'s read-only SQL analytics endpoint.

## Scripts

1. `00_source_profiling.sql` — run against the `LH_Source` SQL analytics endpoint to discover source columns, data types, row counts, candidate-key quality, and basic referential integrity.
2. `01_create_control_tables.sql` — run in `WH_Control` to create entity configuration, watermarks, pipeline audit, data-quality audit, and schema-change audit tables.
3. `02_column_metadata_and_item_mapping.sql` — run in `WH_Control` after script 01 to add explicit Fabric item/schema mapping and the column-level metadata table.

## Control entities

- `entity_config`: one row per source entity, with source and target names, layer, load type, primary key, watermark column, active flag, and execution order.
- `entity_column_config`: one row per discovered source column, including source/target types, ordinal, nullability, key and watermark flags.
- `watermark_control`: last successfully committed watermark per entity.
- `pipeline_run_log`: pipeline/entity/layer execution status, counts, timestamps, watermarks, and errors.
- `data_quality_log`: rule-level evaluated, passed, and failed counts.
- `schema_change_log`: observed schema fingerprints, change summary, and approval status.

## Execution notes

- Run source profiling queries in `LH_Source`'s SQL analytics endpoint. It is read-only.
- Run DDL and DML scripts in `WH_Control`.
- Fabric Warehouse does not support DEFAULT constraints. Audit timestamps are supplied explicitly.
- Warehouse primary/unique/foreign key constraints are NOT ENFORCED. Data quality and pipeline code must enforce uniqueness and referential integrity.
- Do not populate `entity_column_config` with guessed types. Use the actual schema profiling output first.
