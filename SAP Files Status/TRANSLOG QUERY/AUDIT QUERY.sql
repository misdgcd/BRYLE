

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'REMARKS' AS FieldName,
                    (CASE WHEN T0.Comments != (SELECT CASE WHEN TA.Comments IS NULL THEN '' ELSE TA.Comments END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.Comments IS NULL THEN '_' ELSE TA.Comments END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.Comments AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue !=''


UNION ALL



SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'REFERENCE NO.' AS FieldName,
                    (CASE WHEN T0.NumAtCard != (SELECT CASE WHEN TA.NumAtCard IS NULL THEN '' ELSE TA.NumAtCard END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.NumAtCard IS NULL THEN '_' ELSE TA.NumAtCard END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.NumAtCard AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue !=''


UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SALES AGENT' AS FieldName,
                    (CASE WHEN T0.U_SalesAgent != (SELECT CASE WHEN TA.U_SalesAgent IS NULL THEN '' ELSE TA.U_SalesAgent END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SalesAgent IS NULL THEN '_' WHEN TA.U_SalesAgent ='' THEN '_' ELSE TA.U_SalesAgent END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SalesAgent AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue !=''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) CASH' AS FieldName,
                    (CASE WHEN T0.U_SO_Cash != (SELECT CASE WHEN TA.U_SO_Cash IS NULL THEN '' ELSE TA.U_SO_Cash END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_Cash IS NULL THEN '_' ELSE TA.U_SO_Cash END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_Cash AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) ON DATE CHECK' AS FieldName,
                    (CASE WHEN T0.U_SO_ODC != (SELECT CASE WHEN TA.U_SO_ODC IS NULL THEN '' ELSE TA.U_SO_ODC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_ODC IS NULL THEN '_' ELSE TA.U_SO_ODC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_ODC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) CREDIT CARD' AS FieldName,
                    (CASE WHEN T0.U_SO_CC != (SELECT CASE WHEN TA.U_SO_CC IS NULL THEN '' ELSE TA.U_SO_CC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_CC IS NULL THEN '_' ELSE TA.U_SO_CC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_CC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) DEBIT CARD' AS FieldName,
                    (CASE WHEN T0.U_SO_DC != (SELECT CASE WHEN TA.U_SO_DC IS NULL THEN '' ELSE TA.U_SO_DC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_DC IS NULL THEN '_' ELSE TA.U_SO_DC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_DC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) ONLINE TRANSFER' AS FieldName,
                    (CASE WHEN T0.U_SO_OT != (SELECT CASE WHEN TA.U_SO_OT IS NULL THEN '' ELSE TA.U_SO_OT END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_OT IS NULL THEN '_' ELSE TA.U_SO_OT END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_OT AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) DUE TO CUSTOMER' AS FieldName,
                    (CASE WHEN T0.U_SO_DTC != (SELECT CASE WHEN TA.U_SO_DTC IS NULL THEN '' ELSE TA.U_SO_DTC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_DTC IS NULL THEN '_' ELSE TA.U_SO_DTC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_DTC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) CASH ON DELIVERY' AS FieldName,
                    (CASE WHEN T0.U_SO_COD != (SELECT CASE WHEN TA.U_SO_COD IS NULL THEN '' ELSE TA.U_SO_COD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_DTC IS NULL THEN '_' ELSE TA.U_SO_COD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_COD AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) CHARGE ON ACCT (PDC)' AS FieldName,
                    (CASE WHEN T0.U_SO_PDC != (SELECT CASE WHEN TA.U_SO_PDC IS NULL THEN '' ELSE TA.U_SO_PDC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_DTC IS NULL THEN '_' ELSE TA.U_SO_PDC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_PDC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) CHARGE ON ACCT (PO)' AS FieldName,
                    (CASE WHEN T0.U_SO_PO != (SELECT CASE WHEN TA.U_SO_PO IS NULL THEN '' ELSE TA.U_SO_PO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_PO IS NULL THEN '_' ELSE TA.U_SO_PO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_PO AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) CHARGE ON ACCT (HO)' AS FieldName,
                    (CASE WHEN T0.U_SO_HO != (SELECT CASE WHEN TA.U_SO_HO IS NULL THEN '' ELSE TA.U_SO_HO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_HO IS NULL THEN '_' ELSE TA.U_SO_HO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_HO AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (PAYMENT) CREDIT MEMO' AS FieldName,
                    (CASE WHEN T0.U_SO_CM != (SELECT CASE WHEN TA.U_SO_CM IS NULL THEN '' ELSE TA.U_SO_CM END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_CM IS NULL THEN '_' ELSE TA.U_SO_CM END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_CM AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (RELEASING) PICK UP FROM STORE' AS FieldName,
                    (CASE WHEN T0.U_SO_PKS != (SELECT CASE WHEN TA.U_SO_PKS IS NULL THEN '' ELSE TA.U_SO_PKS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_PKS IS NULL THEN '_' ELSE TA.U_SO_PKS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_PKS AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (RELEASING) PICK UP FROM OTHER STORE' AS FieldName,
                    (CASE WHEN T0.U_SO_PKO != (SELECT CASE WHEN TA.U_SO_PKO IS NULL THEN '' ELSE TA.U_SO_PKO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_PKO IS NULL THEN '_' ELSE TA.U_SO_PKO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_PKO AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (RELEASING) DELIVERY FROM STORE' AS FieldName,
                    (CASE WHEN T0.U_SO_DS != (SELECT CASE WHEN TA.U_SO_DS IS NULL THEN '' ELSE TA.U_SO_DS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_DS IS NULL THEN '_' ELSE TA.U_SO_DS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_DS AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SO - (RELEASING) DELIVERY FROM OTHER STORE' AS FieldName,
                    (CASE WHEN T0.U_SO_DO != (SELECT CASE WHEN TA.U_SO_DO IS NULL THEN '' ELSE TA.U_SO_DO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SO_DO IS NULL THEN '_' ELSE TA.U_SO_DO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SO_DO AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) CASH' AS FieldName,
                    (CASE WHEN T0.U_BO_CASH != (SELECT CASE WHEN TA.U_BO_CASH IS NULL THEN '' ELSE TA.U_BO_CASH END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_CASH IS NULL THEN '_' ELSE TA.U_BO_CASH END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_CASH AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) ON DATE CHECK' AS FieldName,
                    (CASE WHEN T0.U_BO_ODC != (SELECT CASE WHEN TA.U_BO_ODC IS NULL THEN '' ELSE TA.U_BO_ODC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_ODC IS NULL THEN '_' ELSE TA.U_BO_ODC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_ODC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) CREDIT CARD' AS FieldName,
                    (CASE WHEN T0.U_BO_CC != (SELECT CASE WHEN TA.U_BO_CC IS NULL THEN '' ELSE TA.U_BO_CC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_CC IS NULL THEN '_' ELSE TA.U_BO_CC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_CC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) DEBIT CARD' AS FieldName,
                    (CASE WHEN T0.U_BO_DC != (SELECT CASE WHEN TA.U_BO_DC IS NULL THEN '' ELSE TA.U_BO_DC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_DC IS NULL THEN '_' ELSE TA.U_BO_DC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_DC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) ONLINE TRANSFER' AS FieldName,
                    (CASE WHEN T0.U_BO_OT != (SELECT CASE WHEN TA.U_BO_OT IS NULL THEN '' ELSE TA.U_BO_OT END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_OT IS NULL THEN '_' ELSE TA.U_BO_OT END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_OT AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) CASH ON DELIVERY' AS FieldName,
                    (CASE WHEN T0.U_BO_COD != (SELECT CASE WHEN TA.U_BO_COD IS NULL THEN '' ELSE TA.U_BO_COD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_COD IS NULL THEN '_' ELSE TA.U_BO_COD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_COD AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) CHARGE ON ACCT (PDC)' AS FieldName,
                    (CASE WHEN T0.U_BO_PDC != (SELECT CASE WHEN TA.U_BO_PDC IS NULL THEN '' ELSE TA.U_BO_PDC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_PDC IS NULL THEN '_' ELSE TA.U_BO_PDC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_PDC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) CHARGE ON ACCT (PO)' AS FieldName,
                    (CASE WHEN T0.U_BO_PO != (SELECT CASE WHEN TA.U_BO_PO IS NULL THEN '' ELSE TA.U_BO_PO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_PO IS NULL THEN '_' ELSE TA.U_BO_PO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_PO AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (PAYMENT) CHARGE ON ACCT (HO)' AS FieldName,
                    (CASE WHEN T0.U_BO_HO != (SELECT CASE WHEN TA.U_BO_HO IS NULL THEN '' ELSE TA.U_BO_HO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_HO IS NULL THEN '_' ELSE TA.U_BO_HO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_HO AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (RELEASING) PICK UP FROM STORE' AS FieldName,
                    (CASE WHEN T0.U_BO_PKS != (SELECT CASE WHEN TA.U_BO_PKS IS NULL THEN '' ELSE TA.U_BO_PKS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_PKS IS NULL THEN '_' ELSE TA.U_BO_PKS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_PKS AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (RELEASING) PICK UP FROM OTHER STORE' AS FieldName,
                    (CASE WHEN T0.U_BO_PKO != (SELECT CASE WHEN TA.U_BO_PKO IS NULL THEN '' ELSE TA.U_BO_PKO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_PKO IS NULL THEN '_' ELSE TA.U_BO_PKO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_PKO AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (RELEASING) DELIVERY FROM STORE' AS FieldName,
                    (CASE WHEN T0.U_BO_DS != (SELECT CASE WHEN TA.U_BO_DS IS NULL THEN '' ELSE TA.U_BO_DS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_DS IS NULL THEN '_' ELSE TA.U_BO_DS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_DS AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (RELEASING)  DELIVERY FROM OTHER STORE' AS FieldName,
                    (CASE WHEN T0.U_BO_DO != (SELECT CASE WHEN TA.U_BO_DO IS NULL THEN '' ELSE TA.U_BO_DO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_DO IS NULL THEN '_' ELSE TA.U_BO_DO END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_DO AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (RELEASING) DROP SHIP DELIVERY-DC' AS FieldName,
                    (CASE WHEN T0.U_BO_DSDD != (SELECT CASE WHEN TA.U_BO_DSDD IS NULL THEN '' ELSE TA.U_BO_DSDD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_DSDD IS NULL THEN '_' ELSE TA.U_BO_DSDD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_DSDD AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (RELEASING) DROP SHIP DELIVERY-VENDOR' AS FieldName,
                    (CASE WHEN T0.U_BO_DSDV != (SELECT CASE WHEN TA.U_BO_DSDV IS NULL THEN '' ELSE TA.U_BO_DSDV END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_DSDV IS NULL THEN '_' ELSE TA.U_BO_DSDV END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_DSDV AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (RELEASING) DROP SHIP PICK UP-DC' AS FieldName,
                    (CASE WHEN T0.U_BO_DSPD != (SELECT CASE WHEN TA.U_BO_DSPD IS NULL THEN '' ELSE TA.U_BO_DSPD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_DSPD IS NULL THEN '_' ELSE TA.U_BO_DSPD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_DSPD AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BO - (RELEASING) DROP SHIP PICK UP-VENDOR' AS FieldName,
                    (CASE WHEN T0.U_BO_DRS != (SELECT CASE WHEN TA.U_BO_DRS IS NULL THEN '' ELSE TA.U_BO_DRS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BO_DRS IS NULL THEN '_' ELSE TA.U_BO_DRS END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BO_DRS AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'WSLIP SERIES' AS FieldName,
                    (CASE WHEN T0.U_WSLIPSERIES != (SELECT CASE WHEN TA.U_WSLIPSERIES IS NULL THEN '' ELSE TA.U_WSLIPSERIES END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_WSLIPSERIES IS NULL THEN '_' ELSE TA.U_WSLIPSERIES END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_WSLIPSERIES AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'ZIP CODE' AS FieldName,
                    (CASE WHEN CAST(T0.U_ZIPCODE AS VARCHAR(10))  != (SELECT CASE WHEN CAST(TA.U_ZIPCODE AS VARCHAR(10))  IS NULL THEN '' ELSE CAST(TA.U_ZIPCODE AS VARCHAR(10))  END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN CAST(TA.U_ZIPCODE AS VARCHAR(10)) IS NULL THEN '_' ELSE CAST(TA.U_ZIPCODE AS VARCHAR(10)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    CAST(T0.U_ZIPCODE AS VARCHAR(10))  AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'CUSTOMER' AS FieldName,
                    (CASE WHEN T0.CARDCODE != (SELECT CASE WHEN TA.CARDCODE IS NULL THEN '' ELSE TA.CARDCODE END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.CARDCODE IS NULL THEN '_' ELSE TA.CARDCODE END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.CARDCODE AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'NAME' AS FieldName,
                    (CASE WHEN T0.CARDNAME != (SELECT CASE WHEN TA.CARDNAME IS NULL THEN '' ELSE TA.CARDNAME END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.CARDNAME IS NULL THEN '_' ELSE TA.CARDNAME END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.CARDNAME AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'CONTACT PERSON' AS FieldName,
                    (CASE WHEN CAST(T0.CNTCTCODE AS VARCHAR(15)) != (SELECT CASE WHEN CAST(TA.CNTCTCODE AS VARCHAR(15)) IS NULL THEN '' ELSE CAST(TA.CNTCTCODE AS VARCHAR(15)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN CAST(TA.CNTCTCODE AS VARCHAR(15)) IS NULL THEN '_' ELSE CAST(TA.CNTCTCODE AS VARCHAR(15)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    CAST(T0.CNTCTCODE AS VARCHAR(15)) AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''



UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'CUSTOMER REF. NO.' AS FieldName,
                    (CASE WHEN T0.NUMATCARD != (SELECT CASE WHEN TA.NUMATCARD IS NULL THEN '' ELSE TA.NUMATCARD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.NUMATCARD IS NULL THEN '_' ELSE TA.NUMATCARD END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.NUMATCARD AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''




UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'CUSTOMER NAME' AS FieldName,
                    (CASE WHEN T0.U_CUSTOMER != (SELECT CASE WHEN TA.U_CUSTOMER IS NULL THEN '' ELSE TA.U_CUSTOMER END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_CUSTOMER IS NULL THEN '_' ELSE TA.U_CUSTOMER END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_CUSTOMER AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BRANCH REG. NO.' AS FieldName,
                    (CASE WHEN T0.VATREGNUM != (SELECT CASE WHEN TA.VATREGNUM IS NULL THEN '' ELSE TA.VATREGNUM END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.VATREGNUM IS NULL THEN '_' ELSE TA.VATREGNUM END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.VATREGNUM AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BRANCH' AS FieldName,
                    (CASE WHEN CAST(T0.BPLID AS VARCHAR(15)) != (SELECT CASE WHEN CAST(TA.BPLID AS VARCHAR(15)) IS NULL THEN '' ELSE CAST(TA.BPLID AS VARCHAR(15)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN CAST(TA.BPLID AS VARCHAR(15)) IS NULL THEN '_' ELSE CAST(TA.BPLID AS VARCHAR(15)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    CAST(T0.BPLID AS VARCHAR(15)) AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SALES EMPLOYEE' AS FieldName,
                    (CASE WHEN CAST(T0.SLPCODE AS VARCHAR(15)) != (SELECT CASE WHEN CAST(TA.SLPCODE AS VARCHAR(15)) IS NULL THEN '' ELSE CAST(TA.SLPCODE AS VARCHAR(15)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN CAST(TA.SLPCODE AS VARCHAR(15)) IS NULL THEN '_' ELSE CAST(TA.SLPCODE AS VARCHAR(15)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    CAST(T0.SLPCODE AS VARCHAR(15)) AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'OWNER' AS FieldName,
                    (CASE WHEN CAST(T0.OWNERCODE AS VARCHAR(15)) != (SELECT CASE WHEN CAST(TA.OWNERCODE AS VARCHAR(15)) IS NULL THEN '' ELSE CAST(TA.OWNERCODE AS VARCHAR(15)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN CAST(TA.OWNERCODE AS VARCHAR(15)) IS NULL THEN '_' ELSE CAST(TA.SLPCODE AS VARCHAR(15)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    CAST(T0.OWNERCODE AS VARCHAR(15)) AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL

SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'PRICE DISCOUNT APPROVAL' AS FieldName,
                    (CASE WHEN T0.U_PRICEAPPROVAL != (SELECT CASE WHEN TA.U_PRICEAPPROVAL IS NULL THEN '' ELSE TA.U_PRICEAPPROVAL END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_PRICEAPPROVAL IS NULL THEN '_' ELSE TA.U_PRICEAPPROVAL END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_PRICEAPPROVAL AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'BELOW COST APPROVAL' AS FieldName,
                    (CASE WHEN T0.U_BELCOSTAP != (SELECT CASE WHEN TA.U_BELCOSTAP IS NULL THEN '' ELSE TA.U_BELCOSTAP END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_BELCOSTAP IS NULL THEN '_' ELSE TA.U_BELCOSTAP END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_BELCOSTAP AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'DOCUMENT DATE' AS FieldName,
                    (CASE WHEN CAST(T0.TAXDATE AS  VARCHAR(10))  != (SELECT CASE WHEN CAST(TA.TAXDATE AS  VARCHAR(10)) IS NULL THEN '' ELSE CAST(TA.TAXDATE AS  VARCHAR(10)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN CAST(TA.TAXDATE AS VARCHAR(10)) IS NULL THEN '_' ELSE CAST(TA.TAXDATE AS  VARCHAR(10)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    CAST(T0.TAXDATE AS VARCHAR(10)) AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'DOCUMENT SERIES' AS FieldName,
                    (CASE WHEN T0.U_DOCSERIES != (SELECT CASE WHEN TA.U_DOCSERIES IS NULL THEN '' ELSE TA.U_DOCSERIES END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_DOCSERIES IS NULL THEN '_' ELSE TA.U_DOCSERIES END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_DOCSERIES AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'DISTRIBUTION CENTER' AS FieldName,
                    (CASE WHEN T0.U_DC != (SELECT CASE WHEN TA.U_DC IS NULL THEN '' ELSE TA.U_DC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_DC IS NULL THEN '_' ELSE TA.U_DC END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_DC AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'TRANSACTION TYPE' AS FieldName,
                    (CASE WHEN T0.U_SOTYPE != (SELECT CASE WHEN TA.U_SOTYPE IS NULL THEN '' ELSE TA.U_SOTYPE END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_SOTYPE IS NULL THEN '_' ELSE TA.U_SOTYPE END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_SOTYPE AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SENIOR CITIZEN / PWD' AS FieldName,
                    (CASE WHEN T0.U_OscaPwd != (SELECT CASE WHEN TA.U_OscaPwd IS NULL THEN '' ELSE TA.U_OscaPwd END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN TA.U_OscaPwd IS NULL THEN '_' ELSE TA.U_OscaPwd END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    T0.U_OscaPwd AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                   
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''


UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'SC/PWD DISCOUNT' AS FieldName,
                    (CASE WHEN CAST(T0.U_SCPWD AS VARCHAR(10)) != (SELECT CASE WHEN CAST(TA.U_SCPWD AS varchar(10)) IS NULL THEN '' ELSE CAST(TA.U_SCPWD AS varchar(10)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN CAST(TA.U_SCPWD AS varchar(10)) IS NULL THEN '_' ELSE CAST(TA.U_SCPWD AS varchar(10)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    CAST(T0.U_SCPWD AS VARCHAR(10)) AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                                 
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''

UNION ALL


SELECT * FROM
              (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'TOTAL' AS FieldName,
                    (CASE WHEN CAST(CAST(T0.DocTotal AS DECIMAL(16,2)) AS VARCHAR(20)) != (SELECT CASE WHEN CAST(TA.DocTotal AS varchar(20)) IS NULL THEN '' ELSE CAST(TA.DocTotal AS varchar(20)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
                    (SELECT CASE WHEN CAST(TA.DocTotal AS varchar(20)) IS NULL THEN '_' ELSE CAST(CAST(TA.DocTotal AS decimal(16,2)) AS varchar(20)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
                    AS OldValue,
                    CAST(CAST(T0.DocTotal AS DECIMAL(16,2)) AS VARCHAR(20)) AS NewValue,
                    (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                                 
FROM ADOC T0) AS TBL_Temp1
WHERE OldValue != ''
AND OldValue <> NewValue


-- SELECT * FROM
--               (SELECT LogInstanc,dbo.ObType(ObjType) AS ObjectType, T0.DocEntry ,'TOTAL' AS FieldName,
--                     (CASE WHEN CAST(T0.DocTotal AS decimal(16,2)) != (SELECT CASE WHEN CAST(TA.DocTotal AS varchar(20)) IS NULL THEN '' ELSE CAST(TA.DocTotal AS varchar(20)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) THEN
--                     (SELECT CASE WHEN CAST(TA.DocTotal AS varchar(20)) IS NULL THEN '_' ELSE CAST(TA.DocTotal AS varchar(20)) END FROM ADOC TA WHERE TA.DocEntry=T0.DocEntry AND TA.ObjType=T0.ObjType AND TA.LogInstanc=T0.LogInstanc -1) ELSE '' END)
--                     AS OldValue,
--                     CAST(T0.DocTotal AS decimal(16,2)) AS NewValue,
--                     (SELECT U_NAME FROM OUSR WHERE OUSR.INTERNAL_K = T0.UserSign) AS USERS
                                 
-- FROM ADOC T0) AS TBL_Temp1
-- WHERE OldValue != ''






ORDER BY ObjectType, DocEntry, LogInstanc ASC