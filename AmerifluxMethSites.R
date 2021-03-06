
rm(list=ls())
#check working directory, set if needed
#setwd("methane/methane-synthesis/")
library(amerifluxr)
library(pander)
library(data.table)

#looking for upland sites that have methane flux and soil moisture data

sites <- amf_site_info()
sites_dt <- data.table::as.data.table(sites)

pander::pandoc.table(sites_dt[!is.na(DATA_START), .N, by = .(IGBP, DATA_POLICY)][order(IGBP)])

#all sites that are CCBY4.0 and not wetlands or agriculture
possible_ls <- sites_dt[IGBP %in% c("BSV", "CSH", "CVM",
                                "DBF", "DNF", "EBF",
                                "ENF", "GRA", "MF",
                                "OSH","SAV","WSA") &
                      !is.na(DATA_START) &
                      LOCATION_LAT < 60 &
                      DATA_POLICY == "CCBY4.0",
                    .(SITE_ID, SITE_NAME, DATA_START, DATA_END)]
data_aval <- data.table::as.data.table(amf_list_data(site_set = possible_ls$SITE_ID))


#now filter by those upland sites methane flux data
data_aval_sub <- data_aval[data_aval$BASENAME %in% c("FCH4"),
                           .(SITE_ID, BASENAME)]
unique(data_aval_sub$SITE_ID)
sites <- list("BR-Npw", "US-Ho1", "US-Jo1", "US-JRn", "US-NC2", "US-PFa", "US-Sne", "US-Snf", "US-Tur")

#get data summary for 9 sites with methane fluxes
data_sum <- amf_summarize_data(site_set = data_aval_sub$SITE_ID,
                               var_set = c("FCH4", "SWC"))
pander::pandoc.table(data_sum)

