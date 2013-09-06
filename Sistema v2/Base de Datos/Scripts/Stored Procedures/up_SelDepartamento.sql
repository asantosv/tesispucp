USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelDepartamento]    Script Date: 09/06/2013 13:07:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_SelDepartamento]
AS
BEGIN
	SELECT IdUbigeo, CodDepartamento, CodProvincia, CodDistrito, Descripcion
	FROM Ubigeo 
	WHERE CodProvincia = '00' AND CodDistrito = '00'
	ORDER BY Descripcion
END
