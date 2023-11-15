
CREATE FUNCTION dbo.ObType(@TYPE INT)
RETURNS VARCHAR(20)

BEGIN

   RETURN ( CASE
             WHEN @TYPE = 17 THEN 
             (select replace(convert(varchar(20),@TYPE),17,'SALES ORDER'))
             WHEN @TYPE = 13 THEN 
             (select replace(convert(varchar(20),@TYPE),13,'A/R INVOICE'))
             WHEN @TYPE = 14 THEN 
             (select replace(convert(varchar(20),@TYPE),14,'A/R CREDIT MEMO'))
        END)              
END



-- DROP FUNCTION ObType