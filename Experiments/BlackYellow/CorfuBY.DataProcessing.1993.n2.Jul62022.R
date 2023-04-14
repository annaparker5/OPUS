#Read in libraries
library(tidyverse)
library(htmlwidgets)
library(stringr)

#Read in recapture data (only those recaptured)
recap <- read.csv("~/Desktop/OPUS 2021/BY/Corfu.BY.1993.n2.Recaps.Dec7.csv")
recap <- recap[ , 1:7]

#Create a "NRECAP" column to track each recapture

recap.unique <- unique(recap$ID)
recap$ID <- as.integer(recap$ID)


recap2 <- data.frame(CASENUM = integer(),
                     ID = integer(),
                     BEH = character(),
                     DATE = character(),
                     TIME = character(),
                     SEX = character(), 
                     TREAT = character())

for(i in 1:length(recap.unique)){
  IDlist = recap[recap$ID == recap.unique[i], ]
  for(j in 1:length(IDlist$ID)){
    IDlist$NRECAP[j] = j  
  }
  recap2 <- rbind(recap2, IDlist)
}


#Remove unneeded rows
recap2 <- select(recap2, -(CASENUM))

#Load in notebook data
nb <- read.csv("~/Desktop/OPUS 2021/BY/Corfu.BY.1993.n2.Dec7.csv")
nb <- nb[complete.cases(nb$ID), ]
#Check for duplicates
nb %>%
  count(ID)%>%
  filter(n>1)

#Remove unneeded rows
nb <- select(nb, -(CASE_NUM), -(NOTEBOOK), -(PG))

#Create NRECAP for nb data
nb$NRECAP <- 0
nb$BEH <- NA
nb$TIME <- NA

nb$REL_DATE <- gsub("/93", "/1993", nb$REL_DATE)
nb$REL_DATE <- as.Date(nb$REL_DATE, "%m/%d/%Y")
nb2 <- mutate(nb, RECAP_DATE = julian(nb$REL_DATE, origin = as.Date("1993-01-01")) + 1)

#Add appropriate columns onto recap data
recap2 <- mutate(recap2, RECAP_DATE = DATE)
recap2 <- select(recap2, -(DATE))

#Modify recap columns to match 1991 dataset
recap2$RECAP_DATE <- gsub("D", "", recap2$RECAP_DATE)
recap2$TREAT <- gsub("T", "Y", recap2$TREAT)
recap2$TREAT <- gsub("C", "B", recap2$TREAT)
recap2$BEH <- gsub("BASK", "B", recap2$BEH)
recap2$BEH <- gsub("REST", "R", recap2$BEH)
recap2$BEH <- gsub("FLIGHT", "F", recap2$BEH)
recap2$BEH <- gsub("SPOOK", "S", recap2$BEH)
recap2$BEH <- gsub("OVI", "O", recap2$BEH)
recap2$BEH <- gsub("NECTAR", "N", recap2$BEH)
recap2$BEH <- gsub("COURT", "C", recap2$BEH)

recap_added <- recap2 %>%
  left_join(select(nb, ID, SPECIES, SITE, COND_0, FWL, REL_DATE), by = "ID")

#Order columns correctly
nb_ordered <-select(nb2, SPECIES, SITE, ID, SEX, TREAT, FWL, REL_DATE, COND_0, RECAP_DATE, NRECAP, BEH, TIME)
recap_ordered <-select(recap_added, SPECIES, SITE, ID, SEX, TREAT, FWL, REL_DATE, COND_0, RECAP_DATE, NRECAP, BEH, TIME)

#Combine datasets
combined <- rbind(nb_ordered, recap_ordered)
combined$NOTEBOOK <- "Corfu.BY.1993_2"




write.csv(combined,file="~/Desktop/OPUS 2021/BY/1993.2.combinedJul62022.csv")

