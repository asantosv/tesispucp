USE [CentroSalud]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ValidarNumeroHistoriaClinica]    Script Date: 09/06/2013 13:12:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_ValidarNumeroHistoriaClinica]
(
  @IdPaciente				INT, 
  @NumeroHistoriaClinica	VARCHAR(10)
)
RETURNS INT
AS
BEGIN
  DECLARE @Contador INT = 0
  
  IF @IdPaciente = 0
  BEGIN
	SELECT @Contador = P.IdPaciente
	FROM Paciente P, HistoriaClinica H
	WHERE H.IdPaciente = P.IdPaciente AND H.Numero = @NumeroHistoriaClinica
  END

  IF @IdPaciente <> 0
  BEGIN
	SELECT @Contador = P.IdPaciente
	FROM Paciente P, HistoriaClinica H
	WHERE H.IdPaciente = P.IdPaciente AND H.Numero = @NumeroHistoriaClinica AND NOT (P.IdPaciente = @IdPaciente)
  END

  RETURN @Contador
END