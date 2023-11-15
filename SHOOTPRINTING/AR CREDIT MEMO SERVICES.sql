SELECT  
T0.DocNum,
ISNULL(T0.U_Customer, T0.CardName) AS CardName,
ISNULL(T0.U_Customer, T0.CardName) AS CUSTOMER,
ISNULL(T0.U_TIN, t0.LicTradNum) as  LicTradNum,
(SELECT LicTradNum FROM OCRD WHERE OCRD.CardCode = T0.CardCode) AS LicTradNum2,
--T1.Dscription,
CONCAT(
T1.[Dscription] ,' ', 
(SELECT CASE WHEN (T1.U_StdQty != '' OR T1.U_StdQty != NULL) THEN 
    CONCAT('(',T1.U_StdQty,' ',(SELECT T8.UomCode FROM OUGP T7 INNER JOIN OUOM T8 ON T7.BaseUom = T8.UomEntry WHERE T7.UgpCode = T1.[ItemCode]),')') 
	ELSE '' END)) AS Dscription, 

ISNULL((CASE WHEN T1.[UomCode]='Manual' THEN 0 ELSE T1.[Quantity] END),0) AS Quantity, 
ISNULL((CASE WHEN T1.[UomCode]='Manual' THEN '' ELSE T1.[UomCode] END),'') AS UomCode,

ISNULL(CAST(CAST(T1.U_GPBD AS money)AS FLOAT),0) AS PriceBeforeDi, 
ISNULL(T1.PriceAfVAT,(T1.[PriceAfVAT]*T1.[Quantity])) AS PriceAfterDi,
T0.DocDate,
CONCAT((SELECT PymntGroup FROM OCTG WHERE GroupNum=T0.GroupNum),'; ',convert(varchar, T0.DocDueDate, 107))AS DueDate,
T0.[NumAtCard], T0.[Comments] AS Comments,
CASE WHEN T0.[SlpCode] = -1 THEN '' ELSE (SELECT OSLP.SlpName FROM OSLP WHERE SlpCode = T0.SlpCode) END AS SalesEmployee,
T0.[OwnerCode],
(SELECT U_VATType FROM OCRD WHERE T0.CardCode = OCRD.CardCode) AS U_VATTYPE,
T0.U_ADDRESS as FullAddress,
CONCAT(T2.[firstName],CASE WHEN T2.[middleName] = '' or T2.[middleName] IS NULL THEN ' ' ELSE ' '+LEFT(T2.[middleName],1)+'. ' END, T2.[lastName])AS DataOwner,
CONCAT('No. ' , LEFT(T0.U_DOCSERIES, 6), '-', RIGHT(T0.U_DOCSERIES, 10)) AS Series,
CASE WHEN T0.CANCELED = 'C' THEN 'CANCELLED' ELSE
	'SALES '+(
	SELECT T1.value FROM (
		SELECT value,ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS number  
		FROM STRING_SPLIT(T0.[U_DocSeries], '-') AS T1
		WHERE RTRIM(value) <> ''
	) T1 where T1.number = 2)+' INVOICE' END AS TenderType,
(SELECT PHONE1 FROM OCRD WHERE OCRD.CardCode = T0.CardCode) AS CUSTEL,
T0.PRINTED,
CASE WHEN
 (SELECT TA.NAME FROM OVTG TA WHERE TA.CODE = T1.VatGroup) LIKE '%EXEMPT%' THEN ' (EXEMPT)'
WHEN
 (SELECT TA.NAME FROM OVTG TA WHERE TA.CODE = T1.VatGroup) LIKE '%ZERO%' THEN ' (ZERO-RATED)'
 ELSE ''
 END as Tax,
(T0.DocTotal +ISNULL((select TA.WTAmnt from inv5 TA WHERE T0.DocNum = TA.AbsEntry),0))+ ISNULL((SELECT SUM(TA.GROSS) FROM INV11 TA WHERE T0.DocNum = TA.DocEntry ),0) as DocTotal,
CASE WHEN
  (SELECT TA.NAME FROM OVTG TA WHERE TA.CODE = T1.VatGroup) LIKE '%EXEMPT%' THEN 0
 WHEN
 (SELECT TA.NAME FROM OVTG TA WHERE TA.CODE = T1.VatGroup) LIKE '%ZERO%' THEN 0
 ELSE ((T0.DocTotal-T0.VATSUM ) +ISNULL((select TA.WTAmnt from inv5 TA WHERE T0.DocNum = TA.AbsEntry),0))
 + ISNULL((SELECT SUM(TA.LineTotal) FROM INV11 TA WHERE T0.DocNum = TA.DocEntry ),0)
 END as VatableSales,
 T0.VatSum  + ISNULL((SELECT SUM(TA.VatSum) FROM INV11 TA WHERE T0.DocNum = TA.DocEntry ),0) AS VatSum,
 CASE WHEN
 (SELECT TA.NAME FROM OVTG TA WHERE TA.CODE = T1.VatGroup) LIKE '%EXEMPT%' THEN T0.DocTotal
 ELSE 0
 END as VatExempt,
  CASE WHEN
 (SELECT TA.NAME FROM OVTG TA WHERE TA.CODE = T1.VatGroup) LIKE '%ZERO%' THEN T0.DocTotal
 ELSE 0
 END as ZERORated,
 CASE WHEN T0.U_OscaPwd IS NULL THEN 0 ELSE 1
 end as Senior,
 T0.U_OscaPwd,
CASE WHEN t0.cardcode = 'C000112' THEN
isnull(T0.U_SCPWD,0)
 ELSE 0 END 
 AS SeniorDisc,
 (SELECT TA.PYMNTGROUP FROM OCTG TA WHERE T0.GROUPNUM = TA.GroupNum) AS Terms,
 ISNULL((select TA.WTAmnt from inv5 TA WHERE T0.DocNum = TA.AbsEntry),0) as WTaxAmt,
 (SELECT CASE WHEN T0.CardName LIKE '%SENIOR CITIZEN%' 
		THEN ISNULL((
				SELECT T6.Discount FROM OEDG T5
				INNER JOIN EDG1 T6 ON T5.[AbsEntry] = T6.[AbsEntry] 
				WHERE T5.[ObjCode] = T0.CardCode AND T6.ObjKey = T1.ItemCode
			 ),0) 
		ELSE 0 
		END
)AS SCPWDDisc,
T0.U_OscaPwd,
ISNULL(T0.U_SCPWD, 0) AS U_SCPWD,
 T1.BaseDocNum
FROM ORIN T0
JOIN RIN1 T1 ON T1.DocEntry = T0.DocNum
JOIN OHEM T2 ON T0.[OwnerCode] = T2.[empID]
WHERE T0.[DocNum] = 108-- {?DocKey@}