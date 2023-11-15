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
	--,ISNULL((T1.U_ALIAS_VENDOR),'') AS [DTTT]
--	,newTable.DTTT
--	,newtable.DT
--	,newTable.DE
	,newTable.WCC
--	,newtable.cc
	,newTable.TIN AS 'Tin Number'
	,newTable.RN AS 'Corporation'
	,(CASE WHEN newTable.NOC1 = '' THEN newTable.NoC ELSE newTable.NoC1 END) AS 'Individual'
 --   ,newTable.NOc1 AS Individual
	,newTable.ATCCode AS 'Wtax Code'
	,newTable.NoP AS 'Wtax Decsription'
	,CAST(SUM(newTable.[1stMosAoIP])AS DECIMAL(16,2)) AS '1st Month Income Payment'
	,CAST(SUM(DISTINCT newTable.[1stMosTR]) AS INT) AS '1st Mos Tax Rate'
	,CAST(SUM(newTable.[1stMosAoTW])AS DECIMAL(16,2)) AS '1st Month Tax Withheld'
--	,CAST(SUM(newTable.[1stMosAoIP]*(newTable.[1stMosTR])/100)AS DECIMAL(16,2)) AS '1st Month Tax Withheld'
	,CAST(SUM(newTable.[2ndMosAoIP])AS DECIMAL(16,2)) AS '2nd Month Income Payment'
	,CAST(SUM(DISTINCT newTable.[2ndMosTR]) AS INT) AS '2nd Mos Tax Rate'
	,CAST(SUM(newTable.[2ndMosAoTW])AS DECIMAL(16,2)) AS '2nd Month Tax Withheld'
--	,CAST(SUM(newTable.[2ndMosAoIP]*(newTable.[2ndMosTR])/100)AS DECIMAL(16,2)) AS '2nd Month Tax Withheld'
	,CAST(SUM(newTable.[3rdMosAoIP])AS DECIMAL(16,2)) AS '3rd Month Income Payment'
	,CAST(SUM(DISTINCT newTable.[3rdMosTR]) AS INT) AS '3rd Mos Tax Rate'
	,CAST(SUM(newTable.[3rdMosAoTW])AS DECIMAL(16,2)) AS '3rd Month Tax Withheld'
--	,CAST(SUM(newTable.[3rdMosAoIP]*(newTable.[3rdMosTR])/100)AS DECIMAL(16,2)) AS '3rd Month Tax Withheld'
	--,SUM(newTable.TIP) AS 'Total Incoming Payment'
	--,SUM(newTable.TTW) AS 'Total Tax Withheld'
	,CAST(SUM(newTable.[1stMosAoIP]) + SUM(newTable.[2ndMosAoIP]) + SUM(newTable.[3rdMosAoIP])AS DECIMAL(16,2)) AS [Total Income Payment]
	,CAST(SUM(newTable.[1stMosAoTW]) + SUM(newTable.[2ndMosAoTW]) + SUM(newTable.[3rdMosAoTW])AS DECIMAL(16,2)) AS [Total Tax Withheld]
	--,CAST(SUM(newTable.[1stMosAoIP]*(newTable.[1stMosTR])/100) + SUM(newTable.[2ndMosAoIP]*(newTable.[2ndMosTR])/100) + SUM(newTable.[3rdMosAoIP]*(newTable.[3rdMosTR])/100)AS DECIMAL(16,2)) AS [Total Tax Withheld]
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
	(concat(T1.U_Customer,'',T1.CardName)) as [DT]
	,ISNULL((T1.U_ALIAS_VENDOR),'') AS [DTTT]
--	,T3.DocNum as [DE]
--	,ISNULL((T1.U_wtaxComCode),T3.U_WTAXCOMCODE) AS [WCC]
	,ISNULL((T3.U_WTAXCOMCODE),'') AS [WCC]
