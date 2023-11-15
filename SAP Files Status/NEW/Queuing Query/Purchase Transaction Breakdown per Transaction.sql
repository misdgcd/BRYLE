--Start Date
DECLARE @strDate AS DATE =try_convert(date,'2021-12-10')
DECLARE @stpDate AS DATE =try_convert(date,'2021-12-31')

	SELECT 
		CAST(T.TM AS DATE) AS [TM]
		,T.TIN
		,T.RN
		,(CASE WHEN T.RN = '' THEN T.ALIAS  ELSE T.ALIAS END) as NoC

		,REPLACE(REPLACE(REPLACE((CASE WHEN T.CA = '' THEN T.CAS ELSE T.CAS END),'PHILIPPINES','PH'),'PH,', 'PHILIPPINES'),'CITY','CITY PHILIPPINES') as CA

		,CAST((T.Net) AS DECIMAL(16,2)) AS [Net]
		
		,CAST((T.VatExempt) AS DECIMAL(16,2)) AS VatExempts

		,CAST((T.ZeroRated) AS DECIMAL (16,2))AS [ZeroRated]

		,CAST((T.Taxable) AS DECIMAL (16,2)) AS [Taxable]

		 ,CAST((T.Services) AS DECIMAL (16,2)) AS [Services]

		 ,CAST((T.Services_QTY) AS DECIMAL (16,2)) AS [Services_QTY]

		,CAST((T.Fixed) AS DECIMAL(16,2)) AS [Fixed]

		,CAST((T.Goods) AS DECIMAL(16,2)) AS [Goods]
		,CAST((T.Goods_QTY) AS DECIMAL(16,2)) AS [Goods_QTY]

		--,CASE 
		--	WHEN SUM(T.Fixed) > 1000000 THEN CAST(SUM(T.Fixed) AS DECIMAL (16,2))
		--	ELSE '0'
		--END AS [GFixed]
		--,CASE 
		--	WHEN SUM(T.Fixed) < 1000000 THEN CAST(SUM(T.Fixed) AS DECIMAL (16,2))
		----	ELSE '0'
		--END AS [LFixed]
		,CAST((T.InputTax) AS DECIMAL(16,2)) AS [InputTax]
		,CAST((T.WTApplied) AS DECIMAL(16,2)) AS [WTApplied]
