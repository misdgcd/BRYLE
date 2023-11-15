--Specify the Year
DECLARE @year AS NVARCHAR(4) = YEAR('2021')
--Specify the Quarter Period
DECLARE @qtr AS INT = 4
--tin of the company
DECLARE @tin NVARCHAR(MAX) = (SELECT TaxIdNum FROM OADM)
--name of the company
DECLARE @payName NVARCHAR(MAX) = (SELECT CompnyName FROM OADM)
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
--START 


SELECT 
	 
--	ROW_NUMBER() OVER(ORDER BY newTable.RN ASC) AS 'Seq No.'
    ROW_NUMBER() OVER (ORDER BY (SELECT 1)) as 'Seq No.'
	,newtable.DT
	,newtable.cc
	,newTable.TIN AS 'Tin Number'
	,newTable.RN AS 'Corporation'
--	,(CASE WHEN newTable.NOC1 = '' THEN newTable.NoC ELSE newTable.NoC1 END) AS 'Individual'
    ,newTable.NOc1 AS Individual
	,newTable.ATCCode AS 'Wtax Code'
	,newTable.NoP AS 'Wtax Decsription'
	,SUM(newTable.[1stMosAoIP]) AS '1st Month Income Payment'
	,CAST(SUM(DISTINCT newTable.[1stMosTR]) AS INT) AS '1st Mos Tax Rate'
	,SUM(newTable.[1stMosAoTW]) AS '1st Month Tax Withheld'
	,SUM(newTable.[2ndMosAoIP]) AS '2nd Month Incomie Payment'
	,CAST(SUM(DISTINCT newTable.[2ndMosTR]) AS INT) AS '2nd Mos Tax Rate'
	,SUM(newTable.[2ndMosAoTW]) AS '2nd Month Tax Withheld'
	,SUM(newTable.[3rdMosAoIP]) AS '3rd Month Income Payment'
	,CAST(SUM(DISTINCT newTable.[3rdMosTR]) AS INT) AS '3rd Mos Tax Rate'
	,SUM(newTable.[3rdMosAoTW]) AS '3rd Month Tax Withheld'
	--,SUM(newTable.TIP) AS 'Total Incoming Payment'
	--,SUM(newTable.TTW) AS 'Total Tax Withheld'
	,SUM(newTable.[1stMosAoIP]) + SUM(newTable.[2ndMosAoIP]) + SUM(newTable.[3rdMosAoIP]) AS [Total Income Payment]
	,SUM(newTable.[1stMosAoTW]) + SUM(newTable.[2ndMosAoTW]) + SUM(newTable.[3rdMosAoTW]) AS [Total Tax Withheld]
	,isnull((@tin),'') AS 'CompTIN'
	,@payName AS 'CompName'
	,@year AS 'YEAR'
	,CASE
		WHEN @qtrEnding = '3' THEN 'MARCH'
		WHEN @qtrEnding = '6' THEN 'JUNE'
		WHEN @qtrEnding = '9' THEN 'SEPTEMBER'
		WHEN @qtrEnding = '12' THEN 'DECEMBER'
		END AS 'MONTH'
	,newTable.Branch
