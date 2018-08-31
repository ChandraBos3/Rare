
drop table #temp
Create table #temp (dt int, Ref_no varchar(30),Action_date datetime, job varchar(10),IC varchar(100),Amount money)

alter table #temp alter column amount money

--WO

Insert into #temp
select 301,hwo_wo_number,twoda_action_on,hwo_job_code,mcled_description,hwo_wo_amount
from eip.sqlwom.wom_h_work_orders,eip.sqlwom.WOM_T_Document_Approvals ,sqlmas.gen_l_job_cluster_elements, sqlmas.gen_m_cluster_element_details
where 
hwo_wo_number=TWODA_Document_Reference_Number
and TWODA_DT_Code=302
and TWODA_DS_Code=3 
and hwo_job_code=ljce_job_code and  ljce_ic_code = mcled_ced_code and ljce_company_code=1 -- and mcled_ced_code --in(1,535)
and HWO_inserted_on >= '03-Apr-2017'
order by mcled_description , hwo_wo_amount

--WOA
Insert into #temp
select distinct 304, hwo_wo_number,twoda_action_on,hwo_job_code,mcled_description,0
from eip.sqlwom.wom_h_work_orders,eip.sqlwom.WOM_T_Document_Approvals ,sqlmas.gen_l_job_cluster_elements, sqlmas.gen_m_cluster_element_details
where 
hwo_wo_number=TWODA_Document_Reference_Number
and hwo_last_amendment_number=TWODA_Amendment_Number
and TWODA_DT_Code=304
and TWODA_DS_Code=3
and hwo_job_code=ljce_job_code and  ljce_ic_code = mcled_ced_code and ljce_company_code=1--and mcled_ced_code --in(1,535)
and twoda_action_on >=  '03-Apr-2017'

--PO
Insert into #temp
SELECT 204,HPO_PO_Number,TSCDA_Inserted_On,HPO_Job_Code,mcled_description,HPO_PO_net_value 
FROM EIP.SQLSCM.SCM_T_Document_Approvals ,EIP.SQLSCM.scm_H_Purchase_Orders, EIP.SQLMAS.GEN_L_Job_Cluster_Elements, sqlmas.gen_m_cluster_element_details
where HPO_PO_Number = TSCDA_Document_Reference_Number
AND TSCDA_DT_Code= 204 
AND TSCDA_DS_Code = 3
AND LJCE_Job_Code = HPO_Job_Code and  ljce_ic_code = mcled_ced_code and ljce_company_code=1--and mcled_ced_code --in(1,535)
AND TSCDA_Inserted_On >=  '03-Apr-2017'
order by mcled_description , HPO_PO_net_value


--POA
Insert into #temp
SELECT 224,HPOAR_Request_Number,TSCDA_Inserted_On,HPOAR_Job_Code,mcled_description,HPOAR_PO_Net_Value
FROM EIP.SQLSCM.SCM_T_Document_Approvals ,sqlscm.SCM_H_PO_Amend_Request, EIP.SQLMAS.GEN_L_Job_Cluster_Elements, sqlmas.gen_m_cluster_element_details
where HPOAR_Request_Number = TSCDA_Document_Reference_Number
AND TSCDA_DT_Code= 224 
AND TSCDA_DS_Code = 3
AND LJCE_Job_Code = HPOAR_Job_Code and  ljce_ic_code = mcled_ced_code and ljce_company_code=1--and mcled_ced_code --in(1,535)
AND TSCDA_Inserted_On >=  '03-Apr-2017'
order by mcled_description , HPOAR_PO_Net_Value

select * from #temp

select  Ic,dt,count(*)cnt
from #temp, sqlmas.gen_m_document_transaction
where dt=mdoct_dt_code
group by ic,dt
order by dt,ic

