CREATE PROCEDURE [dbo].[up_SelVentanas] (
@idPerfil		INT,
@NomVentana		VARCHAR(40),
@accion			INT 
)
AS
BEGIN
	IF @accion = 0
    BEGIN
		SELECT V.Nombre
		FROM VentanasxPerfil X, Ventana V
		WHERE X.Id_Ventana = V.Id_Ventana AND X.Id_Perfil = @idPerfil
	END
	IF @accion = 1
    BEGIN
		SELECT V.Id_Ventana
		FROM Ventana V
		WHERE V.Nombre = @NomVentana
    END
	
END

		