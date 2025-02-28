USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ValidarCodigoEtnia]    Script Date: 09/06/2013 13:08:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ValidarCodigoEtnia]
(
	@IdEtnia		INT,
	@CodigoEtnia	VARCHAR(5),
	@Contador		INT	OUTPUT
)
AS
BEGIN
  IF @IdEtnia = 0
  BEGIN
	SELECT @Contador = COUNT(IdEtnia)
	FROM Etnia
	WHERE Codigo = @CodigoEtnia
  END

  IF @IdEtnia <> 0
  BEGIN
	SELECT @Contador = COUNT(IdEtnia)
	FROM Etnia
	WHERE Codigo = @CodigoEtnia AND NOT (IdEtnia = @IdEtnia)
  END
  
  RETURN @Contador
END