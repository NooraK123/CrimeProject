---- After importing the RAWCrimeData need to filter for only london local authorities
select
	* 
into [LSOA Cleaning]
from [dbo].[RawCrimeData]
where [LSOA name] like 'City of London%' or 
	  [LSOA name] like 'Barking and Dagenham%' or	
	  [LSOA name] like 'Barnet%' or 
	  [LSOA name] like 'Bexley%' or 
	  [LSOA name] like 'Brent%' or 
	  [LSOA name] like 'Bromley%' or 
	  [LSOA name] like 'Camden%' or 
	  [LSOA name] like 'Croydon%' or 
	  [LSOA name] like 'Ealing%' or 
	  [LSOA name] like 'Enfield%' or 
	  [LSOA name] like 'Greenwich%' or
	  [LSOA name] like 'Hackney%' or 
	  [LSOA name] like 'Hammersmith and Fulham%' or 
	  [LSOA name] like 'Haringey%' or 
	  [LSOA name] like 'Harrow%' or 
	  [LSOA name] like 'Havering%' or
	  [LSOA name] like 'Hillingdon%' or
	  [LSOA name] like 'Hounslow%' or
	  [LSOA name] like 'Islington%' or
	  [LSOA name] like 'Kensington and Chelsea%' or
	  [LSOA name] like 'Kingston upon Thames%' or
	  [LSOA name] like 'Lambeth%' or
	  [LSOA name] like 'Lewisham%' or
	  [LSOA name] like 'Merton%' or
	  [LSOA name] like 'Newham%' or
	  [LSOA name] like 'Redbridge%' or
	  [LSOA name] like 'Richmond upon Thames%' or
	  [LSOA name] like 'Southwark%' or
	  [LSOA name] like 'Sutton%' or
	  [LSOA name] like 'Tower Hamlets%' or
	  [LSOA name] like 'Waltham Forest%' or
	  [LSOA name] like 'Wandsworth%' or
	  [LSOA name] like 'Westminster%'



select
	* 
	,SUBSTRING([LSOA name], 0, LEN([LSOA name]) + 1 - 4) [LocalAuthority]
from [dbo].[LSOA Cleaning]
order by SUBSTRING([LSOA name], 0, LEN([LSOA name]) + 1 - 4)


select
	LEFT([month],4) [Year]
,	SUBSTRING([LSOA name], 0, LEN([LSOA name]) + 1 - 4) [LocalAuthority]
,	[Location]
,	CASE
	WHEN [Crime type] = 'Violent Crime' THEN 'Violence and sexual offences'
	WHEN [Crime type] = 'public disorder and weapons' then 'public order'
	else  [Crime type]  END [Crime Type]	
,	[Longitude]
,	[Latitude]
--into CleanLACrime
from [dbo].[LSOA Cleaning]


select distinct 
[crime type] 
from CleanLACrime


select distinct 
CASE
	WHEN [Crime type] = 'Violent Crime' THEN 'Violence and sexual offences'
	WHEN [Crime type] = 'public disorder and weapons' then 'public order'
	else  [Crime type]  END [Crime Type]
from CleanLACrime

select 
* from YearlyCrimeTrends

select 
	[crime type]
	,count([crime type]) [Total Incidences]
	into TotalCrimeProp
from cleanLACrime 
group by [crime type] 

select 
	[crime type]
	,count([crime type]) [2013 Incidences]
	into CrimeProp13
from cleanLACrime 
where [year] = '2013'
group by [crime type] 

select 
	[crime type]
	,count([crime type]) [2014 Incidences]
	into CrimeProp14
from cleanLACrime 
where [year] = '2014'
group by [crime type] 

select 
	[crime type]
	,count([crime type]) [2015 Incidences]
	into CrimeProp15
from cleanLACrime 
where [year] = '2015'
group by [crime type] 

select 
	[crime type]
	,count([crime type]) [2016 Incidences]
	into CrimeProp16
from cleanLACrime 
where [year] = '2016'
group by [crime type] 

select 
	[crime type]
	,count([crime type]) [2017 Incidences]
	into CrimeProp17
