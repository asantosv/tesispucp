CREATE PROCEDURE [dbo].[up_SelPais]
AS
BEGIN
    SELECT Id_Pais, Nombre
    FROM Pais
END