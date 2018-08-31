use finance
GO

drop table #invoices
drop table #tlreg
drop table #jobs

--baseline jobs
--('LE120315','LE150922','LE150011','LE151047','LE131402','LE150285','LE150810','LE150181')



--select * from lnt.dbo.job_master where job_description like '%serv%'

--LE16D036	SSC VENDOR PAYMENTS-BNF IC ACCOUNTS
--LE120048	DEPT CODE - SHARED SERVICES CENTRE - LTC
--SOFAA001	FINANCE & ACCOUNTS DEPARTEMENT - Shared Ser
--SOFAA002	Finance & Accounts - Shared Ser
--SZ000010	Shared Service Centre - Accounting Center
--HC000012	HCP - Shared Service Centre --LTHE company
--LG120001	Shared Service Centre - SSC -- GEO company


--select job_Code, region_Code,job_description from lnt.dbo.job_master where job_code  in
--('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360')

select  job_Code into #jobs 
from lnt.dbo.job_master where Company_code='LE' and job_operating_group <>'I'

--Job_code in ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360')---11 Pilot jobs
-- job_code  in ( 'LE160189','le160645','LE160433','le151046','le160360','le160273','le160643','le150403')
---Pilot Jobs

----PHRS request with dates
--select Asset_Request_No, phrs_date, Asset_Description,group_code, Job_Code, Required_From, Required_To,Quantity,make,model,capacity,vendor_code,Requested_on, approved_on,
--Res_Approved_On from asset.dbo.Asset_Hire_Request where  Job_Code in (select job_code from #jobs)--
---- 'LE160189','le160645','LE160433','le151046','le160360','le160273','le160643','le150403')
--and Res_Approved_By is not NULL	
----select * from eip.sqlwom.WOM_H_Work_Order_Request where HWORQ_Job_Code='LE160433'




--'LE140073','LE130990','LE150462','LE150646',
--'LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931',
--'le150810','le150313','le131215','le131402','le140528','le151047','le140528',
--'le150286','le140149','le150284','le150732','LE130759','LE131215','LE131216','LE131217','LE131218','LE131222','LE131223','LE131224','LE131225','LE131227',
--'LE150285','LE140764','le150462','LE140764','LE150646',
--'LE150807',
--'LE15D120',
--'LE130990',
--'LE131307')
--drop table #tlreg
--drop table #invoices

select distinct a.TLREG_LR_Number ebrnumber into #tlreg
from eip.sqlfas.FAS_T_Ledger_Register a
where TLREG_DS_Code<>8 and tlreg_job_code in ( select job_code from #jobs) 
and tlreg_lr_date between '01-Apr-2016' and '31-Mar-2017' and a.TLREG_Dt_Code in ( 403,404)


--insert into #tlreg
--select distinct a.TLREG_LR_Number ebrnumber --into #tlreg
--from eip.sqlfas.FAS_T_Ledger_Register a
--where TLREG_DS_Code<>8 and tlreg_job_code in ( select job_code from #jobs) 
--and tlreg_lr_date between '01-Jan-2016' and '31-Mar-2016' and a.TLREG_Dt_Code in ( 403,404)

----in ('LE140764','LE150462')
----and TLREG_Job_Code in ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810','le150313','le131215','le131402','le140528','le151047',
----'le150286','le140149','le150284','le150732')

----and tlreg_job_code in ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810','le150313','le131215','le131402','le140528','le151047',
----'le150286','le140149','le150284','le150732','LE130759','LE131215','LE131216','LE131217','LE131218','LE131222','LE131223','LE131224','LE131225','LE131227')
--and TLREG_DT_Code=404


--select distinct a.TLREG_LR_Number ebrnumber into #tlreg from eip.sqlfas.FAS_T_Ledger_Register a, eip.sqlfas.FAS_T_Document_Approvals b
--where a.TLREG_LR_Number= b.TDAPR_Document_Reference_Number and b.TDAPR_DS_Code=19
--and b.TDAPR_Action_On between '01-Nov-2016' and '31-Mar-2016' and a.TLREG_AC_Code='SZ000010' and a.TLREG_Company_Code=1
--and a.TLREG_DT_Code=403
--and exists ( select 'x' from eip.sqlfas.FAS_T_Document_Approvals c where a.TLREG_LR_Number= c.TDAPR_Document_Reference_Number
--and c.TDAPR_DS_Code=4 and c.TDAPR_Action_On <'01-Jul-2016')

