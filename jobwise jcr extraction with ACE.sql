use EPM
GO

drop table #joblist

select TCM_Job_Code Job_code, 'PMP' module , maxdate jcrdate , b.bpcode
into #joblist 
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
										where s.TPBP_PST_Code = 3000 AND 
												s.TPBP_DS_Code IN ('BPDS0003') AND s.TPBP_DS_Code IS NOT NULL
										group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group <>'I' and job_status in ( 'C','R') )
and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 


select TCM_Job_Code Job_code, 'ACE' module , maxdate jcrdate , b.bpcode
into #acejobs
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
										where s.TPBP_PST_Code = 2000 AND 
												s.TPBP_DS_Code IN ('BPDS0003','BPDS0002')  AND s.TPBP_DS_Code IS NOT NULL
										group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group <>'I' and job_status in ( 'C','R') )
and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 


drop table #JCRs

select * from epm.sqlpmp.PMP_T_PBS_Actual_Details  where TPAD_BP_Code=99992
select * from epm.sqlpmp.PMP_T_PBS_Estimation_Details
drop table #aceJCR
drop table #acejobs


select a.TPED_Job_Code jobcode, a.TPED_BP_Code BP_Code, tped_start_date, a.TPeD_End_Date,a.TPeD_PBS_Code,case when a.TPED_PBS_Code is NULL then 'Asset' else case when a.TPeD_PBS_Code like 'IDC%' then 'IDC' else 'NON IDC' end  end as IDC_flag,a.TPED_Quantity ACEQty,
TPED_cost ACEcost,case when TPED_Quantity = 0 then 0 else TPED_cost/TPED_Quantity end Tped_Rate, cast ( 0 as money) Actqty, cast(0 as money) actcost, cast(0 as money) actrate,
cast ( 0 as money) ETCqty, cast(0 as money) ETCcost, cast(0 as money) ETCrate,
cast(0 as money) totalqty,cast(0 as money) TotalCost,cast(0 as money) TotalRate
into #aceJCR
 from  epm.sqlpmp.PMP_T_PBS_Estimation_Details a, #acejobs b
where a.TPED_Job_Code= job_code	 and a.TPED_BP_Code= bpcode

--select *from epm.sqlpmp.PMP_T_PBS_Estimation_Details

select a.TPAD_Job_Code, a.TPAD_BP_Code, tpad_start_date, a.TPAD_End_Date,a.TPAD_PBS_Code,isnull(TPAD_Previous_Period_Quantity,0)+
				isnull(TPAD_Current_Period_Quantity,0) Actqtytilldate,
isnull(TPAD_Previous_Period_Cost,0)+isnull(TPAD_Current_Period_Cost,0) actcosttilldate,TPAD_Overall_Rate,
case when TPAD_Current_Period_Quantity = 0 then 0 else TPAD_Current_Period_Cost/TPAD_Current_Period_Quantity end TPAD_Current_Period_Rate,cast(0 as money) TotalCost,
cast(0 as money) totalqty,cast(0 as money) etcrate
into #JCRs
 from  epm.sqlpmp.PMP_T_PBS_Actual_Details a, #joblist b
where a.TPAD_Job_Code= job_code	 and a.TPAD_BP_Code= bpcode

---SELECT * FROM #JCRs a WHERE TPAD_Job_Code='le150535' AND  TPAD_PBS_Code LIKE 'idc.1310%'


insert into #JCRs
(TPAD_Job_Code,TPAD_BP_Code,tpad_start_date,TPAD_End_Date,TPAD_PBS_Code,Totalcost,totalqty,etcrate)
select TPRE_Job_Code, TPRE_BP_Code , TPRE_Start_Date, TPRE_End_Date,TPRE_PBS_Code,TPRE_Cost Totalcost , 
	TPRE_Quantity totalqty, TPRE_Rate etcrate
from epm.SQLPMP.PMP_T_PBS_Revised_Estimation_Details a, #joblist b 
where TPRE_Job_Code=b.job_code  
and a.TPRE_BP_Code= bpcode

