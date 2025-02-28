USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManHistoriaClinica]    Script Date: 09/06/2013 13:04:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManHistoriaClinica]
(
	@IdHistoriaClinica			BIGINT,
	@IdEpisodio					BIGINT,
	--PACIENTE:
	@IdPaciente					BIGINT,
	@Paterno					VARCHAR(30),
	@Materno					VARCHAR(30),
	@Nombres					VARCHAR(30),
	@IdModoIngreso				INT,
	@Sexo						VARCHAR(9),
	@IdEtnia					INT,
	@IdReligion					INT,
	@IdOcupacion				INT,
	@IdIdioma					INT,
	@EstadoCivil				VARCHAR(10),
	@FechaNacimiento			DATETIME,
	@GrupoSanguineo				VARCHAR(2),
	@FactorSanguineo			VARCHAR(3),
	@Pais						VARCHAR(40),
	@DepartamentoNacimiento		VARCHAR(40),
	@ProvinciaNacimiento		VARCHAR(40),
	@DistritoNacimiento			VARCHAR(40),
	@DepartamentoDomicilio		VARCHAR(40),
	@ProvinciaDomicilio			VARCHAR(40),
	@DistritoDomicilio			VARCHAR(40),
	@Direccion					VARCHAR(100),
	--EXAMEN FISICO:
	@IdExamenFisico				BIGINT,
	@Temperatura				VARCHAR(4),
	@FrecuenciaCardiaca			VARCHAR(10),
	@FrecuenciaRespiratoria		VARCHAR(10),
	@PresionArterial			VARCHAR(10),
	@Peso						VARCHAR(6),
	@Talla						VARCHAR(5),
	@OtrosExamenes				VARCHAR(4000),
	--FUNCIONES BIOLOGICAS:
	@IdFuncionesBiologicas		BIGINT,
	@Apetito					VARCHAR(300),
	@Sed						VARCHAR(300),
	@Orina						VARCHAR(300),
	@Deposiciones				VARCHAR(300),
	--ENFERMEDAD:
	@IdEnfermedad				BIGINT,
	@Tiempo						VARCHAR(3),
	@Inicio						VARCHAR(300),
	@Curso						VARCHAR(300),
	@Sintomas					VARCHAR(4000),
	@RelatoCronologico			VARCHAR(4000),
	--DIAGNOSTICOSXEPISODIO:
	@ListaIdDiagnosticos		VARCHAR(1000),
	--ANTECEDENTES:
	@IdAntecedentes						INT,
	@IndTabaco							CHAR(1),
	@IndAlcohol							CHAR(1),
	@IndCafe							CHAR(1),
	@IndTe								CHAR(1),
	@IndDrogas							CHAR(1),
	@IndDiabetes						CHAR(1),
	@DescDiabetes						VARCHAR(300),
	@IndHipertension					CHAR(1),
	@DescHipertension					VARCHAR(300),
	@IndCoronariopatia					CHAR(1),
	@DescCoronariopatia					VARCHAR(300),
	@IndDislipidemia					CHAR(1),
	@DescDislipidemia					VARCHAR(300),
	@IndAsma							CHAR(1),
	@DescAsma							VARCHAR(300),
	@IndPsicopatia						CHAR(1),
	@DescPsicopatia						VARCHAR(300),
	@IndAlergias						CHAR(1),
	@DescAlergias						VARCHAR(300),
	@IndTuberculosis					CHAR(1),
	@DescTuberculosis					VARCHAR(300),
	@IndAtipia							CHAR(1),
	@DescAtipia							VARCHAR(300),
	@IndGota							CHAR(1),
	@DescGota							VARCHAR(300),
	@IndAfeccionBroncopulmonar			CHAR(1),
	@DescAfeccionBroncopulmonar			VARCHAR(300),
	@IndEndocrinopatia					CHAR(1),
	@DescEndocrinopatia					VARCHAR(300),
	@IndNefropatia						CHAR(1),
	@DescNefropatia						VARCHAR(300),
	@IndUropatia						CHAR(1),
	@DescUropatia						VARCHAR(300),
	@IndHemopatia						CHAR(1),
	@DescHemopatia						VARCHAR(300),
	@IndETS								CHAR(1),
	@DescETS							VARCHAR(300),
	@IndUlcera							CHAR(1),
	@DescUlcera							VARCHAR(300),
	@IndColecistopatia					CHAR(1),
	@DescColecistopatia					VARCHAR(300),
	@IndHepatitis						CHAR(1),
	@DescHepatitis						VARCHAR(300),
	@IndEnfermedadesNeurologicas		CHAR(1),
	@DescEnfermedadesNeurologicas		VARCHAR(300),
	@IndFiebresProlongadas				CHAR(1),
	@DescFiebresProlongadas				VARCHAR(300),
	@IndColagenopatia					CHAR(1),
	@DescColagenopatia					VARCHAR(300),
	@OtrosAntecedentes					VARCHAR(600),
	--
	@Ectoscopia							VARCHAR(4000),
	@IdEmpleado							INT,
	@Accion								INT, --0:INSERT, 1:UPDATE, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
	@IdGenerado							INT OUTPUT
)
AS
BEGIN
  DECLARE @item AS VARCHAR(10)
  DECLARE @IdDiagnostico AS INT
 
  BEGIN TRANSACTION
	IF @Accion = 0
    BEGIN
	  IF @IdEpisodio = 0
	  BEGIN
		--INSERTAMOS EL GRUPO Y FACTOR SANGUINEO
		UPDATE Paciente SET GrupoSanguineo = @GrupoSanguineo, FactorSanguineo = @FactorSanguineo
		WHERE IdPaciente = @IdPaciente
		
		--INSERTAMOS LOS DATOS DEL TRIAJE EN LA TABLA 'ExamenFisico'
		INSERT INTO ExamenFisico(Temperatura, FrecuenciaCardiaca, FrecuenciaRespiratoria, PresionArterial, Peso, Talla, Otros)
		VALUES(@Temperatura, @FrecuenciaCardiaca, @FrecuenciaRespiratoria, @PresionArterial, @Peso, @Talla, @OtrosExamenes)
		
		SET @IdExamenFisico = SCOPE_IDENTITY()
		
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
			VALUES (@IdExamenFisico, @IdEnfermedad, @IdFuncionesBiologicas, GETDATE(), @IdEmpleado, @IdModoIngreso, @IdHistoriaClinica)
		END
		ELSE
		BEGIN
			INSERT INTO Episodio (IdExamenFisico, IdEnfermedad, IdFuncionesBiologicas, FechaRegistro, IdEmpleado, IdHistoriaClinica)
			VALUES (@IdExamenFisico, @IdEnfermedad, @IdFuncionesBiologicas, GETDATE(), @IdEmpleado, @IdHistoriaClinica)
		END
		
		SET @IdEpisodio = SCOPE_IDENTITY()
	  END