--select distinct a.TLREG_LR_Number ebrnumber into #tlreg from eip.sqlfas.FAS_T_Ledger_Register a, eip.sqlfas.FAS_T_Document_Approvals b
--where a.TLREG_LR_Number= b.TDAPR_Document_Reference_Number and b.TDAPR_DS_Code=4
--and b.TDAPR_Action_On between '01-Apr-2016' and '15-Sep-2016' and  a.TLREG_AC_Code='SZ000010' and a.TLREG_Company_Code=1
--and tlreg_dt_code=404

--drop table #tlreg

--select distinct a.TLREG_LR_Number ebrnumber into #tlreg from eip.sqlfas.FAS_T_Ledger_Register a, eip.sqlfas.FAS_T_Document_Approvals b
--where a.TLREG_LR_Number= b.TDAPR_Document_Reference_Number and b.TDAPR_DS_Code=7
--and b.TDAPR_Action_On between'01-Jan-2017' and '31-Mar-2017' --and '15-Sep-2016'-- and  a.TLREG_AC_Code='SZ000010' 
--and a.TLREG_Company_Code=1
--and tlreg_dt_code in (403,404)



select TLREG_LR_Number, TLREG_LR_Date Invregisterdate, TLREG_DT_Code, TLREG_Bill_Number InvoiceNo, TLREG_Bill_Date invoicedate,tlreg_job_code JObcode, 
tlreg_vendor_code vendorcode,cast(null as varchar(3000)) VendName,TLREG_Gross_Amount invvalue, cast ( null as varchar(30)) ordernumber,
cast(null as varchar(15)) PVTag,cast(null as varchar(15)) LDTag, 
cast(null as varchar(15)) ContrBG,cast(null as varchar(15)) advbg,cast(null as varchar(15)) perfbg,cast ( null as date) AcknowDate, 
 cast ( null as date) InvPhyDate, cast ( null as date) MinScrutinyDate, cast ( null as date) MaxScrutinyDate, cast ( null as date) Canceldate,
 cast ( null as date) JVDate, cast ( null as date) MinDisbdate, cast ( null as date) Maxdisbdate,
  cast ( null as date) rejectdate,    cast ( 0 as int) ptevent,cast ( 0 as int) ptcategory,
  cast ( null as date) duedate,cast ( null as varchar(500)) paymentterm , cast(null as varchar(3000)) MRnNumbers, cast(0 as int) scrutinyid,cast(0 as int) SJVuid,
  cast(null as varchar(30)) materialcode,cast(null as varchar(30)) materialgroup, cast(null as varchar(300)) cancelremarks,cast(null as varchar(300)) Rejectremarks,
  cast(null as varchar(3000)) Rejreasons,cast(0 as money) ptquantum
into #invoices 
from eip.sqlfas.fas_t_ledger_register 
where exists ( select 'x' from #tlreg where TLREG_LR_Number= ebrnumber)
--tlreg_dt_code in ( 403)
--and TLREG_Job_Code in ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810','le150313','le131215','le131402','le140528','le151047',
--'le150286','le140149','le150284','le150732')
--and tlreg_job_code ='LE150285'
--and TLREG_LR_Date>='01-Apr-2016'
--and TLREG_LR_Date>='01-Jan-2017' and tlreg_lr_date <='31-Mar-2017'
--and tlreg_ac_code in ( 'SZ000010')--,'SZO00010')

----MR based invoice list
/*
use finance
GO
drop table #invoices
select hmr_mr_Number, hmr_mr_date MrDate, HMR_Job_Code JObcode, cast(null as varchar(30) ) ponumber,cast(null as varchar(30) ) mrnnumber,
cast(null as varchar(30) ) LRnumber,
cast(null as varchar(15)) vendorcode,cast(null as varchar(3000)) VendName,cast( 0 as money) invvalue, cast ( null as varchar(30)) ordernumber,
cast(null as varchar(15)) PVTag,cast(null as varchar(15)) LDTag, 
cast(null as varchar(15)) ContrBG,cast(null as varchar(15)) advbg,cast(null as varchar(15)) perfbg,cast ( null as date) AcknowDate, 
 cast ( null as date) InvPhyDate, cast ( null as date) MinScrutinyDate, cast ( null as date) MaxScrutinyDate, cast ( null as date) Canceldate,
 cast ( null as date) JVDate, cast ( null as date) MinDisbdate, cast ( null as date) Maxdisbdate,
  cast ( null as date) rejectdate,    cast ( 0 as int) ptevent,cast ( 0 as int) ptcategory,
  cast ( null as date) duedate,cast ( null as varchar(500)) paymentterm , cast(null as varchar(3000)) MRnNumbers, cast(0 as int) scrutinyid,cast(0 as int) SJVuid,
  cast(null as varchar(30)) materialcode,cast(null as varchar(30)) materialgroup, cast(null as varchar(300)) cancelremarks,cast(null as varchar(300)) Rejectremarks,
  cast(null as varchar(3000)) Rejreasons,cast(0 as money) ptquantum
into #invoices 
from eip.sqlscm.scm_h_material_request 
where HMR_MR_Date between '01-Jan-2017' and '28-Feb-2017' and HMR_DS_Code=3
and hmr_company_code=1
*/
-----

