/****** Script for SelectTopNRows command from SSMS  ******/
update s
set ParentID='ULTRA ELECTRONICS'
FROM [DIIG].[Vendor].[CanadaSupplierID] s 
where [CanadaSupplierID] in (1015042,23005,24344)

select *
  from contractor.ParentContractor
  where parentheadquarterscountrycode='CAN'
  order by ParentID

SELECT  [CanadaSupplierID]
      ,[Supplier]
	  ,s.parentid as SponsorParentID
	  ,v.standardizedvendorname
	  ,v.parentid as VendorParent
      ,[SuppAddress]
      ,[SuppCity]
      ,[SuppProvince]
      ,[SuppPostCode]
      ,[SuppCountry]
	  
  FROM [DIIG].[Vendor].[CanadaSupplierID] s 
  left outer join vendor.VendorName v
  on s.supplier=v.vendorname
  --where v.parentid is not null 
  order by Supplier


  
  