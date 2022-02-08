
#methane dataset gathered by Emily Kang
getwd()
#setwd() is not a coding best practice
#simply save files within the same folder
#use as many instances of R studio as needed to maintain distinct directories

setwd("C:/Users/morr497/OneDrive - PNNL/Documents/methane/")
EK_meth <- read.csv("EK_methane.csv")

#need to convert all values to common units of mg CH4 m2 d
unique(EK_meth$Unit)
#"mg CH4 m2 d" "kg CH4 ha"   "ug C m2 h"   "mg CH4 m2 h"

#create conversion factors
con_fac <- c("kg CH4 ha" = 0.2739726,
        "ug C m2 h" = 0.03197342,
        "mg CH4 m2 h" = 24,
        "mg CH4 m2 d" = 1)

EK_meth %>%
mutate(cf = con_fac[Unit],
  CH4_control = CH4_control * cf,
       SD_CH4_control =  SD_CH4_control * cf,
       SE_CH4_control = SE_CH4_control * cf,
       CH4_manip = CH4_manip * cf,
       SD_CH4_manip =  SD_CH4_manip * cf,
       SE_CH4_manip = SE_CH4_manip * cf,
       Unit = "mg CH4 m2 d") -> EK_meth