Alter Table #invoices add amendno int, lastamdDate date,noofstages int

Alter Table #invoices add wornumber varchar(30)

alter table #invoices add retnbg char(1)

alter table #invoices add creditdays int

--select * from #invoices


Update a set duedate= hlrv_due_date, ptevent= hlrv_pt_event_code,  ptquantum= b.HLRV_PT_Quantum_Percentage,
			ordernumber= isnull(b.HLRV_PO_Number, b.HLRV_WO_Number), creditdays=HLRV_PT_Credit_Days
from #invoices a, eip.sqlfas.FAS_H_Ledger_Register_Vendor b
where a.tlreg_lr_number= b.HLRV_LR_Number

select  * from eip.sqlfas.FAS_H_Ledger_Register_Vendor


Update a set  MinDisbdate  = mindate 
			from #invoices a, (select TDAPR_Document_Reference_Number, tdapr_ds_code, min(tdapr_action_on) mindate, 
			max(tdapr_action_on) maxdate from eip.sqlfas.fas_t_document_approvals b, #invoices c
			where b.TDAPR_Document_Reference_Number= c.tlreg_lr_number
			group by TDAPR_Document_Reference_Number, tdapr_ds_code ) g
where a.tlreg_lr_number= g.TDAPR_Document_Reference_Number
and g.TDAPR_DS_Code in (  7)


Update a set   Maxdisbdate  = maxdate
from #invoices a, (select TDAPR_Document_Reference_Number, tdapr_ds_code, min(tdapr_action_on) mindate, 
			max(tdapr_action_on) maxdate from eip.sqlfas.fas_t_document_approvals b, #invoices c
			where b.TDAPR_Document_Reference_Number= c.tlreg_lr_number
			group by TDAPR_Document_Reference_Number, tdapr_ds_code ) g
where a.tlreg_lr_number= g.TDAPR_Document_Reference_Number
and g.TDAPR_DS_Code in (  7)



Update a set  MinScrutinyDate  = mindate 
			from #invoices a, (select TDAPR_Document_Reference_Number, tdapr_ds_code, min(tdapr_action_on) mindate, 
			max(tdapr_action_on) maxdate from eip.sqlfas.fas_t_document_approvals b, #invoices c
			where b.TDAPR_Document_Reference_Number= c.tlreg_lr_number
			group by TDAPR_Document_Reference_Number, tdapr_ds_code ) g
where a.tlreg_lr_number= g.TDAPR_Document_Reference_Number
and g.TDAPR_DS_Code in (  4)

Update a set   MaxScrutinyDate  = maxdate
from #invoices a, (select TDAPR_Document_Reference_Number, tdapr_ds_code, min(tdapr_action_on) mindate, 
			max(tdapr_action_on) maxdate from eip.sqlfas.fas_t_document_approvals b, #invoices c
			where b.TDAPR_Document_Reference_Number= c.tlreg_lr_number
			group by TDAPR_Document_Reference_Number, tdapr_ds_code ) g
where a.tlreg_lr_number= g.TDAPR_Document_Reference_Number
and g.TDAPR_DS_Code in (  4)


Update a set scrutinyid=b.TDAPR_Action_By
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =4



Update a set Canceldate=tdapr_action_on,cancelremarks=b.TDAPR_Remarks
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =8

Update a set JVdate  = tdapr_action_on
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =19

Update a set SJVuid=b.TDAPR_Action_By
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =19

			
Update a set AcknowDate  = tdapr_action_on
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =12

Update a set rejectdate  = tdapr_action_on,rejectremarks=b.TDAPR_Remarks
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =13



Update a set ptcategory= mpte_event_category_code
from #invoices a, ---eip.sqlmas.GEN_M_PT_Event_Category b,
eip.sqlmas.GEN_M_PT_Events c
where a.ptevent= c.mpte_event_code 






