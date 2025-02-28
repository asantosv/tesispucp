CREATE PROCEDURE [dbo].[up_SelEnfermera] (
@idEnfermera		INT,
@nombres			VARCHAR(60),
@ap_paterno			VARCHAR(30),
@ap_materno			VARCHAR(30),
@numlicenciatura	VARCHAR(10),
@nomArea			INT,
@estado				VARCHAR(8),
@accion				INT --4: Seleccionar 1, 5: Seleccionar Todos, 6: Seleccionar por Criterios
)
AS
BEGIN
    IF @accion = 4
    BEGIN
		SELECT Enf.Id_Enfermera,P.Paterno,P.Materno,P.Nombres,Enf.NumeroLicenciatura,P.EstadoCivil,P.Sexo,P.FechaNacimiento,TD.Nombre,P.Numero_Documento,A.Nombre,Per.Nombre,P.Telefono,P.Celular,P.Email,Domi.Departamento,Domi.Provincia,Domi.Distrito,Domi.Direccion,LN.Pais,LN.Departamento,LN.Provincia,LN.Distrito,Pl.Estado 
		FROM Persona P, Enfermera Enf, Personal Pl, TipoDocumento TD, Area A, Perfil Per, Domicilio Domi, LugarNacimiento LN
		WHERE Enf.Id_Enfermera = @idEnfermera and Enf.Id_Enfermera =Pl.Id_Personal and Pl.Id_Personal=P.Id_Persona and TD.Id_TipoDocumento=P.Id_TipoDocumento and Enf.Id_AreaMedica=A.Id_Area and Pl.Id_Perfil=Per.Id_Perfil and Domi.Id_Domicilio=P.Id_Domicilio and LN.Id_LugarNacimiento=P.Id_LugarNacimiento
	END
    
    IF @accion = 5
    BEGIN
		SELECT Enf.Id_Enfermera,P.Paterno,P.Materno,P.Nombres,Enf.NumeroLicenciatura,A.Nombre,Pl.Estado 
		FROM Persona P, Enfermera Enf, Personal Pl, Area A
		WHERE P.Id_Persona = Pl.Id_Personal and Pl.Id_Personal=Enf.Id_Enfermera and Enf.Id_AreaMedica=A.Id_Area 
	END
    
    IF @accion = 6
    BEGIN
		DECLARE @query VARCHAR(1000)
		SET @query = 'SELECT Enf.Id_Enfermera,P.Paterno,P.Materno,P.Nombres,Enf.NumeroLicenciatura,A.Nombre,Pl.Estado 
					  FROM Persona P, Enfermera Enf, Personal Pl, Area A
					  WHERE P.Id_Persona = Pl.Id_Personal and Pl.Id_Personal=Enf.Id_Enfermera and Enf.Id_AreaMedica=A.Id_Area '
		
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
		
		IF @numlicenciatura <> ''
		BEGIN
			SET @query = @query + 'AND Enf.NumeroLicenciatura LIKE ''%' + @numlicenciatura + '%'''
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