from cleanLACrime 
where [year] = '2017'
group by [crime type] 


select 
	[crime type]
	,count([crime type]) [2018 Incidences]
	into CrimeProp18 
from cleanLACrime 
where [year] = '2018'
group by [crime type] 


select 
	M.[crime type] [Crime Type]
	,isnull(d.[2013 Incidences],0) [2013 Incidences]
	,isnull(e.[2014 Incidences],0) [2014 Incidences]
	,isnull(f.[2015 Incidences],0) [2015 Incidences]
	,isnull(g.[2016 Incidences],0) [2016 Incidences]
	,isnull(h.[2017 Incidences],0) [2017 Incidences]
	,isnull(i.[2018 Incidences],0) [2018 Incidences]
	,M.[total incidences]
into [YearlyCrimeTrends]
from totalcrimeprop m
left join crimeprop13 d on M.[crime type] = d.[crime type]
left join crimeprop14 e on M.[crime type] = e.[crime type]
left join crimeprop15 f on M.[crime type] = f.[crime type]
left join crimeprop16 g on M.[crime type] = g.[crime type]
left join crimeprop17 h on M.[crime type] = h.[crime type]
left join crimeprop18 i on M.[crime type] = i.[crime type]



select
* 
from londoncrimeproportions
order by [percent] desc


with CTE 
as 
(
select 
	   SUBSTRING([names], 0, LEN([names]) + 1 - 4) [Local Authority]
      ,[% of households with no adults in employment: With dependent chi]
      ,[All lone parent housholds with dependent children]
      ,[Lone parent not in employment %]
      ,[Economically active: Total]
      ,[Economically inactive: Total]
      ,[Employment Rate]
      ,[Unemployment Rate]
      ,[% No qualifications]
      ,[% Highest level of qualification: Level 1 qualifications]
      ,[% Highest level of qualification: Level 2 qualifications]
      ,[% Highest level of qualification: Apprenticeship]
      ,[% Highest level of qualification: Level 3 qualifications]
      ,[% Highest level of qualification: Level 4 qualifications and abo]
      ,[% Highest level of qualification: Other qualifications]
      ,[% Schoolchildren and full-time students: Age 18 and over]
      ,[Day-to-day activities limited a lot (%)]
      ,[Day-to-day activities limited a little (%)]
      ,[Day-to-day activities not limited (%)]
      ,[Very good or Good health (%)]
      ,[Fair health (%)]
      ,[Bad or Very Bad health (%)]
from LSOADemo) 

select distinct
	[LocalAuthority]
	,ROUND(AVG([% No qualifications]) OVER (partition by [LocalAuthority]),2) [NoQualifications%]
	into LAEducationProp
from cte 


select
* 
from [dbo].[CleanLACrime]

select * 
from [DIM LA]


--------------------------------------------------------------------------------
select 
	[LocalAuthority] 
	,count(*) [2013 Incidences]
	--into [LACrimeProp13]
from cleanLACrime 
where [year] = '2013'
group by [LocalAuthority]  


select * from CleanLACrime
select 
	[LocalAuthortiy] 
	,count(*) [2014 Incidences]
	into [LACrimeProp14]
from cleanLACrime 
where [year] = '2014'
group by [LA] 

select 
	[LocalAuthortiy] 
	,count(*) [2015 Incidences]
	into [LACrimeProp15]
from cleanLACrime 
where [year] = '2015'
group by [LocalAuthortiy] 

select 
	[LocalAuthortiy] 
	,count(*) [2016 Incidences]
	into[LACrimeProp16]
from cleanLACrime 
where [year] = '2016'
group by [LocalAuthortiy] 

select 
	[LocalAuthortiy] 
	,count(*) [2017 Incidences]
	into [LACrimeProp17]
from cleanLACrime 
where [year] = '2017'
group by [LocalAuthortiy] 

select 
	[LocalAuthortiy] 
	,count(*) [2018 Incidences]
	into [LACrimeProp18]
from cleanLACrime 
where [year] = '2018'
group by [LocalAuthortiy] 

