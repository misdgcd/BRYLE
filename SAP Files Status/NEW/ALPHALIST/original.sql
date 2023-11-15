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
	ROW_NUMBER() OVER(ORDER BY T.RN ASC, T.Noc  ASC) AS 'Seq No.'
	,T.WCC   as 'Withholding Tax ComCode'
--	,T.DT AS [DT]
--	,T.DT AS [DTTT]
	,T.TIN AS 'Tin Number'
	,T.RN AS 'Corporation'
--	,T.DTTT  as 'Corporation'
	,(CASE WHEN T.ALIAS = '' THEN T.Noc ELSE T.ALIAS END) as 'Individual'
	,T.ATCCode AS 'Wtax Code'
	,T.NoP AS 'Wtax Decsription'
	,CAST(SUM(T.[1stMosIP]) AS DECIMAL(16,2)) AS '1st Mos Income Payment'
	,CAST(SUM(DISTINCT T.[1stMosTR]) AS INT) AS '1st Mos Tax Rate'
--	,CAST(SUM(T.[1stMosIP] * (T.[1stMosTR]/100))AS DECIMAL(16,2)) AS  '1st Mos Tax Withheld'
	,CAST(SUM(T.[1stMosTW])AS DECIMAL(16,2)) AS '1st Mos Tax Withheld'
	,CAST(SUM(T.[2ndMosIP])AS DECIMAL(16,2)) AS '2nd Mos Income Payment'
	,CAST(SUM(DISTINCT T.[2ndMosTR]) AS INT) AS '2nd Mos Tax Rate'
--	,CAST(SUM(T.[2ndMosIP] * (T.[2ndMosTR]/100))AS DECIMAL(16,2))AS  '2nd Mos Tax Withheld'
	,CAST(SUM(T.[2ndMosTW])AS DECIMAL(16,2)) AS '2nd Mos Tax Withheld'
	,CAST(SUM(T.[3rdMosIP])AS DECIMAL(16,2)) AS '3rd Mos Income Payment'
	,CAST(SUM(DISTINCT T.[3rdMosTR]) AS INT) AS '3rd Mos Tax Rate'
--	,CAST(SUM(T.[3rdMosIP]*( T.[3rdMosTR]/100))AS DECIMAL(16,2)) AS '3rd Mos Tax witheld'
	,CAST(SUM(T.[3rdMosTW])AS DECIMAL(16,2)) AS '3rd Mos Tax witheld'
	,CAST(SUM(T.[1stMosIP]) + SUM(T.[2ndMosIP]) + SUM(T.[3rdMosIP])AS DECIMAL(16,2)) AS 'TOTAL INCOME PAYMENT'
	,CAST(SUM(T.[1stMosTW]) + SUM(T.[2ndMosTW]) + SUM(T.[3rdMosTW])AS DECIMAL(16,2)) AS 'TOTAL TAX WITHELD'
	--,CAST(SUM(T.[1stMosIP] * (T.[1stMosTR]/100)) + SUM(T.[2ndMosIP] * (T.[2ndMosTR]/100)) + SUM(T.[3rdMosTW]*( T.[3rdMosTR]/100))AS DECIMAL(16,2)) AS 'TOTAL TAX WITHELD'
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
	--ISNULL((T1.CardName),'') AS [DT]
--	,ISNULL((T1.U_Customer),'') AS [DTT]
	ISNULL((T1.U_ALIAS_VENDOR),'') AS [DTTT]
	,(concat(T1.U_Customer,'',T1.CardName)) as [DT]
	,ISNULL((T1.U_wtaxComCode),T3.U_WTAXCOMCODE) AS [WCC]
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
	            ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR)
		   END) as [ALIAS]


