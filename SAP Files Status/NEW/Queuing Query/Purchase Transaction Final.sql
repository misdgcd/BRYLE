DECLARE @strDate AS DATE =try_convert(date,'2021-12-06')
DECLARE @stpDate AS DATE =try_convert(date,'2021-12-07')

Select T0.DocDate, T0.DocEntry,
T0.LineTotal as [NET],
(-1*T2.BaseAmnt) as [NET_CM],
ISNULL((Select T0.LineTotal where T0.VatGroup like 'IVE%'),0) as [VatExempt],
ISNULL((Select -1*T3.LineTotal where T3.VatGroup like 'IVE%'),0) as [VatExempt_CM],
ISNULL((Select T0.LineTotal where T0.VatGroup like 'IVZ%'),0) as [ZeroRated],
ISNULL((Select -1*T3.LineTotal where T3.VatGroup like 'IVZ%'),0) as [ZeroRated_CM],
ISNULL((Select T0.LineTotal where T0.VatGroup like 'IVT%'),0) as [Taxable],
ISNULL((Select -1*T3.LineTotal where T3.VatGroup like 'IVT%'),0) as [Taxable_CM],
ISNULL((Select T0.LineTotal where T0.VatGroup like 'IVT%' and T1.DocType = 'S'),0) as [Services],
ISNULL((Select -1*T3.LineTotal where T3.VatGroup like 'IVT%' and T1.DocType = 'S'),0) as [Services_CM],
ISNULL((Select T0.LineTotal where T0.VatGroup like 'IVT%' and T1.DocType = 'I' and T4.ItemType ='I'),0) as [Goods],
ISNULL((Select -1*T3.LineTotal where T3.VatGroup like 'IVT%' and T1.DocType = 'I' and T4.ItemType ='I'),0) as [Goods_CM],
ISNULL((Select T0.LineTotal where T0.VatGroup like 'IVT%' and T1.DocType = 'I' and T4.ItemType ='F'),0) as [Fixed],
ISNULL((Select -1*T3.LineTotal where T3.VatGroup like 'IVT%' and T1.DocType = 'I' and T4.ItemType ='F'),0) as [Fixed_CM],
T0.VatSum as [TAX],
(-1*T2.VatSum) as [TAX_CM]
FROM PCH1 T0
Left Join OPCH T1 on T0.DocEntry = T1.DocEntry
Left Join ORPC T2 on T2.DocEntry = T0.TrgetEntry
Left Join RPC1 T3 on T3.BaseEntry = T0.DocEntry
Left Join OITM T4 on T4.ItemCode = T0.ItemCode
Where T1.DocDate between @strDate and @stpDate;