insert into #JCRs
(TPAD_Job_Code,TPAD_BP_Code,tpad_start_date,TPAD_End_Date,TPAD_PBS_Code,Totalcost,totalqty,etcrate)
select TRSED_Job_Code,  TRSED_BP_Code , null startdate, null enddate,'Riskprovision', TRSED_Risk_Provision ,0,0
from 	epm.SQLPMP.PMP_T_Risk_Estimation_Details   a, #joblist b 
where TRSED_Job_Code=b.job_code	
and a.TRSED_BP_Code= bpcode


insert into #JCRs
(TPAD_Job_Code,TPAD_BP_Code,tpad_start_date,TPAD_End_Date,TPAD_PBS_Code,Totalcost,totalqty,etcrate)
select TCECED_Job_Code, TCECED_BP_Code  , null startdate, null enddate, 'Enablingcost', TCECED_Cost ,0,0
from  epm.sqlpmp.PMP_T_Common_Enabling_Cost_Estimation_Details   a, #joblist b 
where TCECED_Job_Code=b.job_code
and TCECED_Cost<>0
and tceced_bp_code = bpcode



alter table #JCRs add PBS_Description varchar(300)

alter table #ACEJCR add PBS_Description varchar(300)

Update a  set PBS_Description=left(ltrim(rtrim(b.TPBS_Description)),300)
from #JCRs a, epm.sqlepm.EPM_T_Project_Breakdown_Structure b
where TPBS_Job_Code= TPAD_Job_Code and TPAD_PBS_Code= b.TPBS_PBS_Code


alter table #ACEJCR add jcrbpcode int, jcrstart date, jcrend date

drop table #jcrgroup
select tpad_job_Code, tpad_bp_code,tpad_pbs_code, sum(actqtytilldate) actqty, sum(actcosttilldate) actcost,
	sum(totalcost) totcost, sum(totalqty) totqty, sum(isnull(totalcost,0)-isnull(actcosttilldate,0)) etccost,
	sum(isnull(totalqty,0)-isnull(actqtytilldate,0)) etcqty
into #jcrgroup
from #jcrs
group by 	tpad_job_Code, tpad_bp_code,tpad_pbs_code

INSERT INTO #aceJCR (jobcode, BP_Code, TPeD_PBS_Code,IDC_flag,ACEQty,
ACEcost,Tped_Rate, Actqty, actcost, ETCqty, ETCcost, totalqty,TotalCost)
SELECT tpad_job_Code, '99992' tpad_bp_code ,tpad_pbs_code,
		case when TPAD_PBS_Code is NULL then 'Asset' else case when TPAD_PBS_Code like 'IDC%' then 'IDC' else 'NON IDC' end  end as IDC_flag,
		 0,0,0,actqty, actcost,etcqty,etccost,totqty,totcost
	 FROM #jcrgroup B
WHERE NOT EXISTS ( SELECT 'X' FROM #aceJCR A WHERE A.jobcode =TPAD_Job_Code 
and tped_pbs_code = tpad_pbs_code )



update a set actqty = b.actqty, actcost=b.actcost, actrate=case when b.actqty=0 then 0 else b.actcost / b.actqty end  ,
			 etcqty=b.etcqty, etccost = b.etccost,
			 etcrate= case when   b.etcqty=0 then 0 else b.etccost / b.etcqty end ,
			   totalqty=b.totqty, totalcost=b.totcost,
			 totalrate=case when b.totqty=0 then 0 else b.totcost / b.totqty end
from #ACEJCR a, #jcrgroup b
where a.jobcode =TPAD_Job_Code 
and tped_pbs_code = tpad_pbs_code

--------------------------------------------------

--AND TPAD_Job_Code='le150535' AND TPAD_PBS_Code='idc.1310'
----------------------------------------------------


Update a  set PBS_Description=left(ltrim(rtrim(b.TPBS_Description)),300)
from #ACEJCR a, epm.sqlepm.EPM_T_Project_Breakdown_Structure b
where b.TPBS_Job_Code= JobCode and TPeD_PBS_Code= b.TPBS_PBS_Code


