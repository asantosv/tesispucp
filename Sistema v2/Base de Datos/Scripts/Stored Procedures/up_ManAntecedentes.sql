USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManAntecedentes]    Script Date: 09/17/2013 18:08:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManAntecedentes]
(
	@IdAntecedentes						BIGINT,
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
	@Otros								VARCHAR(4000),
	@Accion								INT, --0:INSERT, 1:UPDATE, 4:SELECT
	@IdGenerado							INT	OUTPUT 
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Antecedentes(IndTabaco, IndAlcohol, IndCafe, IndTe, IndDrogas, IndDiabetes, DescripcionDiabetes,
						 IndHipertension, DescripcionHipertension, IndCoronariopatia, DescripcionCoronariopatia,
						 IndDislipidemia, DescripcionDislipidemia, IndAsma, DescripcionAsma, IndPsicopatia,
						 DescripcionPsicopatia, IndAlergias, DescripcionAlergias, IndTuberculosis,
						 DescripcionTuberculosis, IndAtipia, DescripcionAtipia, IndGota, DescripcionGota,
						 IndAfeccionBroncopulmonar, DescripcionAfeccionBroncopulmonar, IndEndocrinopatia,
						 DescripcionEndocrinopatia, IndNefropatia, DescripcionNefropatia, IndUropatia,
						 DescripcionUropatia, IndHemopatia, DescripcionHemopatia, IndETS, DescripcionETS,
						 IndUlcera, DescripcionUlcera, IndColecistopatia, DescripcionColecistopatia, IndHepatitis,
						 DescripcionHepatitis, IndEnfermedadesNeurologicas, DescripcionEnfermedadesNeurologicas,
						 IndFiebresProlongadas, DescripcionFiebresProlongadas, IndColagenopatia, DescripcionColagenopatia,
						 Otros)
		VALUES(@IndTabaco, @IndAlcohol, @IndCafe, @IndTe, @IndDrogas, @IndDiabetes, @DescDiabetes, @IndHipertension,
			   @DescHipertension, @IndCoronariopatia, @DescCoronariopatia, @IndDislipidemia, @DescDislipidemia, @IndAsma,
			   @DescAsma, @IndPsicopatia, @DescPsicopatia, @IndAlergias, @DescAlergias, @IndTuberculosis, @DescTuberculosis, 
			   @IndAtipia, @DescAtipia, @IndGota, @DescGota, @IndAfeccionBroncopulmonar, @DescAfeccionBroncopulmonar, 
			   @IndEndocrinopatia, @DescEndocrinopatia, @IndNefropatia, @DescNefropatia, @IndUropatia, @DescUropatia,
			   @IndHemopatia, @DescHemopatia, @IndETS, @DescETS, @IndUlcera, @DescUlcera, @IndColecistopatia, @DescColecistopatia, 
			   @IndHepatitis, @DescHepatitis, @IndEnfermedadesNeurologicas, @DescEnfermedadesNeurologicas, @IndFiebresProlongadas, 
			   @DescFiebresProlongadas, @IndColagenopatia, @DescColagenopatia, @Otros)
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
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
			IndColagenopatia = @IndColagenopatia, DescripcionColagenopatia = @DescColagenopatia, Otros = @Otros
		WHERE IdAntecedentes = @IdAntecedentes	
						
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdAntecedentes, ISNULL(IndTabaco, '') AS 'IndTabaco', ISNULL(IndAlcohol, '') As 'IndAlcohol', 
			   ISNULL(IndCafe, '') AS 'IndCafe', ISNULL(IndTe, '') AS 'IndTe', ISNULL(IndDrogas, '') AS 'IndDrogas', 
			   ISNULL(IndDiabetes, '') AS IndDiabetes, ISNULL(DescripcionDiabetes, '') AS DescripcionDiabetes,
			   ISNULL(IndHipertension, '') AS 'IndHipertension', ISNULL(DescripcionHipertension, '') AS 'DescripcionHipertension',
			   ISNULL(IndCoronariopatia, '') AS 'IndCoronariopatia', ISNULL(DescripcionCoronariopatia, '') AS 'DescripcionCoronariopatia',
			   ISNULL(IndDislipidemia, '') AS 'IndDislipidemia', ISNULL(DescripcionDislipidemia, '') AS 'DescripcionDislipidemia', 
			   ISNULL(IndAsma, '') AS 'IndAsma', ISNULL(DescripcionAsma, '') AS 'DescripcionAsma', 
			   ISNULL(IndPsicopatia, '') AS 'IndPsicopatia', ISNULL(DescripcionPsicopatia, '') AS 'DescripcionPsicopatia', 
			   ISNULL(IndAlergias, '') AS 'IndAlergias', ISNULL(DescripcionAlergias, '') AS 'DescripcionAlergias', 
			   ISNULL(IndTuberculosis, '') AS 'IndTuberculosis', ISNULL(DescripcionTuberculosis, '') AS 'DescripcionTuberculosis', 
			   ISNULL(IndAtipia, '') AS 'IndAtipia', ISNULL(DescripcionAtipia, '') AS 'DescripcionAtipia', 
			   ISNULL(IndGota, '') AS 'IndGota', ISNULL(DescripcionGota, '') AS 'DescripcionGota',
			   ISNULL(IndAfeccionBroncopulmonar, '') AS 'IndAfeccionBroncopulmonar', 
			   ISNULL(DescripcionAfeccionBroncopulmonar, '') AS 'DescripcionAfeccionBroncopulmonar', 
			   ISNULL(IndEndocrinopatia, '') AS 'IndEndocrinopatia',
			   ISNULL(DescripcionEndocrinopatia, '') AS 'DescripcionEndocrinopatia', ISNULL(IndNefropatia, '') AS 'IndNefropatia', 
			   ISNULL(DescripcionNefropatia, '') AS 'DescripcionNefropatia', ISNULL(IndUropatia, '') AS 'IndUropatia',
			   ISNULL(DescripcionUropatia, '') AS 'DescripcionUropatia', ISNULL(IndHemopatia, '') AS 'IndHemopatia', 
			   ISNULL(DescripcionHemopatia, '') AS 'DescripcionHemopatia', ISNULL(IndETS, '') AS 'IndETS', 
			   ISNULL(DescripcionETS, '') AS 'DescripcionETS', ISNULL(IndUlcera, '') AS 'IndUlcera', 
			   ISNULL(DescripcionUlcera, '') AS 'DescripcionUlcera', ISNULL(IndColecistopatia, '') AS 'IndColecistopatia', 
			   ISNULL(DescripcionColecistopatia, '') AS 'DescripcionColecistopatia', ISNULL(IndHepatitis, '') AS 'IndHepatitis',
			   ISNULL(DescripcionHepatitis, '') AS 'DescripcionHepatitis', 
			   ISNULL(IndEnfermedadesNeurologicas, '') AS 'IndEnfermedadesNeurologicas', 
			   ISNULL(DescripcionEnfermedadesNeurologicas, '') AS 'DescripcionEnfermedadesNeurologicas',
			   ISNULL(IndFiebresProlongadas, '') AS 'IndFiebresProlongadas', 
			   ISNULL(DescripcionFiebresProlongadas, '') AS 'DescripcionFiebresProlongadas', 
			   ISNULL(IndColagenopatia, '') AS 'IndColagenopatia', ISNULL(DescripcionColagenopatia, '') AS 'DescripcionColagenopatia',
			   Otros
		FROM Antecedentes
		WHERE IdAntecedentes = @IdAntecedentes
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