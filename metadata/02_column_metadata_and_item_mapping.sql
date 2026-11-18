-- Run in WH_Control after metadata/01_create_control_tables.sql.
-- Extend the entity configuration with explicit Fabric item and target schema names.
ALTER TABLE dbo.entity_config ADD
    source_item VARCHAR(128) NULL,
    target_item VARCHAR(128) NULL,
    target_schema VARCHAR(128) NULL;

UPDATE dbo.entity_config
SET source_item = 'LH_Source',
    target_item = 'LH_Analytics',
    target_schema = 'bronze',
    modified_at = SYSUTCDATETIME();

-- Column-level metadata is populated from the actual source schema profiling results.
CREATE TABLE dbo.entity_column_config (
    column_config_id       BIGINT IDENTITY(1,1) NOT NULL,
    entity_name            VARCHAR(128) NOT NULL,
    column_name            VARCHAR(128) NOT NULL,
    source_data_type       VARCHAR(128) NULL,
    target_data_type       VARCHAR(128) NULL,
    ordinal_position       INT NOT NULL,
    is_nullable            BIT NOT NULL,
    is_primary_key         BIT NOT NULL,
    is_watermark_column    BIT NOT NULL,
    is_active              BIT NOT NULL,
    discovered_at          DATETIME2(3) NOT NULL
);

ALTER TABLE dbo.entity_column_config
ADD CONSTRAINT PK_entity_column_config PRIMARY KEY NONCLUSTERED (column_config_id) NOT ENFORCED;

-- Source item/table and target layer mapping for this POC.
-- The actual source column types and nullability will be inserted after profiling.