update a set jcrbpcode=b.TPAD_BP_Code,jcrstart=b.tpad_start_date,jcrend=TPAD_End_Date
from #ACEJCR a, #JCRs b
where a.jobcode =TPAD_Job_Code and tpad_end_date is not NULL
select * from #jcrs


Update #acejcr set pbs_description=replace (pbs_description , char(9),'-')

Update #acejcr set pbs_description=replace (pbs_description , char(10),'-')

Update #acejcr set pbs_description=replace (pbs_description , char(11),'-')

Update #acejcr set pbs_description=replace (pbs_description , char(12),'-')

Update #acejcr set pbs_description=replace (pbs_description , char(13),'-')

Update #acejcr set pbs_description=replace (pbs_description , char(14),'-')

Update #acejcr set pbs_description=replace (pbs_description , '''','f')
Update #acejcr set pbs_description=replace (pbs_description , '"','i')

DROP TABLE #L2
select a.*, b.job_description, b.Sector_Code, c.Sector_Description, d.bu_description , cast(null as int) L2, cast(null as int) L1, 
	cast ( null as varchar(100)) L2Desc, cast(null as varchar(100)) L1Desc into #L2
from #acejcr a, lnt.dbo.job_master b, lnt.dbo.sector_master c, 
	lnt.dbo.business_unit_master d
 where a.jobcode= job_code and b.Sector_Code= c.Sector_Code and b.bu_code=d.bu_code
 and b.company_code=c.Company_Code and b.company_code= d.company_code

update a set L2= b.LPBSAGRP_Activity_Group_Code 
--select LPBSAGRP_Activity_Group_Code,* 
from #L2 a, epm.sqlpmp.PMP_L_PBS_Activity_Groups b
where a.jobcode = b.LPBSAGRP_Job_Code and a.TPED_PBS_Code= b.LPBSAGRP_PBS_Code


update a set L1= b.LAGPAG_Parent_Activity_Group_Code 
from #L2 a, epm.sqlpmp.GEN_L_Activity_Group_Parent_Activity_Group b
where b.LAGPAG_Activity_Group_Code= l2
										
update #L2 set L2Desc = MAGRP_Description B
from epm.sqlpmp.GEN_M_Activity_Groups b where  b.MAGRP_Is_Active='y' and  b.MAGRP_Activity_Group_Level='AGLE0002'
and L2= MAGRP_Activity_Group_Code

select *from epm.sqlpmp.GEN_M_Activity_Groups where MAGRP_Is_Active='y' and  MAGRP_Activity_Group_Level='AGLE0002'




update #L2 set L1Desc = MAGRP_Description
from epm.sqlpmp.GEN_M_Activity_Groups b where  b.MAGRP_Is_Active='y' and  b.MAGRP_Activity_Group_Level='AGLE0001'
and L1= MAGRP_Activity_Group_Code

 Select *from #L2 
 
 ---WHERE jobcode='le150535' AND  TPED_PBS_Code LIKE 'idc.1310%'

 select a.jobcode,	BP_Code,	tped_start_date,	TPeD_End_Date,	TPeD_PBS_Code,	IDC_flag,	ACEQty,	ACEcost,	Tped_Rate,	Actqty,	actcost,	actrate,	ETCqty,	ETCcost,	ETCrate,	totalqty,	TotalCost,	TotalRate,	PBS_Description,jcrbpcode,	jcrstart,	jcrend,	job_description,	Sector_Code,	Sector_Description,	bu_description,job_status, org_contract_value, rev_contract_value, gm, gm_per, direct_cost, indirect_cost, InvCompPC, costcomppc, L1,L1DESC,L2,L2Desc
 from #L2 a, CRM.DBO.Invoice_Valuation_SHEET  where a.jobcode = job_code  AND valuation_month=12 AND valuation_year=2017



