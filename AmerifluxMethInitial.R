
library(dplyr)
library(tidyr)
library(readr)
library(amerifluxr)

#get names of sites to process
sites <- c("BR-Npw", "US-Ho1", "US-Jo1", "US-JRn", "US-NC2", "US-PFa", "US-Sne", "US-Snf", "US-Tur")

#download zip files for 9 sites
# for (x in sites) {
#   KM_flux <- amf_download_base(
#     user_id = "kendalynnm",
#     user_email = "kendalynn.morris@pnnl.gov",
#     site_id = sites,
#     data_product = "BASE-BADM",
#     data_policy = "CCBY4.0",
#     agree_policy = TRUE,
#     intended_use = "synthesis",
#     intended_use_text = "methane fluxes across soil moisture contents",
#     verbose = TRUE,
#     out_dir = getwd()
#   )
# }

#download meta-data
# KM_meta <- amf_download_bif(
#   user_id = "kendalynnm",
#   user_email = "kendalynn.morris@pnnl.gov",
#   data_policy = "CCBY4.0",
#   agree_policy = TRUE,
#   intended_use = "synthesis",
#   intended_use_text = "methane fluxes across soil moisture contents",
#   verbose = TRUE,
#   out_dir = getwd()
# )

#for loop: f in names of files
#TIMESTAMP start and end still coming through
#read in data
results <- list()
tf <- "tempfile.csv"
if(file.exists(tf)) file.remove(tf)
for (site in sites) {
  filename <- list.files(pattern = site)
  message (site," Found ", length(filename), " files")
  dat_raw <- amf_read_base(file = filename,
                       unzip = TRUE,
                       parse_timestamp = TRUE)
  #columns to keep
  ctk <- grep("^(TIMESTAMP$|CO2|CH4|FC|FCH4|PA|^P$|^P_|SWC|^TA$|^TA_|TS|WTD)", colnames(dat_raw))
  message ("Data has ", ncol(dat_raw), " keeping ", length(ctk))
  dat <- dat_raw[ctk]
  
  # reshape data to long form and add site name
  dat <- dat %>% 
    pivot_longer(-TIMESTAMP) %>% 
    separate(name, into = c("variable", "other"),
             sep = "_", extra="merge", fill="right") %>%
    drop_na(value)
  dat$site <- site
  write_csv(dat, file = tf, append = TRUE, col_names = !file.exists(tf))
}

results <- read.csv(tf)

#next step
#reshape data
#filter by quality flags?
#potential issue because not all sites have quality ratings
#which versions to keep?

#BR-Npw columns to keep
# "YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
# "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END","CH4",
# "FCH4","FCH4_PI_F","CO2","FC","FC_PI_F","PA","TA","P",
# "TS_1_1_1","TS_1_2_1","TS_1_3_1","WTD"
SNp <- subset(Npw, select = c("YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
                              "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END","CH4",
                              "FCH4","FCH4_PI_F","CO2","FC","FC_PI_F","PA","TA","P",
                              "TS_1_1_1","TS_1_2_1","TS_1_3_1","WTD"))

#US-Tur columns to keep
# "YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
# "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END","FC",
# "FC_SSITC_TEST","FCH4","FCH4_SSITC_TEST","TA",
# "SWC_1_1_1","SWC_1_2_1","TS_1_1_1","TS_1_2_1"
ST <- subset(Tur, select = c("YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
                             "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END","FC",
                             "FC_SSITC_TEST","FCH4","FCH4_SSITC_TEST","TA",
                             "SWC_1_1_1","SWC_1_2_1","TS_1_1_1","TS_1_2_1"))