Update a set paymentterm= mpte_description +'-'+ mptec_description + '-'+ case when mptec_is_advance_category ='Y' then 'Advance' 
														when mptec_is_advance_category = 'I' then 'Installation'
														when mptec_is_advance_category = 'E' then 'After Receipt' End 
															
from #invoices a, eip.sqlmas.GEN_M_PT_Event_Category b,eip.sqlmas.GEN_M_PT_Events c
where  a.ptevent = MPTE_Event_Code and tlreg_dt_Code=403
and a.ptcategory = MPTEC_Event_Category_Code

Update a set paymentterm= mpte_description +'-'+  case when mptec_is_advance_category ='Y' then 'Advance' 
														when mptec_is_advance_category = 'I' then 'Installation'
														when mptec_is_advance_category = 'E' then 'After Execution' End 
															
from #invoices a, eip.sqlmas.GEN_M_PT_Event_Category b,eip.sqlmas.GEN_M_PT_Events c
where  a.ptevent = MPTE_Event_Code and tlreg_dt_Code=404
and a.ptcategory = MPTEC_Event_Category_Code



Update a set  vendname = vendor_description
 from #invoices a, finance.dbo.IT_Vendor_View where Company_Code='LE'
 and vendor_Code= a.vendorcode

Update a set pvtag=dpot_isPrice_variation,ldtag=dpot_ld_clause
from eip.sqlscm.SCM_D_Purchase_Order_Terms b,#invoices a
where a.ordernumber=b.DPOT_PO_Number


Update a set ldtag=hwo_is_ld_applicable,amendno=hwo_last_amendment_number,lastamdDate=hwo_last_amendment_date,noofstages=hwo_number_of_stages,
wornumber=b.HWO_WO_Request_Number
--select * 
from eip.sqlwom.WOM_H_Work_Orders b,#invoices a
where a.ordernumber=b.HWO_WO_Number

Update b set contrbg='Y'
from eip.sqlscm.SCM_L_PO_BG_Types a, #invoices b
where ordernumber= a.LPOBT_PO_Number
and a.LPOBT_BG_Type=1


Update b set retnbg='Y'
from eip.sqlwom.WOM_L_WO_Request_BG_Types a, #invoices b
where wornumber= a.LWRBT_Request_Number
and a.LWRBT_BG_Type=3


Update b set contrbg='Y'
from eip.sqlwom.WOM_L_WO_Request_BG_Types a, #invoices b
where wornumber= a.LWRBT_Request_Number
and a.LWRBT_BG_Type=2



Update #invoices set advbg='Y' where ptevent in ( 203,223,224,225,302)
Update #invoices set perfbg='Y' where ptevent in ( 208,210,213,214,218,231,303)

-----PO

--select * from #invoices

--drop table #mrndetails

--select * from #mrndetails

---Invoice based Material Details

select distinct b.DLRV_LR_Number,b.DLRV_MRN_Number,b.DLRV_MRN_Date, 
		b.DLRV_WO_Bill_Number,MMAT_MG_Code, DMRN_Material_Code,MMGRP_Description, JObcode, DPOT_Stock_Type_Detail_Code, DPOT_Direct_Supply, MMGRP_Class_Code
into #MRNdetails
 from #invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b, eip.sqlscm.SCM_D_MRN, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Groups,
		eip.sqlscm.SCM_D_Purchase_Order_Terms
	where a.tlreg_lr_number = b.DLRV_LR_Number and DPOT_PO_Number= ordernumber
and b.DLRV_MRN_Number= DMRN_MRN_Number and MMAT_Material_Code= DMRN_Material_Code
and MMAT_Company_Code=1 
and MMAT_MG_Code= MMGRP_MG_Code and MMGRP_Company_Code=MMAT_Company_Code

select * from #MRNdetails


----and jobcode in   ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810')
----and jobcode in   ('le150313','le131215','le131402','le140528')
--and jobcode in ('le151047','le150286','le140149','le150284','le150732')

select * from eip.sqlscm.SCM_H_Purchase_Orders a, eip.sqlscm.SCM_D_Purchase_Order_Terms, #jobs
where a.HPO_PO_Number= DPOT_PO_Number and DPOT_Direct_Supply='Y'
--and DPOT_Stock_Type_Detail_Code=13
and job_code= a.HPO_Job_Code



