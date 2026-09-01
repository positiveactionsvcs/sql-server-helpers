	select
	LearBase,
	stuff((select distinct ',' + POSupplierVendorCode + ':' + POSupplierName
			from #CAPACITYLPN_EBOM b2
			where b2.LearBase = b1.LearBase
			for xml path('')),1,1,'') POSuppliers

	from #CAPACITYLPN_EBOM b1
	group by LearBase
