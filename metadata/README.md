# Metadata framework

The metadata layer will hold entity configuration, watermarks, run audit, and quality results.

Planned entities:
- `entity_config`: source/target identifiers, keys, load strategy, active flag, execution order.
- `watermark_control`: last successfully committed watermark per entity.
- `pipeline_run_log`: pipeline and notebook run lifecycle.
- `data_quality_log`: rule-level metrics and rejected-row counts.
- `schema_change_log`: observed schema versions and approval status.

The SQL DDL will be added after choosing the POC control store (Fabric Warehouse or Lakehouse SQL endpoint). A Lakehouse SQL analytics endpoint is not a general-purpose transactional SQL write target, so write operations must use a supported Fabric engine.
