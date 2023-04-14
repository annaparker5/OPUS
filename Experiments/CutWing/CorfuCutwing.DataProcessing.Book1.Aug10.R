#Read in libraries
library(tidyverse)
library(htmlwidgets)
library(stringr)

#Read in recapture data (only those recaptured)
recap <- read.csv("~/Desktop/OPUS 2021/Cutwing/Corfu.Cutwings.1993.num1.Recaps&behave.xlsx - Corfu.Cutwings.1993.num1.Recaps.csv")

#Create a "NRECAP" column to track each recapture

recap.unique <- unique(recap$ID)

recap2 <- data.frame(REC_ID = integer(), 
                     ID = integer(), 
                     BEH = character(), 
                     JDATE = character(), 
                     TIME = character(), 
                     SEX = character(), 
                     TREAT = character(), 
                     NRECAP = integer())

for(i in 1:length(recap.unique)){
  IDlist = recap[recap$ID == recap.unique[i], ]
  for(j in 1:length(IDlist$ID)){
    IDlist$NRECAP[j] = j  
  }
  recap2 <- rbind(recap2, IDlist)
}

#Remove unneeded rows
recap2 <- select(recap2,-(REC_ID))

#Load in notebook data
nb <- read.csv("~/Desktop/OPUS 2021/Cutwing/CorfuCutWings1993_book1.cleaned.CHECKED.csv")
#Check for duplicates
nb %>%
  count(ID)%>%
  filter(n>1)
#Remove unneeded rows
nb <- select(nb, -(CASE_NUM), -(NOTEBOOK), -(PG))

#Create NRECAP for nb data
nb$NRECAP <- 0

#Reformat treatment column to be the same as the recapture data
nb <- mutate(nb, TREAT = CUTWING)
nb <- select(nb, -(CUTWING))
nb$TREAT <- gsub("TRT", "T", nb$TREAT)
nb$TREAT <- gsub("CTL", "C", nb$TREAT)
nb$TREAT <- gsub("UNM", "U", nb$TREAT)

#Make JDATE column more informative
recap2 <- mutate(recap2, RECAP_DATE = JDATE)
recap2 <- select(recap2, -(JDATE))
recap2$RECAP_DATE <- gsub("D", "", recap2$RECAP_DATE)

#Add appropriate columns onto nb data
nb$REL_DATE <- gsub("93", "1993", nb$REL_DATE)
nb$REL_DATE <- as.Date(nb$REL_DATE, format = "%m/%d/%Y")
nb2 <- mutate(nb, BEH = NA, TIME = NA, RECAP_DATE = julian(nb$REL_DATE, origin = as.Date("1993-01-01")) + 1)

#Add appropriate columns onto recap data
recap2 <- mutate(recap2, SPECIES = "Pontia_occidentalis", SITE = "Corfu_WA" )
recap_added <- recap2 %>%
  left_join(select(nb, ID, COND_0, FWL, REL_DATE, BUT_WT), by = "ID")

#Order columns correctly
nb_ordered <-select(nb2, SPECIES, SITE, ID, SEX, TREAT, FWL, BUT_WT, REL_DATE, COND_0, RECAP_DATE, NRECAP, BEH, TIME)
recap_ordered <-select(recap_added, SPECIES, SITE, ID, SEX, TREAT, FWL, BUT_WT, REL_DATE, COND_0, RECAP_DATE, NRECAP, BEH, TIME)

#Combine datasets
combined <- rbind(nb_ordered, recap_ordered)
combined$NOTEBOOK <- "Corfu.CutWings.1993_1"
write.csv(combined,file="~/Desktop/OPUS 2021/Cutwing/1993.1.combined10Aug.csv")
