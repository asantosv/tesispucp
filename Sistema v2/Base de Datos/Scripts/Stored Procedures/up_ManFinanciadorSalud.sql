USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManFinanciadorSalud]    Script Date: 09/06/2013 13:03:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManFinanciadorSalud]
(
	@IdFinanciadorSalud		INT,
	@Codigo					VARCHAR(2),
	@Nombre					VARCHAR(100),
	@Descripcion			VARCHAR(300),
	@Estado					VARCHAR(8),
	@Accion					INT,
	@IdGenerado				INT	OUTPUT --0:INSERT, 1:UPDATE, 2:DELETE, 3:RECOVER, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO FinanciadorSalud(Codigo, Nombre, Descripcion, Estado)
		VALUES (@Codigo, @Nombre, @Descripcion, 'ACTIVO')
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE FinanciadorSalud SET Codigo = @Codigo, Nombre = @Nombre, Descripcion = @Descripcion
		WHERE IdFinanciadorSalud = @IdFinanciadorSalud
							
		SET @IdGenerado = 1
    END
    IF @Accion = 2
    BEGIN
		UPDATE FinanciadorSalud SET Estado = 'INACTIVO'
		WHERE IdFinanciadorSalud = @IdFinanciadorSalud
		
		SET @IdGenerado = 1
    END
    IF @Accion = 3
    BEGIN
		UPDATE FinanciadorSalud SET Estado = 'ACTIVO'
		WHERE IdFinanciadorSalud = @IdFinanciadorSalud
		
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdFinanciadorSalud, Codigo, Nombre, Descripcion, Estado 
		FROM FinanciadorSalud
		WHERE IdFinanciadorSalud = @IdFinanciadorSalud
		ORDER BY Codigo, Nombre
	END
    IF @Accion = 5
    BEGIN
		SELECT IdFinanciadorSalud, Codigo, Nombre, Descripcion, Estado 
		FROM FinanciadorSalud
		ORDER BY Codigo, Nombre
	END
	IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(1000)
		SET @Query = 'SELECT IdFinanciadorSalud, Codigo, Nombre, Descripcion, Estado FROM FinanciadorSalud WHERE IdFinanciadorSalud > 0'
		
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
		
		SET @Query = @Query + ' ORDER BY Codigo, Nombre'	
						
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