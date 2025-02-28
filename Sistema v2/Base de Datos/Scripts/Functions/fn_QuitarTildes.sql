USE [CentroSalud]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_QuitarTildes]    Script Date: 09/18/2013 13:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_QuitarTildes]
( 
	@Cadena VARCHAR(1000) 
)
RETURNS VARCHAR(1000)
AS BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cadena, 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u')
END