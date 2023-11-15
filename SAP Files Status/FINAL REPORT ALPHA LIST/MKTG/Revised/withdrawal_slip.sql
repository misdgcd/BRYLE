SELECT 

	( SELECT TOP 1 TC.U_DOCSERIES FROM OPOR TC WHERE TC.DOCNUM = 
	( SELECT TOP 1 TB.DocEntry FROM POR1 TB WHERE TB.BASEENTRY =
	(select  TOP 1 TA.TrgetEntry from prq1 TA where TA.docentry = (SELECT TOP 1 TA.PoTrgNum FROM RDR1 TA WHERE TA.DocEntry = T0.BaseDocNum )))) AS PONumber,

    ( SELECT TOP 1 TC.DocNum FROM OPOR TC WHERE TC.DOCNUM =
	( SELECT TOP 1 TB.DocEntry FROM POR1 TB WHERE TB.BASEENTRY =
	(select  TOP 1 TA.TrgetEntry from prq1 TA where TA.docentry = (SELECT TOP 1 TA.PoTrgNum FROM RDR1 TA WHERE TA.DocEntry = T0.BaseDocNum )))) AS PODocNum,

    (SELECT  BA.DocNum FROM ORDR BA
        JOIN RDR1 BB ON BA.DocNum = BB.DocEntry
        JOIN OINV BC ON BC.DocNum = BB.TrgetEntry WHERE BC.DocNum = T1.DocNum) AS SODocNum,

	( SELECT TOP 1 
	CONCAT(
		ISNULL(CONCAT(TD.STREET,', '), ''), 
		ISNULL(CONCAT(TD.CITY,', '), ''),
		ISNULL(CONCAT(TD.County,', '), ''),
		ISNULL(CONCAT(TD.Country,', '), ''),
		ISNULL(CONCAT(TD.ZipCode,'. '), ''))
		FROM CRD1 TD WHERE TD.CardCode =
	( SELECT TOP 1 TC.CardCode FROM OPOR TC WHERE TC.DOCNUM = 
	( SELECT TOP 1 TB.DocEntry FROM POR1 TB WHERE TB.BASEENTRY =
	( SELECT TOP 1 TA.TrgetEntry from prq1 TA where TA.docentry = (SELECT TOP 1 TA.PoTrgNum FROM RDR1 TA WHERE TA.DocEntry = T0.BaseDocNum ))))) AS POAddress1,
(SELECT TD.U_VENDOR FROM RDR1 TD WHERE TD.DocEntry = T0.BaseDocNum) AS POAddress,
	T1.DOCNUM ,
	RIGHT('000000000'+CAST(t1.docnum AS VARCHAR(9)),9) as DocNUm1a,
	T1.CardCode AS [CardCode],
	T1.CardName AS [Cardname],
	T0.ItemCode AS [ItemCode],
	T0.Dscription AS [Item],
	T0.UomCode,
	T0.Quantity,
	CONCAT(
	   CASE WHEN T4.[StreetNo] = '' OR T4.[StreetNo] = NULL THEN '' ELSE T4.[StreetNo]+' 'END,
	   CASE WHEN T4.[Block] = '' OR T4.[Block] = NULL THEN '' ELSE T4.[Block]+' 'END,
	   CASE WHEN T4.[City] = '' OR T4.[City] = NULL THEN '' ELSE T4.[City]+', 'END,
	   CASE WHEN T4.[ZipCode] = '' OR T4.[ZipCode] = NULL THEN '' ELSE T4.[ZipCode]END
	   ) AS InvoiceAddress,
T4.FEDTAXID,
T0.WHSCODE,
T1.BPLNAME,
T1.NUMATCARD,
T1.DOCDATE,
T1.Comments,
ISNULL(T1.U_BO_DSPD, 'N'), T5.U_DOCSERIES, t5.u_wslipseries

FROM 
	INV1 T0
	INNER JOIN OINV T1 ON T0.DocEntry = T1.DocEntry
	INNER JOIN OWHS T4 ON T4.WhsCode = T0.WhsCode
	INNER JOIN OINV T5 ON T0.DocEntry = T5.DocNum
WHERE  (T1.U_BO_DSPD='Y'  OR T1.U_BO_DRS='Y'  ) AND T1.DOCNUM = 50