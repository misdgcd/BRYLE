--Specify the Year
DECLARE @year AS NVARCHAR(4) = YEAR('2022')
--Specify the Quarter Period
DECLARE @qtr AS INT = 1
----tin of the company
--DECLARE @tin NVARCHAR(MAX) = (SELECT TaxIdNum FROM OADM)
----name of the company
--DECLARE @payName NVARCHAR(MAX) = (SELECT CompnyName FROM OADM)
--quarter ending
DECLARE @qtrEnding AS NVARCHAR(10)

DECLARE @1stMosStr AS DATE
DECLARE @1stMosStp AS DATE
DECLARE @2ndMosStr AS DATE
DECLARE @2ndMosStp AS DATE
DECLARE @3rdMosStr AS DATE
DECLARE @3rdMosStp AS DATE
DECLARE @strDate AS DATE
DECLARE @stpDate AS DATE

BEGIN
	--1st quarter of the year
	IF @qtr = '1'
		BEGIN
			SET @1stMosStr = CONCAT(@year,'-01-01')
			SET @1stMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@1stMosStr))
			SET @2ndMosStr = DATEADD(MONTH,1,@1stMosStr)
			SET @2ndMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@2ndMosStr))
			SET @3rdMosStr = DATEADD(MONTH,1,@2ndMosStr)
			SET @3rdMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@3rdMosStr))
			SET @strDate = @1stMosStr
			SET @stpDate = @3rdMosStp
			SET @qtrEnding = MONTH(@stpDate)
		END
	--2nd quarter of the year
	IF @qtr = '2'
		BEGIN
			SET @1stMosStr = CONCAT(@year,'-04-01')
			SET @1stMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@1stMosStr))
			SET @2ndMosStr = DATEADD(MONTH,1,@1stMosStr)
			SET @2ndMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@2ndMosStr))
			SET @3rdMosStr = DATEADD(MONTH,1,@2ndMosStr)
			SET @3rdMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@3rdMosStr))
			SET @strDate = @1stMosStr
			SET @stpDate = @3rdMosStp
			SET @qtrEnding = MONTH(@stpDate)
		END
	--3rd quarter of the year
	IF @qtr = '3'
		BEGIN
			SET @1stMosStr = CONCAT(@year,'-07-01')
			SET @1stMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@1stMosStr))
			SET @2ndMosStr = DATEADD(MONTH,1,@1stMosStr)
			SET @2ndMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@2ndMosStr))
			SET @3rdMosStr = DATEADD(MONTH,1,@2ndMosStr)
			SET @3rdMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@3rdMosStr))
			SET @strDate = @1stMosStr
			SET @stpDate = @3rdMosStp
			SET @qtrEnding = MONTH(@stpDate)
		END
	--4th quarter of the year
	IF @qtr = '4'
		BEGIN
			SET @1stMosStr = CONCAT(@year,'-10-01')
			SET @1stMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@1stMosStr))
			SET @2ndMosStr = DATEADD(MONTH,1,@1stMosStr)
			SET @2ndMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@2ndMosStr))
			SET @3rdMosStr = DATEADD(MONTH,1,@2ndMosStr)
			SET @3rdMosStp = DATEADD(DAY,-1,DATEADD(MONTH,1,@3rdMosStr))
			SET @strDate = @1stMosStr
			SET @stpDate = @3rdMosStp
			SET @qtrEnding = MONTH(@stpDate)
		END
--Start your query
SELECT
	ROW_NUMBER() OVER(ORDER BY T.DT ASC) AS 'Seq No.'