select 
	 m.[LSOA]
	,isnull(d.[2013 Incidences],0) [2013 Incidences]
	,isnull(e.[2014 Incidences],0) [2014 Incidences]
	,isnull(f.[2015 Incidences],0) [2015 Incidences]
	,isnull(g.[2016 Incidences],0) [2016 Incidences]
	,isnull(h.[2017 Incidences],0) [2017 Incidences]
	into YearlyLAIncidences
from [dbo].[LSOACrimeProp13] m
left join LACrimeProp14 d on M.[LocalAuthortiy]  = d.[LocalAuthortiy] 
left join LACrimeProp15 e on M.[LocalAuthortiy]  = e.[LocalAuthortiy] 
left join LACrimeProp16 f on M.[LocalAuthortiy]  = f.[LocalAuthortiy] 
left join LACrimeProp17 g on M.[LocalAuthortiy]  = g.[LocalAuthortiy] 
left join LACrimeProp18 h on M.[LocalAuthortiy]  = h.[LocalAuthortiy] 
													    
-------------------------------------------------------------------
select * from [dbo].[YearlyCrimeTrends]

select 
* 
from [dbo].[YearlyLAIncidences]
order by [LocalAuthortiy] 
select 
	[Area] [LocalAuthortiy] 
	,[2013]
	,[2014]
	,[2015]
	,[2016]
	,[2017] 
	into [CleanUnqualifiedData]
from [dbo].[5YearEduTrend]
order by [LocalAuthortiy] 


---------------------------------- ASBO 

