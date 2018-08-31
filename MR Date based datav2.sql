

use finance
go

DROP TABLE #MRTOPAY
select a.hmr_mr_number,hmr_mr_date ,DMR_QTY, DMR_Material_Code,cast(null as date) mrauthdate, cast(null as date) pocreatedate, cast(null as varchar(30)) POnumber,
cast(null as date)poauthdate, cast(null as date) mingindate, cast(null as date) maxgindate,cast(null as varchar(30)) ginnumber,cast(0 as money) gin_qty,
cast(null as date ) mindcdate, cast(null as date) maxdcdate, cast(null as date) minmrndate, cast(null as varchar(30)) mrnnumber,cast(0 as money) mrnqty,
cast(0 as money) mrnvalue, 
cast(null as date) maxmrndate, cast(null as date) mininvdate, cast(null as date) maxinvdate,
cast(null as date) lrdate, cast(null as varchar(30)) lrnumber, cast(null as date) invscrutiny, cast(null as date) jvdate, cast(null as date) MINDISBDATE,
 cast(null as date) MAXDISBDATE, cast(null as varchar(100)) BUdesc,cast(null as varchar(100)) ICdesc,cast(null as varchar(30)) material_code, cast(null as varchar(30)) GIN_material_code, cast(null as varchar(30)) MRN_material_code,
hmr_job_code jobcode
into #MRtopay
from eip.sqlscm.SCM_H_Material_Request a, eip.sqlscm.SCM_D_Material_Request B


select *from eip.sqlscm.SCM_D_Material_Request
select *from eip.sqlscm.SCM_h_Material_Request
where hmr_mr_date between '01-Sep-2017' and '04-sep-2017'
and a.HMR_Company_Code=1
AND a.hmr_mr_number = dmr_mr_number
and a.HMR_Company_Code=1
and hmr_ds_code <> 8
---select *from #mrtopay

update a set mrauthdate= tscda_action_on
from #mrtopay a, eip.sqlscm.SCM_T_Document_Approvals 
where hmr_mr_number = TSCDA_Document_Reference_Number
and TSCDA_DS_Code=3

---select * from eip.sqlscm.SCM_H_Purchase_Orders where HPO_MR_Number='EC461EMR7000359'


update a set POnumber= HPO_PO_Number, pocreatedate = HPO_PO_Date,  material_code = DPO_Material_Code
from #mrtopay a, eip.sqlscm.SCM_H_Purchase_Orders , eip.sqlscm.SCM_D_Purchase_Orders
where hmr_mr_number = HPO_MR_Number and hpo_po_number = dpo_po_number and HPO_Company_Code=1 
and a.dmr_material_code = dpo_material_code 

and DPO_Material_Code in ('313050000','3O41M0001000000','3O41M0001000001')



update a set poauthdate= tscda_action_on
from #mrtopay a, eip.sqlscm.SCM_T_Document_Approvals 
where POnumber = TSCDA_Document_Reference_Number
and TSCDA_DS_Code=3

--select * from #mrtopay


update a set ginnumber= HGIN_GIN_Number, mingindate = d.mingindate, 
			maxgindate=d.maxgindate, mindcdate= d.mindcdate, maxdcdate=d.maxdcdate, gin_qty = d.DGIN_Received_Qty
from #mrtopay a, ( select hgin_gin_number, hgin_po_number, min(hgin_gin_date) mingindate, max(hgin_gin_date) maxgindate,
min(dgin_dc_date) mindcdate, max(dgin_dc_date) maxdcdate,  sum(DGIN_Received_Qty) DGIN_Received_Qty, max(DGIN_Material_Code) DGIN_Material_Code
from eip.sqlscm.SCM_H_GIN , eip.sqlscm.scm_d_gin b,#mrtopay c
where c.ponumber = HGIN_PO_Number and HGIN_GIN_Number=b.DGIN_GIN_Number 
and c.material_code = DGIN_Material_Code 
group by HGIN_GIN_Number, HGIN_PO_Number, gin_qty) d
where hgin_po_number = a.ponumber