--	ROW_NUMBER() OVER (ORDER BY (SELECT 1)) as 'Seq No.'
	,T.DT  as [DT]
	,T.TIN AS 'Tin Number'
	,T.RN AS 'Corporation'
	,(CASE WHEN T.ALIAS = '' THEN T.Noc ELSE T.ALIAS END) as 'Individual'
	,T.ATCCode AS 'Wtax Code'
	,T.NoP AS 'Wtax Decsription'
	,SUM(T.[1stMosIP]) AS '1st Mos Income Payment'
	,CAST(SUM(DISTINCT T.[1stMosTR]) AS INT) AS '1st Mos Tax Rate'
	,SUM(T.[1stMosTW]) AS '1st Mos Tax Withheld'
	,SUM(T.[2ndMosIP]) AS '2nd Mos Income Payment'
	,CAST(SUM(DISTINCT T.[2ndMosTR]) AS INT) AS '2nd Mos Tax Rate'
	,SUM(T.[2ndMosTW]) AS '2nd Mos Tax Withheld'
	,SUM(T.[3rdMosIP]) AS '3rd Mos Income Payment'
	,CAST(SUM(DISTINCT T.[3rdMosTR]) AS INT) AS '3rd Mos Tax Rate'
	,SUM(T.[3rdMosTW]) AS '3rd Mos Tax witheld'
	,SUM(T.[1stMosIP]) + SUM(T.[2ndMosIP]) + SUM(T.[3rdMosIP])  AS 'Total Income Payment'
	,SUM(T.[1stMosTW]) + SUM(T.[2ndMosTW]) + SUM(T.[3rdMosTW]) AS  'Total Tax Withheld'
	--,SUM(T.[IP]) AS 'Total Income Payment'
	--,SUM(T.[TW]) AS 'Total Tax Withheld'
	,@year AS 'YEAR'
	,CASE
		WHEN @qtrEnding = '3' THEN 'MARCH'
		WHEN @qtrEnding = '6' THEN 'JUNE'
		WHEN @qtrEnding = '9' THEN 'SEPTEMBER'
		WHEN @qtrEnding = '12' THEN 'DECEMBER'
		END AS 'MONTH'
	,T.Branch 
FROM (
--ARINV
SELECT
	(concat(T1.U_Customer,'',T1.CardName)) as [DT]
	,T1.U_wtaxComCode AS [WCC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
	--,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm = 'N') AS [RN]
	--Card Name
	,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	             'zzz'
		   ELSE
	            ISNULL((SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
	       END) AS [RN]
	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzz'
		  ELSE
               ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'

			   	--Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzz'
		   ELSE
	            ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR)
		   END) as [ALIAS]

--	,ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR) AS [ALIAS]
	--WTAX DESCRIPTION
	,(SELECT U_ATC FROM OWHT
	WHERE WTCode = T0.WTCode) AS [ATCCode]
	,(SELECT U_ATCDesc
		FROM OWHT 
		WHERE OWHT.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @strDate AND @stpDate) AS [NoP]
	
	--first Month of the Quarter
