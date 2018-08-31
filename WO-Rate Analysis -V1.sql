select * from eip.sqlwom.WOM_M_Job_Item_Codes where MJITC_Item_Code='511200000000003'

select * from eip.sqlmas.GEN_M_Item_Groups where MIGRP_Description like 'Concr%' and MIGRP_IsActive='Y'


DROP TABLE #TEMP1
select HWO_WO_Number,HWO_JOB_CODE,Sector_Code,bu_code, DWO_Item_Code,DWO_Item_Rate,DWO_Item_Value,DWO_WO_Qty,HWO_Last_Amendment_Number, HWO_Currency_Code,
HWO_WOT_Code
into #temp1
from eip.sqlwom.wom_h_work_orders a, eip.sqlwom.WOM_D_Work_Orders, lnt.dbo.job_master
where a.HWO_WO_Number = DWO_WO_Number
and job_code = HWO_Job_Code
and hwo_company_code = '1'
and company_code='LE'
and hwo_ds_code=3
--and a.HWO_Job_Code='le150838'
---and DWO_Item_Code like '5112%'
and a.HWO_WO_Date >='01-Dec-2016' 
--AND HWO_Currency_Code ='inr'


alter table #temp1 add workcategorycode  varchar(500)
alter table #temp1 add workCategory varchar(500)
alter table #temp1 add itemdesc varchar(500)



Update a set workcategorycode = MJITC_Item_Group_Code,itemdesc = left(MJITC_Item_Description,500)
from #temp1 a, eip.sqlwom.wom_m_job_item_codes
where HWO_Job_Code = MJITC_Job_Code
and MJITC_Item_Code= DWO_Item_Code
and MJITC_Company_Code=1


Update a set workCategory = b.MIGRP_Description
from #temp1 a,  EIP.SQLMAS.GEN_M_ITEM_GROUPS B --epm.sqlpmp.GEN_M_Activity_Groups b
where workcategorycode= b.MIGRP_Item_Group_Code --and  b.MAGRP_Activity_Group_Level='AGLE0002'
AND B.MIGRP_Company_code=1 


alter table #temp1 add ICdesc varchar(100)
alter table #temp1 add BUdesc varchar(100)
alter table #temp1 add Jobdesc varchar(200)

UPDATE a SET ICdesc = b.Sector_Description
from #temp1 a, lnt.dbo.Sector_Master b
WHERE a.sector_code = b.Sector_Code 
AND b.Company_Code='LE'


UPDATE a SET BUdesc = b.bu_description
from #temp1 a, lnt.dbo.business_unit_master b
WHERE a.bu_code = b.bu_code 
AND b.Company_Code='LE'

UPDATE a SET Jobdesc = b.job_description
from #temp1 a, LNT.dbo.job_master b
WHERE a.HWO_JOB_CODE = b.job_code 
AND b.Company_Code='LE'


Update #temp1 set itemdesc = replace(itemdesc , char(9),'-'), costpackage=replace(costpackage, char(9),'-')

Update #temp1 set itemdesc = replace(itemdesc , char(10),'-'),costpackage=replace(costpackage, char(10),'-')

Update #temp1 set itemdesc = replace(itemdesc , char(11),'-'),costpackage=replace(costpackage, char(11),'-')

Update #temp1 set itemdesc = replace(itemdesc , char(12),'-'),costpackage=replace(costpackage, char(12),'-')

Update #temp1 set itemdesc = replace(itemdesc , char(13),'-'),costpackage=replace(costpackage, char(13),'-')

Update #temp1 set itemdesc = replace(itemdesc , char(14),'-'),costpackage=replace(costpackage, char(14),'-')

Update #temp1 set itemdesc=replace (itemdesc , '''','f')
Update #temp1 set itemdesc=replace (itemdesc , '"','i')

select *from #temp1
where workCategory  like '%Concreting%'
---SELECT *FROM eip.sqlwom.wom_h_work_orders 