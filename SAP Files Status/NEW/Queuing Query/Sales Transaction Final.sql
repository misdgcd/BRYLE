DECLARE @strDate AS DATE = try_convert(date,'2021-12-04')
DECLARE @stpDate AS DATE = try_convert(date,'2021-12-04')

Select 
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
		,CAST(SUM(T.VatExempt) + SUM(T.ZeroRated) + SUM(T.Taxable) + SUM(T.InputTax) AS DECIMAL(16,2)) AS [Gross]
		,CAST(SUM(T.NET_CM) AS DECIMAL(16,2)) AS NET_CM
		,CAST(SUM(T.TAX_CM) AS DECIMAL(16,2)) AS TAX_CM
FROM
(
	--A/R Invoice
	SELECT 
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0))  AS [TM]
		--TINumber
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
		--Card Name
		,ISNULL((SELECT Distinct Coalesce(OCRD.CardName,'') FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS [RN]
		--Name of Customer
		,ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'') 
			FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'') AS 'NoC'
		--Address
		,ISNULL((select Distinct Coalesce(Block+ ', ','')+ '' +Coalesce(Street+' ','')+ '' +Coalesce(City+' ','')+''+Coalesce(Country+' ','')+''+Coalesce(Zipcode,'')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode) , '') AS 'CA'

		,ISNULL((T0.LineTotal),0) as [NET]

		,ISNULL((-1*T2.BaseAmnt),0) as [NET_CM]

		,ISNULL((-1*T2.VatSum),0) as [TAX_CM]

		,ISNULL((Select T0.LineTotal
				 where T0.VatGroup like 'OVE%'),0) as [VatExempt]

		,ISNULL((Select T0.LineTotal 
				where T0.VatGroup like 'OVZ%'),0) as [ZeroRated]

		,ISNULL((Select T0.LineTotal 
				where T0.VatGroup like 'OVT%'),0) as [Taxable]

		,T0.VatSum as [InputTax]

from INV1 T0
Left join OINV T1 on T1.DocNum = T0.DocEntry
left Join ORIN T2 on T2.DocEntry = T0.TrgetEntry
left join INV5 T3 on T3.TrgAbsEntr = T0.TrgetEntry

--where T0.DocEntry = '169') as T
where T1.DocDate between @strDate and @stpDate) as T

Group By
	T.TM
	,T.TIN
	,T.RN
	,T.NoC
	,T.CA