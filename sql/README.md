# SQL assets

This folder will contain portable SQL for control tables, dimensional objects, reconciliation queries, and validation checks.

Write operations against control metadata must use a supported transactional Fabric engine (for example, a Fabric Warehouse or Spark-managed Delta table). The Lakehouse SQL analytics endpoint is primarily for querying and should not be treated as a general-purpose SQL write endpoint.