select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [ASBO13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Anti-social behaviour'
group by [LocalAuthortiy] 

select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [VASO13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Violence and sexual offences'
group by [LocalAuthortiy] 


select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [SHLI13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Shoplifting'
group by [LocalAuthortiy] 


select 
	[LA]
	,count(*) [2013 Incidences]
	into [OTHC13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Other crime'
group by [LA] 



select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [CDAA13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Criminal damage and arson'
group by [LocalAuthortiy] 


select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [VECR13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Vehicle crime'
group by [LocalAuthortiy] 

select 
	[LA]
	,count(*) [2013 Incidences]
	into [ROBB13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Robbery'
group by [LocalAuthortiy] 

select 
	[LA]
	,count(*) [2013 Incidences]
	into [POOW13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Possession of weapons'
group by [LocalAuthortiy]  


select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [OTTH13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Other theft'
group by [LocalAuthortiy] 



select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [BURG13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Burglary'
group by [LocalAuthortiy] 

select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [PUBO13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Public Order'
group by [LocalAuthortiy] 

select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [DRUG13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Drugs'
group by [LocalAuthortiy]  

select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [BITH13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Bicycle theft'
group by [LocalAuthortiy] 

select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	--into [THPE13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Theft from the person '
group by [LocalAuthortiy] 



select 
	 m.[LSOA]
	,isnull(m.[2013 Incidences],0) [Anti-Social Behaviour]
	,isnull(d.[2013 Incidences],0) [Violence and Sexual Offences]
	,isnull(e.[2013 Incidences],0) [Shoplifting]
	,isnull(f.[2013 Incidences],0) [Other Crime]
	,isnull(g.[2013 Incidences],0) [Criminal Damage and Arson]
	,isnull(h.[2013 Incidences],0) [Vehicle Crime]
	,isnull(i.[2013 Incidences],0) [Robbery]
	,isnull(j.[2013 Incidences],0) [Possession of Weapons]
	,isnull(k.[2013 Incidences],0) [Other Theft]
	,isnull(l.[2013 Incidences],0) [Burglary]
	,isnull(n.[2013 Incidences],0) [Puglic Order]
	,isnull(o.[2013 Incidences],0) [Drugs]
	,isnull(p.[2013 Incidences],0) [Bicycle Theft]         
	,isnull(q.[2013 Incidences],0) [Theft from the Person]
	into LSOACrimeBreakDown2013
from [dbo].[ASBO13] m
left join [dbo].[VASO13] d on  m.[LocalAuthortiy]  = d.[LocalAuthortiy] 
left join [dbo].[SHLI13] e on  m.[LocalAuthortiy]  = e.[LocalAuthortiy] 
left join [dbo].[OTHC13] f on  m.[LocalAuthortiy]  = f.[LocalAuthortiy] 
left join [dbo].[CDAA13] g on  m.[LocalAuthortiy]  = g.[LocalAuthortiy] 
left join [dbo].[VECR13] h on  m.[LocalAuthortiy]  = h.[LocalAuthortiy] 
left join [dbo].[ROBB13] i on  m.[LocalAuthortiy]  = i.[LocalAuthortiy] 
left join [dbo].[POOW13] j on  m.[LocalAuthortiy]  = j.[LocalAuthortiy] 
left join [dbo].[OTTH13] k on  m.[LocalAuthortiy]  = k.[LocalAuthortiy] 
left join [dbo].[BURG13] l on  m.[LocalAuthortiy]  = l.[LocalAuthortiy] 
left join [dbo].[PUBO13] n on  m.[LocalAuthortiy]  = n.[LocalAuthortiy] 
left join [dbo].[DRUG13] o on  m.[LocalAuthortiy]  = o.[LocalAuthortiy] 
left join [dbo].[BITH13] p on  m.[LocalAuthortiy]  = p.[LocalAuthortiy] 
left join [dbo].[THPE13] q on  m.[LocalAuthortiy]  = q.[LocalAuthortiy] 


select 
	[Area] [LocalAuthortiy] 
	,[2013]
	,[2014]
	,[2015]
	,[2016]
	,[2017]
	into UnqualMale
 from rawunqualmale
 

 select * from unqualall 
 select * from unqualfem
 select * from unqualmale

 ;with CTE
 as (
 select
	 distinct [crime type]   
from CleanLACrime
) 

select
	 --row_number() over ( order by [Crime type]) CrimeID 
	*
	into DIMCrimetype
	from CTE 


ALTER TABLE dbo.[DIMCrimeType] ADD CrimetypeID int identity(1,1) not null
GO

select 
	distinct [LocalAuthortiy] 
	into [DIMLA]
from cleanLAcrime

ALTER TABLE dbo.[DIMLA] ADD [LocalAuthorityID] int identity(1,1) not null
GO


------------------------------ Need the 2 main tables PopulationData, FinalCrimeData and the DIM tables DIM LA, DIM CrimeType, DIMYear 


select 
	[Year]
	,[LocalAuthority]
	,[Crime Type] 
	into FinalCrimeTable
from cleanLACrime

with cte as (
select distinct 
[year]
--into DIMYear
from cleanLAcrime
where year not in (2010,2011,2012,2018)) 

select 
	*
	,ISNULL(ROW_NUMBER() over (ORDER BY [Year]),0)  [YearID]
into DIMYear
from cte 



ALTER TABLE dbo.[DIMYear] ADD [YearID] int identity(1,1) not null
GO

select * from DIMYear
select * from [DIM LA]
select * from DIMCrimetype
select * from LAPopulationData 
select * from Finalcrimetable

select 
*
from finalcrimetable
where LocalAuthority = 'City of London'

ALTER TABLE dbo.[finalcrimetable] ADD [IncidentID] int identity(1,1) not null
GO

select * from [dbo].[DIMYear]

ALTER TABLE [dbo].[DIM LA]
ADD PRIMARY KEY (LocalAuthorityID);


ALTER TABLE [dbo].[DIMPop]
ADD PRIMARY KEY (POPID);


--select
--  ISNULL(CONCAT(b.YearID,c.LocalAuthorityID),'N/A') [PopID]
-- ,b.YearID
-- ,c.LocalAuthorityID
-- ,a.[Total Population] TotalPopulation
-- ,a.[Female Population] FemalePopulation
-- ,a.[Male Population ] MalePopulation
-- ,a.[Unqualified Population] UnqualifiedPopulation
-- ,a.[Unqualified Female] UnqualifiedFemale
-- ,a.[Unqualified Male] UnqualifiedMale
-- into PopID
--from LAPopulationData a
--inner join [dbo].[DIMYear] b on  a.[year] = b.[year]
--inner join [dbo].[DIM LA] c on a.LocalAuthority = c.LocalAuthority



ALTER TABLE [dbo].[FactTable]
ADD PRIMARY KEY (IncidentID);



select distinct [year] from finalcrimetable

select
	 a.IncidentID
	,b.YearID
	,c.LocalAuthorityID
	,d.CrimetypeID
	,concat(b.YearID,c.LocalAuthorityID) [PopID]
	into FactTable
from finalcrimetable a
inner join DIMYear b on a.[year] = b.[year]
left join DIMLA c on a.LocalAuthority = c.Localauthority
left join DIMCrimetype d on a.[CrimeType] = d.[crimetype]

drop table facttable


 need to now create fact table foreign keys . 


ALTER TABLE [dbo].[DimPop]
ADD PRIMARY KEY (PopID);

ALTER TABLE FactTable
ADD FOREIGN KEY (YearID) REFERENCES DimYear(YearID);

ALTER TABLE FactTable
ADD FOREIGN KEY (CrimetypeID) REFERENCES DimCrimeType(CrimeTypeID);

ALTER TABLE FactTable
ADD FOREIGN KEY (LocalAuthorityID) REFERENCES DimLA(LocalAuthorityID);

ALTER TABLE FactTable
ADD FOREIGN KEY (PopID) REFERENCES DIMPop(PopID);


ALTER TABLE DIMPop
ADD FOREIGN KEY (YearID) REFERENCES DimYear(YearID);


ALTER TABLE DIMPop
ADD FOREIGN KEY (LocalAuthorityID) REFERENCES DIMLA(LocalAuthorityID);


select * from dimpop where localauthorityid = 2 order by yearid desc

select * from DIMpop
select * from [dbo].[WorkingAgePop]


select 
     ISNULL(CONCAT(b.YearID,c.LocalAuthorityID),'N/A') [PopID]
    ,b.YearID
	,c.LocalauthorityID
	,a.[16-64 Population]
	,a.[16-64 Unqualified Population]
	into DIMPop
from [dbo].[WorkingAgePop] a
inner join DIMYear b on a.Year = b.Year
inner join DIMLA c on a.Localauthority = c.Localauthority
order by yearid,LocalAuthorityID


select * from dimpop


select * from DIMCrimetype

select * from DIMLA

select * from DIMYear
select * from ethnicdata

select	
    ISNULL(CONCAT(b.YearID,c.LocalAuthorityID),'N/A') [POPid]
	,CASE WHEN a.[Total] = 0 then 0
	ELSE ROUND(cast(a.[White] as float)/a.[Total],2)*100 end [%White]
	,CASE WHEN a.[Total] = 0 then 0
	ELSE ROUND(cast(a.[Asian] as float)/a.[Total],2)*100 end [%Asian]
	,CASE WHEN a.[Total] = 0 then 0
	ELSE ROUND(cast(a.[Black] as float)/a.[Total],2)*100 end [%Black]
	,CASE WHEN a.[Total] = 0 then 0
	ELSE ROUND(cast(a.[Mixed/ Other] as float)/a.[Total],2)*100 end [%Mixed/Other]
	into CleanEthnicData
 from ethnicdata a 
 inner join DIMYear b on a.Year = b.Year 
 inner join DimLA c on a.LocalAuthority = c.LocalAuthority

 select 
	a.PopID
	,LEFT(a.PopID,1) [YearID]
	,substring(a.POPID,2,5) [LocalAuthorityID]
	,a.[16-64 Population]
	,a.[%Unqualified]
	,b.[%White]
	,b.[%Asian]
	,b.[%Black]
	,b.[%Mixed/Other]
	into DIMPop2
from DIMPop a 
inner join Cleanethnicdata b on a.[popid] = b.[popid]


select * from ethnicdata 
select * from [dbo].[WorkingAgePop]

select
	 ISNULL(CONCAT(c.YearID,d.LocalAuthorityID),'N/A') [PopID]
	 ,c.YearID
	,d.LocalAuthorityID
    ,b.[16-64 Population]
	,b.[16-64 Unqualified Population]
	,ROUND(b.[16-64 Unqualified Population]/b.[16-64 Population],2)*100 [%Unqualified]
	,CASE WHEN a.[Total] = 0 then 0
	ELSE ROUND(cast(a.[White] as float)/a.[Total],2)*100 end [%White]
	,CASE WHEN a.[Total] = 0 then 0
	ELSE ROUND(cast(a.[Asian] as float)/a.[Total],2)*100 end [%Asian]
	,CASE WHEN a.[Total] = 0 then 0
	ELSE ROUND(cast(a.[Black] as float)/a.[Total],2)*100 end [%Black]
	,CASE WHEN a.[Total] = 0 then 0
	ELSE ROUND(cast(a.[Mixed/ Other] as float)/a.[Total],2)*100 end [%Mixed/Other]
	into DIMPOP
from ethnicdata a 
inner join workingagepop b on a.year = b.year and a.localauthority = b.localauthority 
inner join dimyear c on c.year = a.year 
inner join dimla d on d.LocalAuthority = a.LocalAuthority



select * from lsoademo


select 
	a.localauthority
	,ROUND(a.LoneParentHouseholds/b.[16-64 Population],2)*100 [%LoneParentHouseholds]
	into LONEPARENT
from LAHealthFam a 
inner join workingagepop b on a.localauthority = b.LocalAuthority
where Year = 2017  




select * from [dbo].[DIMCrimetype]
select * from [dbo].[DIMLA]
select * from [dbo].[DIMPOP]
select * from [dbo].[DIMYear]

ALTER TABLE DIMLA
ADD LoneParentLevel varchar(10);

ALTER TABLE DIMLA 
drop column [%AvgLonePArentHouseholds]

select 
	* 
	, CASE WHEN [%avgloneparenthouseholds] between 1 and 3 THEN 'LOW'
	  WHEN [%avgloneparenthouseholds] between 4 and 6 THEN 'MODERATE' 
	  ELSE 'HIGH' END  [LoneParentLevels]
 from dimla 


 
update DIMLA 
set LoneParentLevel = (CASE WHEN [%avgloneparenthouseholds] between 1 and 3 THEN 'LOW'
	  WHEN [%avgloneparenthouseholds] between 4 and 6 THEN 'MODERATE' 
	  ELSE 'HIGH' END)
from DIMLA 


----------------------------------------------------- Need break down by levels of qualifications. 



ALTER TABLE [QualBreakdown]
ADD TotalPop float;

update QualBreakdown
set TotalPop = b.[16-64 Population]
from QualBreakdown a
inner join dimpop b on a.LocalAuthorityID =b.LocalauthorityID and a.yearid = b.yearid

select 
	 YearID
	,LocalAuthorityID
	,round([NVQ1]/[TotalPop],2)*100 [%NVQ1] 
	,round([NVQ2]/[TotalPop],2)*100 [%NVQ2] 
	,round([NVQ2]/[TotalPop],2)*100 [%NVQ3] 
	,round([OTHER]/[TotalPop],2)*100 [%OTHERQUAL] 
	into qualbreakdownrefined
from qualbreakdown

select * from dimpop
select * from qualbreakdownrefined 

ALTER TABLE [DIMPop]
ADD [%OTHERQUAL]  float;

update DIMPop
set [%NVQ3] = b.[%NVQ3]
from qualbreakdownrefined b
inner join dimpop a on a.LocalAuthorityID =b.LocalauthorityID and a.yearid = b.yearid

------------- Enrich DimCrimeType
select
  CASE
	 WHEN CrimetypeID in (3,6,10) THEN 'Serious' 
	 WHEN CrimetypeID in (1,2,8,9,11,14,12) THEN 'Moderate'
	 WHEN CrimetypeID in (4,5,7) THEN 'Petty'
	  ELSE 'Other' END  [CrimeBreakDown]
from DIMCrimetype

ALTER TABLE [DIMCrimetype]
ADD [CrimeBreakDown]  varchar(15);

update DIMCrimeType
set [CrimeBreakDown] = (
  CASE
	 
	 WHEN CrimetypeID in (3,6,10) THEN 'Serious' 
	 WHEN CrimetypeID in (1,2,8,9,11,14,12) THEN 'Moderate'
	 WHEN CrimetypeID in (4,5,7) THEN 'Petty'
	  ELSE 'Other' END ) 
from DIMCrimetype 

select * from dimcrimetype


------------------------ Local Authority Affluency 



select 
a.LocalAuthority

AVG(a.[£meanincome])  [AVGIncome] 
, CASE WHEN AVG(a.[£meanincome]) > 65001 then 'HIGH'
	WHEN AVG(a.[£meanincome]) between 35000 and 65000 then 'MEDIUM'
	ELSE 'LOW' END [AverageIncome]
,b.LocalauthorityID
into CLEANLAIncome
from LAIncome a 
inner join DIMLA b on a.Localauthority = b.LocalAuthority
group by a.[LocalAuthority], b.LocalAuthorityID
order by AVG(a.[£meanincome]) desc

select
	a.*
	,b.[AverageIncome]
from dimla a
inner join CleanLAIncome b on a.LocalAuthorityID = b.LocalAuthorityID

select * from cleanlaincome 
ALTER TABLE [DIMLA]
ADD [AverageIncome]  varchar(15);


update DimLA
set [AverageIncome] = b.Averageincome
from DIMLA a
inner join cleanLAIncome b on a.LocalAuthorityID=b.LocalAuthorityID

select * from dimLA
---------------------------


--select 
--	b.YearID
--	,c.LocalAuthorityID
--	,a.[NVQ1]
--	,a.NVQ2
--	,a.NVQ3
--	,a.NVQ4 [NVQ4+]
--	,a.[OTHER ]
--	into qualbreakdown
--from qualbreakdown1 a
--inner join DIMYear b on a.Year = b.Year 
--inner join DIMLA c on a.LocalAuthority = c.LocalAuthority

select * from qualbreakdown
select * from DIMPop 


ALTER TABLE [DIMPop] -- Repeat for all qual type breakdown 
ADD [Black]  float; 

ALTER TABLE [DIMPop] -- Repeat for all qual type breakdown 
ADD [TotalEthnicPop]  float; 

alter table dimpop 
drop column [asian]

update DIMPop      
set [mixed/other] = b.[mixed/ other]  -- repeat also. 
from EthnicDataid b
inner join dimpop a on a.LocalAuthorityID =b.LocalauthorityID and a.yearid = b.yearid

select * from DIMPOP 
where LocalAuthorityID = 1 

select * from [dbo].[FinalCrimeTable]

select * from [dbo].[DIMLA]

select * from [dbo].[LASpatialData]

select * from EthnicData


select 
	a.

--ALTER TABLE DIMLA 
--ADD [SpacialLocation] geography; 

--update DIMLA 
--set [SpacialLocation] = b.[SpatialObjCombine_SpatialObj] 
--from [dbo].[LASpatialData] b 
--inner join dimla a on a.LocalAuthority = b.borough 

select * from DIMPOP 

select * from [dbo].[EthnicData]

select * from [dbo].[WorkingAgePop]

select * from [dbo].[Qualbreakdown]

EXEC sp_rename 'DIMPOP.[16-64 unqualified population]', 'Unqualified', 'COLUMN';  




select * from DIMLA


select
	b.yearid 
	,c.localauthorityid 
	, a.white
	, a.asian
	, a. black 
	, a.[mixed/ other]
	, a.totallapop 
into ethnicdataid
 from ethnicdata a 
inner join dimyear b  on a.year = b.year 
inner join dimla c on a.LocalAuthority = c.LocalAuthority


select 
	 *
	 ,[white]+[black]+[asian]+[mixed/other] [EthnicSum]
	,[totallapop]
from dimpop


update DIMPOP 
set [TotalEthnicPop] = [white]+[black]+[asian]+[mixed/other]
from dimpop 

select * from dimpop 

alter table dimpop 
drop column [TotalLAPop]

select * from dimpop 

select * from [dbo].[TablaeuCrimeRatio3]