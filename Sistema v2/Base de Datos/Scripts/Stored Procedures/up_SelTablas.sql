USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelTablas]    Script Date: 09/06/2013 13:08:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_SelTablas]
(
	@Tabla			VARCHAR(100),
	@IndAuditoria	VARCHAR(5),
	@IndInsertar	CHAR(1),
	@IndActualizar	CHAR(1),
	@IndEliminar	CHAR(1),
	@Accion			INT --5:SELECTALL, 6:SELECT CUSTOM
)
AS
BEGIN
  IF @Accion = 5 
  BEGIN
	SELECT IdTablaAuditada, Tabla, IndAuditoria, Insertar, Actualizar, Eliminar
	FROM TablaAuditada
  END
  IF @Accion = 6
  BEGIN
	DECLARE @Query VARCHAR(3000)
	SET @Query = 'SELECT IdTablaAuditada, Tabla, IndAuditoria, Insertar, Actualizar, Eliminar FROM TablaAuditada WHERE IdTablaAuditada > 0'
	
	IF @Tabla <> ''
	BEGIN
		SET @Query = @Query + ' AND Tabla LIKE ''%' + @Tabla + '%'''
	END
	
	IF @IndAuditoria <> 'TODOS'
	BEGIN
		SET @Query = @Query + ' AND IndAuditoria = ''' + @IndAuditoria + ''''
	END
	
	IF @IndInsertar = 'X'
	BEGIN
		SET @Query = @Query + ' AND Insertar = ''X'''
	END
	
	IF @IndActualizar = 'X'
	BEGIN
		SET @Query = @Query + ' AND Actualizar = ''X'''
	END
	
	IF @IndEliminar = 'X'
	BEGIN
		SET @Query = @Query + ' AND Eliminar = ''X'''
	END
	
	SET @Query = @Query + ' ORDER BY Tabla'	
					
	EXEC(@Query)
  END
END
