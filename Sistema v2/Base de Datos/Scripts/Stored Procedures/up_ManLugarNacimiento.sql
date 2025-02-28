USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManLugarNacimiento]    Script Date: 09/06/2013 13:04:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManLugarNacimiento]
(
	@IdLugarNacimiento	INT,
	@Pais				VARCHAR(40),
	@Departamento		VARCHAR(40),
	@Provincia			VARCHAR(40),
	@Distrito			VARCHAR(40),
	@Accion				INT,
	@IdGenerado			INT	OUTPUT
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO LugarNacimiento (Pais, Departamento, Provincia, Distrito)
		VALUES (@Pais, @Departamento, @Provincia, @Distrito)
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE LugarNacimiento SET Pais = @Pais, Departamento = @Departamento, 
								   Provincia = @Provincia, Distrito = @Distrito
		WHERE IdLugarNacimiento = @IdLugarNacimiento
								   
		SET @IdGenerado = 0
    END
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  
  COMMIT TRANSACTION
  
  RETURN @IdGenerado
END