update a set mrnnumber= d.HMRN_MRN_Number, minmrndate = d.minmrndate, maxmrndate=d.maxmrndate, mrnqty = d.DMRN_ACCEPTED_QTY , mrnvalue =d.DMRN_VALUE
from #mrtopay a, ( select HMRN_MRN_Number, HMRN_PO_Number, min(HMRN_MRN_Date) minmrndate, max(HMRN_MRN_Date) maxmrndate,  sum(DMRN_ACCEPTED_QTY) DMRN_ACCEPTED_QTY, sum(DMRN_VALUE) DMRN_VALUE, max(MRN_Material_Code) MRN_Material_Code
from  eip.sqlscm.SCM_H_MRN , eip.sqlscm.SCM_D_MRN b,#mrtopay c
where c.ponumber = HMRN_PO_Number and HMRN_MRN_Number=b.DMRN_MRN_Number 
and c.material_code = B.DMRN_Material_Code 
group by HMRN_MRN_Number, HMRN_PO_Number, mrnqty,mrnvalue) d
where HMRN_PO_Number = a.ponumber 


---select *from eip.sqlscm.SCM_H_MRN 


alter table #mrtopay add invoiceamount varchar(30)

update a set lrnumber= TLREG_LR_Number, lrdate =tlreg_lr_date, invoiceamount= TLREG_Gross_Amount
from #mrtopay a, eip.sqlfas.FAS_T_Ledger_Register , eip.sqlfas.FAS_H_Ledger_Register_Vendor, eip.sqlfas.FAS_D_Ledger_Register_Vendor
where TLREG_LR_Number= HLRV_LR_Number and HLRV_LR_Number = DLRV_LR_Number
and mrnnumber = DLRV_MRN_Number
and tlreg_ds_code <> 8

update a set invscrutiny= b.TDAPR_Action_On
from #mrtopay a, eip.sqlfas.FAS_T_Document_Approvals b 
where lrnumber = b.TDAPR_Document_Reference_Number
and b.TDAPR_DS_Code=4


update a set jvdate= b.TDAPR_Action_On
from #mrtopay a, eip.sqlfas.FAS_T_Document_Approvals b 
where lrnumber = b.TDAPR_Document_Reference_Number
and b.TDAPR_DS_Code=19



update a set MINDISBDATE = d.minmrndate, MAXDISBDATE=d.maxmrndate
from #mrtopay a, ( select LRNUMBER ,  min(TDAPR_Action_On) minmrndate, max(TDAPR_Action_On) maxmrndate
from  #mrtopay c, EIP.SQLFAS.FAS_T_DOCUMENT_APPROVALS
where LRNUMBER=TDAPR_DOCUMENT_REFERENCE_NUMBER AND TDAPR_DS_CODE=7
group by LRNUMBER) d
where D.LRNUMBER = a.LRNUMBER

SELECT * FROM #MRTOPAY WHERE LRNUMBER IS NOT NULL




uPDATE A SET  BUdesc= c.bu_description
FROM #mrtopay A, lnt.dbo.job_master B, LNT.DBO.business_unit_master c
WHERE A.JOBCODE = b.JOB_cODE AND B.company_code=C.company_code
AND C.BU_CODE = B.BU_CODE


uPDATE A SET ICDESC= c.Sector_Description
FROM #mrtopay A, LNT.DBO.job_master B, LNT.DBO.Sector_Master c
WHERE A.JOBCODE = b.JOB_cODE AND B.Company_Code= C.company_code
AND C.Sector_Code = B.Sector_Code


update #mrtopay set budesc=replace(budesc,',','-'),ICDESC=replace(ICDESC,',','-')


