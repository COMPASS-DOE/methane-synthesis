# Methane synthesis, examining the soil moisture and duration transition point from methane sink to source

Goal: consistent formatting of study site (lat/long), soil moisture as a percentage of potential water holding capacity (or similar),
duration of wet up (or time stamps for both flux and moisture), and methane flux

Bonus for soil temperature, texture, depth of soil in situ for incubations

## Overview

Created February 8th 2022 by Kendalynn A. Morris
Currently in an extremely preliminary and exploratory phase

### Get to know the data

###Currently three data sources

#Literature data
Original data were collected by Emily Kang from primary literature gathered by KAM,
Studies were found using search terms; “methane” and "soil moisture manipulation” OR “soil methane” and “precipitation manipulation” on Google Scholar in September 2021
Current code in EK_methane read in data collected by EK, converts values to uniform units, fills in missing SE values, plots data, and runs a rudimentary meta-analysis on values
More data will come in after literature search and ingestion during the summer 20022
New data should focus on continous datasets with metahena and soil moisture, in addition to more manipulative experiments

#COSORE data
Seven datasets from COSORE (cloned September 7th 2021) contain methane and soil moisture data
Current code in cosore_KM070921 identifies these 7 datasets, but does not combine them into a single dataframe
Next step is to combine the 7 into 1

#Ameriflux
Nine (9) upland sites have methane data. Downloaded using the AmerifluxR package April 19th 2022 (site zipped files),
and April 20th 2022 (metadata .xlsx).

AmerifluxMethSites = code for site selection
AmerifluxMethInitial = code for read-in of relevant data and aggregation
Next step is to aggregate across multiple sensors within sites
Also select variables based on data availabiltiy and QC