#US-Sne columsn to keep
# "YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
# "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END","CH4",
# "FCH4","FCH4_SSITC_TEST","FCH4_PI_F",
# "CO2","FC","FC_SSITC_TEST","FC_PI_F",
# "PA","TA","P",
# "TS_PI_1","TS_PI_2","TS_PI_3","TS_PI_4","WTD"
SE <- subset(Sne, select = c("YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
                             "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END","CH4",
                             "FCH4","FCH4_SSITC_TEST","FCH4_PI_F",
                             "CO2","FC","FC_SSITC_TEST","FC_PI_F",
                             "PA","TA","P",
                             "TS_PI_1","TS_PI_2","TS_PI_3","TS_PI_4","WTD"))

#US-NC2 columns to keep 
# "YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
# "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
# "CO2_1_1_1","FC_1_1_1","PA_1_1_1","TA_1_1_1",
# "SWC_1_1_1","TS_1_1_1","TS_1_2_1","P_1_1_1",
# "FCH4_1_1_1","WTD_1_1_1","CH4_1_1_1"
SNC <- subset(NC2, select = c("YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
                              "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
                              "CO2_1_1_1","FC_1_1_1","PA_1_1_1","TA_1_1_1",
                              "SWC_1_1_1","TS_1_1_1","TS_1_2_1","P_1_1_1",
                              "FCH4_1_1_1","WTD_1_1_1","CH4_1_1_1"))

#US-Snf columns to keep
# "YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
# "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
# "CO2","CH4","FC_1_1_1","FC_1_1_2","FCH4_1_1_1","FCH4_1_1_2"
# "FC_SSITC_TEST","FCH4_SSITC_TEST","PA","TA"
# "TS_PI_1","TS_PI_2"."TS_PI_3","TS_PI_4","TS_PI_5",
# "SWC_PI_1","P","FC_PI_F_1_1_1","FC_PI_F_1_1_2",
# "FCH4_PI_F_1_1_1","FCH4_PI_F_1_1_2"
SF <- subset(Snf, select = c("YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
                             "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
                             "CO2","CH4","FC_1_1_1","FC_1_1_2","FCH4_1_1_1","FCH4_1_1_2",
                             "FC_SSITC_TEST","FCH4_SSITC_TEST","PA","TA",
                             "TS_PI_1","TS_PI_2","TS_PI_3","TS_PI_4","TS_PI_5",
                             "SWC_PI_1","P","FC_PI_F_1_1_1","FC_PI_F_1_1_2",
                             "FCH4_PI_F_1_1_1","FCH4_PI_F_1_1_2"))

#US-PFa columns to keep
# "YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
# "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
# "CO2_1_1_1","CO2_1_2_1","CO2_1_3_1",
# "CH4_1_1_1","CH4_1_2_1","CH4_1_3_1",
# "FC_1_1_1","FC_1_2_1","FC_1_3_1","FCH4_1_1_1",
# ?"SCH4_1_1_1","PA_1_1_1","P","SWC_1_1_1",
# "TA_1_1_1","TA_1_2_1","TA_1_3_1","TA_PI_F_1_3_1"
SP <- subset(PFa, select = c("YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
                             "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
                             "CO2_1_1_1","CO2_1_2_1","CO2_1_3_1",
                             "CH4_1_1_1","CH4_1_2_1","CH4_1_3_1",
                             "FC_1_1_1","FC_1_2_1","FC_1_3_1","FCH4_1_1_1",
                             ?"SCH4_1_1_1","PA_1_1_1","P","SWC_1_1_1",
                             "TA_1_1_1","TA_1_2_1","TA_1_3_1","TA_PI_F_1_3_1"))

# US-Ho1 columns to keep
# "YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
# "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
# "FC_1_1_1","FC_SSITC_TEST_1_1_1",
# "FC_1_1_2","FC_SSITC_TEST_1_1_2",
# "CO2_1_1_1","CO2_1_1_2",
# "FCH4_1_1_1","FCH4_SSITC_TEST_1_1_1",
# "CH4_1_1_1",
# "PA_1_1_1","P_RAIN_1_1_1","P_2_1_1",
# "TS_1_1_1","TS_2_1_1","TS_2_2_1",
# "TS_2_3_1","TS_2_4_1","TS_2_5_1",
# "TS_3_1_1","TS_3_2_1","TS_3_3_1",
# "TS_3_4_1","TS_3_5_1","TA_1_1_1",
# "SWC_2_1_1","SWC_2_2_1","SWC_2_3_1",
# "SWC_2_4_1","SWC_2_5_1","SWC_3_1_1",
# "SWC_3_2_1","SWC_3_3_1","SWC_3_4_1",
# "SWC_3_5_1","WTD_1_1_1","WTD_2_1_1"

