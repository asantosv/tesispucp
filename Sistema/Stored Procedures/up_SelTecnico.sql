CREATE PROCEDURE [dbo].[up_SelTecnico] (
@idTecnico			INT,
@nombres			VARCHAR(60),
@ap_paterno			VARCHAR(30),
@ap_materno			VARCHAR(30),
@nomArea			INT,
@estado				VARCHAR(8),
@accion				INT --4: Seleccionar 1, 5: Seleccionar Todos, 6: Seleccionar por Criterios
)
AS
BEGIN
    IF @accion = 4
    BEGIN
		SELECT Tec.Id_Tecnico,P.Paterno,P.Materno,P.Nombres,P.EstadoCivil,P.Sexo,P.FechaNacimiento,TD.Nombre,P.Numero_Documento,A.Nombre,Per.Nombre,P.Telefono,P.Celular,P.Email,Domi.Departamento,Domi.Provincia,Domi.Distrito,Domi.Direccion,LN.Pais,LN.Departamento,LN.Provincia,LN.Distrito,Pl.Estado 
		FROM Persona P, Tecnico Tec, Personal Pl, TipoDocumento TD, Area A, Perfil Per, Domicilio Domi, LugarNacimiento LN
		WHERE Tec.Id_Tecnico = @idTecnico and Tec.Id_Tecnico =Pl.Id_Personal and Pl.Id_Personal=P.Id_Persona and TD.Id_TipoDocumento=P.Id_TipoDocumento and Tec.Id_AreaMedica=A.Id_Area and Pl.Id_Perfil=Per.Id_Perfil and Domi.Id_Domicilio=P.Id_Domicilio and LN.Id_LugarNacimiento=P.Id_LugarNacimiento
	END
    
    IF @accion = 5
    BEGIN
		SELECT Tec.Id_Tecnico,P.Paterno,P.Materno,P.Nombres,A.Nombre,Pl.Estado 
		FROM Persona P, Tecnico Tec, Personal Pl, Area A
		WHERE P.Id_Persona = Pl.Id_Personal and Pl.Id_Personal=Tec.Id_Tecnico and Tec.Id_AreaMedica=A.Id_Area 
	END
    
    IF @accion = 6
    BEGIN
		DECLARE @query VARCHAR(1000)
		SET @query = 'SELECT Tec.Id_Tecnico,P.Paterno,P.Materno,P.Nombres,A.Nombre,Pl.Estado 
					  FROM Persona P, Tecnico Tec, Personal Pl, Area A
					  WHERE P.Id_Persona = Pl.Id_Personal and Pl.Id_Personal=Tec.Id_Tecnico and Tec.Id_AreaMedica=A.Id_Area '
		
		IF @nombres <> ''
		BEGIN
			SET @query = @query + 'AND P.Nombres LIKE ''%' + @nombres + '%'''
		END
		
		IF @ap_paterno <> ''
		BEGIN
			SET @query = @query + 'AND P.Paterno LIKE ''%' + @ap_paterno + '%'''
		END
		
		IF @ap_materno <> ''
		BEGIN
			SET @query = @query + 'AND P.Materno LIKE ''%' + @ap_materno + '%'''
		END		
		
		IF @nomArea <> ''
		BEGIN
			SET @query = @query + 'AND A.Nombre LIKE ''%' + @nomArea + '%'''
		END
		
		IF @estado <> 'TODOS'
		BEGIN
			SET @query = @query + 'AND Pl.Estado = ''' + @estado + ''''
		END
		
		EXEC(@query)
	END	
END