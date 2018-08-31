drop table #stdcodes
select c.msr_resource_code ITEMScope,msrr_standardized_description stddesc,msrr_description scopedesc, c.MSR_Attribute_Combination_Value stdcode
into #stdcodes
from epm.SQLpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b ,
EPM.sqlpmp.Gen_M_Standard_Resource c
where a.msr_resource_code is not NULL and msrr_approved_by = b.uid and b.Company_Code='LE'
and c.msr_resource_code = a.msr_resource_code

select * from #stdcodes

update #stdcodes set stddesc = replace(stddesc, char(9),'-'), scopedesc = replace(scopedesc,char(9),'-')
update #stdcodes set stddesc = replace(stddesc, char(10),'-'), scopedesc = replace(scopedesc,char(10),'-')
update #stdcodes set stddesc = replace(stddesc, char(11),'-'), scopedesc = replace(scopedesc,char(11),'-')
update #stdcodes set stddesc = replace(stddesc, char(12),'-'), scopedesc = replace(scopedesc,char(12),'-')
update #stdcodes set stddesc = replace(stddesc, char(13),'-'), scopedesc = replace(scopedesc,char(13),'-')
update #stdcodes set stddesc = replace(stddesc, char(14),'-'), scopedesc = replace(scopedesc,char(14),'-')
update #stdcodes set stddesc = replace(stddesc, char(15),'-'), scopedesc = replace(scopedesc,char(15),'-')
update #stdcodes set stddesc = replace(stddesc, '''','-'), scopedesc = replace(scopedesc,'''','-')
update #stdcodes set stddesc = replace(stddesc, '"','-'), scopedesc = replace(scopedesc,'"','-')


select a.HWORQ_Job_Code, a.HWORQ_Request_Number, left(b.DWORQ_Item_Code,9) stditem, right(b.DWORQ_Item_Code,6)  scope, DWORQ_Item_Code,b.DWORQ_Item_Rate, b.DWORQ_Item_Value, d.Sector_Code
from eip.sqlwom.WOM_H_Work_Order_Request a, eip.sqlwom.WOM_D_Work_Order_Request b, #stdcodes c, lnt.dbo.job_master d
where a.HWORQ_Request_Number= b.DWORQ_Request_Number and c.itemscope = b.DWORQ_Item_Code and a.HWORQ_Job_Code = d.job_code
and a.HWORQ_Date>='01-Apr-2017'
order by 3
