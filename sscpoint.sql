
use finance
GO
select * from sqlfas.FAS_T_Document_Approvals where TDAPR_DT_Code = 402 and TDAPR_DS_Code = 13 and TDAPR_Document_Reference_Number ='E0835BIL7000217'

select * from sqlacs.ACS_T_Document_Flow where TDF_Document_Code = 'E0835BIL7000217' and TDF_Sender_UID = 147155  