--IF INCOMING INVOICE HAS ENTRY
	,(CASE	WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) <>
			 (Select SUM(OINV.DocTotal) From OINV where OINV.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) THEN
		
				ISNULL((Cast((Select SUM(RCT2.SumApplied) / SUM(OINV.DocTotal) * SUM(OINV.BaseAmnt)
				from OINV
				JOIN RCT2 on OINV.DocEntry = RCT2.DocEntry 
				JOIN ORCT ON ORCT.DocNum = RCT2.DocNum
				Where OINV.DocNum = T1.DocNum 
				AND ORCT.Canceled = 'N'
				AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp)as DECIMAL(16,2))),0)

		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) IS NULL THEN

			    ISNULL((0),0)
	ELSE

		ISNULL(CAST((SELECT INV5.TaxbleAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [1stMosIP]

	,(CASE WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) IS NULL THEN
		ISNULL((0),0)
		ELSE
		ISNULL(CAST((SELECT INV5.Rate
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [1stMosTR]

--IF INCOMING INVOICE HAS ENTRY
	,(CASE	WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) <>
			 (Select SUM(OINV.DocTotal) From OINV where OINV.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) THEN

		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry)AS DECIMAL(16,2)),0)

		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) IS NULL THEN
		ISNULL((0),0)

		ELSE
		ISNULL(CAST((SELECT INV5.WTAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0)

		--1st month of the quarter JE
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.LineMemo = T1.U_wtaxComCode
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL
			),0)
			END
			)
			AS [1stMosTW]
			--end 1st month of the quarter JE
	--end first Month of the Quarter

	--second Month of the Quarter
--IF INCOMING INVOICE HAS ENTRY
	,(CASE	WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) <>
			 (Select SUM(OINV.DocTotal) From OINV where OINV.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) THEN
		
				ISNULL((Cast((Select SUM(RCT2.SumApplied) / SUM(OINV.DocTotal) * SUM(OINV.BaseAmnt)
				from OINV
				JOIN RCT2 on OINV.DocEntry = RCT2.DocEntry 
				JOIN ORCT ON ORCT.DocNum = RCT2.DocNum
				Where OINV.DocNum = T1.DocNum 
				AND ORCT.Canceled = 'N'
				AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp)as DECIMAL(16,2))),0)

		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) IS NULL THEN

			    ISNULL((0),0)

		ELSE

		ISNULL(CAST((SELECT INV5.TaxbleAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [2ndMosIP]

	,(CASE WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) IS NULL THEN
		ISNULL((0),0)
		ELSE
		ISNULL(CAST((SELECT INV5.Rate
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [2ndMosTR]

--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) > 0 THEN
		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp)AS DECIMAL(16,2)),0)
		
		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) IS NULL THEN

		ISNULL((0),0)
		
		ELSE
		ISNULL(CAST((SELECT INV5.WTAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.LineMemo = T1.U_wtaxComCode
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL
			),0)
			END) AS [2ndMosTW]
	--end second Month of the Quarter
	--third Month of the Quarter

--IF INCOMING INVOICE HAS ENTRY
	,(CASE	WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) <>
			 (Select SUM(OINV.DocTotal) From OINV where OINV.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) THEN
		
				ISNULL((Cast((Select SUM(RCT2.SumApplied) / SUM(OINV.DocTotal) * SUM(OINV.BaseAmnt)
				from OINV
				JOIN RCT2 on OINV.DocEntry = RCT2.DocEntry 
				JOIN ORCT ON ORCT.DocNum = RCT2.DocNum
				Where OINV.DocNum = T1.DocNum 
				AND ORCT.Canceled = 'N'
				AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp)as DECIMAL(16,2))),0)

		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) IS NULL THEN

		ISNULL((0),0)

		ELSE

		ISNULL(CAST((SELECT INV5.TaxbleAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [3rdMosIP]

	,(CASE WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) IS NULL THEN
		ISNULL((0),0)
		ELSE
		ISNULL(CAST((SELECT INV5.Rate
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [3rdMosTR]

--IF INCOMING INVOICE HAS ENTRY
		,(CASE WHEN (Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) > 0 THEN

		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp)AS DECIMAL(16,2)),0)

		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) IS NULL THEN

		ISNULL((0),0)

		ELSE
		ISNULL(CAST((SELECT INV5.WTAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0)
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'ARINV' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.LineMemo = T1.U_wtaxComCode
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL
			),0)
			END)
		AS [3rdMosTW]
	,T2.BPLName AS [Branch]
FROM INV5 T0
JOIN OINV T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
WHERE T1.DocDate BETWEEN @strDate AND @stpDate
--END ARINV

UNION ALL

--ARDPI 
SELECT
	(concat(T1.U_Customer,' ',T1.CardName)) as [DT]
	,T1.U_wtaxComCode AS [WCC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
	--,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm = 'N') AS [RN]
	--Card Name
	,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	             'zzz'
		   ELSE
	            ISNULL((SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
	       END) AS [RN]
	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzz'
		  ELSE
               ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'
			   	--Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzz'
		   ELSE
	            ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR)
		   END) as [ALIAS]

	,(SELECT U_ATC FROM OWHT
	WHERE WTCode = T0.WTCode) AS [ATCCode]
	,(SELECT U_ATCDesc 
		FROM OWHT 
		WHERE OWHT.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @strDate AND @stpDate) AS [NoP]
	
	--first Month of the Quarter
--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) <>
				(Select SUM(OINV.DocTotal) From OINV where OINV.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) THEN
			
	 
		ISNULL(CAST((Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp)AS DECIMAL(16,2)),0)	
			
		ELSE


		ISNULL(CAST((SELECT DPI5.TaxbleAmnt
		FROM DPI5 
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0)
		END) AS [1stMosIP]

	,ISNULL(CAST((SELECT DPI5.Rate
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0) AS [1stMosTR]

--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) > 0 THEN
		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry)AS DECIMAL(16,2)),0)
		ELSE
		ISNULL(CAST((SELECT DPI5.WTAmnt
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0) 
		--1st month of the quarter JE
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.LineMemo = T1.U_wtaxComCode
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL
			),0)
			END)AS [1stMosTW]
	--end first Month of the Quarter

	--second Month of the Quarter