--select DISTINCT b.job_code, hwo_ba_code from eip.sqlwom.WOM_H_Work_Orders a, #jobs b
--where a.HWO_Job_Code= b.Job_Code

--select * from crm.dbo.MRN_SupplyInv_Status where MRN_Code='EC975MRN6000371'
--select * from eip.sqlscm.SCM_H_MRN where HMRN_PO_Number='EC975PO5000028'


alter table #invoices add mrNumber varchar(30) 
alter table #invoices add MRNNUmber varchar(30) 
alter table #invoices add GinNumber varchar(30) 
alter table #invoices add Mrdate date
alter table #invoices add MrAuthDate date
alter table #invoices add POAuth date
alter table #invoices add DCDate date
alter table #invoices add GinDate date
alter table #invoices add MRNDate date
alter table #invoices add MRNAuthDate date

Update a set mrNumber = b.HPO_MR_Number
from #invoices a, eip.sqlscm.SCM_h_Purchase_Orders b
where a.ordernumber = b.HPO_PO_Number

Update a set Mrdate = b.HMR_MR_Date
from #invoices a, eip.sqlscm.SCM_H_Material_Request b
where a.mrNumber = b.HMR_MR_Number


Update a set mrnnumber = b.DLRV_MRN_Number--, mrndate=b.DLRV_MRN_Date
from #invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b
where a.tlreg_lr_number = b.DLRV_LR_Number

Update a set ginnumber=HMRN_Gin_Number, mrndate=b.HMRN_MRN_Date
from #invoices a, eip.sqlscm.scm_h_mrn b
where a.mrnnumber = b.HMRN_MRN_Number

Update a set gindate=b.HGIN_GIN_Date
from #invoices a, eip.sqlscm.SCM_H_GIN b
where a.ginnumber = b.HGIN_GIN_Number

Update a set gindate=b.HGIN_GIN_Date
from #invoices a, eip.sqlscm.SCM_H_GIN b
where a.ginnumber = b.HGIN_GIN_Number

Update a set dcdate=mindcdate
from #invoices a, (select DGIN_GIN_Number , min(DGIN_DC_Date) mindcdate,max(DGIN_DC_Date) maxdcdate 
							 from eip.sqlscm.SCM_d_GIN b,#invoices c
						where c.ginnumber= b.DGIN_GIN_Number
						group by b.DGIN_GIN_Number) g
where a.ginnumber = g.DGIN_GIN_Number

Update c set mrnauthdate= mindate
from #invoices c, (select mrnnumber, min(b.TSCDA_Action_On) mindate, max(b.TSCDA_Action_On) maxdate 
from eip.sqlscm.SCM_T_Document_Approvals b, #invoices a
where a.mrnnumber=b.TSCDA_Document_Reference_Number
and b.TSCDA_DS_Code=3 group by mrnnumber) g
where c.mrnnumber = g.mrnnumber

Update c set POAuth= mindate
from #invoices c, (select ordernumber, min(b.TSCDA_Action_On) mindate, max(b.TSCDA_Action_On) maxdate  
from eip.sqlscm.SCM_T_Document_Approvals b, #invoices a
where a.ordernumber=b.TSCDA_Document_Reference_Number
and b.TSCDA_DS_Code=3  group by ordernumber) g
where c.ordernumber = g.ordernumber

Update c set mrauthdate= mindate
from #invoices c, (select mrNumber, min(b.TSCDA_Action_On) mindate, max(b.TSCDA_Action_On) maxdate 
from eip.sqlscm.SCM_T_Document_Approvals b, #invoices a
where a.mrnumber=b.TSCDA_Document_Reference_Number
and b.TSCDA_DS_Code=3  group by mrNumber) g
where c.mrnumber = g.mrnumber


alter table #invoices add BUdesc varchar(100)
alter table #invoices add ICdesc varchar(100)


uPDATE A SET  BUDESC= B.bu_description
FROM #INVOICES A, business_unit_master B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE
AND C.BU_CODE = B.BU_CODE


uPDATE A SET  ICDESC= B.Sector_Description
FROM #INVOICES A, LNT.DBO.SECTOR_MASTER B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE AND B.Company_Code= C.company_code
AND C.Sector_Code = B.Sector_Code


update #invoices set budesc=replace(budesc,',','-'),ICDESC=replace(ICDESC,',','-'),vendname=replace(vendname,',','-')



select HPO_PO_Number, HPO_PO_Type_Detail_Code, hpo_po_date,mrdate,mrauthdate,poauth,dcdate,gindate, mrndate,mrnauthdate,a.* from #invoices a, eip.sqlscm.SCM_H_Purchase_Orders
where a.ordernumber = HPO_PO_Number

 


