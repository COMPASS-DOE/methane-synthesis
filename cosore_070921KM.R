
library(cosore)
library(ggplot2)
library(tibble)

#load database
x <- csr_database()

#check for methane studies
unique(x$CSR_GASES)

#studies with both CO2 and CH4
x_both <- subset(x, CSR_GASES == "CO2, CH4")
unique(x_both$CSR_DATASET)

#[1] "d20190610_SIHI_H2"          "d20190610_SIHI_H2wetland"   "d20200328_UEYAMA_FAIRBANKS" "d20200328_UEYAMA_HOKUROKU"
#[5] "d20200328_UEYAMA_TESHIO"    "d20200328_UEYAMA_YAMASHIRO" "d20200331_PEICHL"

# "d20190610_SIHI_H2" data looks strange, some fluxes at 10^-6, no soil moisture data
# "d20190610_SIHI_H2wetland" same as above
# all these are fantastic (First Author Ueyama)
# "d20200328_UEYAMA_FAIRBANKS" "d20200328_UEYAMA_HOKUROKU"  "d20200328_UEYAMA_TESHIO" "d20200328_UEYAMA_YAMASHIRO"
# "d20200331_PEICHL" doesn't have soil moisture data

#example of data
dat <- csr_dataset("d20190610_SIHI_H2wetland")
raw_dat <- dat$data
unique(raw_dat$CSR_PORT)
ggplot(raw_dat[raw_dat$CSR_PORT == c("4","6"),], aes(CSR_FLUX_CO2, CSR_FLUX_CH4)) +
  geom_point() +
  facet_grid(CSR_PORT~., scales = "free") + ggtitle("Methane Flux vs Soil Moisture")

#studies with only CH4
x_meth <- subset(x, CSR_GASES == "CH4")

#only one study that only has methane data, same plot
dat_ch4 <- csr_dataset("d20200407_WANG")
raw_Mdat <- dat_ch4$data
unique(raw_Mdat$CSR_PORT)
ggplot(raw_Mdat, aes(CSR_SM10, CSR_FLUX_CH4)) +
  geom_point() +
  facet_grid(CSR_PORT~., scales = "free") +
  ggtitle("Methane Flux vs Soil Moisture")