--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) <>
				(Select SUM(OINV.DocTotal) From OINV where OINV.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) THEN
			
	 
		ISNULL(CAST((Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp)AS DECIMAL(16,2)),0)
			
		ELSE	

		ISNULL(CAST((SELECT DPI5.TaxbleAmnt
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)
		END) AS [2ndMosIP]

	,ISNULL(CAST((SELECT DPI5.Rate
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0) AS [2ndMosTR]

--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) > 0 THEN
		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry)AS DECIMAL(16,2)),0)
		ELSE
		ISNULL(CAST((SELECT DPI5.WTAmnt
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)
		--2nd month of the quarter JE
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.LineMemo = T1.U_wtaxComCode
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL
			),0)
			END) AS [2ndMosTW]
	--end second Month of the Quarter


	--third Month of the Quarter
--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) <>
				(Select SUM(OINV.DocTotal) From OINV where OINV.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) THEN
			
	 
		ISNULL(CAST((Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp)AS DECIMAL(16,2)),0)
			
		ELSE

		ISNULL(CAST((SELECT DPI5.TaxbleAmnt
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0)
		END) AS [3rdMosIP]

	,ISNULL(CAST((SELECT DPI5.Rate
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0) AS [3rdMosTR]

--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) > 0 THEN
		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry)AS DECIMAL(16,2)),0)
		ELSE
		ISNULL(CAST((SELECT DPI5.WTAmnt
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0)
		--third of the quarter JE
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.LineMemo = T1.U_wtaxComCode
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL
			),0)
			END) AS [3rdMosTW]
	--end third Month of the Quarter
	----total
	--,CAST(T0.TaxbleAmnt AS DECIMAL(16,2)) AS [IP]
	--,CAST(T0.WTAmnt AS DECIMAL(16,2)) 
	--+ ISNULL((SELECT 
	--			CASE
	--				WHEN JDT1.Debit <> 0 THEN 
	--					CAST((
	--					SELECT SUM(1*JDT1.Debit) FROM JDT1
	--					JOIN OJDT Th ON Th.TransId = JDT1.TransId
	--					WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
	--					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--					AND JDT1.LineMemo = T1.U_wtaxComCode
	--					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
	--					AND Th.RefDate BETWEEN @strDate AND @stpDate
	--					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--					AND Th.StornoToTr IS NULL
	--					) AS decimal(16,2))
	--				WHEN JDT1.Credit <> 0 THEN 
	--					CAST((
	--					SELECT SUM(-1*JDT1.Credit) FROM JDT1 
	--					JOIN OJDT Th ON Th.TransId = JDT1.TransId
	--					WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
	--					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--					AND JDT1.LineMemo = T1.U_wtaxComCode
	--					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
	--					AND Th.RefDate BETWEEN @strDate AND @stpDate
	--					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--					AND Th.StornoToTr IS NULL
	--					) AS decimal(16,2))
	--			END
	--			FROM JDT1 
	--			JOIN OJDT Th ON Th.TransId = JDT1.TransId
	--			WHERE LEFT(JDt1.Ref1,5) = 'ARDPI' 
	--			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--			AND JDT1.LineMemo = T1.U_wtaxComCode
	--			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
	--			AND Th.RefDate BETWEEN @strDate AND @stpDate
	--			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--			AND Th.StornoToTr IS NULL
	--			),0)
	--AS [TW]	
	----end total
	,T2.BPLName AS [Branch]