--select distinct a.DPORC_PO_Number,a.DPORC_Rate_Component_Code, MRATC_Description, a.DPORC_Percentage, dporc_value
-- from eip.sqlscm.SCM_D_PO_Rate_Components a, eip.sqlmas.GEN_M_Rate_Components
--where a.DPORC_Rate_Component_Code = MRATC_Rate_Component_Code
--and exists ( select top 1  'x' from  #invoices c where
-- c.ordernumber = a.DPORC_PO_Number)

 

--select a.HPOAR_Request_Number, a.HPOAR_PO_Number, HPOAR_Amendment_Number,a.HPOAR_Request_Date, a.HPOAR_Job_Code jobcode,tscda_action_by auth_by, tscda_action_on auth_on
-- from eip.sqlscm.SCM_H_PO_Amend_Request a, eip.sqlscm.SCM_T_Document_Approvals b
--where a.hpoar_request_number=TSCDA_Document_Reference_Number
--and HPOAR_Amendment_Number=TSCDA_Amendment_Number
----and hpoar_job_code  in ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810','le150313','le131215','le131402','le140528','le151047',
----'le150286','le140149','le150284','le150732')
----and  hpoar_job_code='LE150285'
--and tscda_ds_code = 3
--and exists ( select top 1  'x' from  #invoices c where
-- c.ordernumber = a.HPOAR_PO_Number)
--order by 2,3




-----wO


alter table #Invoices add WOREquestNo varchar(30)
alter table #Invoices add WORCreatedDate date
alter table #Invoices add WORequestDate date
alter table #Invoices add WOBillNumber varchar(30)

alter table #Invoices add Billdate date
alter table #Invoices add Billdedndate date
alter table #Invoices add BillDednApprovaldate date
alter table #Invoices add Billapprovaldate date
alter table #Invoices add WOApprovalDate date
alter table #Invoices add WORMinApproved date
alter table #Invoices add WORMaxApproved date
alter table #invoices add BUdesc varchar(100)
alter table #invoices add ICdesc varchar(100)

--alter table #Invoices alter column WOApprovalDate date
--alter table #Invoices drop column WOApprovalDate 



Update a set WOREquestNo= b.HWO_WO_Request_Number, WORequestDate=hwo_wo_date
from #Invoices a, eip.sqlwom.WOM_H_Work_Orders b
where a.ordernumber = b.HWO_WO_Number

Update a set WOBillNumber= b.DLRV_WO_Bill_Number
from #Invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b
where a.tlreg_lr_number = b.DLRV_LR_Number

Update a set Billdate= b.HBILL_Bill_Date
from #Invoices a, eip.sqlwom.WOM_H_Bills b
where a.wobillnumber = b.HBILL_Bill_Number


Update a set Billdedndate= TWOBD_Inserted_On
from #Invoices a, eip.sqlfas.FAS_T_Work_Order_Bill_Deductions
where a.wobillnumber = TWOBD_Bill_Number


Update a set Billdedndate= TDAPR_Action_On
from #Invoices a, eip.sqlfas.FAS_T_Document_Approvals
where a.wobillnumber = TDAPR_Document_Reference_Number
and TDAPR_DS_Code=1

Update a set BillDednApprovaldate= TDAPR_Action_On
from #Invoices a, eip.sqlfas.FAS_T_Document_Approvals
where a.wobillnumber = TDAPR_Document_Reference_Number
and TDAPR_DS_Code=3

Update a set BillDednApprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where a.wobillnumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=17


Update a set Billapprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where a.wobillnumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=3

Update a set woapprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where ordernumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=3
and TWODA_Amendment_Number=0

Update a set woapprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where worequestno = TWODA_Document_Reference_Number
and TWODA_DS_Code=3
and woapprovaldate is NULL

Update a set WORCreatedDate= Twoda_Action_On
--select * 
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where worequestno = TWODA_Document_Reference_Number
and TWODA_DS_Code=1 --and worequestno='E9972WOR6000046'

Update a set WORCreatedDate= HWORQ_Inserted_On
from #Invoices a, eip.sqlwom.WOM_H_Work_Order_Request
where worequestno = HWORQ_Request_Number
and WORCreatedDate is NULL

