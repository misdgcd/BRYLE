--Start Date
DECLARE @strDate AS DATE = try_convert(date,'11.01.2021')
--Stop Date
DECLARE @stpDate AS DATE =try_convert(date,'11.30.2021
')

	SELECT 
		CAST(T.TM AS DATE) AS [TM]
		,T.TIN
		,T.RN
		,T.NoC
		,T.CA
		,CAST(SUM(T.Net) AS DECIMAL(16,2)) AS [Net]
		,CAST(SUM(T.VatExempt) AS DECIMAL(16,2)) AS [VatExempt]
		,CAST(SUM(T.ZeroRated) AS DECIMAL (16,2))AS [ZeroRated]
		,CAST(SUM(T.Taxable) AS DECIMAL (16,2)) AS [Taxable]
		,CAST(SUM(T.Services) AS DECIMAL (16,2)) AS [Services]
		,CAST(SUM(T.Fixed) AS DECIMAL(16,2)) AS [Fixed]
		,CAST(SUM(T.Goods) AS DECIMAL(16,2)) AS [Goods]
		--,CASE 
		--	WHEN SUM(T.Fixed) > 1000000 THEN CAST(SUM(T.Fixed) AS DECIMAL (16,2))
		--	ELSE '0'
		--END AS [GFixed]
		--,CASE 
		--	WHEN SUM(T.Fixed) < 1000000 THEN CAST(SUM(T.Fixed) AS DECIMAL (16,2))
		----	ELSE '0'
		--END AS [LFixed]
		,CAST(SUM(T.InputTax) AS DECIMAL(16,2)) AS [InputTax]
		,CAST(SUM(T.VatExempt) + SUM(T.ZeroRated) + SUM(T.Taxable) + SUM(T.InputTax) AS DECIMAL(16,2)) AS [Gross]
		--,CAST(SUM(T.Gross) AS DECIMAL(16,2)) AS 'Gross'
		,T.Branch
	FROM 
	(
	--Street+ ' ' + City + ' ' + ZipCode + ' ' + County 
	--A/P Invoice
	SELECT 
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0))  AS [TM]
		,T1.CardCode AS [Card]
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
		--Card Name
		,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm = 'N') AS [RN]
		--Name of Customer
		,(SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm = 'I') AS [NoC]
		--Address
		,ISNULL((SELECT COALESCE(Street + ' ' ,'') + COALESCE(City+ ' ','') + COALESCE(Zipcode+ ' ', '')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS [CA]
		--Net
		,ISNULL((SELECT PCH1.LineTotal 
					FROM PCH1 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum
					),0) AS [Net]
		--Vat Exempt
		,ISNULL((SELECT PCH1.LineTotal 
					FROM PCH1 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum 
					AND PCH1.VatGroup LIKE 'IVE%'),0) AS [VatExempt]
		--Zero Rated
		,ISNULL((SELECT PCH1.LineTotal 
					FROM PCH1
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum 
					AND PCH1.VatGroup LIKE 'IVZ%'),0) AS [ZeroRated]
		--Taxable
		,ISNULL((SELECT PCH1.LineTotal 
					FROM PCH1 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum 
					AND PCH1.VatGroup LIKE 'IVT%'),0) AS [Taxable]
		--Services
		,ISNULL((SELECT PCH1.LineTotal 
					FROM PCH1 
					JOIN OPCH ON OPCH.DocNum = PCH1.DocEntry 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum 
					AND OPCH.DocType = 'S' 
					AND PCH1.VatGroup LIKE 'IVT%'),0) AS [Services]
		--Goods
		,ISNULL((SELECT PCH1.LineTotal 
					FROM PCH1 
					JOIN OPCH ON OPCH.DocNum = PCH1.DocEntry 
					JOIN OITM ON OITM.ItemCode = PCH1.ItemCode 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum 
					AND OPCH.DocType = 'I' 
					AND OITM.ItemType = 'I' 
					AND PCH1.VatGroup LIKE 'IVT%'),0) AS [Goods]
		--Fixed Assets
		,ISNULL((SELECT PCH1.LineTotal 
					FROM PCH1 
					JOIN OPCH ON OPCH.DocNum = PCH1.DocEntry
					JOIN OITM ON OITM.ItemCode = PCH1.ItemCode 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum
					AND OPCH.DocType = 'I'
					AND OITM.ItemType = 'F' 
					AND PCH1.VatGroup LIKE 'IVT%'),0) AS [Fixed]
		--Input Tax
		,ISNULL((SELECT PCH1.VatSum 
					FROM PCH1 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum),0) AS [InputTax]
		----Gross Total (Net + Tax)
		--,ISNULL((SELECT PCH1.LineTotal 
		--			FROM PCH1 
		--			WHERE PCH1.DocEntry = T1.DocEntry 
		--			AND PCH1.LineNum = T0.LineNum
		--			AND PCH1.VatGroup LIKE 'IVT%')
		--		+(SELECT PCH1.VatSum 
		--			FROM PCH1 
		--			WHERE PCH1.DocEntry = T1.DocEntry 
		--			AND PCH1.LineNum = T0.LineNum),0) AS 'Gross'
		,T2.BPLName AS [Branch]
	FROM PCH1 T0
	JOIN OPCH T1 ON T1.DocNum = T0.DocEntry
	JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
	AND T1.CANCELED = 'N' AND T1.CardCode NOT IN ('V000107')
	AND T1.DocDate BETWEEN @strDate AND @stpDate
	UNION ALL
	--A/P Credit Memo
	SELECT 
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0))  AS [TM]
		,T1.CardCode AS 'Card'
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode), '') AS [TIN]
		--Card Name
		,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm = 'N') AS [RN]
		--Name of Customer
		,(SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm = 'I') AS [NoC]
		--Address
		,ISNULL((SELECT COALESCE(Street + ' ' ,'') + COALESCE(City+ ' ','') + COALESCE(Zipcode+ ' ', '')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS [CA]
		--Net
		,ISNULL((SELECT -1 * RPC1.LineTotal 
					FROM RPC1 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum),0) AS [Net]
		--Vat Exempt
		,ISNULL((SELECT -1 * RPC1.LineTotal 
					FROM RPC1 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum 
					AND RPC1.VatGroup LIKE 'IVE%'),0) AS [VatExempt]
		--Zero Rated
		,ISNULL((SELECT -1 * RPC1.LineTotal 
					FROM RPC1 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum 
					AND RPC1.VatGroup LIKE 'IVZ%'),0) AS [ZeroRated]
		--Taxable
		,ISNULL((SELECT -1 * RPC1.LineTotal 
					FROM RPC1 WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum 
					AND RPC1.VatGroup LIKE 'IVT%'),0) AS [Taxable]
		--Services
		,ISNULL((SELECT -1 * RPC1.LineTotal 
					FROM RPC1 JOIN ORPC ON ORPC.DocNum = RPC1.DocEntry 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum 
					AND ORPC.DocType = 'S'
					AND RPC1.VatGroup LIKE 'IVT%'),0) AS [Services]
		--Goods
		,ISNULL((SELECT -1 * RPC1.LineTotal 
					FROM RPC1 JOIN ORPC 
					ON ORPC.DocNum = RPC1.DocEntry 
					JOIN OITM ON OITM.ItemCode = RPC1.ItemCode 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum 
					AND ORPC.DocType = 'I' 
					AND OITM.ItemType = 'I'
					AND RPC1.VatGroup LIKE 'IVT%'),0) AS [Goods]
		--Fixed
		,ISNULL((SELECT -1 * RPC1.LineTotal 
					FROM RPC1 
					JOIN ORPC ON ORPC.DocNum = RPC1.DocEntry
					JOIN OITM ON OITM.ItemCode = RPC1.ItemCode 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum 
					AND ORPC.DocType = 'I'
					AND OITM.ItemType = 'F'
					AND RPC1.VatGroup LIKE 'IVT%'),0) AS [Fixed]
		--Tax
		,ISNULL((SELECT -1 * RPC1.VatSum 
					FROM RPC1 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum
					), 0) AS [InputTax]
		----Gross (Net + Tax)
		--,ISNULL((SELECT -1 * RPC1.LineTotal 
		--			FROM RPC1 
		--			WHERE RPC1.DocEntry = T1.DocEntry 
		--			AND RPC1.LineNum = T0.LineNum
		--			AND RPC1.VatGroup LIKE 'IVT%')
		--		-(SELECT 1 * RPC1.VatSum 
		--			FROM RPC1 
		--			WHERE RPC1.DocEntry = T1.DocEntry 
		--			AND RPC1.LineNum = T0.LineNum),0) AS 'Gross'
		,T2.BPLName AS [Branch]
	FROM RPC1 T0
	JOIN ORPC T1 ON T1.DocNum = T0.DocEntry
	JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
	AND T1.CANCELED = 'N' AND T1.CardCode NOT IN ('V000107')
	AND T1.DocDate BETWEEN @strDate AND @stpDate
	) AS T
	GROUP BY
		T.TM
		,T.Card
		,T.RN
		,T.TIN
		,T.NoC
		,T.CA
		,T.Branch
	ORDER BY
		T.TM
		,T.RN