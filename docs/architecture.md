# Architecture

## Logical components

- **Source Lakehouse:** holds the source tables used for the POC.
- **Metadata store:** defines active entities, source/target names, keys, load strategy, incremental column, and current watermark.
- **Bronze:** preserves ingested source records with ingestion metadata.
- **Silver:** applies type normalization, deduplication, required-field checks, and conformance rules.
- **Gold:** publishes facts and dimensions for analytics; applicable dimensions use Type 2 history.
- **Orchestration:** Fabric Data Pipelines invoke parameterized notebook activities and record execution outcomes.

## Initial entities

| Entity | Business key | Incremental field | Load |
|---|---|---|---|
| customers | customer_id | modified_at | Full then incremental |
| products | product_id | modified_at | Full then incremental |
| orders | order_id | modified_at | Full then incremental |
| order_details | order_detail_id | modified_at | Full then incremental |

These are POC design choices. The final keys and change-tracking fields will be verified against the generated source schema before implementation.

## Key design decisions

1. Keep source ingestion separate from business transformation.
2. Advance watermarks only after the corresponding load and validation succeed.
3. Make incremental processing replay-safe through deterministic keys and merge/upsert logic.
4. Record run-level and entity-level audit information.
5. Treat schema changes as observable events; only approved compatible changes move downstream.
6. Keep rejected records available for investigation rather than silently discarding them.

## Physical layout

The initial POC uses separate Lakehouse schemas or clearly separated layer tables for Bronze, Silver, and Gold. The final choice will follow the workspace capacity and Git/deployment capabilities available in the tenant.
