
library(amerifluxr)
library(pander)
library(data.table)

#methane flux
#soil moisture

sites <- amf_site_info()
sites_dt <- data.table::as.data.table(sites)

pander::pandoc.table(sites_dt[!is.na(DATA_START), .N, by = .(IGBP, DATA_POLICY)][order(IGBP)])

possible_ls <- sites_dt[IGBP %in% c("BSV", "CSH", "CVM",
                                "DBF", "DNF", "EBF",
                                "ENF", "GRA", "MF",
                                "OSH","SAV","WSA") &
                      !is.na(DATA_START) &
                      LOCATION_LAT < 60 &
                      DATA_POLICY == "CCBY4.0",
                    .(SITE_ID, SITE_NAME, DATA_START, DATA_END)]
data_aval <- data.table::as.data.table(amf_list_data(site_set = possible_ls$SITE_ID))
pander::pandoc.table(data_aval[c(1:10), ])

data_aval_sub <- data_aval[data_aval$BASENAME %in% c("FCH4","SWC"),
                           .(SITE_ID, BASENAME, Y2015, Y2016, Y2017, Y2018)]
data_aval_sub <- data_aval_sub[, lapply(.SD, mean), 
                               by = .(SITE_ID),
                               .SDcols = c("Y2015", "Y2016", "Y2017", "Y2018")]
ls2 <- data_aval_sub[(Y2015 + Y2016 + Y2017 + Y2018) / 4 > 0.20]
pander::pandoc.table(ls2)


amf_plot_datayear(
  site_set = ls2$SITE_ID,
  var_set = "FCH4",
  nonfilled_only = TRUE,
  year_set = c(2015:2018)
)

