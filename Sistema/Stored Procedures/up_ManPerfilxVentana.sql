CREATE PROCEDURE [dbo].[up_ManPerfilxVentana] (
@idPerfil			INT,
@idVentana			INT,
@accion				INT --0: Insertar, 1: Modificar
)
AS

BEGIN
  BEGIN TRANSACTION
    
	IF @accion = 0
    BEGIN
		
		DECLARE @id INT
		
		SET @id=(select max(Id_Perfil) from Perfil )
		INSERT INTO VentanasxPerfil (Id_Ventana, Id_Perfil)
		VALUES (@idVentana,@id)    	
		
    END
    
    IF @accion = 1
    BEGIN
		INSERT INTO VentanasxPerfil (Id_Ventana, Id_Perfil)
		VALUES (@idVentana,@idPerfil)    	
    END	
    
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  COMMIT TRANSACTION
END