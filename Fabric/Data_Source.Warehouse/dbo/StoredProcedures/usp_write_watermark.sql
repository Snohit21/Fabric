CREATE PROCEDURE usp_write_watermark @LastModifiedDate datetime, @TableName VARCHAR(50)
AS

BEGIN

UPDATE watermarktable
SET WatermarkValue = @LastModifiedDate
WHERE TableName = @TableName

END

GO