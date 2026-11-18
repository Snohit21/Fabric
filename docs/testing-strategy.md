# Testing Strategy

| Test | Scenario | Expected result |
|---|---|---|
| Initial full load | Empty target, source populated | All eligible source rows land in Bronze |
| Idempotent rerun | Same full-load input processed again | No unintended duplicate business keys |
| Incremental insert | Add source entity with later watermark | New row processed |
| Incremental update | Modify existing entity and modified_at | Latest record available downstream; history preserved where required |
| Equal watermark | Multiple rows share a timestamp | No records skipped; use a tie-breaker strategy if needed |
| Late-arriving update | Older business event updated later | Change captured using modification timestamp |
| Schema addition | Add nullable source column | Change detected and logged; downstream promotion follows approval |
| Type change | Change source column type incompatibly | Change flagged and safely quarantined/blocked |
| Required null | Null mandatory field | Rejected or quarantined per rule |
| Duplicate key | Repeated business key | Duplicate detected and resolved deterministically |
| SCD Type 2 | Change tracked dimension attribute | Old row expired and new current row inserted |
| Failure/restart | Interrupt a load before watermark commit | Rerun safely processes uncommitted data |
| Reconciliation | Compare input and output counts | Counts and rejected/duplicate differences explained |

Tests will be marked passed only after execution evidence is captured in Fabric.
