USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManAdministrativo]    Script Date: 09/06/2013 13:00:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManAdministrativo]
(
	@IdAdministrativo			BIGINT,
	@Paterno					VARCHAR(30),
	@Materno					VARCHAR(30),
	@Nombres					VARCHAR(30),
	@Sexo						VARCHAR(9),
	@FechaNacimiento			DATETIME,
	@IdTipoDocumento			INT,
	@NumeroDocumento			VARCHAR(50),
	@EstadoCivil				VARCHAR(10),
	@Pais						VARCHAR(40),
	@DepartamentoNacimiento		VARCHAR(40),
	@ProvinciaNacimiento		VARCHAR(40),
	@DistritoNacimiento			VARCHAR(40),
	@DepartamentoDomicilio		VARCHAR(40),
	@ProvinciaDomicilio			VARCHAR(40),
	@DistritoDomicilio			VARCHAR(40),
	@Direccion					VARCHAR(100),
	@Telefono					VARCHAR(12),
	@Celular					VARCHAR(12),
	@CorreoElectronico			VARCHAR(100),
	@TipoPersona				VARCHAR(8),
	@Foto						VARCHAR(2000),
	@Usuario					VARCHAR(20),
	@Contrasena					VARCHAR(20),
	@TipoEmpleado				VARCHAR(14),
	@IdArea						INT,
	@IdPerfil					INT,
	@Estado						VARCHAR(8),
	@Accion						INT, --0:INSERT, 1:UPDATE, 2:DELETE, 3:RECOVER, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
	@IdGenerado					INT OUTPUT
)
AS
BEGIN
  BEGIN TRANSACTION
	IF @Accion = 0
    BEGIN
		DECLARE @IdLugarNacimiento INT, @IdDomicilio INT, @Output INT
		-- INSERTAMOS EN LA TABLA 'LugarNacimiento'
		INSERT INTO LugarNacimiento (Pais, Departamento, Provincia, Distrito)
		VALUES (@Pais, @DepartamentoNacimiento, @ProvinciaNacimiento, @DistritoNacimiento)
		
		SET @IdLugarNacimiento = SCOPE_IDENTITY()
		
		-- INSERTAMOS EN LA TABLA 'Domicilio'
		INSERT INTO Domicilio (Departamento, Provincia, Distrito, Direccion)
		VALUES (@DepartamentoDomicilio, @ProvinciaDomicilio, @DistritoDomicilio, @Direccion)
		
		SET @IdDomicilio = SCOPE_IDENTITY()
		
		-- INSERTAMOS EN LA TABLA 'Persona'
		INSERT INTO Persona (Paterno, Materno, Nombres, Sexo, FechaNacimiento,
							 NumeroDocumento, EstadoCivil, IdLugarNacimiento, IdDomicilio, Telefono,
							 Celular, CorreoElectronico, FechaRegistro, TipoPersona)
		VALUES (@Paterno, @Materno, @Nombres, @Sexo, @FechaNacimiento, @NumeroDocumento,
				@EstadoCivil, @IdLugarNacimiento, @IdDomicilio, @Telefono, @Celular, @CorreoElectronico,
				GETDATE(), @TipoPersona)
		
		SET @IdAdministrativo = SCOPE_IDENTITY()
		
		IF (@IdTipoDocumento <> 0)
		BEGIN
			UPDATE Persona 
			SET IdTipoDocumento = @IdTipoDocumento 
			WHERE IdPersona = @IdAdministrativo
		END
									   
		-- INSERTAMOS EN LA TABLA 'Empleado'
		INSERT INTO Empleado (IdEmpleado, Foto, Usuario, Contrasena, TipoEmpleado, IdArea, IdPerfil, Estado)
		VALUES (@IdAdministrativo, @Foto, @Usuario, @Contrasena, @TipoEmpleado, @IdArea, @IdPerfil,'ACTIVO')
		
		-- INSERTAMOS EN LA TABLA 'Administrativo'
		INSERT INTO Administrativo(IdAdministrativo)
		VALUES (@IdAdministrativo)
		
		SET @IdGenerado = @IdAdministrativo
		
    END
    
    IF @Accion = 1
    BEGIN
		SELECT @IdLugarNacimiento = IdLugarNacimiento, @IdDomicilio = IdDomicilio
		FROM Persona
		WHERE IdPersona = @IdAdministrativo
		
		-- MODIFICAMOS LA TABLA 'LugarNacimiento'
		UPDATE LugarNacimiento SET Pais = @Pais, Departamento = @DepartamentoNacimiento, 
								   Provincia = @ProvinciaNacimiento, Distrito = @DistritoNacimiento
		WHERE IdLugarNacimiento = @IdLugarNacimiento
								   
		-- MODIFICAMOS LA TABLA 'Domicilio'
		UPDATE Domicilio SET Departamento = @DepartamentoDomicilio, Provincia = @ProvinciaDomicilio, 
							Distrito = @DistritoDomicilio, Direccion = @Direccion
		WHERE IdDomicilio = @IdDomicilio
		
		-- MODIFICAMOS LA TABLA 'Persona'
		UPDATE Persona SET Paterno = @Paterno, Materno = @Materno, Nombres = @Nombres, Sexo = @Sexo, 
						   FechaNacimiento = @FechaNacimiento,
						   NumeroDocumento = @NumeroDocumento, EstadoCivil = @EstadoCivil, 
						   IdLugarNacimiento = @IdLugarNacimiento, IdDomicilio = @IdDomicilio, 
						   Telefono = @Telefono, Celular = @Celular, 
						   CorreoElectronico = @CorreoElectronico, TipoPersona = @TipoPersona
		WHERE IdPersona = @IdAdministrativo
		
		IF (@IdTipoDocumento <> 0)
		BEGIN
			UPDATE Persona 
			SET IdTipoDocumento = @IdTipoDocumento 
			WHERE IdPersona = @IdAdministrativo
		END
		
		-- MODIFICAMOS LA TABLA 'Empleado'
		UPDATE Persona SET Paterno = @Paterno, Materno = @Materno, Nombres = @Nombres, Sexo = @Sexo, 
						   FechaNacimiento = @FechaNacimiento,
						   NumeroDocumento = @NumeroDocumento, EstadoCivil = @EstadoCivil, 
						   IdLugarNacimiento = @IdLugarNacimiento, IdDomicilio = @IdDomicilio, 
						   Telefono = @Telefono, Celular = @Celular, 
						   CorreoElectronico = @CorreoElectronico, TipoPersona = @TipoPersona
		WHERE IdPersona = @IdAdministrativo
		
		SET @IdGenerado = 1
		
    END
    
    IF @Accion = 2
    BEGIN
		UPDATE Empleado SET Estado = 'INACTIVO'
		WHERE IdEmpleado = @IdAdministrativo
		
		SET @IdGenerado = 1
    END
    
    IF @Accion = 3
    BEGIN
		UPDATE Empleado SET Estado = 'ACTIVO'
		WHERE IdEmpleado = @IdAdministrativo
		
		SET @IdGenerado = 1
    END
    
    IF @Accion = 4
    BEGIN
		SELECT DISTINCT P.IdPersona, P.Paterno, P.Materno, P.Nombres, P.FechaNacimiento, P.Sexo, P.IdTipoDocumento, TD.Nombre AS TipoDocumento, P.NumeroDocumento, P.EstadoCivil, P.IdLugarNacimiento, 
			   LN.Pais, LN.Departamento, LN.Provincia, LN.Distrito, P.IdDomicilio, DM.Departamento AS DepartamentoDomicilio, DM.Provincia AS ProvinciaDomicilio, 
			   DM.Distrito AS DistritoDomicilio, DM.Direccion, P.Telefono, P.Celular, P.CorreoElectronico, E.Usuario, E.Contrasena, E.IdArea, A.Nombre AS Area, E.Foto, E.IdPerfil, PF.Nombre AS Perfil, 
			   E.Estado
		FROM Persona P, Empleado E, Administrativo AD, LugarNacimiento LN, Domicilio DM, TipoDocumento TD, Area A, Perfil PF
		WHERE P.IdPersona = E.IdEmpleado AND E.IdEmpleado = AD.IdAdministrativo AND E.IdArea = A.IdArea AND P.TipoPersona = 'EMPLEADO' AND E.TipoEmpleado = 'ADMINISTRATIVO' AND 
			  P.IdLugarNacimiento = LN.IdLugarNacimiento AND P.IdDomicilio = DM.IdDomicilio AND P.IdTipoDocumento = TD.IdTipoDocumento AND E.IdPerfil = PF.IdPerfil AND P.IdPersona = @IdAdministrativo
		ORDER BY P.Paterno, P.Materno, P.Nombres
    END
    
    IF @Accion = 5
    BEGIN
		SELECT DISTINCT P.IdPersona, P.Paterno, P.Materno, P.Nombres, P.FechaNacimiento, P.Sexo, P.IdTipoDocumento, TD.Nombre AS TipoDocumento, P.NumeroDocumento, P.EstadoCivil, P.IdLugarNacimiento, 
						LN.Pais, LN.Departamento, LN.Provincia, LN.Distrito, P.IdDomicilio, DM.Departamento AS DepartamentoDomicilio, DM.Provincia AS ProvinciaDomicilio, 
						DM.Distrito AS DistritoDomicilio, DM.Direccion, P.Telefono, P.Celular, P.CorreoElectronico, E.Usuario, E.Contrasena, E.IdArea, A.Nombre AS Area, E.Foto, E.IdPerfil, E.Estado
		FROM Persona P, Empleado E, Administrativo AD, LugarNacimiento LN, Domicilio DM, TipoDocumento TD, Area A
		WHERE P.IdPersona = E.IdEmpleado AND E.IdEmpleado = AD.IdAdministrativo AND E.IdArea = A.IdArea AND P.TipoPersona = 'EMPLEADO' AND E.TipoEmpleado = 'ADMINISTRATIVO' AND
			  P.IdLugarNacimiento = LN.IdLugarNacimiento AND P.IdDomicilio = DM.IdDomicilio AND P.IdTipoDocumento = TD.IdTipoDocumento
		ORDER BY P.Paterno, P.Materno, P.Nombres
    END
    
    IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(2000)
		SET @Query = 'SELECT DISTINCT P.IdPersona, P.Paterno, P.Materno, P.Nombres, P.FechaNacimiento, P.Sexo, P.IdTipoDocumento, TD.Nombre AS TipoDocumento, P.NumeroDocumento, P.EstadoCivil, P.IdLugarNacimiento, 
								   	  LN.Pais, LN.Departamento, LN.Provincia, LN.Distrito, P.IdDomicilio, DM.Departamento AS DepartamentoDomicilio, DM.Provincia AS ProvinciaDomicilio, 
									  DM.Distrito AS DistritoDomicilio, DM.Direccion, P.Telefono, P.Celular, P.CorreoElectronico, E.Usuario, E.Contrasena, E.IdArea, A.Nombre AS Area, E.Foto, E.IdPerfil, E.Estado
					  FROM Persona P, Empleado E, Administrativo AD, LugarNacimiento LN, Domicilio DM, TipoDocumento TD, Area A
					  WHERE P.IdPersona = E.IdEmpleado AND E.IdEmpleado = AD.IdAdministrativo AND E.IdArea = A.IdArea AND P.TipoPersona = ''EMPLEADO'' AND E.TipoEmpleado = ''ADMINISTRATIVO'' AND
						    P.IdLugarNacimiento = LN.IdLugarNacimiento AND P.IdDomicilio = DM.IdDomicilio AND P.IdTipoDocumento = TD.IdTipoDocumento'
						    
		IF @Paterno <> ''
		BEGIN
			SET @Query = @Query + ' AND P.Paterno LIKE ''%' + @Paterno + '%'''
		END
		
		IF @Materno <> ''
		BEGIN
			SET @Query = @Query + ' AND P.Materno LIKE ''%' + @Materno + '%'''
		END
		
		IF @Nombres <> ''
		BEGIN
			SET @Query = @Query + ' AND P.Nombres LIKE ''%' + @Nombres + '%'''
		END
		
		IF @IdArea <> 0
		BEGIN
			SET @Query = @Query + ' AND E.IdArea = ' + CONVERT(VARCHAR(2), @IdArea) + ''
		END
		
		IF @Estado <> 'TODOS'
		BEGIN
			SET @Query = @Query + ' AND E.Estado = ''' + @Estado + ''''
		END	
		
		SET @Query = @Query + ' ORDER BY P.Paterno, P.Materno, P.Nombres'	
						
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