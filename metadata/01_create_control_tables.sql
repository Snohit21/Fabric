-- Execute in a Fabric Warehouse (or another supported transactional SQL engine).
-- These tables are control metadata, not business data.

CREATE TABLE dbo.entity_config (
    entity_id            INT IDENTITY(1,1) NOT NULL,
    entity_name          VARCHAR(128) NOT NULL,
    source_schema        VARCHAR(128) NULL,
    source_table         VARCHAR(128) NOT NULL,
    target_layer         VARCHAR(20) NOT NULL,
    target_table         VARCHAR(256) NOT NULL,
    load_type            VARCHAR(20) NOT NULL,
    primary_key_columns  VARCHAR(500) NOT NULL,
    watermark_column     VARCHAR(128) NULL,
    source_path          VARCHAR(1000) NULL,
    target_path          VARCHAR(1000) NULL,
    load_sequence        INT NOT NULL DEFAULT 100,
    is_active            BIT NOT NULL DEFAULT 1,
    created_at           DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    modified_at          DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_entity_config PRIMARY KEY (entity_id),
    CONSTRAINT UQ_entity_config_name UNIQUE (entity_name),
    CONSTRAINT CK_entity_config_layer CHECK (target_layer IN ('BRONZE','SILVER','GOLD')),
    CONSTRAINT CK_entity_config_load CHECK (load_type IN ('FULL','INCREMENTAL'))
);

CREATE TABLE dbo.watermark_control (
    entity_name          VARCHAR(128) NOT NULL,
    last_successful_value VARCHAR(100) NULL,
    last_successful_at   DATETIME2(3) NULL,
    modified_at          DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_watermark_control PRIMARY KEY (entity_name)
);

CREATE TABLE dbo.pipeline_run_log (
    run_log_id           BIGINT IDENTITY(1,1) NOT NULL,
    pipeline_run_id      VARCHAR(100) NOT NULL,
    pipeline_name        VARCHAR(256) NOT NULL,
    entity_name          VARCHAR(128) NULL,
    layer_name           VARCHAR(20) NULL,
    load_type            VARCHAR(20) NULL,
    status               VARCHAR(20) NOT NULL,
    start_time           DATETIME2(3) NOT NULL,
    end_time             DATETIME2(3) NULL,
    source_count         BIGINT NULL,
    target_count         BIGINT NULL,
    inserted_count       BIGINT NULL,
    updated_count        BIGINT NULL,
    rejected_count       BIGINT NULL,
    watermark_before     VARCHAR(100) NULL,
    watermark_after      VARCHAR(100) NULL,
    error_message        VARCHAR(4000) NULL,
    CONSTRAINT PK_pipeline_run_log PRIMARY KEY (run_log_id)
);

CREATE TABLE dbo.data_quality_log (
    quality_log_id       BIGINT IDENTITY(1,1) NOT NULL,
    pipeline_run_id      VARCHAR(100) NOT NULL,
    entity_name          VARCHAR(128) NOT NULL,
    layer_name           VARCHAR(20) NOT NULL,
    rule_name            VARCHAR(256) NOT NULL,
    evaluated_count      BIGINT NOT NULL,
    passed_count         BIGINT NOT NULL,
    failed_count         BIGINT NOT NULL,
    severity             VARCHAR(20) NOT NULL,
    recorded_at          DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_data_quality_log PRIMARY KEY (quality_log_id)
);

CREATE TABLE dbo.schema_change_log (
    schema_change_id     BIGINT IDENTITY(1,1) NOT NULL,
    entity_name          VARCHAR(128) NOT NULL,
    detected_at          DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    previous_schema_hash VARCHAR(128) NULL,
    current_schema_hash VARCHAR(128) NOT NULL,
    change_summary       VARCHAR(2000) NOT NULL,
    approval_status      VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    reviewed_by          VARCHAR(256) NULL,
    reviewed_at          DATETIME2(3) NULL,
    CONSTRAINT PK_schema_change_log PRIMARY KEY (schema_change_id)
);

-- Starter configuration for the four source entities.
INSERT INTO dbo.entity_config
(entity_name, source_schema, source_table, target_layer, target_table,
 load_type, primary_key_columns, watermark_column, load_sequence)
VALUES
('customers', 'dbo', 'customers', 'BRONZE', 'bronze_customers', 'FULL', 'customer_id', 'modified_at', 10),
('products', 'dbo', 'products', 'BRONZE', 'bronze_products', 'FULL', 'product_id', 'modified_at', 20),
('orders', 'dbo', 'orders', 'BRONZE', 'bronze_orders', 'FULL', 'order_id', 'modified_at', 30),
('order_details', 'dbo', 'order_details', 'BRONZE', 'bronze_order_details', 'FULL', 'order_detail_id', 'modified_at', 40);

INSERT INTO dbo.watermark_control (entity_name, last_successful_value)
VALUES ('customers', NULL), ('products', NULL), ('orders', NULL), ('order_details', NULL);