--		,CAST(SUM(T.Taxable) + SUM(T.Services) + SUM(T.Fixed) + SUM(T.Goods) + SUM(T.InputTax) + SUM(-T.WTApplied) AS DECIMAL(16,2)) AS [Gross]

		
		,CAST (			 CASE WHEN T.Services_QTY <> 0 THEN 
						(T.Taxable) + (T.Services) + (T.Fixed) + (T.Goods) + (T.InputTax) 
					
					ELSE
						(T.Taxable) +  + (T.Fixed) + (T.Goods) + (T.InputTax) END AS DECIMAL(16,2))
						AS [Gross]

 --       ,CAST((T.Taxable) + (T.Services) + (T.Fixed) + (T.Goods) + (T.InputTax)  AS DECIMAL(16,2)) AS [Gross]
		  
		--,CAST(SUM(T.Gross) AS DECIMAL(16,2)) AS 'Gross'
		,T.Branch
	FROM 
	(
	--Street+ ' ' + City + ' ' + ZipCode + ' ' + County 
	--A/P Invoice
	SELECT 
		--YYYY-MM
		T1.DocDate as [TM]
	--	DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0))  AS [TM]
	--	,T1.CardCode AS [Card]
		--TINumber
		,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
		--TINumber2
	--	,ISNULL((SELECT OPCH.U_TIN FROM OPCH WHERE OPCH.DocEntry = T0.DocEntry),'') AS [TINS]
		--Card Name
		,ISNULL((SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [RN]
		--ALIAS NAME
		,ISNULL((T1.U_ALIAS_VENDOR),T1.Cardname) AS [ALIAS]
--		,ISNULL((SELECT Distinct Coalesce(OPCH.U_ALIAS_VENDOR,'') FROM OPCH WHERE OPCH.DocNum = T0.DocEntry),'') AS [ALIAS]
		--CUSTOMER NAME
--		,ISNULL((SELECT Distinct Coalesce(OPCH.U_CUSTOMER,'') FROM OPCH WHERE OPCH.DocNum = T0.DocEntry),'') AS [CN]
		--Name of Customer
		,ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [NoC]
		--Address
		,ISNULL((SELECT COALESCE(Street + ' ' ,'') + COALESCE(City+ ' ','') + COALESCE(Zipcode+ ' ', '')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS [CA]
		,ISNULL((T1.U_ADDRESS),T2.City) as [CAS]
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

		--Service
		,ISNULL((SELECT PCH1.LineTotal 
					FROM PCH1 
					JOIN OPCH ON OPCH.DocNum = PCH1.DocEntry 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum 
					AND OPCH.DocType = 'S' 
					AND PCH1.VatGroup LIKE 'IVT%'),0) AS [Services]

		--Service QTY
		,ISNULL((SELECT PCH1.Quantity 
					FROM PCH1 
					JOIN OPCH ON OPCH.DocNum = PCH1.DocEntry 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum 
					AND OPCH.DocType = 'S' 
					AND PCH1.VatGroup LIKE 'IVT%'),0) AS [Services_QTY]



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

		--Goods
		,ISNULL((SELECT PCH1.Quantity 
					FROM PCH1 
					JOIN OPCH ON OPCH.DocNum = PCH1.DocEntry 
					JOIN OITM ON OITM.ItemCode = PCH1.ItemCode 
					WHERE PCH1.DocEntry = T1.DocEntry 
					AND PCH1.LineNum = T0.LineNum 
					AND OPCH.DocType = 'I' 
					AND OITM.ItemType = 'I' 
					AND PCH1.VatGroup LIKE 'IVT%'),0) AS [Goods_QTY]


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
		,ISNULL((SELECT OPCH.WTSum
					From OPCH
					WHERE T0.DocEntry = OPCH.DocEntry
					),0) as [WTApplied]


		,T2.BPLName AS [Branch]
		,'AP PURCHASE INVOICE' AS [RM]
	FROM PCH1 T0
	JOIN OPCH T1 ON T1.DocNum = T0.DocEntry
	JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
	AND T1.CANCELED = 'N' AND T1.CardCode NOT IN ('V000107')
	AND T1.DocDate BETWEEN @strDate AND @stpDate
	UNION ALL
	--A/P Credit Memo
	SELECT 
		--YYYY-MM
		T1.DocDate as [TM]
	--	DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0))  AS [TM]
	--	,T1.CardCode AS [Card]
		--TINumber
		,ISNULL((SELECT ISNULL((OCRD.LicTradNum),T1.U_TIN) FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
		--TINumber
	--	,ISNULL((SELECT ORPC.U_TIN FROM ORPC WHERE ORPC.DocEntry = T0.DocEntry),'') AS [TINS]
		--Card Name
		,ISNULL((SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [RN]
		--ALIAS NAME
		,ISNULL((T1.U_ALIAS_VENDOR),T1.Cardname) AS [ALIAS]
--		,ISNULL((SELECT Distinct Coalesce(ORPC.U_ALIAS_VENDOR,'') FROM ORPC WHERE ORPC.DocNum = T0.DocEntry),'') AS [ALIAS]
		--CUSTOMER NAME
--		,ISNULL((SELECT Distinct Coalesce(ORPC.U_CUSTOMER,'') FROM ORPC WHERE ORPC.DocNum = T0.DocEntry),'') AS [CN]
		--Name of Customer
		,ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [NoC]
		--Address
		,ISNULL((SELECT COALESCE(Street + ' ' ,'') + COALESCE(City+ ' ','') + COALESCE(Zipcode+ ' ', '')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS [CA]
		,ISNULL((T1.U_ADDRESS),T2.City) as [CAS]
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


		--Services
		,ISNULL((SELECT -1 * RPC1.Quantity 
					FROM RPC1 JOIN ORPC ON ORPC.DocNum = RPC1.DocEntry 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum 
					AND ORPC.DocType = 'S'
					AND RPC1.VatGroup LIKE 'IVT%'),0) AS [Services_QTY]


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

		--Goods
		,ISNULL((SELECT -1 * RPC1.Quantity 
					FROM RPC1 JOIN ORPC 
					ON ORPC.DocNum = RPC1.DocEntry 
					JOIN OITM ON OITM.ItemCode = RPC1.ItemCode 
					WHERE RPC1.DocEntry = T1.DocEntry 
					AND RPC1.LineNum = T0.LineNum 
					AND ORPC.DocType = 'I' 
					AND OITM.ItemType = 'I'
					AND RPC1.VatGroup LIKE 'IVT%'),0) AS [Goods_QTY]

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

		,ISNULL((SELECT -1*ORPC.WTSum
					From ORPC
					WHERE T0.DocEntry = ORPC.DocEntry
					),0) as [WTApplied]


		,T2.BPLName AS [Branch]
		,'AP PURCHASE CREDIT MEMO' AS [RM]
	FROM RPC1 T0
	JOIN ORPC T1 ON T1.DocNum = T0.DocEntry
	JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
	AND T1.CANCELED = 'N' AND T1.CardCode NOT IN ('V000107')
	AND T1.DocDate BETWEEN @strDate AND @stpDate
	) AS T
--	GROUP BY
--		T.TM
--		,T.Card
--		,T.RN
--		,T.TIN
--		,T.NoC
--		,T.CA
--		,T.Branch
--		,T.TINS
--		,T.CN
--		,T.ALIAS
	ORDER BY
		T.TM
		,T.RN;

