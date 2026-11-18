# Metadata-Driven Medallion Architecture on Microsoft Fabric

An end-to-end Microsoft Fabric Data Engineering project demonstrating metadata-driven ingestion and a Bronze, Silver, and Gold Lakehouse architecture.

**Project status:** Initial scaffold. Features are marked complete only after implementation and validation in Microsoft Fabric.

## Objectives

- Metadata-controlled ingestion of multiple source tables
- Full and incremental load patterns with watermark management
- Bronze raw landing and schema-change observability
- Silver cleansing, standardization, deduplication, and data-quality checks
- Gold dimensional modeling with SCD Type 2
- Source-to-target reconciliation, audit logging, and restartability
- Fabric Data Pipelines orchestrating PySpark notebooks and SQL

## Architecture

```text
Retail source data
      |
      v
Source Lakehouse
      |
      v
Metadata-driven orchestration <---- Configuration / watermark / audit tables
      |
      v
Bronze: raw Delta tables
      |
      v
Silver: validated and conformed Delta tables
      |
      v
Gold: dimensions + facts (star schema)
      |
      v
Semantic model / reporting
```

## Technology

Microsoft Fabric Lakehouse, Fabric Data Pipelines, PySpark, Delta Lake, SQL, and Git integration.

## Repository layout

| Folder | Purpose |
|---|---|
| `data/` | Reproducible synthetic source and test data |
| `metadata/` | Configuration, watermark, and audit SQL |
| `notebooks/` | Notebook source code for Bronze/Silver/Gold |
| `pipelines/` | Orchestration design and parameter contracts |
| `sql/` | DDL, reconciliation, and dimensional SQL |
| `docs/` | Architecture, setup, data dictionary, runbook |
| `tests/` | Test cases and expected outcomes |

## Dataset

This project uses a generated retail dataset (customers, products, orders, and order details). It is synthetic and contains no personal or production data. The generator and scenario files will be added under `data/`.

## Implementation roadmap

1. Workspace and Lakehouse setup
2. Source data generation and ingestion
3. Metadata and audit framework
4. Bronze full/incremental ingestion
5. Schema drift detection and approval process
6. Silver quality and standardization
7. Gold SCD Type 2 and dimensional model
8. Orchestration, failure recovery, and reconciliation
9. End-to-end testing and runbook

## Getting started

See [docs/implementation-guide.md](docs/implementation-guide.md) for the planned Fabric setup and execution sequence. The project will include executable artifacts as each phase is implemented and tested.

## Validation policy

A design or code sample is not considered production-ready merely because it exists in this repository. Test results, screenshots, configuration exports, and known limitations will be documented as the implementation progresses.

## License

MIT License. See [LICENSE](LICENSE).
