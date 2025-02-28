USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelDatosCuenta]    Script Date: 09/06/2013 13:07:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DECLARE @id INT
EXEC @id = up_ValidarCorreoElectronico 'wilder_young@hotmil.com'
PRINT(@id)
*/
ALTER PROCEDURE [dbo].[up_SelDatosCuenta]
(
	@CorreoElectronico		VARCHAR(100)
)
AS
BEGIN
  DECLARE @IdEmpleado INT = 0;
  
  SELECT @IdEmpleado = E.IdEmpleado 
  FROM Persona P, Empleado E
  WHERE P.IdPersona = E.IdEmpleado AND E.Estado = 'ACTIVO' AND P.CorreoElectronico = @CorreoElectronico
	
  SELECT P.Paterno, P.Materno, P.Nombres, E.Usuario, E.Contrasena
  FROM Persona P, Empleado E
  WHERE P.IdPersona = E.IdEmpleado AND E.IdEmpleado = @IdEmpleado
END