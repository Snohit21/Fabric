# Pipeline design

## Parent pipeline (planned)

1. Read active entity configuration ordered by execution sequence.
2. Iterate entities.
3. Pass entity metadata into the Bronze notebook or copy activity.
4. Check notebook/activity result.
5. Write entity-level audit status.
6. Run Silver transformation after Bronze success.
7. Run Gold processing after Silver validation.
8. Finalize run summary.

## Load control

- FULL: read complete source entity and apply the agreed initial/reload strategy.
- INCREMENTAL: read changes beyond the committed watermark.
- Watermark advancement occurs only after successful write and validation.
- Failed activities do not advance the watermark.

## Implementation note

Pipeline JSON exported from Fabric may contain workspace-specific IDs and connection references. Only portable definitions and sanitized examples will be committed; secrets and tenant-specific identifiers must not be committed.