---------------------------------------START QUERY HERE--------------------------------------

	
	,(SELECT U_ATC FROM OWHT WHERE WTCode = T0.WTCode) AS [ATCCode]
	
	,(SELECT U_ATCDesc
		FROM OWHT 
		WHERE OWHT.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @strDate AND @stpDate) AS [NoP]

	--first Month of the Quarter
	,(CASE	WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp THEN
	
	(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt 
	
	ELSE

	--TEST THIS QUERY--
		ISNULL(CAST((SELECT SUM(INV5.TaxbleAmnt)
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
	--	AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0)
		END)
		AS [1stMosIP]

	,ISNULL(CAST((SELECT INV5.Rate
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp ) AS DECIMAL(16,2)) ,0)AS [1stMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp THEN  
         (T3.U_WtaxPay)
     --  CAST(((T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt) * (T0.Rate/100) AS DECIMAL(16,2))  	
	--	((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)

		ELSE

		ISNULL(CAST((SELECT INV5.WTAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0)


		--1st month of the quarter JE
		+ ISNULL((SELECT top 1
			CASE
				WHEN JDT1.Debit <> 0 THEN 
					CAST((
					SELECT SUM(1*JDT1.Debit) FROM JDT1
					JOIN OJDT Th ON Th.TransId = JDT1.TransId
					WHERE LEFT(JDt1.Ref1,7) = 'A/R INV' 
					AND SUBSTRING(JDT1.Ref1,(PATINDEX('%[#]%',JDT1.Ref1)+1),10) = T1.DocNum
					AND JDT1.LineMemo = T1.U_wtaxComCode
					AND JDT1.TransType = 30 AND JDT1.ShortName = T0.Account
					AND Th.RefDate BETWEEN @1stMosStr AND @1stMosStp
					AND Th.TransId not in (SELECT th.StornoToTr FROM OJDT th WHERE th.stornototr is not null)
					AND Th.StornoToTr IS NULL
					AND Th.U_WTax = 'Received'
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
					AND Th.U_WTax = 'Received'
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
			AND Th.U_WTax = 'Received'
			),0)
			END)
			AS [1stMosTW]
	--end 1st month of the quarter JE
	--end first Month of the Quarter

	--second Month of the Quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp THEN
	(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt
	ELSE
	ISNULL(CAST((SELECT SUM(INV5.TaxbleAmnt)
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
	--	AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode) ) AS DECIMAL(16,2)) ,0)
		END)
		AS [2ndMosIP]

	,ISNULL(CAST((SELECT INV5.Rate
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0)AS [2ndMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp THEN  
	  
        (T3.U_WtaxPay)
     -- CAST(((T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt) * (T0.Rate/100) AS DECIMAL(16,2))
	--	((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
		
		ELSE

		ISNULL(CAST((SELECT INV5.WTAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0)
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
			END)
		AS [2ndMosTW]
	--end second Month of the Quarter

	--third Month of the Quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp THEN
	(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt
	ELSE
	ISNULL(CAST((SELECT SUM(INV5.TaxbleAmnt)
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
--		AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0)
		END)
		AS [3rdMosIP]

	,ISNULL(CAST((SELECT INV5.Rate
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0) AS [3rdMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp THEN
	   (T3.U_WtaxPay)  
    -- CAST(((T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt) * (T0.Rate/100) AS DECIMAL(16,2))
    --	((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
		 
		ELSE
		ISNULL(CAST((SELECT INV5.WTAmnt
		FROM INV5
		WHERE INV5.AbsEntry = T1.DocNum
		AND INV5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0)
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
JOIN OINV T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N'  AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
JOIN RCT2 T3 ON T3.DocEntry = T1.DocNum AND T3.InvType = 13
JOIN ORCT T4 ON T4.DocNum = T3.DocNum AND T4.Canceled = 'N'  AND T1.U_WTax <> 'N/A' -- AND T3.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode IS NOT NULL)
WHERE T4.TaxDate BETWEEN @strDate AND @stpDate
--END ARINV

UNION ALL

--ARDPI 
SELECT
--	ISNULL((T1.CardName),'') AS [DT]
--	,ISNULL((T1.U_Customer),T1.U_ALIAS_VENDOR) AS [DTT]
--	,ISNULL((T1.U_ALIAS_VENDOR),T1.CardName) AS [DTTT]
	(concat(T1.U_Customer,'',T1.CardName)) as [DT]
	,ISNULL((T1.U_ALIAS_VENDOR),'') AS [DTTT]
	,ISNULL((T1.U_wtaxComCode),T3.U_WTAXCOMCODE) AS [WCC]
	,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
	--Card Name
	,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	             'zzzzz'
		   ELSE
	             ISNULL((T1.U_ALIAS_VENDOR),(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null))
	       END) AS [RN]
	--Name of Customer
,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN'zzzzz'
ELSE
ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') END) AS 'NoC'
--Name of Customer
,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN 'zzzzz'
ELSE ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR) END) as [ALIAS]

---------------------------------------START QUERY HERE--------------------------------------

	,(SELECT U_ATC FROM OWHT
	WHERE WTCode = T0.WTCode) AS [ATCCode]
	,(SELECT U_ATCDesc 
		FROM OWHT 
		WHERE OWHT.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @strDate AND @stpDate) AS [NoP]
	--first Month of the Quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp THEN
	(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt 
	ELSE
	ISNULL(CAST((SELECT SUM(DPI5.TaxbleAmnt)
		FROM DPI5 
		WHERE DPI5.AbsEntry = T1.DocNum
	--	AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0) 
		END)
		AS [1stMosIP]

	,ISNULL(CAST((SELECT DPI5.Rate
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0) AS [1stMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp THEN  
         (T3.U_WtaxPay)
     --   ((T3.SumApplied/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
    --  ((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
	--	T3.U_WtaxPay
		ELSE
		ISNULL(CAST((SELECT DPI5.WTAmnt
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0) 
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
		END)
		AS [1stMosTW]
	--end first Month of the Quarter

	--second Month of the Quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp THEN
	(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt
	ELSE
	ISNULL(CAST((SELECT SUM(DPI5.TaxbleAmnt)
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
--		AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode) ) AS DECIMAL(16,2)) ,0)
		END)
		AS [2ndMosIP]

	,ISNULL(CAST((SELECT DPI5.Rate
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0) AS [2ndMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp THEN  
         (T3.U_WtaxPay)
    --    ((T3.SumApplied/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
    -- ((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
	--	T3.U_WtaxPay
		ELSE
		ISNULL(CAST((SELECT DPI5.WTAmnt
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0)
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
		END)
		AS [2ndMosTW]
	--end second Month of the Quarter

	--third Month of the Quarter
	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp THEN
	(T3.SumApplied / T1.DOCTOTAL) * T1.BaseAmnt
	ELSE
	ISNULL(CAST((SELECT SUM(DPI5.TaxbleAmnt )
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
--		AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0) 
		END)
		AS [3rdMosIP]

	,ISNULL(CAST((SELECT DPI5.Rate
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0) AS [3rdMosTR]

	,(CASE WHEN (T3.SUMAPPLIED) <> T1.DocTotal AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp THEN
     (T3.U_WtaxPay)
    -- ((T3.SumApplied/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
    --((T1.PaidSum/T1.DocTotal)*T1.BaseAmnt) *(T0.RATE/100)
	--	 T3.U_WtaxPay
		ELSE
		ISNULL(CAST((SELECT DPI5.WTAmnt
		FROM DPI5
		WHERE DPI5.AbsEntry = T1.DocNum
		AND DPI5.WTCode = T0.WTCode
		AND T4.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T1.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM JDT1 WHERE U_wTaxComCode = T3.U_wTaxComCode)) AS DECIMAL(16,2)) ,0)
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
		END)
		AS [3rdMosTW]	
	,T2.BPLName AS [Branch]
FROM DPI5 T0
JOIN ODPI T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
JOIN RCT2 T3 ON T3.DocEntry = T1.DocNum AND T3.InvType = 203
JOIN ORCT T4 ON T4.DocNum = T3.DocNum AND T4.Canceled = 'N' AND T1.U_WTax <> 'N/A'
WHERE T4.TaxDate BETWEEN @strDate AND @stpDate
--END ARDPI

UNION ALL

--ARCM
SELECT
--	ISNULL((T1.CardName),'') AS [DT]
--	,ISNULL((T1.U_Customer),T1.U_ALIAS_VENDOR) AS [DTT]
--	,ISNULL((T1.U_ALIAS_VENDOR),T1.CardName) AS [DTTT]
	(concat(T1.U_Customer,'',T1.CardName)) as [DT]
	,ISNULL((T1.U_ALIAS_VENDOR),'') AS [DTTT]
--	,T1.DocNum AS [DE]
	,ISNULL((T1.U_wtaxComCode),T3.U_WTAXCOMCODE) AS [WCC]
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
	            ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR)
		   END) as [ALIAS]


	,(SELECT U_ATC FROM OWHT
	WHERE WTCode = T0.WTCode) AS [ATCCode]
	,(SELECT U_ATCDesc 
		FROM OWHT 
		WHERE OWHT.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @strDate AND @stpDate) AS [NoP]
	--first Month of the Quarter
	,ISNULL(CAST((SELECT -1 * SUM(RIN5.TaxbleAmnt)
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
--		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0) AS [1stMosIP]
	,ISNULL(CAST((SELECT RIN5.Rate
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0) AS [1stMosTR]
	,ISNULL(CAST((SELECT -1 * RIN5.WTAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @1stMosStr AND @1stMosStp) AS DECIMAL(16,2)) ,0) AS [1stMosTW]
	--end first Month of the Quarter
	--second Month of the Quarter
	,ISNULL(CAST((SELECT -1 * SUM(RIN5.TaxbleAmnt)
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
--		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0) AS [2ndMosIP]
	,ISNULL(CAST((SELECT RIN5.Rate
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0) AS [2ndMosTR]
	,ISNULL(CAST((SELECT -1 * RIN5.WTAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp) AS DECIMAL(16,2)) ,0) AS [2ndMosTW]
	--end second Month of the Quarter
	--third Month of the Quarter
	,ISNULL(CAST((SELECT -1 * SUM(RIN5.TaxbleAmnt)
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
--		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0) AS [3rdMosIP]
	,ISNULL(CAST((SELECT RIN5.Rate
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0) AS [3rdMosTR]
	,ISNULL(CAST((SELECT -1 * RIN5.WTAmnt
		FROM RIN5
		WHERE RIN5.AbsEntry = T1.DocNum
		AND RIN5.WTCode = T0.WTCode
		AND T1.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp) AS DECIMAL(16,2)) ,0) AS [3rdMosTW]
	,T2.BPLName AS [Branch]
FROM RIN5 T0
JOIN ORIN T1 ON T1.DocNum = T0.AbsEntry AND T1.CANCELED = 'N' AND T0.WTAmnt <> 0 --AND  T1.U_WTax <> 'N/A'
JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
JOIN RCT2 T3 ON T3.DocEntry = T1.DocNum AND T3.InvType = 14
JOIN ORCT T4 ON T4.DocNum = T3.DocNum AND T4.Canceled = 'N' 
WHERE T1.TaxDate BETWEEN @strDate AND @stpDate

UNION ALL

--JOURNAL ENTRY OINV
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
	            (SELECT OINV.U_ALIAS_VENDOR FROM OINV JOIN OCRD ON OCRD.CardCode = OINV.CardCode WHERE OINV.CardCode = T2.CardCode GROUP BY OINV.U_ALIAS_VENDOR) 
				 -- ISNULL((T3.U_CUSTOMER),T3.U_ALIAS_VENDOR)
	  	     END) as [ALIAS]

	 ,(SELECT OWHT.U_ATC FROM OWHT WHERE OWHT.WTCode = T1.U_WTaxCode) AS [ATCCode]

	 ,T1.U_ATCName AS [NoP]

	  --first Month of the Quarter
		  ,ISNULL(CAST((SELECT SUM(RCT2.SumApplied) - SUM(OINV.VatSum) + SUM(OINV.WTSum)
		  FROM RCT2 
		  JOIN OINV ON OINV.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL )AS DECIMAL(16,2)),0) AS [1stMosIP]

	  	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosTR]


	  	  ,ISNULL(CAST((SELECT SUM(RCT2.U_WtaxPay )
		  FROM RCT2 
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosTW]
	  --end first Month of the Quarter

	  --second Month of the Quarter
	    ,ISNULL(CAST((SELECT SUM(RCT2.SumApplied) - SUM(OINV.VatSum) + SUM(OINV.WTSum)
		  FROM RCT2 
		  JOIN OINV ON OINV.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosTR]

	  ,ISNULL(CAST((SELECT SUM(RCT2.U_WtaxPay )
		  FROM RCT2 
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosTW]
	 --end second Month of the Quarter

	  --third Month of the Quarter
	    ,ISNULL(CAST((SELECT SUM(RCT2.SumApplied) - SUM(OINV.VatSum) + SUM(OINV.WTSum)
		  FROM RCT2 
		  JOIN OINV ON OINV.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosTR]

	  ,ISNULL(CAST((SELECT SUM(RCT2.U_WtaxPay )
		  FROM RCT2 
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosTW]
	  --end third Month of the Quarter

	  ,T5.BPLName AS [Branch]


FROM RCT2 T0
JOIN ORCT T2 ON T2.DocNum = T0.DocNum AND T2.Canceled = 'N'
JOIN JDT1 T1 ON T0.U_wTaxComCode = T1.U_wTaxComCode --AND T0.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM OINV WHERE U_wTaxComCode IS NULL)
JOIN OJDT T4 ON T4.Number = T0.DocEntry AND T4.TransId NOT IN (SELECT StornoToTr from OJDT WHERE StornoToTr IS NOT NULL)
LEFT JOIN OBPL T5 ON T2.BPLid = T5.BPLid AND T5.MAINBPL = 'N' AND T5.DISABLED = 'N' AND T4.TransId NOT IN (SELECT TransId from OJDT WHERE StornoToTr IS NOT NULL)
WHERE T2.TaxDate BETWEEN @strDate AND @stpDate
--END OF JOURNAL ENTRY OINV

UNION ALL

--JOURNAL ENTRY ARDPI
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
	            (SELECT OINV.U_ALIAS_VENDOR FROM OINV JOIN OCRD ON OCRD.CardCode = OINV.CardCode WHERE OINV.CardCode = T2.CardCode GROUP BY OINV.U_ALIAS_VENDOR) 
				 -- ISNULL((T3.U_CUSTOMER),T3.U_ALIAS_VENDOR)
	  	     END) as [ALIAS]

	 ,(SELECT OWHT.U_ATC FROM OWHT WHERE OWHT.WTCode = T1.U_WTaxCode) AS [ATCCode]

	 ,T1.U_ATCName AS [NoP]

	  --first Month of the Quarter
		  ,ISNULL(CAST((SELECT SUM(RCT2.SumApplied) - SUM(ODPI.VatSum) + SUM(ODPI.WTSum)
		  FROM RCT2 
		  JOIN ODPI ON ODPI.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL )AS DECIMAL(16,2)),0) AS [1stMosIP]

	  	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosTR]


	  	  ,ISNULL(CAST((SELECT SUM(RCT2.U_WtaxPay )
		  FROM RCT2 
		  JOIN ODPI ON ODPI.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [1stMosTW]
	  --end first Month of the Quarter

	  --second Month of the Quarter
	 	,ISNULL(CAST((SELECT SUM(RCT2.SumApplied) - SUM(ODPI.VatSum) + SUM(ODPI.WTSum)
		  FROM RCT2 
		  JOIN ODPI ON ODPI.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosTR]

	  ,ISNULL(CAST((SELECT SUM(RCT2.U_WtaxPay )
		  FROM RCT2 
		  JOIN ODPI ON ODPI.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [2ndMosTW]
	 --end second Month of the Quarter

	  --third Month of the Quarter
	    ,ISNULL(CAST((SELECT SUM(RCT2.SumApplied) - SUM(ODPI.VatSum) + SUM(ODPI.WTSum)
		  FROM RCT2 
		  JOIN ODPI ON ODPI.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_wTaxComCode = T1.U_wTaxComCode AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosTR]

	  ,ISNULL(CAST((SELECT SUM(RCT2.U_WtaxPay )
		  FROM RCT2 
		  JOIN ODPI ON ODPI.DocNum = RCT2.DocEntry
		  WHERE RCT2.DocEntry = T0.DocEntry AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp AND T0.U_wTaxComCode IS NOT NULL)AS DECIMAL(16,2)),0) AS [3rdMosTW]
	  --end third Month of the Quarter

	  ,T5.BPLName AS [Branch]


FROM RCT2 T0
JOIN ORCT T2 ON T2.DocNum = T0.DocNum AND T2.Canceled = 'N'
JOIN JDT1 T1 ON T0.U_wTaxComCode = T1.U_wTaxComCode --AND T0.U_wTaxComCode NOT IN (SELECT U_wTaxComCode FROM OINV WHERE U_wTaxComCode IS NULL)
JOIN OJDT T4 ON T4.Number = T0.DocEntry AND T4.TransId NOT IN (SELECT StornoToTr from OJDT WHERE StornoToTr IS NOT NULL)
LEFT JOIN OBPL T5 ON T2.BPLid = T5.BPLid AND T5.MAINBPL = 'N' AND T5.DISABLED = 'N' AND T4.TransId NOT IN (SELECT TransId from OJDT WHERE StornoToTr IS NOT NULL)
WHERE T2.TaxDate BETWEEN @strDate AND @stpDate
--END OF JOURNAL ENTRY ARDPI

) AS T
WHERE T.DT LIKE '%BALDON%' -- OR T.DT LIKE '%UNKNOWNWALK-IN_WTAX%' OR T.DT LIKE '%VFRESHWALK-IN_WTAX%' OR T.DT LIKE '%BADIN%'
AND T.WCC IS NOT NULL AND T.WCC <> ''
AND T.ATCCode NOT IN ('WV010','WV020')
GROUP BY
	T.DT
--	,T.DTT
	,T.DTTT
	,T.WCC
	,T.ATCCode
	,T.ALIAS
	,T.TIN
	,T.RN
	,T.NoC
	,T.NoP
	,T.Branch
	,T.WCC
	ORDER BY
	T.DT ASC,T.RN ASC
END