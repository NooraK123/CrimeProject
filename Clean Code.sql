 /* After importing the RAWCrimeData need to filter for only london local authorities,
 then clean data colum for LSOA Name, removing the LSOA Code that comes after, then selecting distinct names which appear
 to ensure the correct 33 LA's in london are being accounted for, this then goes in to a new
 table called LSOA cleaning */
select
 *
,SUBSTRING([LSOA name], 0, LEN([LSOA name]) + 1 - 4) [LocalAuthority]
--into [LSOA Cleaning]
from [dbo].[RawCrimeData]
where [LSOA name] like 'City of London %' or 
	  [LSOA name] like 'Barking and Dagenham %' or	
	  [LSOA name] like 'Barnet %' or 
	  [LSOA name] like 'Bexley %' or 
	  [LSOA name] like 'Brent %' or 
	  [LSOA name] like 'Bromley %' or 
	  [LSOA name] like 'Camden %' or 
	  [LSOA name] like 'Croydon %' or 
	  [LSOA name] like 'Ealing %' or 
	  [LSOA name] like 'Enfield %' or 
	  [LSOA name] like 'Greenwich %' or
	  [LSOA name] like 'Hackney %' or 
	  [LSOA name] like 'Hammersmith and Fulham %' or 
	  [LSOA name] like 'Haringey %' or 
	  [LSOA name] like 'Harrow %' or 
	  [LSOA name] like 'Havering %' or
	  [LSOA name] like 'Hillingdon %' or
	  [LSOA name] like 'Hounslow %' or
	  [LSOA name] like 'Islington %' or
	  [LSOA name] like 'Kensington and Chelsea %' or
	  [LSOA name] like 'Kingston upon Thames %' or
	  [LSOA name] like 'Lambeth %' or
	  [LSOA name] like 'Lewisham %' or
	  [LSOA name] like 'Merton %' or
	  [LSOA name] like 'Newham %' or
	  [LSOA name] like 'Redbridge %' or
	  [LSOA name] like 'Richmond upon Thames %' or
	  [LSOA name] like 'Southwark %' or
	  [LSOA name] like 'Sutton %' or
	  [LSOA name] like 'Tower Hamlets %' or
	  [LSOA name] like 'Waltham Forest %' or
	  [LSOA name] like 'Wandsworth %' or
	  [LSOA name] like 'Westminster %'

select distinct --Ensuring only LONDON LA's have been selected. 
	SUBSTRING([LSOA name], 0, LEN([LSOA name]) + 1 - 4) [LocalAuthority]
from [dbo].[LSOA Cleaning]


/* Then further cleaning, we will only select potentially relevant columns for our search
and place these in to a new table. So, looking at yearly trends, we will select the YEAR,
LocalAuthority, Location, Crime Type,Lat+Long data columns and put these in to CleanLACrime */ 

select
	LEFT([month],4) [Year]
,	SUBSTRING([LSOA name], 0, LEN([LSOA name]) + 1 - 4) [LocalAuthority]
,	[Location]
,	[Crime Type]	
,	[Longitude]
,	[Latitude]
into CleanLACrime
from [dbo].[LSOA Cleaning] 

/* Then to analyse the data, after taking a look at the count of specific crime types 
over the last few years it is clear that 2 categories can just be merged into others. 
Namely Violent Crime --> Violence and Sexual Offences, Public disorder and weapons -->
Public Order. */ 


select 
	[crime type]
	,count([crime type]) [2013 Incidences]
	into CrimeProp13
from cleanLACrime 
where [year] = '2013'
group by [crime type]   /* repeat this for all years being considered */ 


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


/* FIG 1  this is the table that highlights the trends and shows the 0 counts. We fix this
 by recreating the original clean data table and introduce a case statement like so*/ 


drop table cleanlacrime 

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
into CleanLACrime
from [dbo].[LSOA Cleaning]

/* After this using the same joins on the cleaner dataset we produce the better table that does not contain nulls FIG 2  */ 

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


/* Now we have our data set cleaned, we want to take a look at crime trends specific to
Local Authority as opposed to crime type.  */ 