--	,T1.CardCode AS [CC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
	--Card Name
	,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	             'zzzzz'
		   ELSE
	             ISNULL((T1.U_ALIAS_VENDOR),(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null))
	       END) AS [RN]

	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzzzz'
		  ELSE
               ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'

	--Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzzzz'
		   ELSE
	            ISNULL((T1.U_ALIAS_VENDOR),T1.CardName)
		   END) as NoC1
		   

	,(SELECT U_ATC FROM OWHT WHERE OWHT.WTCode = T0.WTCode) AS [ATCCode]
	,(SELECT U_ATCDesc FROM OWHT WHERE OWHT.WTCode = T0.WTCode) AS [NoP]
	--first month of the quarter

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp THEN
		(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt 
		ELSE
		CAST (ISNULL( (SELECT SUM(PCH5.TaxbleAmnt) FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
	--	AND PCH5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) ,0) AS DECIMAL(16,2))
		END)
		AS [1stMosAoIP]

	,CAST (ISNULL( (SELECT PCH5.Rate FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp ) ,0) AS DECIMAL (16,2)) AS [1stMosTR]

	
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp THEN  
		T3.U_WtaxPay
	--	((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
			
		ELSE
		CAST (ISNULL( (SELECT PCH5.WTAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) ,0) AS DECIMAL (16,2)) 

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
			END)
		AS [1stMosAoTW]
	--end first month of the quarter

	--second month of the quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp THEN
		(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt 
		ELSE
		CAST (ISNULL( (SELECT SUM(PCH5.TaxbleAmnt) FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
--		AND PCH5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) ,0) AS DECIMAL(16,2)) 
		END)
		AS [2ndMosAoIP]

	,CAST (ISNULL( (SELECT PCH5.Rate FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) AS [2ndMosTR]


	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp THEN  
	--((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
		T3.U_WtaxPay
		ELSE
		CAST (ISNULL( (SELECT PCH5.WTAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) ,0) AS DECIMAL (16,2)) 

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
		END)
		AS [2ndMosAoTW]
	--end second month of the quarter

	--third month of the quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp THEN
		(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt
		ELSE
		CAST (ISNULL( (SELECT SUM(PCH5.TaxbleAmnt) FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
	--	AND PCH5.WTCode = T0.WTCode
		AND T1.CANCELED = 'N'
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) ,0) AS DECIMAL(16,2))
		END)
		AS [3rdMosAoIP]

	,CAST (ISNULL( (SELECT PCH5.Rate FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) AS [3rdMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp THEN  
	--((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
		T3.U_WtaxPay
		ELSE
		CAST (ISNULL( (SELECT PCH5.WTAmnt FROM PCH5
		WHERE PCH5.AbsEntry = T0.AbsEntry
		AND PCH5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) ,0) AS DECIMAL (16,2)) 
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
			END)
		--END JE 3rd Month of the Quarter
		AS [3rdMosAoTW]
	--end third month of the quarter


	,T2.BPLName AS [Branch]
FROM PCH5 T0
JOIN OPCH T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
JOIN VPM2 T3 ON T3.DocEntry = T1.DocNum AND T3.InvType = 18
JOIN OVPM T4 ON T4.DocNum = T3.DocNum AND T4.Canceled = 'N' --AND T4.U_WTAX <> 'N/A'
WHERE T4.TaxDate BETWEEN @strDate AND @stpDate
--END APINV

UNION ALL

--APDPI
SELECT
	T1.CardName AS [DT]
	,ISNULL((T1.U_ALIAS_VENDOR),'') AS [DTTT]
--	,T3.DocNum as [DE]
	,ISNULL((T3.U_WTAXCOMCODE),'') AS [WCC]
--	,T1.CardCode AS [CC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
	--Card Name
	,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	             'zzzzz'
		   ELSE
	            ISNULL((T1.U_ALIAS_VENDOR),(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null))
	       END) AS [RN]
	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzzzz'
		  ELSE
               ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'
	--Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzzzz'
		   ELSE
	            ISNULL((T1.U_ALIAS_VENDOR),T1.CardName)
		   END) as NoC1
		   

	,(SELECT U_ATC FROM OWHT WHERE OWHT.WTCode = T0.WTCode) AS [ATCCode]
	,(SELECT U_ATCDesc FROM OWHT WHERE OWHT.WTCode = T0.WTCode) AS [NoP]
	
	--first month of the quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp THEN
		(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt 
		ELSE
		CAST (ISNULL( (SELECT SUM(DPO5.TaxbleAmnt) FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
	--	AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T3.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T1.U_wTaxComCode)) ,0) AS DECIMAL(16,2))
		end)
		AS [1stMosAoIP]

	,CAST (ISNULL( (SELECT DPO5.Rate FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) AS [1stMosTR]
	
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp THEN  
	--((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
		T3.U_WtaxPay
		ELSE
		CAST (ISNULL( (SELECT DPO5.WTAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T3.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T1.U_wTaxComCode)) ,0) AS DECIMAL (16,2)) 
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
		END)
		AS [1stMosAoTW]
	--end first month of the quarter

	--second month of the quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp THEN
		(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt 
		ELSE
		CAST (ISNULL( (SELECT SUM(DPO5.TaxbleAmnt) FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
	--	AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T3.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T1.U_wTaxComCode)) ,0) AS DECIMAL(16,2))
		END)
		AS [2ndMosAoIP]

	,CAST (ISNULL( (SELECT DPO5.Rate FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) AS [2ndMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp THEN  
		T3.U_WtaxPay
	--((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
		ELSE
		CAST (ISNULL( (SELECT DPO5.WTAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T3.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T1.U_wTaxComCode)) ,0) AS DECIMAL (16,2)) 
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
		END)
		AS [2ndMosAoTW]
	--end second month of the quarter

	--third month of the quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp THEN
		(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt 
		ELSE
		CAST (ISNULL( (SELECT SUM(DPO5.TaxbleAmnt) FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
--		AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T3.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T1.U_wTaxComCode)) ,0) AS DECIMAL(16,2))
		END)
		AS [3rdMosAoIP]

	,CAST (ISNULL( (SELECT DPO5.Rate FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) AS [3rdMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp THEN  
		T3.U_WtaxPay
	--	((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
		ELSE
		CAST (ISNULL( (SELECT DPO5.WTAmnt FROM DPO5
		WHERE DPO5.AbsEntry = T0.AbsEntry
		AND DPO5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T3.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T1.U_wTaxComCode)) ,0) AS DECIMAL (16,2)) 
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
					(SELECT t5.DocEntry FROM dbo.OVPM T5 WHERE t5.CancelDate IS NOT NULL)) AS decimal(16,2))
				WHEN JDT1.Credit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Credit) FROM JDT1 
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,5) = 'APDPI' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @strDate AND @stpDate
					AND JDT1.BaseRef NOT IN 
					(SELECT t5.DocEntry FROM dbo.OVPM T5 WHERE t5.CancelDate IS NOT NULL)) AS decimal(16,2))
			END
			FROM JDT1 
			JOIN OJDT Th ON Th.TransId = JDT1.TransId
			WHERE LEFT(JDt1.Ref1,5) = 'APDPI'  
			AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
			AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
			AND Th.RefDate BETWEEN @3rdMosStr AND @3rdMosStp
			AND JDT1.BaseRef NOT IN 
			(SELECT t5.DocEntry FROM dbo.OVPM T5 WHERE t5.CancelDate IS NOT NULL)),0)
		--END JE 3rd Month of the Quarter			
		END)
		AS [3rdMosAoTW]
	----end third month of the quarter

	,T2.BPLName AS [Branch]
FROM DPO5 T0
JOIN ODPO T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
JOIN VPM2 T3 ON T3.DocEntry = T1.DocNum AND T3.InvType = 204
JOIN OVPM T4 ON T4.DocNum = T3.DocNum AND T4.Canceled = 'N' --AND T4.U_WTAX <> 'N/A'
WHERE T4.TaxDate BETWEEN @strDate AND @stpDate
--END APDPI

UNION ALL

--APCM
SELECT

	T1.Cardname AS [DT]
	,ISNULL((T1.U_ALIAS_VENDOR),T1.Cardname) AS [DTTT]
	--,T3.DocNum as [DE]
	,ISNULL((T3.U_WTAXCOMCODE),'') AS [WCC]
--	,ISNULL((T1.U_wtaxComCode),'') AS [WCC]
--	,T1.CardCode AS [CC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
	--Card Name
	,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
			   'zzzzz'
		  ELSE
	           ISNULL((T1.U_ALIAS_VENDOR),(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null))
	       END) AS [RN]

	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		                FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		         'zzzzz'
		   ELSE
		         ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		                        FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		   END) AS 'NoC'
	--Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzzzz'
		   ELSE
	            ISNULL((T1.U_ALIAS_VENDOR),T1.CardName)
		   END) as NoC1

	,(SELECT U_ATC FROM OWHT WHERE OWHT.WTCode = T0.WTCode) AS [ATCCode]
	,(SELECT U_ATCDesc FROM OWHT WHERE OWHT.WTCode = T0.WTCode) AS [NoP]
	--first month of the quarter
	,CAST (ISNULL( (SELECT -1 * SUM(RPC5.TaxbleAmnt) FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
--		AND RPC5.WTCode = T0.WTCode
		
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL(16,2)) AS [1stMosAoIP]
		
	,CAST (ISNULL( (SELECT RPC5.Rate FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) AS [1stMosTR]
	,CAST (ISNULL( (SELECT -1 * RPC5.WTAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @1stMosStr AND @1stMosStp) ,0) AS DECIMAL (16,2)) AS [1stMosAoTW]
	--end first month of the quarter

	--second month of the quarter
	,CAST (ISNULL( (SELECT -1 * SUM(RPC5.TaxbleAmnt) FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
--		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL(16,2)) 
		AS [2ndMosAoIP]
	,CAST (ISNULL( (SELECT RPC5.Rate FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) AS [2ndMosTR]
	,CAST (ISNULL( (SELECT -1 * RPC5.WTAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @2ndMosStr AND @2ndMosStp) ,0) AS DECIMAL (16,2)) AS [2ndMosAoTW]
	--end second month of the quarter

	--third month of the quarter
	,CAST (ISNULL( (SELECT -1 * SUM(RPC5.TaxbleAmnt) FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
--		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL(16,2)) AS [3rdMosAoIP]
	,CAST (ISNULL( (SELECT RPC5.Rate FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) AS [3rdMosTR]
	,CAST (ISNULL( (SELECT -1 * RPC5.WTAmnt FROM RPC5
		WHERE RPC5.AbsEntry = T1.DocNum
		AND RPC5.WTCode = T0.WTCode
		AND T1.DocDate BETWEEN @3rdMosStr AND @3rdMosStp) ,0) AS DECIMAL (16,2)) AS [3rdMosAoTW]
	--end third month of the quarter
	,T2.BPLName AS [Branch]
FROM RPC5 T0
JOIN ORPC T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0 -- AND T1.U_WTax <> 'N/A'
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
JOIN VPM2 T3 ON T3.DocEntry = T1.DocNum AND T3.InvType = 19
JOIN OVPM T4 ON T4.DocNum = T3.DocNum AND T4.Canceled = 'N'
WHERE T4.TaxDate BETWEEN @strDate AND @stpDate
--END APCM
UNION ALL

--JOURNAL ENTRY 
SELECT
	  T2.CardName as [DT]
	 ,T2.CardName AS [DTTT] 
--	,T2.CardName  AS [DTT]
--	,T2.CardName  AS [DTTT]
--	  ,T0.DocEntry as [DE]
	  ,ISNULL((T0.U_wtaxComCode),'') AS [WCC]
	  ,ISNULL((SELECT ISNULL((OCRD.LicTradNum),'') FROM OCRD WHERE OCRD.CardCode = T2.CardCode),'') AS [TIN]
	  --Card Name
	  ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T2.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	               'zzzzz'
	  	     ELSE
	              ISNULL((SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T2.CardCode AND OCRD.ValidComm is null),'')
	         END) AS [RN]
	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T2.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzzzz'
		  ELSE
                 ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T2.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'

	  	  	     	  --Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T2.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	              'zzzzz'
	  	     ELSE
			     (SELECT OPCH.U_ALIAS_VENDOR FROM OPCH JOIN OCRD ON OCRD.CardCode = OPCH.CardCode WHERE OPCH.DocNum = T0.DocEntry GROUP BY OPCH.U_ALIAS_VENDOR) 
	       --     (SELECT OPCH.U_ALIAS_VENDOR FROM OPCH JOIN OCRD ON OCRD.CardCode = OPCH.CardCode WHERE OPCH.CardCode = T2.CardCode GROUP BY OPCH.U_ALIAS_VENDOR) 
				 -- ISNULL((T3.U_CUSTOMER),T3.U_ALIAS_VENDOR)
	  	     END) as [ALIAS]

	 ,(SELECT OWHT.U_ATC FROM OWHT WHERE OWHT.WTCode = T1.U_WTaxCode) AS [ATCCode]

	 ,T1.U_ATCName AS [NoP]

	  --first Month of the Quarter
		   ,ISNULL(CAST((SELECT SUM(VPM2.SumApplied) - SUM(OPCH.VatSum) + SUM(OPCH.WTSum)
		  FROM VPM2 
		  JOIN OPCH ON OPCH.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosAoIP]

	  	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp  AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosTR]


	  	  ,ISNULL(CAST((SELECT SUM(VPM2.U_WtaxPay )
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp  AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosAoTW]
	  --end first Month of the Quarter

	  --second Month of the Quarter
	   ,ISNULL(CAST((SELECT SUM(VPM2.SumApplied) - SUM(OPCH.VatSum) + SUM(OPCH.WTSum)
		  FROM VPM2 
		  JOIN OPCH ON OPCH.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosAoIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosTR]

	  ,ISNULL(CAST((SELECT SUM(VPM2.U_WtaxPay )
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosAoTW]
	 --end second Month of the Quarter

	  --third Month of the Quarter
	     ,ISNULL(CAST((SELECT SUM(VPM2.SumApplied) - SUM(OPCH.VatSum) + SUM(OPCH.WTSum)
		  FROM VPM2 
		  JOIN OPCH ON OPCH.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosAoIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosTR]

	  ,ISNULL(CAST((SELECT SUM(VPM2.U_WtaxPay )
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosAoTW]
	  --end third Month of the Quarter

	  ,T5.BPLName AS [Branch]

FROM VPM2 T0
JOIN OVPM T2 ON T2.DocNum = T0.DocNum AND T2.Canceled = 'N'
JOIN JDT1 T1 ON T0.U_wTaxComCode = T1.U_wTaxComCode 
JOIN OJDT T4 ON T4.Number = T0.DocEntry AND T4.TransId NOT IN (SELECT StornoToTr from OJDT WHERE StornoToTr IS NOT NULL)
LEFT JOIN OBPL T5 ON T2.BPLid = T5.BPLid AND T5.MAINBPL = 'N' AND T5.DISABLED = 'N' AND T4.TransId NOT IN (SELECT TransId from OJDT WHERE StornoToTr IS NOT NULL)
WHERE T2.TaxDate BETWEEN @strDate AND @stpDate
--END OF JOURNAL ENTRY
 UNION ALL

-- --JOURNAL ENTRY APDPI
SELECT

	T2.CardName  AS [DTT]
	,T2.CardName  AS [DTTT]
	  ,ISNULL((T0.U_wtaxComCode),'') AS [WCC]
	  ,ISNULL((SELECT ISNULL((OCRD.LicTradNum),'') FROM OCRD WHERE OCRD.CardCode = T2.CardCode),'') AS [TIN]
	  --Card Name
	  ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T2.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	               'zzzzz'
	  	     ELSE
	              ISNULL((SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T2.CardCode AND OCRD.ValidComm is null),'')
	         END) AS [RN]
	--Name of Customer
	,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T2.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzzzz'
		  ELSE
                 ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T2.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'

	  	  	     	  --Name of Customer
    ,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T2.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	              'zzzzz'
	  	     ELSE
	            (SELECT OPCH.U_ALIAS_VENDOR FROM OPCH JOIN OCRD ON OCRD.CardCode = OPCH.CardCode WHERE OPCH.DocNum = T0.DocEntry GROUP BY OPCH.U_ALIAS_VENDOR) 
				 -- ISNULL((T3.U_CUSTOMER),T3.U_ALIAS_VENDOR)
	  	     END) as [ALIAS]

	 ,(SELECT OWHT.U_ATC FROM OWHT WHERE OWHT.WTCode = T1.U_WTaxCode) AS [ATCCode]

	 ,T1.U_ATCName AS [NoP]

	  --first Month of the Quarter
		   ,ISNULL(CAST((SELECT SUM(VPM2.SumApplied) - SUM(ODPO.VatSum) + SUM(ODPO.WTSum)
		  FROM VPM2 
		  JOIN ODPO ON ODPO.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL )AS DECIMAL(16,2)),0) AS [1stMosAoIP]

	  	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosTR]


	  	  ,ISNULL(CAST((SELECT SUM(VPM2.U_WtaxPay )
		  FROM VPM2 
		  JOIN ODPO ON ODPO.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosAoTW]
	  --end first Month of the Quarter

	  --second Month of the Quarter
	 	 ,ISNULL(CAST((SELECT SUM(VPM2.SumApplied) - SUM(ODPO.VatSum) + SUM(ODPO.WTSum)
		  FROM VPM2 
		  JOIN ODPO ON ODPO.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosAoIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosTR]

	  ,ISNULL(CAST((SELECT SUM(VPM2.U_WtaxPay )
		  FROM VPM2 
		  JOIN ODPO ON ODPO.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosAoTW]
	 --end second Month of the Quarter

	  --third Month of the Quarter
	     ,ISNULL(CAST((SELECT SUM(VPM2.SumApplied) - SUM(ODPO.VatSum) + SUM(ODPO.WTSum)
		  FROM VPM2 
		  JOIN ODPO ON ODPO.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosAoIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosTR]

	  ,ISNULL(CAST((SELECT SUM(VPM2.U_WtaxPay )
		  FROM VPM2 
		  JOIN ODPO ON ODPO.DocNum = VPM2.DocEntry
		  WHERE VPM2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosAoTW]
	  --end third Month of the Quarter

	  ,T5.BPLName AS [Branch]


FROM VPM2 T0
JOIN OVPM T2 ON T2.DocNum = T0.DocNum AND T2.Canceled = 'N'
JOIN JDT1 T1 ON T0.U_wTaxComCode = T1.U_wTaxComCode --AND T0.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM OINV WHERE U_wTaxComCode IS NULL)
JOIN OJDT T4 ON T4.Number = T0.DocEntry AND T4.TransId NOT IN (SELECT StornoToTr from OJDT WHERE StornoToTr IS NOT NULL)
LEFT JOIN OBPL T5 ON T2.BPLid = T5.BPLid AND T5.MAINBPL = 'N' AND T5.DISABLED = 'N' AND T4.TransId NOT IN (SELECT TransId from OJDT WHERE StornoToTr IS NOT NULL)
WHERE T2.TaxDate BETWEEN @strDate AND @stpDate
--END OF JOURNAL ENTRY APDPI

) AS newTable
--WHERE newTable.DT like '%DRAGON%'
WHERE newTable.WCC IS NOT NULL AND newTable.WCC <> ''
--AND newTable.WCC LIKE 'KOROSTGS-V00016220220210%'
GROUP BY
	--newTable.CC
	newTable.ATCCode
	,newTable.DTTT
	,newTable.DT
--	,newTable.DE
	,newTable.WCC
	,newTable.NoC1
	,newTable.TIN
	,newTable.RN
	,newTable.NOC
	,newTable.NoP
	,newTable.Branch
	ORDER BY
	newTable.DT ASC,newTable.WCC asc
END