FROM (
--APINV
SELECT
	T1.Cardname AS [DT]
	,T1.CardCode AS [CC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
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
	            ISNULL((T1.U_ALIAS_VENDOR),T1.CardName)
		   END) as NoC1
	--,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode) AS [RN]
	----Name of Customer
	--,(SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
	--	FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode) AS 'NoC'
	,ISNULL((SELECT U_ATC FROM OWHT WHERE OWHT.WTCode = T0.WTCode),'') AS [ATCCode]
	,ISNULL((SELECT U_ATCDesc FROM OWHT WHERE OWHT.WTCode = T0.WTCode),'') AS [NoP]
	--first month of the quarter
	,CAST (ISNULL( (SELECT PCH5.TaxbleAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL(16,2)) AS [1stMosAoIP]
	,CAST (ISNULL( (SELECT PCH5.Rate FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) AS [1stMosTR]
	,CAST (ISNULL( (SELECT PCH5.WTAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) 
		--JE 1st Month of the Quarter
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND th.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL),0)
		AS [1stMosAoTW]
	--end first month of the quarter

	--second month of the quarter
	,CAST (ISNULL( (SELECT PCH5.TaxbleAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL(16,2)) AS [2ndMosAoIP]
	,CAST (ISNULL( (SELECT PCH5.Rate FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) AS [2ndMosTR]
	,CAST (ISNULL( (SELECT PCH5.WTAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) 

		--JE 2nd Month of the Quarter
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Credit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
			END
			FROM JDT1
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL),0)
		--END JE 2nd Month of the Quarter
		AS [2ndMosAoTW]
	--end second month of the quarter

	--third month of the quarter
	,CAST (ISNULL( (SELECT PCH5.TaxbleAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL(16,2)) AS [3rdMosAoIP]
	,CAST (ISNULL( (SELECT PCH5.Rate FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) AS [3rdMosTR]
	,CAST (ISNULL( (SELECT PCH5.WTAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) 
		--JE 3rd Month of the Quarter
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId AND Th.StornoToTr IS  NULL
					WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL),0)
		--END JE 3rd Month of the Quarter
		AS [3rdMosAoTW]
	--end third month of the quarter

	--,T0.TaxbleAmnt AS [TIP]
	--,T0.WTAmnt 
	----JE for the quarter
	--+ ISNULL((SELECT 
	--			CASE
	--				WHEN JDT1.Debit <> 0 THEN 
	--					CAST((
	--					SELECT SUM(-1*JDT1.Debit) FROM JDT1
	--					JOIN OJDT Th ON Th.TransId = JDT1.TransId AND Th.StornoToTr IS  NULL
	--					WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
	--					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
	--					AND Th.RefDate BETWEEN @strDate AND @stpDate
	--					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--					AND Th.StornoToTr IS NULL) AS decimal(16,2))
	--				WHEN JDT1.Credit <> 0 THEN 
	--					CAST((
	--					SELECT SUM(1*JDT1.Credit) FROM JDT1 
	--					JOIN OJDT Th ON Th.TransId = JDT1.TransId
	--					WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
	--					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
	--					AND Th.RefDate BETWEEN @strDate AND @stpDate
	--					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--					AND Th.StornoToTr IS NULL) AS decimal(16,2))
	--			END
	--			FROM JDT1 
	--			JOIN OJDT Th ON Th.TransId = JDT1.TransId
	--			WHERE LEFT(JDt1.Ref1,5) = 'APINV' 
	--			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
	--			AND Th.RefDate BETWEEN @strDate AND @stpDate
	--			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--			AND Th.StornoToTr IS NULL),0)
	----end of JE for the quarter
	--AS [TTW]
	,T2.BPLName AS [Branch]
FROM PCH5 T0
JOIN OPCH T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
WHERE T1.DocDate BETWEEN @strDate AND @stpDate
--END APINV

UNION ALL

--APDPI
SELECT
	T1.CardName AS [DT]
	,T1.CardCode AS [CC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
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
	,ISNULL((''),'') as NoC1
	--,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode) AS [RN]
	--,(SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
	--	FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode) AS 'NoC'
	,ISNULL((SELECT U_ATC FROM OWHT WHERE OWHT.WTCode = T0.WTCode),'') AS [ATCCode]
	,ISNULL((SELECT U_ATCDesc FROM OWHT WHERE OWHT.WTCode = T0.WTCode),'') AS [NoP]
	
	--first month of the quarter
	,CAST (ISNULL( (SELECT DPO5.TaxbleAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL(16,2)) AS [1stMosAoIP]
	,CAST (ISNULL( (SELECT DPO5.Rate FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) AS [1stMosTR]
	,CAST (ISNULL( (SELECT DPO5.WTAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) 
		--JE 1st Month of the Quarter
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Debit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @strDate AND @stpDate
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @strDate AND @stpDate
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'APDPI'  
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL),0)
		--END JE 1st Month of the Quarter
		AS [1stMosAoTW]
	--end first month of the quarter

	--second month of the quarter
	,CAST (ISNULL( (SELECT DPO5.TaxbleAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL(16,2)) AS [2ndMosAoIP]
	,CAST (ISNULL( (SELECT DPO5.Rate FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) AS [2ndMosTR]
	,CAST (ISNULL( (SELECT DPO5.WTAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) 
		--JE 2nd Month of the Quarter
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @strDate AND @stpDate
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Credit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @strDate AND @stpDate
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'APDPI'  
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @2ndMosStr AND @2ndMosStp
			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
			AND Th.StornoToTr IS NULL),0)
		--END JE 2nd Month of the Quarter	
		AS [2ndMosAoTW]
	--end second month of the quarter

	--third month of the quarter
	,CAST (ISNULL( (SELECT DPO5.TaxbleAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL(16,2)) AS [3rdMosAoIP]
	,CAST (ISNULL( (SELECT DPO5.Rate FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) AS [3rdMosTR]
	,CAST (ISNULL( (SELECT DPO5.WTAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) 
		--JE 3rd Month of the Quarter
		+ ISNULL((SELECT 
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(-1*JDT1.Debit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @strDate AND @stpDate
					AND JDT1.BaseRef NOT IN 
					(SELECT t5.DocEntry FROM dbo.ORCT T5 WHERE t5.CancelDate IS NOT NULL)) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @strDate AND @stpDate
					AND JDT1.BaseRef NOT IN 
					(SELECT t5.DocEntry FROM dbo.ORCT T5 WHERE t5.CancelDate IS NOT NULL)) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'APDPI'  
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
			AND JDT1.BaseRef NOT IN 
			(SELECT t5.DocEntry FROM dbo.ORCT T5 WHERE t5.CancelDate IS NOT NULL)),0)
		--END JE 3rd Month of the Quarter			
		AS [3rdMosAoTW]
	----end third month of the quarter
	--,T0.TaxbleAmnt AS [TIP]
	--,T0.WTAmnt 
	--+ ISNULL((SELECT 
	--			CASE
	--				WHEN JDT1.Debit <> 0 THEN 
	--					CAST((
	--					SELECT SUM(-1*JDT1.Debit) FROM JDT1
	--					JOIN OJDT Th ON Th.TransId = JDT1.TransId
	--					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
	--					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
	--					AND Th.RefDate BETWEEN @strDate AND @stpDate
	--					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--					AND Th.StornoToTr IS NULL) AS decimal(16,2))
	--				WHEN JDT1.Credit <> 0 THEN 
	--					CAST((
	--					SELECT SUM(1*JDT1.Credit) FROM JDT1 
	--					JOIN OJDT Th ON Th.TransId = JDT1.TransId
	--					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
	--					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
	--					AND Th.RefDate BETWEEN @strDate AND @stpDate
	--					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--					AND Th.StornoToTr IS NULL) AS decimal(16,2))
	--			END
	--			FROM JDT1 
	--			JOIN OJDT Th ON Th.TransId = JDT1.TransId
	--			WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
	--			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
	--			AND th.TransType = 30 AND JDT1.ShortName = T0.Account
	--			AND Th.RefDate BETWEEN @strDate AND @stpDate
	--			AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
	--			AND Th.StornoToTr IS NULL),0)
	--AS [TTW]
	,T2.BPLName AS [Branch]
FROM DPO5 T0
JOIN ODPO T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
WHERE T1.DocDate BETWEEN @strDate AND @stpDate
--END APDPI

UNION ALL

--APCM
SELECT

	T1.Cardname AS [DT]
	,T1.CardCode AS [CC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
	--Card Name
	,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
			   'zzz'
		  ELSE
	           ISNULL((SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
	      END) 
		       AS [RN]
	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		                FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		         'zzz'
		   ELSE
		         ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		                        FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		   END) AS 'NoC'
	--Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzz'
		   ELSE
	            ISNULL((T1.U_ALIAS_VENDOR),T1.CardName)
		   END) as NoC1
	--,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode) AS [RN]
	----Name of Customer
	--,(SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
	--	FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode) AS 'NoC'
	,ISNULL((SELECT U_ATC FROM OWHT WHERE OWHT.WTCode = T0.WTCode),'') AS [ATCCode]
	,ISNULL((SELECT U_ATCDesc FROM OWHT WHERE OWHT.WTCode = T0.WTCode),'') AS [NoP]
	--first month of the quarter
	,CAST (ISNULL( (SELECT -1 * RPC5.TaxbleAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL(16,2)) AS [1stMosAoIP]
	,CAST (ISNULL( (SELECT RPC5.Rate FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) AS [1stMosTR]
	,CAST (ISNULL( (SELECT -1 * RPC5.WTAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) AS [1stMosAoTW]
	--end first month of the quarter

	--second month of the quarter
	,CAST (ISNULL( (SELECT -1 * RPC5.TaxbleAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL(16,2)) AS [2ndMosAoIP]
	,CAST (ISNULL( (SELECT RPC5.Rate FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) AS [2ndMosTR]
	,CAST (ISNULL( (SELECT -1 * RPC5.WTAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) AS [2ndMosAoTW]
	--end second month of the quarter

	--third month of the quarter
	,CAST (ISNULL( (SELECT -1 * RPC5.TaxbleAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL(16,2)) AS [3rdMosAoIP]
	,CAST (ISNULL( (SELECT RPC5.Rate FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) AS [3rdMosTR]
	,CAST (ISNULL( (SELECT -1 * RPC5.WTAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T0.AbsEntry
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) AS [3rdMosAoTW]
	--end third month of the quarter
	,T2.BPLName AS [Branch]
FROM RPC5 T0
JOIN ORPC T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
WHERE T1.DocDate BETWEEN @strDate AND @stpDate
--END APCM
) AS newTable
GROUP BY
	newTable.DT
	,newTable.CC
	,newTable.ATCCode
	,newTable.TIN
	,newTable.RN
	,newTable.NOC
	,newTable.Noc1
	,newTable.NoP
	,newTable.Branch
--	ORDER BY
--	newTable.RN 
--	newTable.Noc desc
--	,newTable.NoC1 ASC
END