select 
	[LocalAuthority] 
	,count(*) [2013 Incidences]
	into [LACrimeProp13]
from cleanLACrime 
where [year] = '2013'
group by [LocalAuthority]   /* Repeat this for all years being considered */ 


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

/* Now we want to further enrich this and create a table that breaks down instances
of crime types per LA per year.*/  


select 
	[LocalAuthortiy] 
	,count(*) [2013 Incidences]
	into [ASBO13]
from cleanLACrime 
where [year] = '2013' and [crime type] = 'Anti-social behaviour'
group by [LocalAuthortiy]  /* Repeat for combinations of years and crime types */ 



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
	into LACrimeBreakDown2013
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


/* FIG3  Create this table for as many years as you want to see a break down of crimes types 
per LA during a specific year. */ 


/* So now we need to narrow our data source specific to the hypothesis we want to 
test, we will require YEAR,LA,Crime Type from our CleanLACrime table, we do not need 
to narrow down the date by month as qualifications do not differ majorly over months but
rather years due to their nature.  */ 

select 
	 [Year]
	,[LocalAuthority]
	,[Crime Type] 
	into FinalCrimeTable
from cleanLACrime
 

/*  we can now use this to begin making some dimensions and a fact table , we will need
a DIMYear, DIMLocalAuthority and DIMCrimeType, also to avoid duplicate instances in our 
fact table we will create a key for incidents in our FinalCrimeTable. */

ALTER TABLE dbo.[finalcrimetable] ADD [IncidentID] int identity(1,1) not null
GO 


--DIMYear
with cte as (
select distinct 
[year]
into DIMYear
from cleanLAcrime
where year not in (2010,2011,2012,2018)) 

select 
	*
	,ISNULL(ROW_NUMBER() over (ORDER BY [Year]),0)  [YearID]
into DIMYear
from cte 



ALTER TABLE dbo.[DIMYear] ADD [YearID] int identity(1,1) not null
GO


--DIMLA

select 
	distinct [LocalAuthortiy] 
	into [DIMLA]
from cleanLAcrime

ALTER TABLE dbo.[DIMLA] ADD [LocalAuthorityID] int identity(1,1) not null
GO


--DIMCrimeType

 ;with CTE
 as (
 select
	 distinct [crime type]   
from CleanLACrime
) 

select
	 row_number() over ( order by [Crime type]) CrimeID 
	,*
	into DIMCrimetype
	from CTE 


/* Now we want to introduce our data on the population, we want to be able to see given
the year and local authority, what the enviroment at that time looked like, i.e. what % 
of the pop was unqualified? We will call this DIMPop and will have an ID constructed 
with YearID concatenated with the LAID, these will always be unqiue and reflective of
the specific pop at the given year. */ 

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



/* Now we have our 4 DIMtables we want to create our FACT table based on the final crime
table  */ 

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

/* Note PopID does not require any further joins as it is a unique concatenation based on
YearID and LaID. Now we will our PK's and FK's. */ 

--PK 


ALTER TABLE [dbo].[FactTable]
ADD PRIMARY KEY (IncidentID);


ALTER TABLE [dbo].[DIM LA]
ADD PRIMARY KEY (LocalAuthorityID);


ALTER TABLE [dbo].[DIMPop]
ADD PRIMARY KEY (POPID);


ALTER TABLE [dbo].[DIMCrimeType]
ADD PRIMARY KEY (CrimeTypeID);


ALTER TABLE [dbo].[DIMYear]
ADD PRIMARY KEY (YearID);


--FK 


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


/* Now we have completed our main data sets, unqualified data and crime data, we then want
to enrich our data further where applicable. DIMYear needs no further enrichment. DIMLA 
will be enriched with two categories, level of LoneParentHouseholds in the LA, and the
AverageIncome of the LA. */ 


-- LoneParentLevel 


select 
	a.localauthority
	,ROUND(a.LoneParentHouseholds/b.[16-64 Population],2)*100 [%LoneParentHouseholds]
	into LONEPARENT
from LAHealthFam a 
inner join workingagepop b on a.localauthority = b.LocalAuthority