--select distinct a.TLREG_LR_Number ebrnumber into #tlreg
--from eip.sqlfas.FAS_T_Ledger_Register a
--where TLREG_DS_Code<>8 and tlreg_job_code in ( select job_code from #jobs) 
--and tlreg_lr_date between '01-Sep-2016' and '30-Sep-2017' and a.TLREG_Dt_Code in ( 403,404)

---For payment based Invoices
--drop table #tlreg
--select distinct TLREG_LR_Number ebrnumber into #tlreg from eip.sqlfas.FAS_T_Ledger_Register_Breakup a, eip.sqlfas.fas_t_ledger_register 
--where TLRBR_Cheque_Date between '01-Sep-2017' and '30-Sep-2017'
--and a.TLRBR_LR_Number= TLREG_LR_Number
--and TLREG_DS_Code<>8
--and TLREG_Currency_Code=72 and TLREG_DT_Code in ( 403,404)
--and TLREG_Company_Code=1 


--select TLREG_LR_Number, TLREG_LR_Date Invregisterdate, TLREG_DT_Code, TLREG_Bill_Number InvoiceNo, TLREG_Bill_Date invoicedate,tlreg_job_code JObcode, 
--tlreg_vendor_code vendorcode,cast(null as varchar(3000)) VendName,TLREG_Gross_Amount invvalue, cast ( null as varchar(30)) ordernumber,
--cast(null as varchar(15)) PVTag,cast(null as varchar(15)) LDTag, 
--cast(null as varchar(15)) ContrBG,cast(null as varchar(15)) advbg,cast(null as varchar(15)) perfbg,cast ( null as date) AcknowDate, 
-- cast ( null as date) InvPhyDate, cast ( null as date) MinScrutinyDate, cast ( null as date) MaxScrutinyDate, cast ( null as date) Canceldate,
-- cast ( null as date) JVDate, cast ( null as date) MinDisbdate, cast ( null as date) Maxdisbdate,
--  cast ( null as date) rejectdate,    cast ( 0 as int) ptevent,cast ( 0 as int) ptcategory,
--  cast ( null as date) duedate,cast ( null as varchar(500)) paymentterm , cast(null as varchar(3000)) MRnNumbers, cast(0 as int) scrutinyid,cast(0 as int) SJVuid,
--  cast(null as varchar(30)) materialcode,cast(null as varchar(30)) materialgroup, cast(null as varchar(300)) cancelremarks,cast(null as varchar(300)) Rejectremarks,
--  cast(null as varchar(3000)) Rejreasons,cast(0 as money) ptquantum
--into #mrtopay 
--from eip.sqlfas.fas_t_ledger_register 
--where exists ( select 'x' from #tlreg where TLREG_LR_Number= ebrnumber)



select * from #mrtopay

select HPO_JOB_CODE,hmr_mr_number,a.HMR_MR_Date,a.DMR_QTY, a.mrauthdate, POAuthdate,pocreatedate, maxgindate,	maxmrndate,maxinvdate,JVDate,	MinDisbdate,	Maxdisbdate,	HPO_PO_Number,	BUdesc,	ICdesc,lrnumber,A.material_code,d.DPO_Basic_Rate,d.DPO_Net_Rate,d.DPO_Value,d.DPO_Qty,
a.invoiceamount, mrnnumber,maxmrndate, HPO_Warehouse_Code, HPO_BA_CODE, maxgindate,ginnumber, gin_qty, mrnqty, mrnvalue, GIN_material_code, MRN_material_code
--, A.*	
from #mrtopay a,  eip.sqlscm.SCM_H_Purchase_Orders c, eip.sqlscm.SCM_D_Purchase_Orders d
--, eip.sqlfas.fas_t_ledger_register e
where ponumber = HPO_PO_Number and HPO_PO_Number =DPO_PO_NUMBER
and DPO_Material_Code in ('313050000','3O41M0001000000','3O41M0001000001')

---try 
select HPO_JOB_CODE,hmr_mr_number,a.HMR_MR_Date,a.DMR_QTY, a.mrauthdate, POAuthdate, maxgindate,	maxmrndate,maxinvdate,JVDate,	MinDisbdate,	Maxdisbdate,	HPO_PO_Number,	BUdesc,	ICdesc,lrnumber,A.material_code,d.DPO_Basic_Rate,d.DPO_Net_Rate,d.DPO_Value,d.DPO_Qty,
a.invoiceamount, mrnnumber,maxmrndate, HPO_Warehouse_Code, HPO_BA_CODE, maxgindate,ginnumber, e.DGIN_Received_Qty gin_qty, mrnqty DMRN_ACCEPTED_QTY, mrnvalue DMRN_VALUE
--, A.*	
from #mrtopay a,  eip.sqlscm.SCM_H_Purchase_Orders c, eip.sqlscm.SCM_D_Purchase_Orders d,eip.sqlscm.scm_d_gin e,eip.sqlscm.scm_h_gin,   eip.sqlscm.SCM_D_MRN  f, eip.sqlscm.SCM_H_MRN
--, eip.sqlfas.fas_t_ledger_register e
where ponumber = HPO_PO_Number and HPO_PO_Number =DPO_PO_NUMBER
and HPO_PO_Number = HGIN_PO_Number and HGIN_GIN_Number=DGIN_GIN_Number
and HPO_PO_Number = HMRN_PO_Number and HMRN_MRN_Number=DMRN_MRN_Number


and DPO_Material_Code in ('313050000','3O41M0001000000','3O41M0001000001')

a---nd HPO_PO_nUMBER in ('EC030PO7000339','EC999PO7000154','EC999PO7000175','EC999PO7000179','EF201PO7000082','EG450PO7000016','EC030PO7000338','EC461PO7000258','EC461PO7000261','EC461PO7000263','EC461PO7000291','EC461PO7000293','EC461PO7000294','EC461PO7000298','EC461PO7000326','EC461PO7000328','EC461PO7000331','EC461PO7000332','EC461PO7000334','EC461PO7000336','EC461PO7000337','EC461PO7000338','EC461PO7000339','EC461PO7000340','EC461PO7000343','EC461PO7000345','EC461PO7000346','EC461PO7000347','EC461PO7000349','EC461PO7000350','EC461PO7000351','EC461PO7000353','EC461PO7000354','EC461PO7000355','EC461PO7000356','EC461PO7000358','EC461PO7000359','EC461PO7000367','EC461PO7000369','EC461PO7000377','EC462PO7000305','EC462PO7000314','EC462PO7000319','EC462PO7000320','EC462PO7000321','EC462PO7000324','EC462PO7000327','EC462PO7000340','EC462PO7000346','EC462PO7000347','EC462PO7000348','EC462PO7000349','EC462PO7000350','EC462PO7000351','EC462PO7000352','EC462PO7000353','EC462PO7000354','EC462PO7000370','EC462PO7000377','EC462PO7000379','EC462PO7000381','EC462PO7000382','EC462PO7000396','EC462PO7000397','EC463PO7000248','EC463PO7000250','EC463PO7000253','EC463PO7000264','EC463PO7000266','EC463PO7000269','EC463PO7000275','EC463PO7000295','EC463PO7000300','EC463PO7000301','EC463PO7000306','EC463PO7000307','EC463PO7000308','EC463PO7000309','EC463PO7000310','EC463PO7000311','EC463PO7000312','EC463PO7000313','EC463PO7000314','EC463PO7000315','EC463PO7000316','EC463PO7000320','EC463PO7000321','EC999PO7000151','EC999PO7000153','EC999PO7000173','EC999PO7000174','EC999PO7000177','EC999PO7000178','EE569PO7000422','EF201PO7000085','EG450PO7000015','EG745PO7000018 ','EG795PO7000004')
--and tlreg_dt_code=404 and tlreg_ds_code <> 8

DROP TABLE #MRNdetails

---Material
select distinct DMRN_MRN_Number,HMRN_MRN_Date, 
		HMRN_PO_Number,MMAT_MG_Code, DMRN_Material_Code,MMGRP_Description, hmrn_job_code, DPOT_Stock_Type_Detail_Code, DPOT_Direct_Supply, MMGRP_Class_Code
into #MRNdetails
 from #mrtopay a, eip.sqlscm.scm_h_mrn , eip.sqlscm.SCM_D_MRN, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Groups,
		eip.sqlscm.SCM_D_Purchase_Order_Terms
	where a.mrnnumber = dmrn_mrn_number and dmrn_mrn_number = hmrn_mrn_number
 and MMAT_Material_Code= DMRN_Material_Code
and MMAT_Company_Code=1 AND HMRN_PO_NUMBER = DPOT_PO_Number 
and MMAT_MG_Code= MMGRP_MG_Code and MMGRP_Company_Code=MMAT_Company_Code
('LE/SZ000010/FPI/17/INR/0331511','LE/SZ000010/FPI/17/INR/0278683','LE/SZ000010/FPI/17/INR/0133570','LE/SZ000010/FPI/17/INR/0214871','LE/SZ000010/FPI/17/INR/0184413','LE/SZ000010/FPI/17/INR/0082707','LE/SZ000010/FPI/17/INR/0138482','LE/SZ000010/FPI/17/INR/0042102','LE/SZ000010/FPI/17/INR/0111767','LE/SZ000010/FPI/17/INR/0169794','LE/SZ000010/FPI/17/INR/0169664','LE/SZ000010/FPI/17/INR/0113690','LE/SZ000010/FPI/17/INR/0158159','LE/SZ000010/FPI/17/INR/0158070','LE/SZ000010/FPI/17/INR/0095730','LE/SZ000010/FPI/17/INR/0154972','LE/SZ000010/FPI/17/INR/0155007','LE/SZ000010/FPI/17/INR/0096362','LE/SZ000010/FPI/17/INR/0162224','LE/SZ000010/FPI/17/INR/0200036','LE/SZ000010/FPI/17/INR/0170656','LE/SZ000010/FPI/17/INR/0106436','LE/SZ000010/FPI/17/INR/0105639','LE/SZ000010/FPI/17/INR/0063567','LE/SZ000010/FPI/17/INR/0373233','LE/SZ000010/FPI/17/INR/0161475','LE/SZ000010/FPI/17/INR/0242515','LE/SZ000010/FPI/17/INR/0106212','LE/SZ000010/FPI/17/INR/0116899','LE/SZ000010/FPI/17/INR/0143722','LE/SZ000010/FPI/17/INR/0116942','LE/SZ000010/FPI/17/INR/0098360','LE/SZ000010/FPI/17/INR/0169981','LE/SZ000010/FPI/17/INR/0168632','LE/SZ000010/FPI/17/INR/0124161','LE/SZ000010/FPI/17/INR/0162320','LE/SZ000010/FPI/17/INR/0200048','LE/SZ000010/FPI/17/INR/0379557','LE/SZ000010/FPI/17/INR/0379626','LE/SZ000010/FPI/17/INR/0037781','LE/SZ000010/FPI/17/INR/0250816','LE/SZ000010/FPI/17/INR/0161470','LE/SZ000010/FPI/17/INR/0119777','LE/SZ000010/FPI/17/INR/0250835','LE/SZ000010/FPI/17/INR/0133869','LE/SZ000010/FPI/17/INR/0373250','LE/SZ000010/FPI/17/INR/0154017','LE/SZ000010/FPI/17/INR/0153288','LE/SZ000010/FPI/17/INR/0127189','LE/SZ000010/FPI/17/INR/0116353','LE/SZ000010/FPI/17/INR/0102174','LE/SZ000010/FPI/17/INR/0146354','LE/SZ000010/FPI/17/INR/0182842','LE/SZ000010/FPI/17/INR/0121099','LE/SZ000010/FPI/17/INR/0121105','LE/SZ000010/FPI/17/INR/0092947')

--and jobcode in   ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810')
--and jobcode in   ('le150313','le131215','le131402','le140528')
--and jobcode in ('le151047','le150286','le140149','le150284','le150732')


drop table #MRNdetails
select distinct b.DLRV_LR_Number,b.DLRV_MRN_Number,b.DLRV_MRN_Date, 
		b.DLRV_WO_Bill_Number,MMAT_MG_Code, DMRN_Material_Code,MMGRP_Description, JObcode, DPOT_Stock_Type_Detail_Code, DPOT_Direct_Supply, MMGRP_Class_Code
into #MRNdetails
 from #mrtopay a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b, eip.sqlscm.SCM_D_MRN, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Groups,
		eip.sqlscm.SCM_D_Purchase_Order_Terms
	where a.lrnumber = b.DLRV_LR_Number and DPOT_PO_Number= a.POnumber
and b.DLRV_MRN_Number= DMRN_MRN_Number and MMAT_Material_Code= DMRN_Material_Code
and MMAT_Company_Code=1 
and MMAT_MG_Code= MMGRP_MG_Code and MMGRP_Company_Code=MMAT_Company_Code
and lrnumber in ('LE/SZ000010/FPI/17/INR/0331511','LE/SZ000010/FPI/17/INR/0278683','LE/SZ000010/FPI/17/INR/0133570','LE/SZ000010/FPI/17/INR/0214871','LE/SZ000010/FPI/17/INR/0184413','LE/SZ000010/FPI/17/INR/0082707','LE/SZ000010/FPI/17/INR/0138482','LE/SZ000010/FPI/17/INR/0042102','LE/SZ000010/FPI/17/INR/0111767','LE/SZ000010/FPI/17/INR/0169794','LE/SZ000010/FPI/17/INR/0169664','LE/SZ000010/FPI/17/INR/0113690','LE/SZ000010/FPI/17/INR/0158159','LE/SZ000010/FPI/17/INR/0158070','LE/SZ000010/FPI/17/INR/0095730','LE/SZ000010/FPI/17/INR/0154972','LE/SZ000010/FPI/17/INR/0155007','LE/SZ000010/FPI/17/INR/0096362','LE/SZ000010/FPI/17/INR/0162224','LE/SZ000010/FPI/17/INR/0200036','LE/SZ000010/FPI/17/INR/0170656','LE/SZ000010/FPI/17/INR/0106436','LE/SZ000010/FPI/17/INR/0105639','LE/SZ000010/FPI/17/INR/0063567','LE/SZ000010/FPI/17/INR/0373233','LE/SZ000010/FPI/17/INR/0161475','LE/SZ000010/FPI/17/INR/0242515','LE/SZ000010/FPI/17/INR/0106212','LE/SZ000010/FPI/17/INR/0116899','LE/SZ000010/FPI/17/INR/0143722','LE/SZ000010/FPI/17/INR/0116942','LE/SZ000010/FPI/17/INR/0098360','LE/SZ000010/FPI/17/INR/0169981','LE/SZ000010/FPI/17/INR/0168632','LE/SZ000010/FPI/17/INR/0124161','LE/SZ000010/FPI/17/INR/0162320','LE/SZ000010/FPI/17/INR/0200048','LE/SZ000010/FPI/17/INR/0379557','LE/SZ000010/FPI/17/INR/0379626','LE/SZ000010/FPI/17/INR/0037781','LE/SZ000010/FPI/17/INR/0250816','LE/SZ000010/FPI/17/INR/0161470','LE/SZ000010/FPI/17/INR/0119777','LE/SZ000010/FPI/17/INR/0250835','LE/SZ000010/FPI/17/INR/0133869','LE/SZ000010/FPI/17/INR/0373250','LE/SZ000010/FPI/17/INR/0154017','LE/SZ000010/FPI/17/INR/0153288','LE/SZ000010/FPI/17/INR/0127189','LE/SZ000010/FPI/17/INR/0116353','LE/SZ000010/FPI/17/INR/0102174','LE/SZ000010/FPI/17/INR/0146354','LE/SZ000010/FPI/17/INR/0182842','LE/SZ000010/FPI/17/INR/0121099','LE/SZ000010/FPI/17/INR/0121105','LE/SZ000010/FPI/17/INR/0092947')


select *from #MRNdetails


select * from #MRNdetails A,#mrtopay B
WHERE DMRN_MRN_Number= MRNNUMBER

Select * from eip.sqlfas.FAS_T_Ledger_Register a, eip.sqlfas.FAS_H_Ledger_Register_Vendor
where TLREG_LR_Number= HLRV_LR_Number




select * from eip.sqlfas.FAS_T_Document_Approvals where TDAPR_Document_Reference_Number='LE/SZ000010/FPI/16/INR/0538756'

SELECT *FROM eip.sqlscm.scm_d_gin
