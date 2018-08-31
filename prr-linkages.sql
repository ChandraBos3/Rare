
select a.* ,c.job_description,MMAT_Material_Description, 
LMMCLM_Material_Category_Code matcategory,MMC_Description catdescription, c.Sector_Code IC,MMAT_Inserted_On createdon 
into #prrmat
from epm.sqlpmp.PMP_T_ExecPlan_Purchase_Register a, epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping, 
lnt.dbo.job_master c, epm.sqlpmp.GEN_M_Material_Category, eip.sqlmas.GEN_M_Materials
where a.TEPR_Job_Code= c.job_code and a.TEPR_Material_Code= LMMCLM_Material_Code and LMMCLM_Company_Code=1
and c.company_code='LE'  and MMC_Company_Code=1 and MMC_Material_Category_Code= LMMCLM_Material_Category_Code
and a.TEPR_Inserted_On>='23-Mar-2017' and MMAT_Material_Code= a.TEPR_Material_Code and MMAT_Company_Code=1

insert into #prrmat
select a.* ,c.job_description,MMAT_Material_Description, 9999,'not linked', c.Sector_Code ,MMAT_Inserted_On from epm.sqlpmp.PMP_T_ExecPlan_Purchase_Register a, 
	lnt.dbo.job_master c, eip.sqlmas.GEN_M_Materials
where a.TEPR_Job_Code= c.job_code  and tepr_material_code = MMAT_Material_Code and MMAT_Company_Code=1 
and c.company_code='LE'  
and a.TEPR_Inserted_On>='23-Mar-2017'
and not exists ( select top 1 'x' from epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping
where a.TEPR_Material_Code= LMMCLM_Material_Code and LMMCLM_Company_Code=1)

---work category others



update #prrmat set job_description=replace(job_description,',','-'),MMAT_Material_Description=replace(MMAT_Material_Description,',','-')


update #prrmat set job_description=replace(job_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')

update #prrmat set job_description=replace(job_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

update #prrmat set job_description=replace(job_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')
update #prrmat set job_description=replace(job_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
update #prrmat set job_description=replace(job_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')

update #prrmat set job_description=replace(job_description,'''','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'''','-')
update #prrmat set job_description=replace(job_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')

select * from #prrmat




select * from epm.SQLPMP.GEN_M_Work_Items
select * from epm.sqlpmp.GEN_M_Item_Groups where MIGRP_IsActive='Y'---4020

select * from epm.sqlpmp.Gen_M_Standard_Resource where MSR_Resource_Type_Code='SCPL'
and MSR_Resource_Group_Code='4020'

-- New Program for item code vs WO Number
Select distinct hwo_wo_number , hwo_wo_date, HWO_WOT_Code,DWO_Item_Code, HWO_Job_Code, HWO_WO_Amount
 from eip.sqlwom.WOM_H_Work_Orders a, eip.sqlwom.WOM_D_Work_Orders 
where HWO_WO_Number = DWO_WO_Number and HWO_WO_Date >='01-Jan-2012' and HWO_Company_Code=1
and exists ( select top 1 'x'  from epm.sqlpmp.Gen_M_Standard_Resource where MSR_IsActive='Y' and MSR_Resource_Type_Code='SCPL'
and MSR_Resource_Code = DWO_Item_Code)