Update a set WORMinApproved= Mindt,WORMaxApproved=maxdt
from #Invoices a, (select TWODA_Document_Reference_Number, min(twoda_action_on) mindt, max(twoda_action_on) maxdt
			from eip.sqlwom.WOM_T_Document_Approvals, #Invoices c
			where c.worequestno = TWODA_Document_Reference_Number and TWODA_DS_Code=2 
					and twoda_amendment_number=0
			group by TWODA_Document_Reference_Number) d
where a.worequestno=TWODA_Document_Reference_Number


uPDATE A SET  BUDESC= B.bu_description
FROM #INVOICES A, business_unit_master B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE
AND C.BU_CODE = B.BU_CODE


uPDATE A SET  ICDESC= B.Sector_Description
FROM #INVOICES A, LNT.DBO.SECTOR_MASTER B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE AND B.Company_Code= C.company_code
AND C.Sector_Code = B.Sector_Code

update #invoices set budesc=replace(budesc,',','-'),ICDESC=replace(ICDESC,',','-')

select b.DLRV_LR_Number,b.DLRV_WO_Bill_Number, hbill_bill_date ,hbill_from_date,hbill_to_date,HWO_WO_Number, HWO_WOT_Code, hwo_currency_code,hwo_wo_date,d.HWO_Job_Code,
	d.HWO_WO_Request_Number,hwo_from_date,hwo_to_date,d.HWO_WO_Amount,a.*
---MJITC_Item_Group_Code, MJITC_Item_Code,dwmbl_asset_code,MJITC_Item_Description,MJITC_Item_Additional_Description,a.*
from #invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b, eip.sqlwom.WOM_H_Bills c,eip.sqlwom.WOM_H_Work_Orders d
		--,eip.sqlwom.WOM_M_Job_Item_Codes
where a.tlreg_lr_number = b.DLRV_LR_Number and a.ordernumber = HWO_WO_Number
and b.DLRV_WO_Bill_Number= hbill_bill_number --and DWMBL_Item_Code= MJITC_Item_Code
--and DWMBL_Job_Code= MJITC_Job_Code
--and MJITC_Company_Code=1 
--and jobcode in   ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810')
--and jobcode in   ('le150313','le131215','le131402','le140528')
--and jobcode in ('le151047','le150286','le140149','le150284','le150732')

--select * from eip.sqlwom.WOM_T_Document_Approvals where TWODA_Document_Reference_Number='E9972WOR6000046'

--select hwoa_wo_number, hwoa_amendment_number, hwoa_job_code, hwoa_wo_amendment_date, hwoa_from_date, hwoa_to_date,b.TWODA_Action_By auth_by,b.TWODA_Action_On Authorised_on
--from eip.sqlwom.WOM_H_WOA_Request a, eip.sqlwom.WOM_T_Document_Approvals b, #jobs c
--where hwoa_wo_number = b.TWODA_Document_Reference_Number 
--and hwoa_amendment_number =b.TWODA_Amendment_Number
--and hwoa_job_code=c.job_Code
----and hwoa_job_code  in ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810','le150313','le131215','le131402','le140528','le151047',
----'le150286','le140149','le150284','le150732')
--and twoda_ds_code = 3
--order by 1,2



select * from eip.sqlwom.WOM_D_Work_Orders




 ---common

 select tlreg_dt_code,b.TLRBR_Voucher_Date, tlrbr_dt_Code,sum(b.TLRBR_Paid_Amount), sum(TLRBR_received_amount) NEt
  from eip.sqlfas.FAS_T_Ledger_Register a, eip.sqlfas.FAS_T_Ledger_Register_Breakup b--,#invoices c
 where a.TLREG_LR_Number= b.TLRBR_LR_Number --and a.TLREG_LR_Number= c.tlreg_lr_number
 and  tlrbr_dt_code  in ( 412,414) and a.TLREG_Company_Code=1
 and b.TLRBR_Voucher_Date >='01-Apr-2016'
 and a.TLREG_AC_Code='SZ000010'
 group by b.TLRBR_Voucher_Date, a.TLREG_DT_Code,b.TLRBR_DT_Code
 order by 1


 select  * from eip.sqlfas.FAS_T_Ledger_Register_Breakup where TLRBR_Voucher_Date='01-Apr-2016'
 and TLRBR_DT_Code=414 and TLRBR_AC_Code='SZ000010'







select tlrab_lr_number, tlrab_nd_code, TNDOC_Description, a.TLRAB_Gross_Amount
 from eip.sqlfas.fas_t_ledger_Register_gross_amount_break_up a, eip.sqlfas.FAS_T_Nature_Of_Document, #invoices c
