DECLARE @strDate AS DATE = try_convert(date,'2021-12-09')
DECLARE @stpDate AS DATE = try_convert(date,'2021-12-31')

	SELECT

		CAST(T.TM AS DATE) [TM]
--		,T.CD [CD]
		,(CASE WHEN T.TINS = '' THEN T.TIN ELSE T.TINS END ) AS TIN
		,T.RN
		,(CASE WHEN T.ALIAS = '' THEN T.Noc ELSE T.ALIAS END) as NoC
	--	,(CASE WHEN (CASE WHEN T.CA = '' THEN T.CAS ELSE T.CA END) like 'PH%' THEN 'PHILIPPINES' ELSE (CASE WHEN T.CA = '' THEN T.CAS ELSE T.CA END) END ) AS CA
	--  ,REPLACE(REPLACE((CASE WHEN T.CA = '' THEN T.CA1 ELSE T.CA1 END),'PHILIPPINES','PH'),'PH','PHILIPPINES') as CA
		,REPLACE(REPLACE(REPLACE((CASE WHEN T.CA = '' THEN T.CA1 ELSE T.CA1 END),'PHILIPPINES','PH'),'PH,', 'PHILIPPINES'),'CITY','CITY PHILIPPINES') as CA
	--	,T.ALIAS
	--	,T.CN
	--	,(CASE WHEN T.TINS ='' THEN T.TIN ELSE T.TINS END) AS TINS
	--	,T.CAS
		,CAST(SUM(T.Net) AS DECIMAL(16,2)) AS [NET]
		,CAST(SUM(T.VatExempt) AS DECIMAL(16,2)) AS [VatExmpt]
		,CAST(SUM(T.ZeroRated) AS DECIMAL (16,2))AS [ZeroRated]
		,CAST(SUM(T.Taxable) AS DECIMAL (16,2)) AS [Taxable]
		,CAST(SUM(T.InputTax) AS DECIMAL(16,2)) AS [Tax]
	--	,CAST(SUM(T.WTApplied) AS DECIMAL(16,2)) AS [WTApplied]
	--	,CAST(SUM(T.VatExempt) + SUM(T.ZeroRated) + SUM(T.Taxable) + SUM(T.InputTax) + SUM(-T.WTApplied) AS DECIMAL(16,2)) AS [GrossTotal]
	--	,CAST(SUM(T.VatExempt) + SUM(T.ZeroRated) + SUM(T.Taxable) + SUM(T.InputTax) AS DECIMAL(16,2)) AS [GrossTotal]
		,CAST(SUM(T.Taxable) + SUM(T.InputTax) AS DECIMAL(16,2)) AS [GrossTotal]
		--,CAST(SUM(T.Taxable) + (Select Sum(WTApplied) From OINV join INV1 on INV1.DocEntry = OINV.DocEntry) AS DECIMAL(16,2)) AS [GrossTotal]
		,T.Branch
		--,T.RM [RM]
	FROM 
	(
	--A/R Invoice
	SELECT 
	--	T1.CardCode [CD],
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0))  AS [TM]
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
		--TINumber2
		,ISNULL((SELECT OINV.U_TIN FROM OINV WHERE OINV.DocNum = T0.DocEntry),'') AS [TINS]
		--Card Name
		,ISNULL((SELECT Distinct Coalesce(OCRD.CardName,'') FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [RN]
		--ALIAS NAME
		,ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR) AS [ALIAS]
	--	,ISNULL((SELECT Distinct Coalesce(OINV.U_ALIAS_VENDOR,'') FROM OINV WHERE OINV.DocNum = T0.DocEntry),'') AS [ALIAS]
		--CUSTOMER NAME
	--	,ISNULL((SELECT Distinct Coalesce(OINV.U_CUSTOMER,'') FROM OINV WHERE OINV.DocNum = T0.DocEntry),'') AS [CN]
		--Name of Customer
		,ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname +'','') + ' ' + COALESCE(Middlename,'') 
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS 'NoC'

		--Address
		,ISNULL((select Distinct Coalesce(Block+ ', ','')+ '' +Coalesce(Street+' ','')+ '' +Coalesce(City+' ','')+''+Coalesce(Country+' ','')+''+Coalesce(Zipcode,'')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS 'CA'
		--CAS
	 --    ,ISNULL((SELECT OINV.U_ADDRESS FROM OINV WHERE OINV.DocNum = T0.DocEntry),'') AS [CA1]
	--	,ISNULL((Select Top 1 OWHS.City from OWHS left join OUDG on OWHS.WhsCode = OUDG.Warehouse Right join OINV on OUDG.UserSign = T1.UserSign and OWHS.BPLid = T2.BPLId ),'') as [CAS]
	--	,Concat(REPLACE((T1.U_ADDRESS),' PH',''),' ',T2.Address) as [CAS] 
		,ISNULL((T1.U_ADDRESS),T2.CITY) AS [CA1]
	--	,ISNULL((T2.CITY),'') as [CAS]
		--Net
		,ISNULL((SELECT INV1.LineTotal 
					FROM INV1 
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum
			--		AND T1.DocType = 'I'
					),0) AS [Net]
		--Vat Exempt
		,ISNULL((SELECT INV1.LineTotal 
					FROM INV1 
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum 
			--		AND T1.DocType = 'I'
					AND INV1.VatGroup LIKE 'OVE%'),0) AS [VatExempt]

		--Zero Rated
		,ISNULL((SELECT INV1.LineTotal 
					FROM INV1
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum 
			--		AND T1.DocType = 'I'
					AND INV1.VatGroup LIKE 'OVZ%'),0) AS [ZeroRated]


		--Taxable
		,ISNULL((SELECT INV1.LineTotal 
					FROM INV1 
					WHERE INV1.DocEntry = T1.DocEntry 
					AND INV1.LineNum = T0.LineNum 
			--		AND T1.DocType = 'I'
					AND INV1.VatGroup LIKE 'OVT%'),0) AS [Taxable]

		--Input Tax
		,ISNULL((SELECT INV1.VatSum 
					FROM INV1 
					WHERE INV1.DocEntry = T1.DocEntry 
			--		AND T1.DocType = 'I'
					AND INV1.LineNum = T0.LineNum),0) AS [InputTax]

	/*			--WTAPPLIED
		,ISNULL((SELECT OINV.WTApplied 
					FROM OINV 
					WHERE T0.DocEntry = OINV.DocEntry 
			--		AND T1.DocType = 'I'
					),0) AS [WTApplied]*/
		

		,T2.BPLName AS [Branch]
	--	,'AR SALES INVOICE' AS [RM]
	FROM INV1 T0
	JOIN OINV T1 ON T1.DocNum = T0.DocEntry
	JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
	AND T1.CANCELED = 'N' AND T1.DocType = 'I'  AND T1.DocDate BETWEEN @strDate AND @stpDate	
	Union ALL
	--A/R Credit Memo
	SELECT 
	--	T1.CardCode [CD],
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0)) AS [TM]
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode), '') AS [TIN]
		--TINumber2
		,ISNULL((SELECT ORIN.U_TIN FROM ORIN WHERE ORIN.DocNum = T0.DocEntry),'') AS [TINS]
		--Card Name
		,ISNULL((SELECT Distinct Coalesce(OCRD.CardName,'') FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [RN]
		--ALIAS NAME
		,ISNULL((T1.U_CUSTOMER),T1.U_ALIAS_VENDOR) AS [ALIAS]
	--	,ISNULL((SELECT Distinct Coalesce(ORIN.U_ALIAS_VENDOR,'') FROM ORIN WHERE ORIN.DocNum = T0.DocEntry),'') AS [ALIAS]
		--CUSTOMER NAME
--		,ISNULL((SELECT Distinct Coalesce(ORIN.U_CUSTOMER,'') FROM ORIN WHERE ORIN.DocNum = T0.DocEntry),'') AS [CN]
		--Name of Customer
		,ISNULL((Select Distinct Coalesce(Lastname+ ',' , '') + '' + Coalesce(Firstname+ '','')+ ' ' +Coalesce(Middlename,'')
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS 'NoC'
		--Address
		,ISNULL((select Distinct Coalesce(Block+ ', ','')+ '' +Coalesce(Street+' ','')+ '' +Coalesce(City+' ','')+''+Coalesce(Country+' ','')+''+Coalesce(Zipcode,'')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS 'CA'
		--CAS
	--	,ISNULL((SELECT ORIN.U_ADDRESS FROM ORIN WHERE ORIN.DocNum = T0.DocEntry),'') AS [CA1]
	--	,ISNULL((Select Top 1 OWHS.City from OWHS left join OUDG on OWHS.WhsCode = OUDG.Warehouse RIGHT join ORIN on OUDG.UserSign = T1.UserSign and OWHS.BPLid = T2.BPLId ),'') as [CAS]
	--	,Concat(REPLACE((T1.U_ADDRESS),' PH',''),' ',T2.Address) as [CAS] 
	--	,ISNULL((T2.CITY),'') as [CAS]
		,ISNULL((T1.U_ADDRESS),T2.CITY) AS [CA1]
		--Net
		,ISNULL((SELECT -1 * RIN1.LineTotal 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
			--		AND T1.DocType = 'I'
					AND RIN1.LineNum = T0.LineNum),0) AS [Net]
		--Vat Exempt
		,ISNULL((SELECT -1 * RIN1.LineTotal 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
					AND RIN1.LineNum = T0.LineNum 
			--		AND T1.DocType = 'I'
					AND RIN1.VatGroup LIKE 'OVE%'),0) AS [VatExempt]


		--Zero Rated
		,ISNULL((SELECT -1 * RIN1.LineTotal 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
					AND RIN1.LineNum = T0.LineNum 
			--		AND T1.DocType = 'I'
					AND RIN1.VatGroup LIKE 'OVZ%'),0) AS [ZeroRated]


		--Taxable
		,ISNULL((SELECT -1 * RIN1.LineTotal 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
					AND RIN1.LineNum = T0.LineNum 
			--		AND T1.DocType = 'I'
					AND RIN1.VatGroup LIKE 'OVT%'),0) AS [Taxable]


		--Tax
		,ISNULL((SELECT -1 * RIN1.VatSum 
					FROM RIN1 
					WHERE RIN1.DocEntry = T1.DocEntry 
			--		AND T1.DocType = 'I'
					AND RIN1.LineNum = T0.LineNum), 0) AS [InputTax]

	/*			--WTAPPLIED
		,ISNULL((SELECT -1* ORIN.WTSum 
					FROM ORIN 
					WHERE T0.DocEntry = ORIN.DocEntry 
			--		AND T1.DocType = 'I'
					),0) AS [WTApplied]  */


		,T2.BPLName AS [Branch]
	--	,'AR SALES CREDIT MEMO' AS [RM]
	FROM RIN1 T0
	JOIN ORIN T1 ON T1.DocNum = T0.DocEntry
	JOIN OBPL T2 ON T2.BPLid = T1.BPLid AND T2.MAINBPL = 'N' AND T2.DISABLED = 'N'
	AND T1.CANCELED = 'N' AND T1.DocType = 'I' AND  T1.DocDate BETWEEN @strDate AND @stpDate) AS T
	GROUP BY
		T.TM
	--	,T.CD
		,T.RN
		,T.TIN
		,T.NoC
		,T.CA
		,T.Branch
		,T.TINS
	--	,T.CN
		,T.ALIAS
	--	,T.CAS
		,T.CA1
	ORDER BY
		T.TM
		,T.RN ASC;