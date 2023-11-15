DECLARE @strDate AS DATE =try_convert(date,'2021-11-02')
DECLARE @stpDate AS DATE =try_convert(date,'2021-12-07')
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
		,CAST(SUM(T.InputTax) AS DECIMAL(16,2)) AS [InputTax]
		,CAST(SUM(T.VatExempt) + SUM(T.ZeroRated) + SUM(T.Taxable) + SUM(T.InputTax) AS DECIMAL(16,2)) AS [Gross]
	--	,CAST(SUM(T.NET_CM) AS DECIMAL(16,2)) AS [NET_CM]
	--	,CAST(SUM(T.TAX_CM) AS DECIMAL(16,2)) AS [TAX_CM]
		,T.Branch
	FROM 
	(
	--Street+ ' ' + City + ' ' + ZipCode + ' ' + County 
	--A/P Invoice
	SELECT 
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T2.DocDate) + 1, 0))  AS [TM]
		,T2.CardCode AS [Card]
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T2.CardCode),'') AS [TIN]
		--Card Name
		,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T2.CardCode AND OCRD.ValidComm is null) AS [RN]
		--Name of Customer
		,(SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T2.CardCode AND OCRD.ValidComm is null) AS [NoC]
		--Address
		,ISNULL((SELECT COALESCE(Street + ' ' ,'') + COALESCE(City+ ' ','') + COALESCE(Zipcode+ ' ', '')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T2.CardCode) , '') AS [CA]
	--NET
		,ISNULL((T0.LineTotal),0) as [Net]
	--VATEXEMPT
		,ISNULL((Select T0.LineTotal 
				where T0.VatGroup like 'IVE%'),0) as [VatExempt]
	--ZERORATED
		,ISNULL((Select T0.LineTOtal 
				where T0.VatGroup like 'IVZ%'),0) as [ZeroRated]
	--TAXABLE
		,ISNULL((Select T0.LineTotal 
				where T0.VatGroup like 'IVT%'),0) as [Taxable]
	--SERVICES
		,ISNULL((Select T0.LineTotal 
				where T0.VatGroup like 'IVT%' and T2.DocType = 'S'),0) as [Services]
	--GOODS
		,ISNULL((Select T0.LineTotal 
				where T0.VatGroup like 'IVT%' and T2.DocType = 'I' and T3.ItemType = 'I'),0) as [Goods]
	--FIXED
		,ISNULL((Select T0.LineTotal 
				where T0.VatGroup like 'IVT%' and T2.DocType = 'I' and T3.ItemType = 'F'),0) as [Fixed]
	--INPUTTAX
		,ISNULL((T0.VatSum),0) as [InputTax]

	--INPUTTAX
	--	,ISNULL((-1*T1.LineTotal),0) as [NET_CM]

	--INPUTTAX
	--	,ISNULL((-1*T1.VatSum),0) as [TAX_CM]

	--BRANCH
		,T4.BPLName AS [Branch]
	--CM
	from PCH1 T0
	--Left Join RPC1 T1 on T0.DocEntry = T1.BaseEntry
	Left Join OPCH T2 on T2.DocNum = T0.DocEntry
	Left Join OITM T3 on T3.ItemCode = T0.ItemCode
	Left Join OBPL T4 on T4.BPLid = T2.BPLId

	--Left join PCH1 T5 on T5.BaseDocNum = T0.DocEntry
	where T4.MAINBPL = 'N' AND T4.DISABLED = 'N'
	AND T2.DocDate between @strDate and @stpDate
	AND T2.CANCELED = 'N' AND T2.CardCode NOT IN ('V000107')
	
	UNION ALL
	SELECT 
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T2.DocDate) + 1, 0))  AS [TM]
		,T2.CardCode AS [Card]
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T2.CardCode),'') AS [TIN]
		--Card Name
		,(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T2.CardCode AND OCRD.ValidComm is null) AS [RN]
		--Name of Customer
		,(SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T2.CardCode AND OCRD.ValidComm is null) AS [NoC]
		--Address
		,ISNULL((SELECT COALESCE(Street + ' ' ,'') + COALESCE(City+ ' ','') + COALESCE(Zipcode+ ' ', '')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T2.CardCode) , '') AS [CA]
	--NET
		,ISNULL((-1*T0.LineTotal),0) as [Net]
	--VATEXEMPT
		,ISNULL((Select -1*T0.LineTotal 
				where T0.VatGroup like 'IVE%'),0) as [VatExempt]
	--ZERORATED
		,ISNULL((Select -1*T0.LineTOtal 
				where T0.VatGroup like 'IVZ%'),0) as [ZeroRated]
	--TAXABLE
		,ISNULL((Select -1*T0.LineTotal 
				where T0.VatGroup like 'IVT%'),0) as [Taxable]
	--SERVICES
		,ISNULL((Select -1*T0.LineTotal 
				where T0.VatGroup like 'IVT%' and T2.DocType = 'S'),0) as [Services]
	--GOODS
		,ISNULL((Select -1*T0.LineTotal 
				where T0.VatGroup like 'IVT%' and T2.DocType = 'I' and T3.ItemType = 'I'),0) as [Goods]
	--FIXED
		,ISNULL((Select -1*T0.LineTotal 
				where T0.VatGroup like 'IVT%' and T2.DocType = 'I' and T3.ItemType = 'F'),0) as [Fixed]
	--INPUTTAX
		,ISNULL((-1*T0.VatSum),0) as [InputTax]

	--INPUTTAX
	--	,ISNULL((-1*T1.LineTotal),0) as [NET_CM]

	--INPUTTAX
	--	,ISNULL((-1*T1.VatSum),0) as [TAX_CM]

	--BRANCH
		,T4.BPLName AS [Branch]
	--CM
	from RPC1 T0
	--Left Join RPC1 T1 on T0.DocEntry = T1.BaseEntry
	Left Join OPCH T2 on T2.DocNum = T0.DocEntry
	Left Join OITM T3 on T3.ItemCode = T0.ItemCode
	Left Join OBPL T4 on T4.BPLid = T2.BPLId

	--Left join PCH1 T5 on T5.BaseDocNum = T0.DocEntry
	where T4.MAINBPL = 'N' AND T4.DISABLED = 'N'
	AND T2.DocDate between @strDate and @stpDate
	AND T2.CANCELED = 'N' AND T2.CardCode NOT IN ('V000107')) as T
	Group By
	T.TM
	,T.TIN
	,T.RN
	,T.NoC
	,T.CA
	,T.Branch	
	ORDER BY
		T.TM
		,T.RN;