DECLARE @inv AS INT
DECLARE @type AS NVARCHAR(10)
DECLARE @cmNo AS INT
DECLARE @cCode AS VARCHAR(10)
DECLARE @wTaxRecv AS DATE

SET @cCode = $[ORIN.CardCode]
SET @wTaxRecv = $[ORIN.U_WTaxRecDate]
SET @cmNo = $[ORIN.DocNum]

SELECT
	@inv = T.Inv
	,@type = T.type
FROM(SELECT DISTINCT
	T3.DocNum AS [Inv]
	,T0.DocNum AS [Cm]
	,'ARDPI' AS [type]
FROM
	ORIN T0 INNER JOIN
	RIN1 T1 ON T0.DocEntry = T1.DocEntry LEFT JOIN
	DPI1 T2 ON T1.BaseEntry = T2.DocEntry AND T1.BaseLine = T2.LineNum AND T1.BaseType = 203 INNER JOIN
	ODPI T3 ON T2.DocEntry = T3.DocEntry
UNION ALL
SELECT DISTINCT
	T3.DocNum AS [Inv]
	,T0.DocNum AS [Cm]
	,'ARINV' AS [type]
FROM 
	ORIN T0 INNER JOIN
	RIN1 T1 ON T0.DocEntry = T1.DocEntry LEFT JOIN
	INV1 T2 ON T1.BaseEntry = T2.DocEntry AND T1.BaseLine = T2.LineNum AND T1.BaseType = 13 INNER JOIN
	OINV T3 ON T2.DocEntry = T3.DocEntry) AS t
WHERE t.Cm = @cmNo

--SELECT @inv,@type

BEGIN
	IF @inv IS NOT NULL AND @type IS NOT NULL
		BEGIN
			IF @type = 'ARDPI'
			     BEGIN
				SELECT U_wtaxComCode FROM ODPI WHERE DocNum = @inv	
			     END
			IF @type = 'ARINV'
			     BEGIN
				SELECT U_wtaxComCode FROM OINV WHERE DocNum = @inv		
			     END
		END
	IF @inv IS NULL AND @type IS NULL
		BEGIN
			DECLARE @invTypeRef AS NVARCHAR(10)
			DECLARE @invRef AS INT

			SET @invTypeRef = $[ORIN.U_invType]
			SET @invRef =$[ORIN.U_invDocNum]

			--SET @invTypeRef = 'ARINV'
			--SET @invRef = '16553'

			IF @invTypeRef = 'ARDPI'
				BEGIN
					SELECT U_wtaxComCode FROM ODPI WHERE DocNum = @invRef 
				END
			IF @invTypeRef = 'ARINV'
				BEGIN
					SELECT U_wtaxComCode FROM OINV WHERE DocNum = @invRef 
				END
		END
END