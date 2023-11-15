DECLARE @strDate AS DATE = try_convert(date,'2021-11-02')
DECLARE @stpDate AS DATE = try_convert(date,'2021-12-02')
	SELECT 
		CAST(T.TM AS DATE) [TM]
		,T.TIN
		,T.RN
		,T.NoC
		,T.CA
		,CAST(SUM(T.Net) AS DECIMAL(16,2)) AS [NET]
		,CAST(SUM(T.VatExempt) AS DECIMAL(16,2)) AS [VatExmpt]
		,CAST(SUM(T.ZeroRated) AS DECIMAL (16,2))AS [ZeroRated]
		,CAST(SUM(T.Taxable) AS DECIMAL (16,2)) AS [Taxable]
		,CAST(SUM(T.InputTax) AS DECIMAL(16,2)) AS [Tax]
		,CAST(SUM(T.VatExempt) + SUM(T.ZeroRated) + SUM(T.Taxable) + SUM(T.InputTax) AS DECIMAL(16,2)) AS [GrossTotal]
		,T.Branch
	FROM 
	(
	--A/R Invoice
	SELECT 
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0))  AS [TM]
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
		--Card Name
		,ISNULL((SELECT COALESCE(OCRD.CardName,'') FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [RN]
		--Name of Customer
		,ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'') 
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS 'NoC'
		--Address
		,ISNULL((select Distinct Coalesce(Block+ ', ','')+ '' +Coalesce(Street+' ','')+ '' +Coalesce(City+' ','')+''+Coalesce(Country+' ','')+''+Coalesce(Zipcode,'')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS 'CA'
		--Net
		,ISNULL((SELECT INV1.LineTotal 
					FROM INV1 
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum
					),0) AS [Net]
		--Vat Exempt
		,ISNULL((SELECT INV1.LineTotal 
					FROM INV1 
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum 
					AND INV1.VatGroup LIKE 'OVE%'),0) AS [VatExempt]
		--Zero Rated
		,ISNULL((SELECT INV1.LineTotal 
					FROM INV1
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum 
					AND INV1.VatGroup LIKE 'OVZ%'),0) AS [ZeroRated]
		--Taxable
		,ISNULL((SELECT INV1.LineTotal 
					FROM INV1 
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum 
					AND INV1.VatGroup LIKE 'OVT%'),0) AS [Taxable]
		--Input Tax
		,ISNULL((SELECT INV1.VatSum 
					FROM INV1 
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum),0) AS [InputTax]
		,T2.BPLName AS [Branch]
	FROM INV1 T0
	JOIN OINV T1 ON T1.DocNum = T0.DocEntry
	JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
	AND T1.CANCELED = 'N' AND T1.DocDate BETWEEN @strDate AND @stpDate
	
	UNION ALL
	--A/R Credit Memo
	SELECT 
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0)) AS [TM]
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode), '') AS [TIN]
		--Card Name
		,ISNULL((SELECT COALESCE(OCRD.CardName,'') FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [RN]
		--Name of Customer
		,ISNULL((Select Distinct Coalesce(Lastname+ ', ' , '') + '' + Coalesce(Firstname+ ' ','')+ '' +Coalesce(Middlename,'')
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS 'NoC'
		--Address
		,ISNULL((select Distinct Coalesce(Block+ ', ','')+ '' +Coalesce(Street+' ','')+ '' +Coalesce(City+' ','')+''+Coalesce(Country+' ','')+''+Coalesce(Zipcode,'')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS 'CA'
		--Net
		,ISNULL((SELECT -1 * RIN1.LineTotal 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
					AND RIN1.LineNum = T0.LineNum),0) AS [Net]
		--Vat Exempt
		,ISNULL((SELECT -1 * RIN1.LineTotal 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
					AND RIN1.LineNum = T0.LineNum 
					AND RIN1.VatGroup LIKE 'OVE%'),0) AS [VatExempt]
		--Zero Rated
		,ISNULL((SELECT -1 * RIN1.LineTotal 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
					AND RIN1.LineNum = T0.LineNum 
					AND RIN1.VatGroup LIKE 'OVZ%'),0) AS [ZeroRated]
		--Taxable
		,ISNULL((SELECT -1 * RIN1.LineTotal 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
					AND RIN1.LineNum = T0.LineNum 
					AND RIN1.VatGroup LIKE 'OVT%'),0) AS [Taxable]
		--Tax
		,ISNULL((SELECT -1 * RIN1.VatSum 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
					AND RIN1.LineNum = T0.LineNum), 0) AS [InputTax]
		,T2.BPLName AS [Branch]
	FROM RIN1 T0
	JOIN ORIN T1 ON T1.DocNum = T0.DocEntry
	JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
	AND T1.CANCELED = 'N' AND T1.DocDate BETWEEN @strDate AND @stpDate
	) AS T
	GROUP BY
		T.TM
		,T.RN
		,T.TIN
		,T.NoC
		,T.CA
		,T.Branch
	ORDER BY
		T.TM
		,T.RN
