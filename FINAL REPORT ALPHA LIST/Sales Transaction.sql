DECLARE @strDate AS DATE = '2021-11-01'
DECLARE @stpDate AS DATE = '2021-11-30'


		SELECT

		CAST(T.TM AS DATE) [TM]
        ,T.ALIAS
		,(CASE WHEN T.TINS = '' THEN T.TIN ELSE T.TINS END ) AS TIN
		,T.DT AS [DT]
		,T.RN AS  [CORPORATION]
		,T.CORP AS [INDIVIDUAL]
		,REPLACE(REPLACE(REPLACE((CASE WHEN T.CAS = '' THEN T.CA ELSE T.CAS END),'PHILIPPINES','PH'),'PH,', T.CA2),'CITY','CITY PHILIPPINES') as CA
		,CAST(SUM(T.Net) AS DECIMAL(16,2)) AS [NET]
		,CAST(SUM(T.VatExempt) AS DECIMAL(16,2)) AS [VatExmpt]
		,CAST(SUM(T.ZeroRated) AS DECIMAL (16,2))AS [ZeroRated]
		,CAST(SUM(T.Taxable) AS DECIMAL (16,2)) AS [Taxable]
		,CAST(SUM(T.InputTax) AS DECIMAL(16,2)) AS [Tax]
		,CAST(SUM(T.Taxable) + SUM(T.InputTax) AS DECIMAL(16,2)) AS [GrossTotal]
		,T.Branch
	FROM 
	(
	--A/R Invoice
	SELECT 
	--	T1.CardCode [CD],
		--YYYY-MM
		DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, T1.DocDate) + 1, 0))  AS [TM]
		--TINumber
	    ,T1.U_ALIAS_VENDOR AS [ALIAS]
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode),'') AS [TIN]
		--,ISNULL((T1.U_ALIAS_VENDOR),(concat(T1.U_Customer,'',T1.CardName))) as [DT]
		,ISNULL((SELECT CONCAT(LastName,', ' ,FirstName,' ',MiddleName) FROM OCPR JOIN OCRD ON OCPR.CardCode = OCRD.CardCode WHERE OCRD.CardCode = T1.CardCode),(T1.CardName)) as [DT]
		--TINumber2
		,ISNULL((SELECT OINV.U_TIN FROM OINV WHERE OINV.DocNum = T0.DocEntry),'') AS [TINS]
		--Card Name
		,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	             'zzzzz'
		   ELSE
	             ISNULL((SELECT CONCAT(LastName,', ' ,FirstName,' ',MiddleName) FROM OCPR JOIN OCRD ON OCPR.CardCode = OCRD.CardCode WHERE OCRD.CardCode = T1.CardCode),(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null))
	       END) AS [RN]
		--ALIAS NAME
		,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzzzz'
		   ELSE
			     ISNULL((SELECT CONCAT(LastName,', ' ,FirstName,' ',MiddleName) FROM OCPR JOIN OCRD ON OCPR.CardCode = OCRD.CardCode WHERE OCRD.CardCode = T1.CardCode),(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null))
		    --ISNULL((T1.U_ALIAS_VENDOR),T1.CardName)
			END) AS [CORP]

		,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzzzz'
		  ELSE
               ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'

		,ISNULL((SELECT COALESCE(Street + ' ' ,'') + COALESCE(City+ ' ','') + COALESCE(Zipcode+ ' ', '')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode),'') AS [CA]

		,ISNULL((T1.U_ADDRESS),T2.City) as [CAS]

		,T2.City AS [CA2]
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
	    ,T1.U_ALIAS_VENDOR AS [ALIAS]
		,ISNULL((SELECT OCRD.LicTradNum FROM OCRD WHERE OCRD.CardCode = T1.CardCode), '') AS [TIN]
		,ISNULL((SELECT CONCAT(LastName,', ' ,FirstName,' ',MiddleName) FROM OCPR JOIN OCRD ON OCPR.CardCode = OCRD.CardCode WHERE OCRD.CardCode = T1.CardCode),(T1.CardName)) as [DT]
		--TINumber2
		,ISNULL((SELECT ORIN.U_TIN FROM ORIN WHERE ORIN.DocNum = T0.DocEntry),'') AS [TINS]
		--Card Name
		,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'N' THEN
	             'zzzzz'
		   ELSE
	             ISNULL((SELECT CONCAT(LastName,', ' ,FirstName,' ',MiddleName) FROM OCPR JOIN OCRD ON OCPR.CardCode = OCRD.CardCode WHERE OCRD.CardCode = T1.CardCode),(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null))
	       END) AS [RN]
		--ALIAS NAME
		,(CASE WHEN (SELECT OCRD.U_taxPayerClass FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
	            'zzzzz'
		   ELSE
			    ISNULL((SELECT CONCAT(LastName,', ' ,FirstName,' ',MiddleName) FROM OCPR JOIN OCRD ON OCPR.CardCode = OCRD.CardCode WHERE OCRD.CardCode = T1.CardCode),(SELECT OCRD.CardName FROM OCRD WHERE OCRD.CardCode = T1.CardCode AND OCRD.ValidComm is null))
		    --ISNULL((T1.U_ALIAS_VENDOR),T1.CardName)
			END) AS [CORP]

		,(CASE WHEN (SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		               FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null) <> 'I' THEN
		       'zzzzz'
		  ELSE
               ISNULL((SELECT DISTINCT COALESCE(Lastname+ ',' ,'') + '' + COALESCE(Firstname + ' ','') + '' + COALESCE(Middlename,'')
		       FROM OCPR  JOIN OCRD ON OCRD.CntctPrsn = OCPR.Name AND OCPR.CardCode = T1.CardCode AND OCRD.ValidComm is null),'')
		  END) 
			   AS 'NoC'

				--Address
		,ISNULL((SELECT COALESCE(Street + ' ' ,'') + COALESCE(City+ ' ','') + COALESCE(Zipcode+ ' ', '')
			FROM CRD1 
			WHERE AdresType = 'S' AND  CardCode = T1.CardCode),'') AS [CA]

		,ISNULL((T1.U_ADDRESS),T2.City) as [CAS]

		,T2.City AS [CA2]
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
		WHERE T.ALIAS <> T.DT
	GROUP BY
		T.TM
		,T.DT
	    ,T.ALIAS
		,T.CORP
		,T.RN
		,T.TIN
		,T.NoC
		,T.CA
		,T.CAS
		,T.CA2
		,T.Branch
		,T.TINS
	ORDER BY
		T.DT ASC;