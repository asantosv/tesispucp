USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManEpisodio]    Script Date: 09/20/2013 16:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManEpisodio]
(
	@IdEpisodio					BIGINT,
	@Ectoscopia					VARCHAR(4000),
	@IdExamenFisico				BIGINT,
	@Temperatura				VARCHAR(4),
	@FrecuenciaCardiaca			VARCHAR(10),
	@FrecuenciaRespiratoria		VARCHAR(10),
	@PresionArterial			VARCHAR(10),
	@Peso						VARCHAR(6),
	@Talla						VARCHAR(5),
	@Otros						VARCHAR(4000),
	@IdEnfermedad				BIGINT,
	@Tiempo						VARCHAR(3),
	@Inicio						VARCHAR(300),
	@Curso						VARCHAR(300),
	@Sintomas					VARCHAR(4000),
	@RelatoCronologico			VARCHAR(4000),
	@IdFuncionesBiologicas		BIGINT,
	@Apetito					VARCHAR(300),
	@Sed						VARCHAR(300),
	@Orina						VARCHAR(300),
	@Deposiciones				VARCHAR(300),
	@IdModoIngreso				INT,
	@IdHistoriaClinica			BIGINT,
	@IdEmpleado					BIGINT,
	@DetalleXML					XML,
	@Accion						INT, --0:INSERT, 1:UPDATE, 4:SELECT
	@IdGenerado					INT OUTPUT
)
AS
BEGIN
  BEGIN TRANSACTION
	IF @Accion = 0
    BEGIN
		
		
		SET @IdGenerado = 0
    END
    
    IF @Accion = 1
    BEGIN
		--ACTUALIZAMOS LA TABLA EXAMEN FISICO
		UPDATE ExamenFisico 
		SET Temperatura = @Temperatura, FrecuenciaCardiaca = @FrecuenciaCardiaca, FrecuenciaRespiratoria = @FrecuenciaRespiratoria,
		    PresionArterial = @PresionArterial, Peso = @Peso, Talla = @Talla, Otros = @Otros
		WHERE IdExamenFisico = @IdExamenFisico
		
		--ACTUALIZAMOS LA TABLA ENFERMEDAD
		UPDATE Enfermedad 
		SET Tiempo = @Tiempo, Inicio = @Inicio, Curso = @Curso, Sintomas = @Sintomas,
		    RelatoCronologico = @RelatoCronologico
		WHERE IdEnfermedad = @IdEnfermedad
		
		--ACTUALIZAMOS LA TABLA FUNCIONESBIOLOGICAS
		UPDATE FuncionesBiologicas 
		SET Apetito = @Apetito, Sed = @Sed, Orina = @Orina, Deposiciones = @Deposiciones
		WHERE IdFuncionesBiologicas = @IdFuncionesBiologicas
		
		--ACTUALIZAMOS EL EPISODIO
		UPDATE Episodio
		SET Ectoscopia = @Ectoscopia, IdExamenFisico = @IdExamenFisico, 
		    IdEnfermedad = @IdEnfermedad, IdFuncionesBiologicas = @IdFuncionesBiologicas,
		    FechaRegistro = GETDATE(), IdEmpleado = @IdEmpleado, 
		    IdHistoriaClinica = @IdHistoriaClinica
		WHERE IdEpisodio = @IdEpisodio
		
		--SI EXISTE MODO DE INGRESO SE ACTUALIZA
		IF @IdModoIngreso <> 0
		BEGIN
			UPDATE Episodio
			SET IdModoIngreso = @IdModoIngreso
			WHERE IdEpisodio = @IdEpisodio
		END
									
		-- ELIMINAMOS E INSERTAMOS EN LA TABLA 'Diagnostico'
		DELETE FROM Diagnostico
		WHERE IdEpisodio = @IdEpisodio
		
		-- RECORREMOS EL ARCHIVO XML E INSERTAMOS EN LA TABLA 'DetalleDisponibilidad'
		DECLARE @IdDiagnostico INT, @IdCie10 INT, @Descripcion VARCHAR(4000)
		DECLARE cur CURSOR FOR 
		(
			SELECT
			  R.x.value('(IdDiagnostico/text())[1]', 'int') AS IdDiagnostico,
			  R.x.value('(IdCie10/text())[1]', 'int') AS IdCie10,
			  R.x.value('(Descripcion/text())[1]', 'varchar(4000)') AS Descripcion
			FROM
			  @DetalleXML.nodes('/ArrayOfClsDetalleDiagnostico[1]') AS P(x)
			  CROSS APPLY
			  P.x.nodes('clsDetalleDiagnostico') AS R(x)
		)  

		OPEN cur
		FETCH NEXT FROM cur INTO @IdDiagnostico, @IdCie10, @Descripcion

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			INSERT INTO Diagnostico (IdCie10, Descripcion, IdEpisodio)
			VALUES (@IdCie10, @Descripcion, @IdEpisodio)
			
			FETCH NEXT FROM cur INTO @IdDiagnostico, @IdCie10, @Descripcion
		END

		CLOSE cur
		DEALLOCATE cur
		
		SET @IdGenerado = 1
    END
    
    IF @Accion = 4
    BEGIN
		SELECT HC.IdPaciente,
			   E.IdEpisodio, 
			   (CASE
					WHEN CONVERT(CHAR(10),E.FechaRegistro, 113) = CONVERT(CHAR(10), GETDATE(), 113) THEN ISNULL(E.Ectoscopia, '')
					ELSE ''
				END) AS 'Ectoscopia', 
			   E.IdExamenFisico, X.Temperatura, X.FrecuenciaCardiaca, X.FrecuenciaRespiratoria, 
			   X.PresionArterial, X.Peso, X.Talla, X.Otros,
			   E.IdEnfermedad, F.Tiempo, F.Inicio, F.Curso, F.Sintomas, F.RelatoCronologico,
			   E.IdFuncionesBiologicas, FB.Apetito, FB.Sed, FB.Orina, FB.Deposiciones,
			   ISNULL(E.IdModoIngreso, 0) AS 'IdModoIngreso', E.IdHistoriaClinica
		FROM HistoriaClinica HC, Episodio E, ExamenFisico X, Enfermedad F, FuncionesBiologicas FB
		WHERE HC.IdHistoriaClinica = E.IdHistoriaClinica AND E.IdExamenFisico = X.IdExamenFisico AND E.IdEnfermedad = F.IdEnfermedad AND
			  E.IdFuncionesBiologicas = FB.IdFuncionesBiologicas AND IdEpisodio = @IdEpisodio

		SELECT D.IdDiagnostico, D.IdCie10, C.Codigo, D.Descripcion
		FROM Diagnostico D, Cie10 C
		WHERE D.IdCie10 = C.IdCie10 AND D.IdEpisodio = @IdEpisodio 
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