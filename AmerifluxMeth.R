
rm(list=ls())
#check working directory, set if needed
#setwd("methane/methane-synthesis/")
library(amerifluxr)
library(pander)
library(data.table)

#methane flux
#soil moisture

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
UM <- list("BR-Npw", "US-Ho1", "US-Jo1", "US-JRn", "US-NC2", "US-PFa", "US-Sne", "US-Snf", "US-Tur")

#get data summary for 9 sites with methane fluxes
data_sum <- amf_summarize_data(site_set = data_aval_sub$SITE_ID,
                               var_set = c("FCH4", "SWC"))
pander::pandoc.table(data_sum)

#download zip files for 9 sites
for (x in UM) {
  KM_flux <- amf_download_base(
  user_id = "kendalynnm",
  user_email = "kendalynn.morris@pnnl.gov",
  site_id = UM,
  data_product = "BASE-BADM",
  data_policy = "CCBY4.0",
  agree_policy = TRUE,
  intended_use = "synthesis",
  intended_use_text = "methane fluxes across soil moisture contents",
  verbose = TRUE,
  out_dir = getwd()
)
}

#download meta-data
  KM_meta <- amf_download_bif(
    user_id = "kendalynnm",
    user_email = "kendalynn.morris@pnnl.gov",
    data_policy = "CCBY4.0",
    agree_policy = TRUE,
    intended_use = "synthesis",
    intended_use_text = "methane fluxes across soil moisture contents",
    verbose = TRUE,
    out_dir = getwd()
  )
  
#read in the first site
Ho1 <- amf_read_base(
  file = "AMF_US-Ho1_BASE-BADM_7-5.zip",
  unzip = TRUE,
  parse_timestamp = TRUE)

#read in metadata
MD <- amf_read_bif(file = "AMF_AA-Net_BIF_CCBY4_20220228.xlsx")
#subset by target site
Ho1_MD <- MD[MD$SITE_ID == "US-Ho1",]

unique(Ho1_MD$VARIABLE_GROUP)
paper <- amf_extract_badm(bif_data = Ho1_MD,
                          select_group = "GRP_REFERENCE_PAPER")
#Where is Ho1's SWC data???
