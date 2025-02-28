USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManEnfermedad]    Script Date: 09/06/2013 13:02:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManEnfermedad]
(
	@IdEnfermedad			INT,
	@Tiempo					VARCHAR(3),
	@Inicio					VARCHAR(300),
	@Curso					VARCHAR(300),
	@Sintomas				VARCHAR(1000),
	@RelatoCronologico		VARCHAR(1000),
	@Accion					INT,
	@IdGenerado				INT	OUTPUT --0:INSERT, 1:UPDATE, 4:SELECT, 5:SELECTALL
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Enfermedad(Tiempo, Inicio, Curso, Sintomas, RelatoCronologico)
		VALUES(@Tiempo, @Inicio, @Curso, @Sintomas, @RelatoCronologico)
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE Enfermedad 
		SET Tiempo = @Tiempo, Inicio = @Inicio, Curso = @Curso, Sintomas = @Sintomas,
		    RelatoCronologico = @RelatoCronologico
		WHERE IdEnfermedad = @IdEnfermedad
							
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdEnfermedad, Tiempo, Inicio, Curso, Sintomas, RelatoCronologico
		FROM Enfermedad
		WHERE IdEnfermedad = @IdEnfermedad
	END
    IF @Accion = 5
    BEGIN
		SELECT IdEnfermedad, Tiempo, Inicio, Curso, Sintomas, RelatoCronologico
		FROM Enfermedad
	END
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
    
    SET @IdGenerado = 0
	
	RETURN @IdGenerado
  END
  
  COMMIT TRANSACTION
  
  RETURN @IdGenerado
END