USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManEtnia]    Script Date: 09/06/2013 13:03:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManEtnia]
(
	@IdEtnia		INT,
	@Codigo			VARCHAR(3),
	@Nombre			VARCHAR(50),
	@Descripcion	VARCHAR(500),
	@Estado			VARCHAR(8),
	@Accion			INT,
	@IdGenerado		INT	OUTPUT --0:INSERT, 1:UPDATE, 2:DELETE, 3:RECOVER, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Etnia(Codigo, Nombre, Descripcion, Estado)
		VALUES (@Codigo, @Nombre, @Descripcion, 'ACTIVO')
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE Etnia SET Codigo = @Codigo, Nombre = @Nombre, Descripcion = @Descripcion
		WHERE IdEtnia = @IdEtnia
							
		SET @IdGenerado = 1
    END
    IF @Accion = 2
    BEGIN
		UPDATE Etnia SET Estado = 'INACTIVO'
		WHERE IdEtnia = @IdEtnia
		
		SET @IdGenerado = 1
    END
    IF @Accion = 3
    BEGIN
		UPDATE Etnia SET Estado = 'ACTIVO'
		WHERE IdEtnia = @IdEtnia
		
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdEtnia, Codigo, Nombre, Descripcion, Estado 
		FROM Etnia
		WHERE IdEtnia = @IdEtnia
		ORDER BY Nombre
	END
    IF @Accion = 5
    BEGIN
		SELECT IdEtnia, Codigo, Nombre, Descripcion, Estado 
		FROM Etnia
		ORDER BY Nombre
	END
	IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(1000)
		SET @Query = 'SELECT IdEtnia, Codigo, Nombre, Descripcion, Estado FROM Etnia WHERE IdEtnia > 0'
		
		IF @Codigo <> ''
		BEGIN
			SET @Query = @Query + ' AND Codigo = ''' + @Codigo + ''''
		END
		
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