FROM DPI5 T0
JOIN ODPI T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
WHERE T1.DocDate BETWEEN @strDate AND @stpDate
--END ARDPI

UNION ALL

--ARCM
SELECT
	(concat(T1.U_Customer,'',T1.CardName)) as [DT]
	,T1.U_wtaxComCode AS [WCC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
	--,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm = 'N') AS [RN]
	--Card Name
	,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	             'zzz'
		   ELSE
	            ISNULL((SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
	       END) AS [RN]
	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzz'
		  ELSE
               ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'

			   	--Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzz'
		   ELSE
	            ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR)
		   END) as [ALIAS]

	,(SELECT U_ATC FROM OWHT
	WHERE WTCode = T0.WTCode) AS [ATCCode]
	,(SELECT U_ATCDesc 
		FROM OWHT 
		WHERE OWHT.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @strDate AND @stpDate) AS [NoP]

	--first Month of the Quarter
--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0
		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) IS NULL THEN
		ISNULL((0),0)
		
		ELSE

		ISNULL(CAST((SELECT -1 * RIN5.TaxbleAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0)
		END) AS [1stMosIP]

	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0
		ELSE
		ISNULL(CAST((SELECT RIN5.Rate
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [1stMosTR]

--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0 
		
		WHEN (Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) > 0 THEN
		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry)AS DECIMAL(16,2)),0)
		
		ELSE
		ISNULL(CAST((SELECT -1 * RIN5.WTAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0)
		END) 
		AS [1stMosTW]

	--end first Month of the Quarter
	--second Month of the Quarter
--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0
		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) IS NULL THEN
		ISNULL((0),0)
		
		ELSE

		ISNULL(CAST((SELECT -1 *RIN5.TaxbleAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)
		END) AS [2ndMosIP]

	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0
		ELSE
		ISNULL(CAST((SELECT RIN5.Rate
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [2ndMosTR]

--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0 
	
		WHEN (Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) > 0 THEN
		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry)AS DECIMAL(16,2)),0)
	
		ELSE
	
		ISNULL(CAST((SELECT -1 * RIN5.WTAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)
		END) AS [2ndMosTW]
	--end second Month of the Quarter

	--third Month of the Quarter - WALA PA NAHUMAN
--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0
		WHEN (Select SUM(RCT2.SumApplied) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) IS NULL THEN
		ISNULL((0),0)
		
		ELSE

		ISNULL(CAST((SELECT -1 * RIN5.TaxbleAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0)
		END) AS [3rdMosIP]

	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0
		ELSE
		ISNULL(CAST((SELECT RIN5.Rate
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0)
		END)
		AS [3rdMosTR]

--IF INCOMING INVOICE HAS ENTRY
	,(CASE WHEN (SELECT SUM(PaidToDate) FROM ORIN WHERE ORIN.DocEntry = T1.DocEntry) > 0 then
		0 
	
		WHEN (Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) > 0 THEN
		ISNULL(CAST((Select SUM(RCT2.U_WTAXPay) From RCT2 where RCT2.DocEntry = T1.DocEntry)AS DECIMAL(16,2)),0)
	
		ELSE
		ISNULL(CAST((SELECT -1 * RIN5.WTAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0)
		END) AS [3rdMosTW]

	--end third Month of the Quarter
	----total

	--,CAST(-1 * T0.TaxbleAmnt AS DECIMAL(16,2)) AS [IP]
	--,CAST(-1 * T0.WTAmnt AS DECIMAL(16,2)) AS [TW]	
	--end total

,T2.BPLName AS [Branch]
FROM RIN5 T0
JOIN ORIN T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
WHERE T1.DocDate BETWEEN @strDate AND @stpDate ) AS T
GROUP BY
	T.WCC
	,T.DT
	,T.ATCCode
	,T.TIN
	,T.RN
	,T.NoC
	,T.NoP
	,T.Branch
	,T.ALIAS
	ORDER BY
	 T.DT
--	,T.NOC
	,T.ALIAS ASC
END;