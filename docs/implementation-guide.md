# Implementation Guide

## Prerequisites

- Microsoft Fabric workspace with an assigned capacity or eligible trial
- Permission to create Lakehouses, Warehouses, notebooks, and pipelines
- Git client and access to this repository
- Python 3.10+ for generating local test data (Fabric runtime is managed separately)

## Workspace objects

Create a workspace dedicated to this POC. Create:
1. `LH_Source` — sample source tables.
2. `LH_Analytics` — Bronze, Silver, and Gold data.
3. `WH_Control` (or control tables in a Lakehouse) — metadata and audit state.

The control-store choice will be finalized after confirming the available Fabric items and permissions.

## Build sequence

1. Generate the source data using `data/generate_retail_data.py`.
2. Load the CSV files into `LH_Source`.
3. Create the control tables from the SQL scripts under `metadata/`.
4. Implement a parameterized Bronze notebook and validate full load.
5. Add incremental extraction using the entity watermark.
6. Add schema fingerprinting and schema-change logging.
7. Implement Silver standardization, data quality, and quarantine.
8. Implement Gold dimensions, Type 2 history, and fact table.
9. Orchestrate entities with a metadata-driven Fabric pipeline.
10. Execute the test scenarios and publish measured results.

## Runtime parameter contract

The notebook interface is designed around these parameters:
- `entity_name`
- `source_table`
- `target_table`
- `load_type` (FULL or INCREMENTAL)
- `primary_key`
- `watermark_column`
- `last_watermark`
- `run_id`

Parameter names may be adapted to Fabric pipeline/notebook parameter conventions during implementation.

## Execution and evidence

For each phase, record:
- Fabric item names and configuration
- Input and output record counts
- Watermark before and after processing
- Test scenarios executed and results
- Pipeline run status and failure details
- Any capacity- or tenant-specific limitations

Do not store credentials, access tokens, tenant secrets, or production data in Git.
