/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[TicketNum]
      ,[TicketDate]
      ,[TransType]
      ,[TransSubType]
      ,[Status]
  FROM [DGCD_QSYSTEM].[dbo].[tbl_Ticket]
  where cast(ticketdate as date) = '2021-12-01';