where TNDOC_ND_Code= a.TLRAB_ND_Code and c.tlreg_lr_number=a.TLRAB_LR_Number
and a.TLRAB_ND_Code not in ( 1,9)
and tlreg_dt_code = TNDOC_DT_Code



select tlreg_lr_number, c.MDOCR_DR_Code, c.MDOCR_Description Rejectionreason, a.TDOCR_Inserted_On rejeectedon, a.TDOCR_Inserted_By rejectdby
 from eip.sqlfas.FAS_T_Document_Reasons a, #invoices b,  eip.sqlmas.GEN_M_Document_Reasons c
where a.TDOCR_Document_Reference_Number= b.tlreg_lr_number
and a.TDOCR_DT_Code= tlreg_dt_Code
and a.TDOCR_DT_Code=c.MDOCR_DT_Code and mdocr_dr_code = a.TDOCR_DR_Code


select distinct scrutinyid, MUSGD_Full_Name from #invoices , eip.sqlmas.GEN_M_User_General_Details
where scrutinyid  = MUSGD_User_ID


select distinct sjvuid, MUSGD_Full_Name from #invoices , eip.sqlmas.GEN_M_User_General_Details
where SJVuid  = MUSGD_User_ID



---Masters

select region_code regncode, region_description description
 from region_master where Company_Code='LE' and Active_Tag='Y'


 select * from eip.sqlmas.GEN_U_Unit_Of_Measurement where UUOM_ISActive='Y'
 
 select a.vendor_code, a.vendor_description, service_tax_registration_no, a.central_sales_tax, a.state_sales_Tax, a.pan_number,a.payment_mode
 from finance.dbo.IT_Vendor_View a 
where a.Company_Code='LE' and exists ( select 'x' from #invoices b
where vendorcode= vendor_code)

---TDS master

select a.MSDK_Standard_Deduction_Key_Code, a.MSDK_Standard_Deduction_Code, b.MSDKD_Standard_Deduction_Component_Code,
 c.MSD_Description, d.MSDSR_Description, e.MSDC_Description,f.MSDCP_Description,b.MSDKD_Percentage,b.MSDKD_Effective_From, b.MSDKD_Effective_Up_To
 from eip.sqlmas.GEN_M_Standard_Deduction_Key a, eip.sqlmas.GEN_M_Standard_Deduction_Key_Details b, eip.sqlmas.GEN_M_Standard_Deductions c,
eip.sqlmas.GEN_M_Standard_Deduction_Section_Reference d, eip.sqlmas.GEN_M_Standard_Deduction_Category e, eip.sqlmas.GEN_M_Standard_Deduction_Components f
where
MSDK_Standard_Deduction_Key_Code= b.MSDKD_Standard_Deduction_Key_Code AND
a.MSDK_Company_Code=1 and a.MSDK_Company_Code= c.MSD_Company_Code and  a.MSDK_Company_Code= e.MSDC_Company_Code and f.MSDCP_Company_Code= a.MSDK_Company_Code and
a.MSDK_Standard_Deduction_Code= c.MSD_Standard_Deduction_Code AND a.MSDK_Standard_Deduction_Code= e.MSDC_Standard_Deduction_Code and
a.MSDK_Section_Reference_Code= d.MSDSR_Section_Reference_Code AND f.MSDCP_Standard_Deduction_Code=a.MSDK_Standard_Deduction_Code AND
b.MSDKD_Standard_Deduction_Component_Code= f.MSDCP_Standard_Deduction_Component_Code and
a.MSDK_ISActive='Y' and
e.MSDC_Standard_Deduction_Category_Code= a.MSDK_Standard_Deduction_Category_Code and
b.MSDKD_Effective_From>='01-Apr-2016' AND
b.MSDKD_ISActive='Y'and
a.MSDK_Standard_Deduction_Category_Code= e.MSDC_Standard_Deduction_Category_Code 

---service tax master


select b.MNS_Service_Description,c.MSTC_Service_Tax_Components_Description,a.* from eip.sqlmas.GEN_M_Service_Tax_Combinations a,eip.sqlmas.Gen_M_Nature_of_Services b,EIP.SQLMAS.GEN_M_Service_Tax_Components c
where  mstpc_service_tax_effective_from='01-Apr-2016' and a.MSTPC_Service_Tax_Component_Code= c.MSTC_Service_Tax_Components
and a.MSTPC_Service_Code= b.MNS_Service_Code


