
library(dplyr)
library(tidyr)
library(ggplot2)
library(metafor)
library(broom)

#methane dataset gathered by Emily Kang
EK_meth <- read.csv("EK_methane.csv")

#need to convert all values to common units of mg CH4 m2 d
unique(EK_meth$Unit)
#"mg CH4 m2 d" "kg CH4 ha"   "ug C m2 h"   "mg CH4 m2 h"

#create conversion factors
con_fac <- c("kg CH4 ha" = 0.2739726,
        "ug C m2 h" = 0.03197342,
        "mg CH4 m2 h" = 24,
        "mg CH4 m2 d" = 1)

#convert all fluxes to mg CH4 m2 d
EK_meth %>%
mutate(cf = con_fac[Unit],
  CH4_control = CH4_control * cf,
       SD_CH4_control =  SD_CH4_control * cf,
       SE_CH4_control = SE_CH4_control * cf,
       CH4_manip = CH4_manip * cf,
       SD_CH4_manip =  SD_CH4_manip * cf,
       SE_CH4_manip = SE_CH4_manip * cf,
       Unit = "mg CH4 m2 d",
  Manipulation = case_when(
    Percent_control < 100 ~ "Drought",
    Percent_control > 100 ~ "Irrigation",
    TRUE ~ NA_character_))-> EK_meth

original <- EK_meth$SD_CH4_control
new <- EK_meth$SD_CH4_control

#Calculate SD from SE
gaps1 <- is.na(EK_meth$SD_CH4_control)
gaps2 <- is.na(EK_meth$SD_CH4_manip)

EK_meth$SD_CH4_control[gaps1] <- EK_meth$SE_CH4_control[gaps1]*sqrt(EK_meth$N_control[gaps1])
EK_meth$SD_CH4_manip[gaps2] <- EK_meth$SE_CH4_manip[gaps2]*sqrt(EK_meth$N_manip[gaps2])


ggplot(EK_meth, 
       aes(Percent_control, CH4_manip - CH4_control)) +
  geom_point() +
  geom_line() +
  facet_grid(. ~ Manipulation, scales = "free")

#Calculate effect sizes
methdat <- escalc(
  measure = "ROM",
  m1i = CH4_manip, m2i = CH4_control,
  sd1i = SD_CH4_manip, sd2i = SD_CH4_control,
  n1i = N_manip, n2i = N_control,
  data = EK_meth
)

#Run meta analysis
meth_model <- rma.mv(yi, vi,
                         random = ~ 1 | X,
                         mods = ~ Manipulation * Ecosystem_type * Percent_control - 1,
                         method = "REML",
                         data = methdat,
                         slab = Ecosystem_type,
)

summary(meth_model)
methMA <- tidy(meth_model)
profile(meth_model)
forest.rma(meth_model)
funnel(meth_model)
plot(cooks.distance(meth_model), type = "o")
