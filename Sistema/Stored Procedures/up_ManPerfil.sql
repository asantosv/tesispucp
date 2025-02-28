CREATE PROCEDURE [dbo].[up_ManPerfil] (
@idPerfil			INT,
@nombre				VARCHAR(30),
@tipoPersonal		VARCHAR(15),
@estado				VARCHAR(8),
--@xmlVentanas		TEXT,
@accion				INT --0: Insertar, 1: Modificar, 2: Eliminar, 3: Recuperar
)
AS

BEGIN
  BEGIN TRANSACTION
    IF @accion = 0
    BEGIN
		INSERT INTO Perfil (Nombre, TipoPersonal, Estado)
		VALUES (@nombre, @tipoPersonal, 'ACTIVO')
    END
    
    IF @accion = 1
    BEGIN
		UPDATE Perfil
		SET Nombre = @nombre, TipoPersonal = @tipoPersonal
		WHERE Id_Perfil = @idPerfil
		
		delete VentanasxPerfil where Id_Perfil=@idPerfil
		
    END
    
    IF @accion = 2
    BEGIN
		UPDATE Perfil
		SET Estado = 'INACTIVO'
		WHERE Id_Perfil = @idPerfil
    END
    
    IF @accion = 3
    BEGIN
		UPDATE Perfil
		SET Estado = 'ACTIVO'
		WHERE Id_Perfil = @idPerfil
    END
    
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  COMMIT TRANSACTION
END