
-----wOR Date basis
 drop table #invoices
Select HWORQ_Request_Number wornumber, HWORQ_Date wordate, HWORQ_Job_Code job_Code  into #invoices
 from eip.sqlwom.wom_H_work_order_request where HWORQ_Date between '01-Jan-2017' and '31-Oct-2017' and hworq_ds_Code=3 
and hworq_company_Code=1


Alter Table #invoices add amendno int, lastamdDate date,noofstages int
alter table #invoices add retnbg char(1)
alter table #invoices add wostddedn date
alter table #invoices add WO_number varchar(30)
alter table #invoices add Tlreg_lr_number varchar(30)

Update a set  WO_number=hwo_wo_number
from #invoices a , eip.sqlwom.wom_h_work_orders
where HWO_WO_Request_Number=wornumber

Update a set tlreg_lr_number = hlrv_lr_number
from #invoices a, eip.sqlfas.fas_h_ledger_register_vendor, eip.sqlfas.fas_t_ledger_register b
where hlrv_lr_number = b.tlreg_lr_number and hlrv_wo_number = wo_number
and b.TLREG_LR_Date>=wordate

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


update #invoices set WOBillNumber = null,Billdate=null,Billdedndate=null,BillDednApprovaldate= null

Update a set WOBillNumber= b.DLRV_WO_Bill_Number
from #Invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b, eip.sqlfas.fas_h_ledger_register_vendor 
where hlrv_lr_number = b.DLRV_LR_Number and a.tlreg_lr_number = HLRV_LR_Number

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
where wo_number = TWODA_Document_Reference_Number
and TWODA_DS_Code=3
and TWODA_Amendment_Number=0

Update a set woapprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where wornumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=3
and woapprovaldate is NULL

Update a set WORCreatedDate= Twoda_Action_On
--select * 
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where wornumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=1 --and worequestno='E9972WOR6000046'

Update a set wostddedn= Twoda_Action_On
--select * 
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where wornumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=16 --and worequestno='E9972WOR6000046'

--select * from eip.sqlmas.GEN_M_Document_Status where MDOCS_DT_Code=301

Update a set WORCreatedDate= HWORQ_Inserted_On
from #Invoices a, eip.sqlwom.WOM_H_Work_Order_Request
where wornumber = HWORQ_Request_Number
and WORCreatedDate is NULL

Update a set WORMinApproved= Mindt,WORMaxApproved=maxdt
from #Invoices a, (select TWODA_Document_Reference_Number, min(twoda_action_on) mindt, max(twoda_action_on) maxdt
			from eip.sqlwom.WOM_T_Document_Approvals, #Invoices c
			where c.wornumber = TWODA_Document_Reference_Number and TWODA_DS_Code=2 
					and twoda_amendment_number=0
			group by TWODA_Document_Reference_Number) d
where a.wornumber=TWODA_Document_Reference_Number


uPDATE A SET  BUDESC= B.bu_description
FROM #INVOICES A, lnt.dbo.business_unit_master B, LNT.DBO.JOB_MASTER c
WHERE A.job_Code = C.JOB_cODE
AND C.BU_CODE = B.BU_CODE


uPDATE A SET  ICDESC= B.Sector_Description
FROM #INVOICES A, LNT.DBO.SECTOR_MASTER B, LNT.DBO.JOB_MASTER c
WHERE A.job_Code = C.JOB_cODE AND B.Company_Code= C.company_code
AND C.Sector_Code = B.Sector_Code

update #invoices set budesc=replace(budesc,',','-'),ICDESC=replace(ICDESC,',','-')


alter table #invoices add mindisbdate date
alter table #invoices add Maxdisbdate date

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



select b.DLRV_LR_Number,b.DLRV_WO_Bill_Number, hbill_bill_date ,hbill_from_date,hbill_to_date,HWO_WO_Number, HWO_WOT_Code, hwo_currency_code,hwo_wo_date,d.HWO_Job_Code,
	d.HWO_WO_Request_Number,hwo_from_date,hwo_to_date,d.HWO_WO_Amount,a.*
---MJITC_Item_Group_Code, MJITC_Item_Code,dwmbl_asset_code,MJITC_Item_Description,MJITC_Item_Additional_Description,a.*
from #invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b, eip.sqlwom.WOM_H_Bills c,eip.sqlwom.WOM_H_Work_Orders d
		--,eip.sqlwom.WOM_M_Job_Item_Codes
where a.tlreg_lr_number = b.DLRV_LR_Number and a.wo_number = HWO_WO_Number
and b.DLRV_WO_Bill_Number= hbill_bill_number --and DWMBL_Item_Code= MJITC_Item_Code
--and DWMBL_Job_Code= MJITC_Job_Code
--and MJITC_Company_Code=1 
--and jobcode in   ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810')
--and jobcode in   ('le150313','le131215','le131402','le140528')
--and jobcode in ('le151047','le150286','le140149','le150284','le150732')



select hwoa_wo_number, hwoa_amendment_number, hwoa_job_code, hwoa_wo_amendment_date, hwoa_from_date, hwoa_to_date,b.TWODA_Action_By auth_by,b.TWODA_Action_On Authorised_on
from eip.sqlwom.WOM_H_WOA_Request a, eip.sqlwom.WOM_T_Document_Approvals b, #jobs c
where hwoa_wo_number = b.TWODA_Document_Reference_Number 
and hwoa_amendment_number =b.TWODA_Amendment_Number
and hwoa_job_code=c.job_Code
--and hwoa_job_code  in ('LE120315','le150230','le150011','le141037','le150922','le160041','le150181','le140931','le150810','le150313','le131215','le131402','le140528','le151047',
--'le150286','le140149','le150284','le150732')
and twoda_ds_code = 3
order by 1,2

