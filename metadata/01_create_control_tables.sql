-- Execute this script in a Microsoft Fabric Warehouse.
-- Fabric Warehouse does not support DEFAULT constraints. Supply audit timestamps
-- explicitly in INSERT/UPDATE statements. Key constraints are NOT ENFORCED, so
-- pipeline/data-quality logic must still detect duplicate business identifiers.

CREATE TABLE dbo.entity_config (
    entity_id             BIGINT IDENTITY NOT NULL,
    entity_name           VARCHAR(128) NOT NULL,
    source_schema         VARCHAR(128) NULL,
    source_table          VARCHAR(128) NOT NULL,
    target_layer          VARCHAR(20) NOT NULL,
    target_table          VARCHAR(256) NOT NULL,
    load_type             VARCHAR(20) NOT NULL,
    primary_key_columns   VARCHAR(500) NOT NULL,
    watermark_column      VARCHAR(128) NULL,
    source_path           VARCHAR(1000) NULL,
    target_path           VARCHAR(1000) NULL,
    load_sequence         INT NOT NULL,
    is_active             BIT NOT NULL,
    created_at            DATETIME2(3) NOT NULL,
    modified_at           DATETIME2(3) NOT NULL
);

ALTER TABLE dbo.entity_config
ADD CONSTRAINT PK_entity_config PRIMARY KEY NONCLUSTERED (entity_id) NOT ENFORCED;

ALTER TABLE dbo.entity_config
ADD CONSTRAINT UQ_entity_config_name UNIQUE NONCLUSTERED (entity_name) NOT ENFORCED;

CREATE TABLE dbo.watermark_control (
    entity_name            VARCHAR(128) NOT NULL,
    last_successful_value  VARCHAR(100) NULL,
    last_successful_at     DATETIME2(3) NULL,
    modified_at            DATETIME2(3) NOT NULL
);

ALTER TABLE dbo.watermark_control
ADD CONSTRAINT PK_watermark_control PRIMARY KEY NONCLUSTERED (entity_name) NOT ENFORCED;

CREATE TABLE dbo.pipeline_run_log (
    run_log_id             BIGINT IDENTITY NOT NULL,
    pipeline_run_id        VARCHAR(100) NOT NULL,
    pipeline_name          VARCHAR(256) NOT NULL,
    entity_name            VARCHAR(128) NULL,
    layer_name             VARCHAR(20) NULL,
    load_type              VARCHAR(20) NULL,
    status                 VARCHAR(20) NOT NULL,
    start_time             DATETIME2(3) NOT NULL,
    end_time               DATETIME2(3) NULL,
    source_count           BIGINT NULL,
    target_count           BIGINT NULL,
    inserted_count         BIGINT NULL,
    updated_count          BIGINT NULL,
    rejected_count         BIGINT NULL,
    watermark_before       VARCHAR(100) NULL,
    watermark_after        VARCHAR(100) NULL,
    error_message          VARCHAR(4000) NULL
);

ALTER TABLE dbo.pipeline_run_log
ADD CONSTRAINT PK_pipeline_run_log PRIMARY KEY NONCLUSTERED (run_log_id) NOT ENFORCED;

CREATE TABLE dbo.data_quality_log (
    quality_log_id         BIGINT IDENTITY NOT NULL,
    pipeline_run_id        VARCHAR(100) NOT NULL,
    entity_name            VARCHAR(128) NOT NULL,
    layer_name             VARCHAR(20) NOT NULL,
    rule_name              VARCHAR(256) NOT NULL,
    evaluated_count        BIGINT NOT NULL,
    passed_count           BIGINT NOT NULL,
    failed_count           BIGINT NOT NULL,
    severity               VARCHAR(20) NOT NULL,
    recorded_at            DATETIME2(3) NOT NULL
);

ALTER TABLE dbo.data_quality_log
ADD CONSTRAINT PK_data_quality_log PRIMARY KEY NONCLUSTERED (quality_log_id) NOT ENFORCED;

CREATE TABLE dbo.schema_change_log (
    schema_change_id       BIGINT IDENTITY NOT NULL,
    entity_name            VARCHAR(128) NOT NULL,
    detected_at            DATETIME2(3) NOT NULL,
    previous_schema_hash   VARCHAR(128) NULL,
    current_schema_hash    VARCHAR(128) NOT NULL,
    change_summary         VARCHAR(2000) NOT NULL,
    approval_status        VARCHAR(20) NOT NULL,
    reviewed_by            VARCHAR(256) NULL,
    reviewed_at            DATETIME2(3) NULL
);

ALTER TABLE dbo.schema_change_log
ADD CONSTRAINT PK_schema_change_log PRIMARY KEY NONCLUSTERED (schema_change_id) NOT ENFORCED;

-- Initial metadata configuration. The first run is a full load.
INSERT INTO dbo.entity_config
(entity_name, source_schema, source_table, target_layer, target_table,
 load_type, primary_key_columns, watermark_column, load_sequence,
 is_active, created_at, modified_at)
VALUES
('customers', 'dbo', 'customers', 'BRONZE', 'bronze_customers', 'FULL', 'customer_id', 'modified_at', 10, 1, SYSUTCDATETIME(), SYSUTCDATETIME()),
('products', 'dbo', 'products', 'BRONZE', 'bronze_products', 'FULL', 'product_id', 'modified_at', 20, 1, SYSUTCDATETIME(), SYSUTCDATETIME()),
('orders', 'dbo', 'orders', 'BRONZE', 'bronze_orders', 'FULL', 'order_id', 'modified_at', 30, 1, SYSUTCDATETIME(), SYSUTCDATETIME()),
('order_details', 'dbo', 'order_details', 'BRONZE', 'bronze_order_details', 'FULL', 'order_detail_id', 'modified_at', 40, 1, SYSUTCDATETIME(), SYSUTCDATETIME());

INSERT INTO dbo.watermark_control
(entity_name, last_successful_value, last_successful_at, modified_at)
VALUES
('customers', NULL, NULL, SYSUTCDATETIME()),
('products', NULL, NULL, SYSUTCDATETIME()),
('orders', NULL, NULL, SYSUTCDATETIME()),
('order_details', NULL, NULL, SYSUTCDATETIME());
