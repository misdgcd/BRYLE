WITH TRANSLOG AS
(
SELECT
	  [CardCode] AS [CARDCODE]
    , [ACRD].[CreateDate] AS [CREATEDATE]
	, [CardName] AS [NEW_NAME]
	, [ACRD].[UpdateDate] AS [UPDATEDATE]
    , [U_NAME]
FROM [ACRD]
JOIN [OUSR] ON [OUSR].INTERNAL_K = [ACRD].UserSign2
WHERE [CardCode] = 'C000001'

UNION ALL

SELECT
	  [CardCode] AS [CARDCODE]
    , [OCRD].[CreateDate] AS [CREATEDATE]
	, [CardName] AS [NEW_NAME]
	, [OCRD].[UpdateDate] AS [UPDATEDATE]
    , [U_NAME]
FROM [OCRD]
JOIN [OUSR] ON [OUSR].INTERNAL_K = [OCRD].UserSign2
WHERE [CardCode] = 'C000001'

)

   ,[LOGLINE] AS
    (
        SELECT
	        ROW_NUMBER () OVER(ORDER BY [TRANSLOG].[CARDCODE] ASC) AS [LOGINSTANC]
	        , *
        FROM
	    [TRANSLOG]
    )

, [LOGUPDATE] AS
    (
        SELECT *
             , CASE
                   WHEN ISNULL(LAG([LOGLINE].[NEW_NAME], 1) OVER (Order BY [LOGLINE].[LOGINSTANC]), '') = ''
                       THEN ''
                   WHEN LAG([LOGLINE].[NEW_NAME], 1) OVER (Order BY [LOGLINE].[LOGINSTANC]) <> [LOGLINE].[NEW_NAME]
                       THEN LAG([LOGLINE].[NEW_NAME], 1) OVER (Order BY [LOGLINE].[LOGINSTANC])
                   ELSE ''
            END AS [PREVIOUS_NAME]
        FROM [LOGLINE]
        WHERE CAST([LOGLINE].[UpdateDate] AS DATE) between '2022-03-05' AND '2022-03-08'
    )

SELECT *
FROM [LOGUPDATE]
WHERE[LOGUPDATE].[PREVIOUS_NAME] <> ''