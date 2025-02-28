USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManTriaje]    Script Date: 09/19/2013 00:41:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManTriaje]
(
	@IdEmpleado					INT,
	@IdPaciente					INT,
	@IdHistoriaClinica			INT,
	@GrupoSanguineo				VARCHAR(2),
	@FactorSanguineo			VARCHAR(3),
	@IdModoIngreso				INT,
	@Temperatura				VARCHAR(4),
	@FrecuenciaCardiaca			VARCHAR(10),
	@FrecuenciaRespiratoria		VARCHAR(10),
	@PresionArterial			VARCHAR(10),
	@Peso						VARCHAR(6),
	@Talla						VARCHAR(5),
	@Observaciones				VARCHAR(1000),
	@IdExamenFisico				INT,
	@IdEpisodio					INT,
	@Accion						INT,
	@IdGenerado					INT	OUTPUT --0:INSERT, 1:UPDATE, 4:SELECT
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		DECLARE @IdExamen INT, @IdEnfermedad INT, @IdFuncionesBiologicas INT, @Output INT
		
		--INSERTAMOS EL GRUPO Y FACTOR SANGUINEO
		UPDATE Paciente SET GrupoSanguineo = @GrupoSanguineo, FactorSanguineo = @FactorSanguineo
		WHERE IdPaciente = @IdPaciente
		
		--INSERTAMOS LOS DATOS DEL TRIAJE EN LA TABLA 'ExamenFisico'
		INSERT INTO ExamenFisico(Temperatura, FrecuenciaCardiaca, FrecuenciaRespiratoria, PresionArterial, Peso, Talla, Otros)
		VALUES(@Temperatura, @FrecuenciaCardiaca, @FrecuenciaRespiratoria, @PresionArterial, @Peso, @Talla, @Observaciones)
		
		SET @IdExamen = SCOPE_IDENTITY()
		
		--CREAMOS LA TABLA 'Enfermedad'
		INSERT INTO Enfermedad(Tiempo, Inicio, Curso, Sintomas, RelatoCronologico)
		VALUES('', '', '', '', '')
		
		SET @IdEnfermedad = SCOPE_IDENTITY()
		
		--CREAMOS LA TABLA 'FuncionesBiologicas'
		INSERT INTO FuncionesBiologicas(Apetito, Sed, Orina, Deposiciones)
		VALUES('', '', '', '')
		
		SET @IdFuncionesBiologicas = SCOPE_IDENTITY()
		
		--CREAMOS LA TABLA 'Episodio'
		IF @IdModoIngreso <> 0
		BEGIN
			INSERT INTO Episodio (IdExamenFisico, IdEnfermedad, IdFuncionesBiologicas, FechaRegistro, IdEmpleado, IdModoIngreso, IdHistoriaClinica)
			VALUES (@IdExamen, @IdEnfermedad, @IdFuncionesBiologicas, GETDATE(), @IdEmpleado, @IdModoIngreso, @IdHistoriaClinica)
			
			SET @IdEpisodio = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			INSERT INTO Episodio (IdExamenFisico, IdEnfermedad, IdFuncionesBiologicas, FechaRegistro, IdEmpleado, IdHistoriaClinica)
			VALUES (@IdExamen, @IdEnfermedad, @IdFuncionesBiologicas, GETDATE(), @IdEmpleado, @IdHistoriaClinica)
			
			SET @IdEpisodio = SCOPE_IDENTITY()
		END
		
		SET @IdGenerado = @IdEpisodio
    END
    IF @Accion = 1
    BEGIN
		--ACTUALIZAMOS LA TABLA 'Paciente'
		UPDATE Paciente SET GrupoSanguineo = @GrupoSanguineo, FactorSanguineo = @FactorSanguineo
		WHERE IdPaciente = @IdPaciente
		
		--ACTUALIZAMOS LA TABLA 'ExamenFisico'
		UPDATE ExamenFisico 
		SET Temperatura = @Temperatura, FrecuenciaCardiaca = @FrecuenciaCardiaca, FrecuenciaRespiratoria = @FrecuenciaRespiratoria,
		    PresionArterial = @PresionArterial, Peso = @Peso, Talla = @Talla, Otros = @Observaciones
		WHERE IdExamenFisico = @IdExamenFisico
		
		--ACTUALIZAMOS LA TABLA 'Episodio'
		IF @IdModoIngreso <> 0
		BEGIN
			UPDATE Episodio SET IdModoIngreso = @IdModoIngreso
			WHERE IdEpisodio = @IdEpisodio
		END
		
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT EP.IdEmpleado, H.IdPaciente, H.IdHistoriaClinica, P.GrupoSanguineo, P.FactorSanguineo, EP.IdModoIngreso, 
			   E.Temperatura, E.FrecuenciaCardiaca, E.FrecuenciaRespiratoria, E.PresionArterial, E.Peso, E.Talla, 
			   E.Otros AS Observaciones, E.IdExamenFisico, EP.IdEpisodio
		FROM Paciente P, HistoriaClinica H, ExamenFisico E, Episodio EP
		WHERE P.IdPaciente = H.IdPaciente AND P.IdPaciente = @IdPaciente AND EP.IdHistoriaClinica = H.IdHistoriaClinica AND
			  H.IdHistoriaClinica = @IdHistoriaClinica AND EP.IdEmpleado = @IdEmpleado AND EP.IdExamenFisico = E.IdExamenFisico AND
			  YEAR(EP.FechaRegistro) = YEAR(GETDATE()) AND
		      MONTH(EP.FechaRegistro) = MONTH(GETDATE()) AND
		      DAY(EP.FechaRegistro) = DAY(GETDATE())
		ORDER BY EP.FechaRegistro DESC
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