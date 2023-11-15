Select * from tbl_Ticket 
left join tbl_TransactionType on tbl_Ticket.TransType = tbl_TransactionType.ID
left join tbl_OrderingTime on tbl_OrderingTime.TicketID  = tbl_Ticket.ID
where cast(TicketDate as date) = '2021-12-01'