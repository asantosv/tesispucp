USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ValidarCodigoCPT]    Script Date: 09/06/2013 13:08:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ValidarCodigoCPT]
(
	@IdCPT			INT,
	@CodigoCPT		VARCHAR(5),
	@Contador		INT	OUTPUT
)
AS
BEGIN
  IF @IdCPT = 0
  BEGIN
	SELECT @Contador = COUNT(IdCPT)
	FROM CPT
	WHERE Codigo = @CodigoCPT
  END

  IF @IdCPT <> 0
  BEGIN
	SELECT @Contador = COUNT(IdCPT)
	FROM CPT
	WHERE Codigo = @CodigoCPT AND NOT (IdCPT = @IdCPT)
  END
  
  RETURN @Contador
END