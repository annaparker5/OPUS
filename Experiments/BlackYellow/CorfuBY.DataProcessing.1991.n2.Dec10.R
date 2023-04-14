#Read in libraries
library(tidyverse)
library(htmlwidgets)
library(stringr)

#Read in recapture data (only those recaptured)
recap <- read.csv("~/Desktop/OPUS 2021/BY/Corfu.BY.1991.n2.Recaps.Dec7.csv")
recap <- select(recap, -(X), -(X.1))

#Create a "NRECAP" column to track each recapture

recap.unique <- unique(recap$ID)
recap$ID <- as.integer(recap$ID)
recap <- recap[complete.cases(recap$ID), ]

recap2 <- data.frame(CASENUM = integer(),
                     NOTEBOOK = character(), 
                     PG = integer(),
                     SPECIES = character(), 
                     SITE = character(),
                     TREAT = character(),
                     ID = integer(),
                     DATE = character(), 
                     TIME = character(), 
                     COND = integer(), 
                     BEH = character(),   
                     NRECAP = integer())

for(i in 1:length(recap.unique)){
  IDlist = recap[recap$ID == recap.unique[i], ]
  for(j in 1:length(IDlist$ID)){
    IDlist$NRECAP[j] = j  
   }
  recap2 <- rbind(recap2, IDlist)
}

recap2 <- recap2[complete.cases(recap2), ]

#Remove unneeded rows
recap2 <- select(recap2, -(CASENUM), -(NOTEBOOK), -(PG))

#Convert time of recapture to AM/PM

for(i in 1:length(recap2$ID)){
  if (recap2[i, 6] <= 1159) {
    recap2[i, 6] <- "AM"
  } else if (recap2[i, 6] >= 1200) {
    recap2[i, 6] <- "PM"
  }
}

# Convert recap_date to Julian day

recap2[11, 5] <- "7/17/1991"
recap2[15, 5] <- "7/17/1991"

recap2$DATE <- as.Date(recap2$DATE, "%m/%d/%Y")
recap2 <- mutate(recap2, RECAP_DATE = julian(recap2$DATE, origin = as.Date("1991-01-01")) + 1)
recap2 <- select(recap2, -(DATE))

#Load in notebook data
nb <- read.csv("~/Desktop/OPUS 2021/BY/Corfu.BY.1991.n2.CHECKED.Dec10.csv")
nb$IDreal <- nb$ID.1
nb <- nb[complete.cases(nb$IDreal), ]
#Check for duplicates
nb %>%
  count(IDreal) %>%
    filter(n > 1)

#Remove unneeded rows
nb <- select(nb, -(REC_NUM), -(ID), -(CASE_NUM), -(NOTEBOOK), -(PG), -(ID.1))

#Create NRECAP for nb data
nb$NRECAP <- 0

#Reformat treatment column to be the same as the recapture data
nb <- mutate(nb, TREAT = BlaYel.Treatment)
nb <- select(nb, -(BlaYel.Treatment))

nb <- mutate(nb, ID = IDreal)
nb <- select(nb, -(IDreal))

#Add RECAP_DATE for nb data 

nb$REL_DATE <- as.Date(nb$REL_DATE, "%m/%d/%Y")
nb2 <- mutate(nb, BEH = NA, TIME = NA, RECAP_DATE = julian(nb$REL_DATE, origin = as.Date("1991-01-01")) + 1)

#Add appropriate columns onto recap data

recap_added <- recap2 %>%
  left_join(select(nb2, ID, SEX, COND_0, FWL, REL_DATE), by = "ID")

#Order columns correctly
nb_ordered <-select(nb2, SPECIES, SITE, ID, SEX, TREAT, FWL, REL_DATE, COND_0, RECAP_DATE, NRECAP, COND, BEH, TIME)
recap_ordered <-select(recap_added, SPECIES, SITE, ID, SEX, TREAT, FWL, REL_DATE, COND_0, RECAP_DATE, NRECAP, COND, BEH, TIME)

#Combine datasets
combined <- rbind(nb_ordered, recap_ordered)
combined$NOTEBOOK <- "Corfu.BY.1991_2"
write.csv(combined,file="~/Desktop/OPUS 2021/BY/1991.2.combinedDec10.csv")

