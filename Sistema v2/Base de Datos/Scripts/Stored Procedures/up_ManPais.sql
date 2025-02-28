USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManPais]    Script Date: 09/06/2013 13:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManPais]
(
	@IdPais			INT,
	@Nombre			VARCHAR(50),
	@Descripcion	VARCHAR(300),
	@Estado			VARCHAR(8),
	@Accion			INT,
	@IdGenerado		INT	OUTPUT --0:INSERT, 1:UPDATE, 2:DELETE, 3:RECOVER, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Pais(Nombre, Descripcion, Estado)
		VALUES (@Nombre, @Descripcion, 'ACTIVO')
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE Pais SET Nombre = @Nombre, Descripcion = @Descripcion
		WHERE IdPais = @IdPais
							
		SET @IdGenerado = 1
    END
    IF @Accion = 2
    BEGIN
		UPDATE Pais SET Estado = 'INACTIVO'
		WHERE IdPais = @IdPais
		
		SET @IdGenerado = 1
    END
    IF @Accion = 3
    BEGIN
		UPDATE Pais SET Estado = 'ACTIVO'
		WHERE IdPais = @IdPais
		
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdPais, Nombre, Descripcion, Estado 
		FROM Pais
		WHERE IdPais = @IdPais
		ORDER BY Nombre
	END
    IF @Accion = 5
    BEGIN
		SELECT IdPais, Nombre, Descripcion, Estado 
		FROM Pais
		ORDER BY Nombre
	END
	IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(1000)
		SET @Query = 'SELECT IdPais, Nombre, Descripcion, Estado FROM Pais WHERE IdPais > 0'
		
		IF @Nombre <> ''
		BEGIN
			SET @Query = @Query + ' AND Nombre LIKE ''%' + @Nombre + '%'''
		END
		
		IF @Estado <> 'TODOS'
		BEGIN
			SET @Query = @Query + ' AND Estado = ''' + @Estado + ''''
		END	
		
		SET @Query = @Query + ' ORDER BY Nombre'	
						
		EXEC(@Query)
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