SH <- subset(Ho1, select = c("YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
                             +                     "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
                             +                     "FC_1_1_1","FC_SSITC_TEST_1_1_1",
                             +                     "FC_1_1_2","FC_SSITC_TEST_1_1_2",
                             +                     "CO2_1_1_1","CO2_1_1_2",
                             +                     "FCH4_1_1_1","FCH4_SSITC_TEST_1_1_1",
                             +                     "CH4_1_1_1",
                             +                     "PA_1_1_1","P_RAIN_1_1_1","P_2_1_1",
                             +                     "TS_1_1_1","TS_2_1_1","TS_2_2_1",
                             +                     "TS_2_3_1","TS_2_4_1","TS_2_5_1",
                             +                     "TS_3_1_1","TS_3_2_1","TS_3_3_1",
                             +                     "TS_3_4_1","TS_3_5_1","TA_1_1_1",
                             +                     "SWC_2_1_1","SWC_2_2_1","SWC_2_3_1",
                             +                     "SWC_2_4_1","SWC_2_5_1","SWC_3_1_1",
                             +                     "SWC_3_2_1","SWC_3_3_1","SWC_3_4_1",
                             +                     "SWC_3_5_1","WTD_1_1_1","WTD_2_1_1"
                             ))

# US-Jo1 columns to keep
# "YEAR","MONTH","DAY","DOY","HOUR","MINUTE"
# "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
# "FC","FCH4","CO2","CH4"
# "FC_SSITC_TEST","FCH4_SSITC_TEST",
# "PA_1_1_1","PA_2_1_1","P_RAIN_1_1_1",
# "P_RAIN_2_1_1","P_RAIN_3_1_1","SWC_1_1_1",
# "SWC_1_2_1","SWC_1_3_1","SWC_1_4_1","SWC_2_1_1",
# "SWC_2_2_1","SWC_2_3_1","SWC_2_4_1","SWC_3_1_1",
# "SWC_3_2_1","SWC_3_3_1","SWC_3_4_1","SWC_4_1_1",
# "SWC_4_2_1","SWC_4_3_1","SWC_4_4_1","TS_PI_1",
# "TS_1_PI_SD","TS_1_PI_N","TS_PI_2",
# "TS_2_PI_SD","TS_2_PI_N","TA_1_1_1"

SJ<- subset(Jo1, select = c("YEAR","MONTH","DAY","DOY","HOUR","MINUTE",
                            "TIMESTAMP","TIMESTAMP_START","TIMESTAMP_END",
                            "FC","FCH4","CO2","CH4",
                            "FC_SSITC_TEST","FCH4_SSITC_TEST",
                            "PA_1_1_1","PA_2_1_1","P_RAIN_1_1_1",
                            "P_RAIN_2_1_1","P_RAIN_3_1_1","SWC_1_1_1",
                            "SWC_1_2_1","SWC_1_3_1","SWC_1_4_1","SWC_2_1_1",
                            "SWC_2_2_1","SWC_2_3_1","SWC_2_4_1","SWC_3_1_1",
                            "SWC_3_2_1","SWC_3_3_1","SWC_3_4_1","SWC_4_1_1",
                            "SWC_4_2_1","SWC_4_3_1","SWC_4_4_1","TS_PI_1",
                            "TS_1_PI_SD","TS_1_PI_N","TS_PI_2",
                            "TS_2_PI_SD","TS_2_PI_N","TA_1_1_1"
                            ))
Jnames
