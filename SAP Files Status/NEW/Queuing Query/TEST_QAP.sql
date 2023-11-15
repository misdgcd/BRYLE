--Specify the Year
DECLARE @year AS NVARCHAR(4) = YEAR('2022')
--Specify the Quarter Period
DECLARE @qtr AS INT = 1
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
	  ,T.DT  as [DT]
	  ,T.WCC   as 'Withholding Tax ComCode'
	  ,T.TIN AS 'Tin Number'
	  ,T.RN AS 'Corporation'
	  ,(CASE WHEN T.ALIAS = '' THEN T.Noc ELSE T.ALIAS END) as 'Individual'
	  ,T.ATCCode AS 'Wtax Code'
	  ,T.NoP AS 'Wtax Decsription'
	  ,CAST(SUM(T.[1stMosIP]) AS DECIMAL(16,2)) AS '1st Mos Income Payment'
	  ,CAST(SUM(DISTINCT T.[1stMosTR]) AS INT) AS '1st Mos Tax Rate'
	  ,SUM(T.[1stMosTW]) AS '1st Mos Tax Withheld'
	  ,CAST(SUM(T.[2ndMosIP])AS DECIMAL(16,2)) AS '2nd Mos Income Payment'
	  ,CAST(SUM(DISTINCT T.[2ndMosTR]) AS INT) AS '2nd Mos Tax Rate'
	  ,SUM(T.[2ndMosTW]) AS '2nd Mos Tax Withheld'
	  ,CAST(SUM(T.[1stMosIP]) + SUM(T.[2ndMosIP]) + SUM(T.[3rdMosIP])AS DECIMAL(16,2)) AS 'TOTAL INCOME PAYMENT'
	  ,CAST(SUM(T.[1stMosTW]) + SUM(T.[2ndMosTW]) + SUM(T.[3rdMosTW])AS DECIMAL(16,2)) AS 'TOTAL TAX WITHELD'
	  ,@year AS 'YEAR'
	  ,CASE
	  	  WHEN @qtrEnding = '3' THEN 'MARCH'
	  	  WHEN @qtrEnding = '6' THEN 'JUNE'
	  	  WHEN @qtrEnding = '9' THEN 'SEPTEMBER'
	  	  WHEN @qtrEnding = '12' THEN 'DECEMBER'
	  	  END AS 'MONTH'
	  ,T.Branch 
FROM (
--JOURNAL ENTRY
SELECT
	  T2.CardName as [DT]
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
	            (SELECT OPCH.U_ALIAS_VENDOR FROM OPCH JOIN OCRD ON OCRD.CardCode = OPCH.CardCode WHERE OPCH.CardCode = T2.CardCode GROUP BY OPCH.U_ALIAS_VENDOR) 
				 -- ISNULL((T3.U_CUSTOMER),T3.U_ALIAS_VENDOR)
	  	     END) as [ALIAS]

	 ,(SELECT OWHT.U_ATC FROM OWHT WHERE OWHT.WTCode = T1.U_WTaxCode) AS [ATCCode]

	 ,T1.U_ATCName AS [NoP]

	  --first Month of the Quarter
		  ,ISNULL(CAST((SELECT VPM2.SumApplied
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND VPM2.InvoiceId = 1 AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp)AS DECIMAL(16,2)),0) AS [1stMosIP]

	  	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_DOCNUM = T1.U_DOCNUM  AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp)AS DECIMAL(16,2)),0) AS [1stMosTR]


	  	  ,ISNULL(CAST((SELECT VPM2.U_WtaxPay 
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND VPM2.InvoiceId = 1 AND T2.TaxDate BETWEEN @1stMosStr AND @1stMosStp)AS DECIMAL(16,2)),0) AS [1stMosTW]
	  --end first Month of the Quarter

	  --second Month of the Quarter
	  ,ISNULL(CAST((SELECT VPM2.SumApplied 
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND VPM2.InvoiceId = 1 AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp)AS DECIMAL(16,2)),0) AS [2ndMosIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_DOCNUM = T1.U_DOCNUM AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp)AS DECIMAL(16,2)),0) AS [2ndMosTR]

	  ,ISNULL(CAST((SELECT VPM2.U_WtaxPay 
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND VPM2.InvoiceId = 1 AND T2.TaxDate BETWEEN @2ndMosStr AND @2ndMosStp)AS DECIMAL(16,2)),0) AS [2ndMosTW]
	 --end second Month of the Quarter

	  --third Month of the Quarter
	  ,ISNULL(CAST((SELECT VPM2.SumApplied 
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND VPM2.InvoiceId = 1 AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp)AS DECIMAL(16,2)),0) AS [3rdMosIP]

	  ,ISNULL(CAST((SELECT JDT1.U_WTaxRate 
		  FROM JDT1 
		  WHERE JDT1.U_DOCNUM = T1.U_DOCNUM AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp)AS DECIMAL(16,2)),0) AS [3rdMosTR]

	  ,ISNULL(CAST((SELECT VPM2.U_WtaxPay 
		  FROM VPM2 
		  WHERE VPM2.DocEntry = T0.DocEntry AND VPM2.InvoiceId = 1 AND T2.TaxDate BETWEEN @3rdMosStr AND @3rdMosStp)AS DECIMAL(16,2)),0) AS [3rdMosTW]
	  --end third Month of the Quarter

	  ,T5.BPLName AS [Branch]


FROM VPM2 T0
JOIN OVPM T2 ON T2.DocNum = T0.DocNum AND T2.Canceled = 'N'
JOIN JDT1 T1 ON T0.DocNum = T1.U_DOCnUM 
--LEFT JOIN ODPI T3 ON T3.DocNum = T1.DocEntry
JOIN OJDT T4 ON T4.U_DocNum = T2.DocNum AND T4.TransId NOT IN (SELECT StornoToTr from OJDT WHERE StornoToTr IS NOT NULL)
LEFT JOIN OBPL T5 ON T2.BPLid = T5.BPLid AND T5.MAINBPL = 'N' AND T5.DISABLED = 'N' AND T4.TransId NOT IN (SELECT TransId from OJDT WHERE StornoToTr IS NOT NULL)
WHERE T2.TaxDate BETWEEN @strDate AND @stpDate
--END OF JOURNAL ENTRY
) AS T
GROUP BY

	  T.DT
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
	  T.DT ASC,T.RN ASC,T.ALIAS ASC
END
--END ARINV