ALTER TABLE DIMLA
ADD LoneParentLevel varchar(10);


update DIMLA 
set LoneParentLevel = (CASE WHEN [%avgloneparenthouseholds] between 1 and 3 THEN 'LOW'
	  WHEN [%avgloneparenthouseholds] between 4 and 6 THEN 'MODERATE' 
	  ELSE 'HIGH' END)
from DIMLA 


-- AverageIncome 

select 
	a.localauthority

	,AVG(a.[£meanincome])  [AVGIncome] 
	, CASE  WHEN AVG(a.[£meanincome]) > 65001 then 'HIGH'
			WHEN AVG(a.[£meanincome]) between 35000 and 65000 then 'MEDIUM'
	 ELSE 'LOW' END  [AverageIncome]
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


/* now we will further enrich DIMPop, we will break this down in to ethnicity breakdowns
and qualification types within an LA. */ 

--- Qualification Breakdowns 

drop table [QualBreakdownrefined]

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
	,round([NVQ3]/[TotalPop],2)*100 [%NVQ3] 
	,round([NVQ4+]/[TotalPop],2)*100 [%NVQ4+] 
	,round([OTHER]/[TotalPop],2)*100 [%OTHERQUAL] 
	into qualbreakdownrefined
from qualbreakdown

select * from dimpop
select * from qualbreakdownrefined 

ALTER TABLE [DIMPop] -- Repeat for all qual type breakdown 
ADD [NVQ1]  float;

update DIMPop      
set [NVQ1] = b.[NVQ1]  -- repeat also. 
from qualbreakdown b
inner join dimpop a on a.LocalAuthorityID =b.LocalauthorityID and a.yearid = b.yearid
 
 ---- Ethnicity Breakdowns. 

 drop table DIMPop 
 
 select
	 ISNULL(CONCAT(c.YearID,d.LocalAuthorityID),'N/A') [PopID]
	 ,c.YearID
	,d.LocalAuthorityID
    ,b.[16-64 Population] [TotalQualPop]
	,b.[16-64 Unqualified Population] [Unqualified]
	,a.white
	,a.asian
	,a.black
	,a.[Mixed/ Other]
	into DIMPOP              /* We can rerun our previous queries above to add new columns for qualification breakdown */ 
from ethnicdata a 
inner join workingagepop b on a.year = b.year and a.localauthority = b.localauthority 
inner join dimyear c on c.year = a.year 
inner join dimla d on d.LocalAuthority = a.LocalAuthority


/* Now we will further enrich DIMCrime to categorise the severity of a crime  */ 
select * from dimcrimetype

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



/* So now we have our final enriched set of kimball model tables:
FIG 4 Facttable, DIMPOP, DIMLA, DIMYear, DIMCrimeType.*/ 
select * from dimpop 

/* to illustrate the analysis table we now need to rejoin all these dimensions. */

select 
	 a.INCIDENTID
	,c.Year
	,d.CrimeType
	,d.CrimeBreakDown
	,b.LocalAuthority
	,e.[TotalQualPop]
	,e.[Unqualified]
	,e.[NVQ1]
	,e.[NVQ2]
	,e.[NVQ3]
	,e.[NVQ4+]
	,e.[OtherQual]
	,b.LoneParentLevel
	,b.AverageIncome
	,e.TotalEthnicPop
	,e.[White]
	,e.[Asian]
	,e.[Black]
	,e.[Mixed/Other]
	into FullFinalDataSet
from facttable a 
inner join DIMLA b on a.LocalauthorityID = b.LocalauthorityID
inner join DIMYear c on a.YearID = c.YearID
inner join DIMCrimetype d on a.CrimetypeID = d.crimetypeid 
inner join DIMPop e on a.PopID = e.PopID 

/* Enrich LA data with spatial locations of boroughs via shp file import from Alterxy ALTFIG */ 

ALTER TABLE DIMLA 
ADD [SpacialLocation] geography; 

update DIMLA 
set [SpacialLocation] = b.[SpatialObjCombine_SpatialObj] 
from [dbo].[LASpatialData] b 
inner join dimla a on a.LocalAuthority = b.borough 

