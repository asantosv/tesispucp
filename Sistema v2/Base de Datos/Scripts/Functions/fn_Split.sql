USE [CentroSalud]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 09/06/2013 13:11:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_Split]
(    
	@Lista VARCHAR(8000), -- Lista de items
	@Delimitador VARCHAR(1) -- Delimitador
) 
RETURNS @ListaFinal TABLE (Item VARCHAR(8000))
BEGIN
	DECLARE @SItem VARCHAR(8000)
	WHILE CHARINDEX(@Delimitador, @Lista, 0) <> 0 
	BEGIN 
		SELECT  
			@SItem = RTRIM(LTRIM(SUBSTRING(@Lista, 1, CHARINDEX(@Delimitador, @Lista, 0) - 1))), 
			@Lista = RTRIM(LTRIM(SUBSTRING(@Lista, CHARINDEX(@Delimitador, @Lista, 0) + LEN(@Delimitador), LEN(@Lista))))  
		IF LEN(@SItem) > 0  
			INSERT INTO @ListaFinal SELECT @SItem 
		END
		
		IF LEN(@Lista) > 0 
			INSERT INTO @ListaFinal SELECT @Lista -- Put the last item in
		
	RETURN
END