USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManExamenFisico]    Script Date: 09/06/2013 13:03:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManExamenFisico]
(
	@IdExamenFisico				INT,
	@Temperatura				VARCHAR(4),
	@FrecuenciaCardiaca			VARCHAR(10),
	@FrecuenciaRespiratoria		VARCHAR(10),
	@PresionArterial			VARCHAR(10),
	@Peso						VARCHAR(6),
	@Talla						VARCHAR(5),
	@Otros						VARCHAR(1000),
	@Accion						INT,
	@IdGenerado					INT	OUTPUT --0:INSERT, 1:UPDATE, 4:SELECT, 5:SELECTALL
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO ExamenFisico(Temperatura, FrecuenciaCardiaca, FrecuenciaRespiratoria, PresionArterial, Peso, Talla, Otros)
		VALUES(@Temperatura, @FrecuenciaCardiaca, @FrecuenciaRespiratoria, @PresionArterial, @Peso, @Talla, @Otros)
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE ExamenFisico 
		SET Temperatura = @Temperatura, FrecuenciaCardiaca = @FrecuenciaCardiaca, FrecuenciaRespiratoria = @FrecuenciaRespiratoria,
		    PresionArterial = @PresionArterial, Peso = @Peso, Talla = @Talla, Otros = @Otros
		WHERE IdExamenFisico = @IdExamenFisico
							
		SET @IdGenerado = 1
    END
    
    IF @Accion = 4
    BEGIN
		SELECT IdExamenFisico, Temperatura, FrecuenciaCardiaca, FrecuenciaRespiratoria, PresionArterial, Peso, Talla, Otros
		FROM ExamenFisico
		WHERE IdExamenFisico = @IdExamenFisico
	END
	
    IF @Accion = 5
    BEGIN
		SELECT IdExamenFisico, Temperatura, FrecuenciaCardiaca, FrecuenciaRespiratoria, PresionArterial, Peso, Talla, Otros
		FROM ExamenFisico
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