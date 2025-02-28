USE [CentroSalud]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FieldDelimiter]    Script Date: 09/06/2013 13:12:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_FieldDelimiter]
(
  @FieldDataType VARCHAR(20)
)
RETURNS VARCHAR(4)
AS
BEGIN

DECLARE @FieldDelimiter VARCHAR(4)
   IF @FieldDataType IN ('VARCHAR','CHAR','TEXT')
	SELECT @FieldDelimiter = ''''''''''
   ELSE
	SELECT @FieldDelimiter = ''''''

    RETURN(@FieldDelimiter)	
END
