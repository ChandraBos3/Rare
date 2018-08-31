use EPM
GO

select b.MIGRP_Description,a.*  into #items from epm.sqlpmp.Gen_M_Standard_Resource a, epm.sqlpmp.GEN_M_Item_Groups b
where a.MSR_Resource_Group_Code= b.MIGRP_Item_Group_Code
--and b.MIGRP_Description like 'Misc%'
and a.MSR_IsActive='Y'
and a.MSR_Resource_Type_Code='SCPL'

drop table #items

select MSR_Resource_Group_Code, MIGRP_Description,msr_resource_code, msr_description, msr_standardized_description from #items

Update #items set msr_description = replace (msr_description,char(9),'-'), msr_standardized_description = replace (msr_standardized_description,char(9),'-'),
			MIGRP_Description=replace(MIGRP_Description, char(9),'-')
Update #items set msr_description = replace (msr_description,char(10),'-'), msr_standardized_description = replace (msr_standardized_description,char(10),'-'),
	MIGRP_Description=replace(MIGRP_Description, char(10),'-')
Update #items set msr_description = replace (msr_description,char(11),'-'), msr_standardized_description = replace (msr_standardized_description,char(11),'-'),
	MIGRP_Description=replace(MIGRP_Description, char(11),'-')
Update #items set msr_description = replace (msr_description,char(12),'-'), msr_standardized_description = replace (msr_standardized_description,char(12),'-'),
	MIGRP_Description=replace(MIGRP_Description, char(12),'-')
Update #items set msr_description = replace (msr_description,char(13),'-'), msr_standardized_description = replace (msr_standardized_description,char(13),'-'),
	MIGRP_Description=replace(MIGRP_Description, char(13),'-')
Update #items set msr_description = replace (msr_description,char(14),'-'), msr_standardized_description = replace (msr_standardized_description,char(14),'-'),
	MIGRP_Description=replace(MIGRP_Description, char(14),'-')

Update #items set msr_description = replace (msr_description,'''','-'), msr_standardized_description = replace (msr_standardized_description,'''','-'),
	MIGRP_Description=replace(MIGRP_Description, '''','-')
Update #items set msr_description = replace (msr_description,'"','-'), msr_standardized_description = replace (msr_standardized_description,'"','-'),
	MIGRP_Description=replace(MIGRP_Description, '"','-')
Update #items set msr_description = replace (msr_description,',','-'), msr_standardized_description = replace (msr_standardized_description,',','-'),
	MIGRP_Description=replace(MIGRP_Description, ',','-')

