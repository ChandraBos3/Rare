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




drop table #JCRs


select * from epm.sqlpmp.PMP_T_PBS_Actual_Details where TPAD_Job_Code='LE120041' and TPAD_PBS_Code='WP10012'


select a.TPAD_Job_Code, a.TPAD_BP_Code, tpad_start_date, a.TPAD_End_Date,a.TPAD_PBS_Code,TPAD_Previous_Period_Quantity+TPAD_Current_Period_Quantity Actqtytilldate,
TPAD_Previous_Period_Cost+TPAD_Current_Period_Cost actcosttilldate,TPAD_Overall_Rate,
case when TPAD_Current_Period_Quantity = 0 then 0 else TPAD_Current_Period_Cost/TPAD_Current_Period_Quantity end TPAD_Current_Period_Rate,cast(0 as money) TotalCost,
cast(0 as money) totalqty,cast(0 as money) etcrate
into #JCRs
 from  epm.sqlpmp.PMP_T_PBS_Actual_Details a, #joblist b
where a.TPAD_Job_Code= job_code	 and a.TPAD_BP_Code= bpcode

insert into #JCRs
(TPAD_Job_Code,TPAD_BP_Code,tpad_start_date,TPAD_End_Date,TPAD_PBS_Code,Totalcost,totalqty,etcrate)
select TPRE_Job_Code, TPRE_BP_Code , TPRE_Start_Date, TPRE_End_Date,TPRE_PBS_Code,TPRE_Cost Totalcost , 
	TPRE_Quantity totalqty, TPRE_Rate etcrate
from SQLPMP.PMP_T_PBS_Revised_Estimation_Details a, #joblist b 
where TPRE_Job_Code=b.job_code  
and a.TPRE_BP_Code= bpcode

insert into #JCRs
(TPAD_Job_Code,TPAD_BP_Code,tpad_start_date,TPAD_End_Date,TPAD_PBS_Code,Totalcost,totalqty,etcrate)
select TRSED_Job_Code,  TRSED_BP_Code , null startdate, null enddate,'Riskprovision', TRSED_Risk_Provision ,0,0
from 	SQLPMP.PMP_T_Risk_Estimation_Details   a, #joblist b 
where TRSED_Job_Code=b.job_code	
and a.TRSED_BP_Code= bpcode


insert into #JCRs
(TPAD_Job_Code,TPAD_BP_Code,tpad_start_date,TPAD_End_Date,TPAD_PBS_Code,Totalcost,totalqty,etcrate)
select TCECED_Job_Code, TCECED_BP_Code  , null startdate, null enddate, 'Enablingcost', TCECED_Cost ,0,0
from  sqlpmp.PMP_T_Common_Enabling_Cost_Estimation_Details   a, #joblist b 
where TCECED_Job_Code=b.job_code
and TCECED_Cost<>0
and tceced_bp_code = bpcode

alter table #JCRs add PBS_Description varchar(300)

Update a  set PBS_Description=left(ltrim(rtrim(b.TPBS_Description)),300)
from #JCRs a, epm.sqlepm.EPM_T_Project_Breakdown_Structure b
where TPBS_Job_Code= TPAD_Job_Code and TPAD_PBS_Code= b.TPBS_PBS_Code

select a.*, b.job_description, b.Sector_Code, c.Sector_Description, d.bu_description from #JCRs a, lnt.dbo.job_master b, lnt.dbo.sector_master c, lnt.dbo.business_unit_master d
 where a.TPAD_Job_Code= job_code and b.Sector_Code= c.Sector_Code and b.bu_code=d.bu_code
 and b.company_code=c.Company_Code and b.company_code= d.company_code



												

select * from epm.sqlpmp.GEN_M_Project_Stage_Type

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