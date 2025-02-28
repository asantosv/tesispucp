USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelDistrito]    Script Date: 09/06/2013 13:07:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_SelDistrito]
(
	@CodDepartamento      CHAR(2),
	@CodProvincia         CHAR(2)
)
AS
BEGIN	
	SELECT IdUbigeo, CodDepartamento, CodProvincia, CodDistrito, Descripcion
	FROM Ubigeo 
	WHERE CodDepartamento = @CodDepartamento AND CodProvincia = @CodProvincia AND CodDistrito <> '00'
END