select *from lnt.dbo.Location_Master


 select * from epm.sqlpmp.GEN_L_Activity_Group_Parent_Activity_Group a, epm.sqlpmp.GEN_M_Activity_Groups b, epm.sqlpmp.GEN_M_Activity_Groups c
 where b.MAGRP_Is_Active='y' and  b.MAGRP_Activity_Group_Level='AGLE0001' and c.MAGRP_Is_Active='y'and c.MAGRP_Activity_Group_Level='AGLE0002'
 and a.LAGPAG_Parent_Activity_Group_Code =  b.MAGRP_Activity_Group_Code
 and a. LAGPAG_Activity_Group_Code =  c.MAGRP_Activity_Group_Code



Update a set tpad_start_date = s.TPBP_From_Date,TPAD_End_Date = s.TPBP_To_Date
from #JCRs a , epm.sqlpmp.PMP_T_Project_Base_Plans s
										where a.TPAD_Job_Code = S.TPBP_Job_Code AND s.TPBP_PST_Code in ( 2000,3000) 
										and s.TPBP_BP_Code= TPAD_BP_Code




select TPAD_Job_Code,TPAD_BP_Code,tpad_start_date,TPAD_End_Date,TPAD_PBS_Code,PBS_Description, sum(isnull(Totalcost,0)) totalcost,
sum(isnull(totalqty,0)) totalqty, sum(case when isnull(totalqty,0)= 0 then 0 else  isnull(Totalcost,0) /isnull(totalqty,0) END)
 etcrate, sum(isnull(Actqtytilldate,0)) actqtytilldate,
sum(isnull(actcosttilldate,0)) actcost, sum(case when isnull(Actqtytilldate,0) = 0 then 0 else  isnull(actcosttilldate,0) /isnull(Actqtytilldate,0) END)  overallrate,
job_description
From #JCRs a, lnt.dbo.job_master 
where TPAD_Job_Code= job_Code
group by TPAD_Job_Code,TPAD_BP_Code,TPAD_PBS_Code,PBS_Description,tpad_start_date,TPAD_End_Date, job_description


select * from #jcrs
 select * from epm.sqlpmp.GEN_M_Activity_Groups where MAGRP_Is_Active='y' and MAGRP_Activity_Group_Level='AGLE0002'
 and MAGRP_Activity_Group_Code=1035

 ---L2 --'AGLE0002'
 select * from epm.sqlpmp.GEN_M_Activity_Groups where MAGRP_Is_Active='y' and MAGRP_Activity_Group_Level='AGLE0002'

 
 select * from epm.sqlpmp.GEN_L_Activity_Group_Parent_Activity_Group a, epm.sqlpmp.GEN_M_Activity_Groups b, epm.sqlpmp.GEN_M_Activity_Groups c
 where b.MAGRP_Is_Active='y' and  b.MAGRP_Activity_Group_Level='AGLE0001' and c.MAGRP_Is_Active='y'and c.MAGRP_Activity_Group_Level='AGLE0002'
 and a.LAGPAG_Parent_Activity_Group_Code =  b.MAGRP_Activity_Group_Code
 and a. LAGPAG_Activity_Group_Code =  c.MAGRP_Activity_Group_Code


 --L1 to L2 

 select *from epm.sqlpmp.PMP_L_PBS_Activity_Groups, epm.sqlpmp.GEN_M_Activity_Groups 
where  MAGRP_Activity_Group_Level='AGLE0002'
and LPBSAGRP_Activity_Group_Code = MAGRP_Activity_Group_Code
AND LPBSAGRP_JOB_CODE  = 'LE090183'

 select *from epm.sqlpmp.GEN_M_Activity_Groups  WHERE LPBSAGRP_Job_Code  = 'LE090183'
and MAGRP_Is_Active='y' 



 select  * from epm.sqlpmp.PMP_T_Project_Breakdown_Structure where TPBS_Job_Code='le160217'

 select * from epm.sqlpmp.PMP_L_PBS_Activity_Groups where lpbsagrp_job_code='le160217'

 select * from eip.sqlmas.gen_m_project_breakdown_structure