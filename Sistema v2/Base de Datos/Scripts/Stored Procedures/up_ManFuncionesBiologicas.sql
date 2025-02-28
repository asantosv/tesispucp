USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManFuncionesBiologicas]    Script Date: 09/06/2013 13:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManFuncionesBiologicas]
(
	@IdFuncionesBiologicas	INT,
	@Apetito				VARCHAR(300),
	@Sed					VARCHAR(300),
	@Orina					VARCHAR(300),
	@Deposiciones			VARCHAR(300),
	@Accion					INT,
	@IdGenerado				INT	OUTPUT --0:INSERT, 1:UPDATE, 4:SELECT, 5:SELECTALL
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO FuncionesBiologicas(Apetito, Sed, Orina, Deposiciones)
		VALUES(@Apetito, @Sed, @Orina, @Deposiciones)
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE FuncionesBiologicas 
		SET Apetito = @Apetito, Sed = @Sed, Orina = @Orina, Deposiciones = @Deposiciones
		WHERE IdFuncionesBiologicas = @IdFuncionesBiologicas
							
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdFuncionesBiologicas, Apetito, Sed, Orina, Deposiciones
		FROM FuncionesBiologicas
		WHERE IdFuncionesBiologicas = @IdFuncionesBiologicas
	END
    IF @Accion = 5
    BEGIN
		SELECT IdFuncionesBiologicas, Apetito, Sed, Orina, Deposiciones
		FROM FuncionesBiologicas
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