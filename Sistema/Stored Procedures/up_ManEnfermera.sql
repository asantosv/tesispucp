ALTER PROCEDURE [dbo].[up_ManEnfermera] (
@idPersona					INT,
@paterno					VARCHAR(30),
@materno					VARCHAR(30),
@nombres					VARCHAR(60),
@sexo						CHAR(1),
@fechaNacimiento			DATETIME,
@idTipoDocumento			INT,
@numeroDocumento			VARCHAR(20),
@estadoCivil				VARCHAR(10),
--@idLugarNacimiento	INT,
--@idDomicilio		INT,
@paisNacimiento				VARCHAR(40),
@departamentoNacimiento		VARCHAR(40),
@provinciaNacimiento		VARCHAR(40),
@distritoNacimiento			VARCHAR(40),
@departamentoDomicilio		VARCHAR(40),
@provinciaDomicilio			VARCHAR(40),
@distritoDomicilio			VARCHAR(40),
@direccionDomicilio			VARCHAR(200),
@telefono					VARCHAR(8),
@celular					VARCHAR(10),
@email						VARCHAR(60),
@fechaRegistro				DATETIME,
@tipoPersona				VARCHAR(8),
@usuario					VARCHAR(20),
@contrasena					VARCHAR(20),
@tipoPersonal				VARCHAR(14),
@idPerfil					INT,
@estado						VARCHAR(8),
@idAreaMedica				INT,
@numerolicenciatura			VARCHAR(5),
@accion						INT --0: Insertar, 1: Modificar, 2: Eliminar, 3: Recuperar
)
AS

BEGIN
  BEGIN TRANSACTION
	DECLARE @idLugarNacimiento INT, @idDomicilio INT,@idEnfermera INT, @output INT
    IF @accion = 0
    BEGIN
		
		--Insertamos en la Tabla LugarNacimiento
		EXEC @idLugarNacimiento = up_ManLugarNacimiento 0, @paisNacimiento, @departamentoNacimiento,
														@provinciaNacimiento, @distritoNacimiento,
														@accion, @output OUTPUT
		
		--Insertamos en la Tabla Domicilio
		EXEC @idDomicilio = up_ManDomicilio 0, @departamentoDomicilio, @provinciaDomicilio, @distritoDomicilio,
											@direccionDomicilio, @accion, @output OUTPUT
		
		--Insertamos en la Tabla Persona
		EXEC @idEnfermera = up_ManPersona 0, @paterno, @materno, @nombres, @sexo, 
								 @fechaNacimiento, @idTipoDocumento, @numeroDocumento, 
								 @estadoCivil, @idLugarNacimiento, @idDomicilio, 
								 @telefono, @celular, @email, @fechaRegistro, @tipoPersona, 
								 @accion, @output OUTPUT
		
		--Insertamos en la Tabla Personal
		EXEC up_ManPersonal @idEnfermera, @usuario, @contrasena, @tipoPersonal, @idPerfil, @estado, @accion
		
		--Insertamos en la Tabla Enfermera
		INSERT INTO Enfermera (Id_Enfermera, Id_AreaMedica, NumeroLicenciatura)
		VALUES (@idEnfermera, @idAreaMedica, @numerolicenciatura)
	END
    
    IF @accion = 1
    BEGIN
		DECLARE @pidLugarNacimiento INT, @pidDomicilio INT
		
		SET @pidDomicilio= (select Id_Domicilio
							from Persona
							where Id_Persona= @idPersona)	
							
		SET @pidLugarNacimiento= (select Id_LugarNacimiento
								  from Persona
								  where Id_Persona=@idPersona )	
		
		EXEC @idLugarNacimiento = up_ManLugarNacimiento @pidLugarNacimiento, @paisNacimiento, @departamentoNacimiento,
														@provinciaNacimiento, @distritoNacimiento,
														@accion, @output OUTPUT
						
		EXEC @idDomicilio = up_ManDomicilio @pidDomicilio, @departamentoDomicilio, @provinciaDomicilio, @distritoDomicilio,
											@direccionDomicilio, @accion, @output OUTPUT
		
		EXEC @idEnfermera = up_ManPersona @idPersona, @paterno, @materno, @nombres, @sexo, 
								 @fechaNacimiento, @idTipoDocumento, @numeroDocumento, 
								 @estadoCivil, @idLugarNacimiento, @idDomicilio, 
								 @telefono, @celular, @email, @fechaRegistro, @tipoPersona, 
								 @accion, @output OUTPUT
		
		EXEC up_ManPersonal @idPersona, @usuario, @contrasena, @tipoPersonal, @idPerfil, @estado, @accion
		
		UPDATE Enfermera
		SET	  Id_AreaMedica = @idAreaMedica, NumeroLicenciatura = @numerolicenciatura
		WHERE Id_Enfermera = @idPersona
	END
	
	IF @accion = 2
    BEGIN
		EXEC up_ManPersonal @idPersona, @usuario, @contrasena, @tipoPersonal, @idPerfil, @estado, @accion
    END
    
    IF @accion = 3
    BEGIN
		EXEC up_ManPersonal @idPersona, @usuario, @contrasena, @tipoPersonal, @idPerfil, @estado, @accion
    END
    
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  COMMIT TRANSACTION
END