#Read in libraries
library(tidyverse)
library(htmlwidgets)
library(stringr)

#Read in recapture data (only those recaptured)
recap <- read.csv("~/Desktop/OPUS 2021/Weighted/Corfu.WEIGHTED.1995.Recaps&behave.xlsx - data.csv")

#Create a "NRECAP" column to track each recapture

recap.unique <- unique(recap$ID)

recap2 <- data.frame(REC_NUM = integer(), 
                     ID = integer(), 
                     TREAT = character(), 
                     SEX = character(), 
                     BEH = character(), 
                     WEAR = integer(), 
                     SITE = integer(),
                     TIME = numeric(), 
                     REL = integer(),
                     JDATE = character(), 
                     NRECAP = integer())

for(i in 1:length(recap.unique)){
  IDlist = recap[recap$ID == recap.unique[i], ]
  for(j in 1:length(IDlist$ID)){
    IDlist$NRECAP[j] = j  
  }
  recap2 <- rbind(recap2, IDlist)
}

#Remove unneeded rows
recap2 <- select(recap2,-(REC_NUM))

#Load in notebook data
nb <- read.csv("~/Desktop/OPUS 2021/Weighted/KINGSOLVER.WEIGHTED1995.EXPTS.2020.cleaned.CHECKED.csv")
#Check for duplicates
nb %>%
  count(ID)%>%
  filter(n>1)
#Remove unneeded rows
nb <- select(nb, -(CASE_NUM), -(NOTEBOOK), -(PG), -(wt_bug.env), -(wt_env), -(X_but.env.wt))
#nb$BUT_WT <- nb$BUT_WT/100

#Create NRECAP for nb data
nb$NRECAP <- 0

#Reformat treatment column to be the same as the recapture data
nb <- mutate(nb, TREAT = WEIGHTED_TRT)
nb <- select(nb, -(WEIGHTED_TRT))
nb$TREAT <- gsub("WTD", "W", nb$TREAT)
nb$TREAT <- gsub("CTL", "C", nb$TREAT)
nb$TREAT <- gsub("UNM", "U", nb$TREAT)

recap2$TREAT <- recap2$TRT
recap2 <- select(recap2, -(TRT))

#Make JDATE column more informative
recap2 <- mutate(recap2, RECAP_DATE = JDATE)
recap2 <- select(recap2, -(JDATE))
recap2$RECAP_DATE <- gsub("J", "", recap2$RECAP_DATE)

#Add appropriate columns onto recap data
recap2 <- mutate(recap2, SPECIES = "Pontia_occidentalis", SITE = "Corfu_WA" )

recap_added <- recap2 %>%
  left_join(select(nb, ID, COND_0, FWL, BUT_WT, WTDBUT_WT), by = "ID")

recap_added$REL_DATE <- as.Date(recap_added$REL, origin = "1995-01-01") - 1
recap_added <- select(recap_added, -(REL))

#Add appropriate columns onto nb data
nb$REL_DATE <- as.Date(nb$REL_DATE, format = "%m/%d/%Y")
nb2 <- mutate(nb, BEH = NA, TIME = NA, WEAR = NA, RECAP_DATE = julian(nb$REL_DATE, origin = as.Date("1995-01-01")) + 1)

#Order columns correctly
nb_ordered <-select(nb2, SPECIES, SITE, ID, SEX, TREAT, FWL, BUT_WT, WTDBUT_WT, REL_DATE, COND_0, RECAP_DATE, NRECAP, BEH, TIME, WEAR)
recap_ordered <-select(recap_added, SPECIES, SITE, ID, SEX, TREAT, FWL, BUT_WT, WTDBUT_WT, REL_DATE, COND_0, RECAP_DATE, NRECAP, BEH, TIME, WEAR)

#Combine datasets
combined <- rbind(nb_ordered, recap_ordered)
combined$NOTEBOOK <- "Corfu.Weighted.1995"
write.csv(combined,file="~/Desktop/OPUS 2021/Weighted/1995.combined.10Aug.csv")