--	  ELSE
--	  BEGIN
		
--	  END
		  
	  SELECT @IdExamenFisico = IdExamenFisico, @IdEnfermedad = IdEnfermedad, 
			   @IdFuncionesBiologicas = IdFuncionesBiologicas
	  FROM Episodio
	  WHERE IdEpisodio = @IdEpisodio
	  
	  SELECT @IdAntecedentes = IdAntecedentes
	  FROM HistoriaClinica
	  WHERE IdHistoriaClinica = @IdHistoriaClinica
	  --TABLA Paciente
	  
	  --TABLA ExamenFisico	
	  UPDATE ExamenFisico
	  SET Temperatura = @Temperatura, FrecuenciaCardiaca = @FrecuenciaCardiaca,
	      FrecuenciaRespiratoria = @FrecuenciaRespiratoria, PresionArterial = @PresionArterial,
	      Peso = @Peso, Talla = @Talla, Otros = @OtrosExamenes
	  WHERE IdExamenFisico = @IdExamenFisico
	  --TABLA Enfermedad
	  UPDATE Enfermedad
	  SET Tiempo = @Tiempo, Inicio = @Inicio, Curso = @Curso, Sintomas = Sintomas, 
		  RelatoCronologico = @RelatoCronologico
	  WHERE IdEnfermedad = @IdEnfermedad
	  --TABLA FuncionesBiologicas
	  UPDATE FuncionesBiologicas
	  SET Apetito = @Apetito, Sed = @Sed, Orina = @Orina, Deposiciones = @Deposiciones
	  WHERE IdFuncionesBiologicas = @IdFuncionesBiologicas
	  --TABLA Antecedentes
	  UPDATE Antecedentes 
	  SET IndTabaco = @IndTabaco, IndAlcohol = @IndAlcohol, IndCafe = @IndCafe, IndTe = @IndTe, IndDrogas = @IndDrogas, 
		  IndDiabetes = @IndDiabetes, DescripcionDiabetes = @DescDiabetes, IndHipertension = @IndHipertension, 
		  DescripcionHipertension = @DescHipertension, IndCoronariopatia = @IndCoronariopatia, 
		  DescripcionCoronariopatia = @DescCoronariopatia, IndDislipidemia = @IndDislipidemia, 
		  DescripcionDislipidemia = @DescDislipidemia, IndAsma = @IndAsma, DescripcionAsma = @DescAsma, 
		  IndPsicopatia = @IndPsicopatia, DescripcionPsicopatia = @DescPsicopatia, IndAlergias = @IndAlergias, 
		  DescripcionAlergias = @DescAlergias, IndTuberculosis = @IndTuberculosis, DescripcionTuberculosis = @DescTuberculosis, 
		  IndAtipia = @IndAtipia, DescripcionAtipia = @DescAtipia, IndGota = @IndGota, DescripcionGota = @DescGota,
		  IndAfeccionBroncopulmonar = @IndAfeccionBroncopulmonar, DescripcionAfeccionBroncopulmonar = @DescAfeccionBroncopulmonar, 
		  IndEndocrinopatia = @IndEndocrinopatia, DescripcionEndocrinopatia = @DescEndocrinopatia, IndNefropatia = @IndNefropatia, 
		  DescripcionNefropatia = @DescNefropatia, IndUropatia = @IndUropatia, DescripcionUropatia = @DescUropatia, 
		  IndHemopatia = @IndHemopatia, DescripcionHemopatia = @DescHemopatia, IndETS = @IndETS, DescripcionETS = @DescETS,
		  IndUlcera = @IndUlcera, DescripcionUlcera = @DescUlcera, IndColecistopatia = @IndColecistopatia, 
		  DescripcionColecistopatia = @DescColecistopatia, IndHepatitis = @IndHepatitis, DescripcionHepatitis = @DescHepatitis, 
		  IndEnfermedadesNeurologicas = @IndEnfermedadesNeurologicas, DescripcionEnfermedadesNeurologicas = @DescEnfermedadesNeurologicas,
		  IndFiebresProlongadas = @IndFiebresProlongadas, DescripcionFiebresProlongadas = @DescFiebresProlongadas, 
		  IndColagenopatia = @IndColagenopatia, DescripcionColagenopatia = @DescColagenopatia, Otros = @OtrosAntecedentes
	  WHERE IdAntecedentes = @IdAntecedentes
	  --TABLA Episodio
	  UPDATE Episodio
	  SET Ectoscopia = @Ectoscopia
	  WHERE IdEpisodio = @IdEpisodio
	  --TABLA DiagnosticosxEpisodio
	  DELETE FROM DiagnosticosxEpisodio 
	  WHERE IdEpisodio = @IdEpisodio
	
	  DECLARE cur CURSOR FOR 
	  (
	     SELECT Item FROM fn_Split(@ListaIdDiagnosticos, ',') 
	  )

	  OPEN cur
	  FETCH NEXT FROM cur INTO @item

	  WHILE @@FETCH_STATUS = 0 
	  BEGIN
		SET @IdDiagnostico = CONVERT(INT, @item)
		
		INSERT INTO DiagnosticosxEpisodio(IdDiagnostico, IdEpisodio)
		VALUES (@IdDiagnostico, @IdEpisodio)
		
		FETCH NEXT FROM cur INTO @item
	  END

	  CLOSE cur
	  DEALLOCATE cur
    END
    
 --   IF @Accion = 1
 --   BEGIN
		
 --   END
    
 --   IF @Accion = 4
 --   BEGIN
		
 --   END
    
 --   IF @Accion = 5
 --   BEGIN
		
 --   END
    
 --   IF @Accion = 6
	--BEGIN
		
	--END
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
    
	SET @IdGenerado = 0
	
	RETURN @IdGenerado
  END
  
  COMMIT TRANSACTION
  
  RETURN @IdGenerado
END