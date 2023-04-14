## Natural Variation for loop code 

## This code is for making the last OPUS file into long format

library(tidyverse)
library(lubridate)

natvar <- read.csv("~/Desktop/OPUS 2021/Natural Variation /Corfu.NatVar.1989.23Jul2022.csv", header = TRUE)

jdaystart <- julian(as.Date("1989-06-21"), origin = as.Date("1989-01-01"))

natvarfinal <- natvar[, c(2:24, 33)] 
natvarfinal$NRECAP <- 0
natvarfinal$RECAP_DATE <- jdaystart

natvarfinal %>%
  count(ID) %>%
  filter(n>1)

## 56, 244, 296 are duplicated 
## Changed in original datafile to add 10000 to ID

for(i in 1:length(natvar$ID)){
  uniqueID <- natvar[i, 4]
  uniquerow <- as.data.frame(natvarfinal[natvarfinal$ID == uniqueID, ])
  numrecap <- 0
  if(is.na(natvar[natvar$ID == uniqueID, 26]) == FALSE){
    if(natvar[natvar$ID == uniqueID, 26] == 1){
      numrecap <- numrecap + 1
      uniquerow$RECAP_DATE <- 172 
      uniquerow$NRECAP <- numrecap
      natvarfinal <- rbind(natvarfinal, uniquerow)
    }else if (natvar[natvar$ID == uniqueID, 26] == 0){
      numrecap <- numrecap + 0
    }
  }
  else if(is.na(natvar[natvar$ID == uniqueID, 26]) == TRUE){
    numrecap <- numrecap + 0
  }
  if(is.na(natvar[natvar$ID == uniqueID, 27]) == FALSE){
    if(natvar[natvar$ID == uniqueID, 27] == 1){
      numrecap <- numrecap + 1
      uniquerow$RECAP_DATE <- 173 
      uniquerow$NRECAP <- numrecap
      natvarfinal <- rbind(natvarfinal, uniquerow)
    }else if (natvar[natvar$ID == uniqueID, 27] == 0){
      numrecap <- numrecap + 0
    }
  }
  else if(is.na(natvar[natvar$ID == uniqueID, 27]) == TRUE){
    numrecap <- numrecap + 0
  }
  if(is.na(natvar[natvar$ID == uniqueID, 28]) == FALSE){
    if(natvar[natvar$ID == uniqueID, 28] == 1){
      numrecap <- numrecap + 1
      uniquerow$RECAP_DATE <- 174 
      uniquerow$NRECAP <- numrecap
      natvarfinal <- rbind(natvarfinal, uniquerow)
    }else if (natvar[natvar$ID == uniqueID, 28] == 0){
      numrecap <- numrecap + 0
    }
  }else if(is.na(natvar[natvar$ID == uniqueID, 28]) == TRUE){
    numrecap <- numrecap + 0
  }
  if(is.na(natvar[natvar$ID == uniqueID, 29]) == FALSE){
    if(natvar[natvar$ID == uniqueID, 29] == 1){
      numrecap <- numrecap + 1
      uniquerow$RECAP_DATE <- 175 
      uniquerow$NRECAP <- numrecap
      natvarfinal <- rbind(natvarfinal, uniquerow)
    }else if (natvar[natvar$ID == uniqueID, 29] == 0){
      numrecap <- numrecap + 0
    }
  }else if(is.na(natvar[natvar$ID == uniqueID, 29]) == TRUE){
    numrecap <- numrecap + 0
  }
  if(is.na(natvar[natvar$ID == uniqueID, 30]) == FALSE){
    if(natvar[natvar$ID == uniqueID, 30] == 1){
      numrecap <- numrecap + 1
      uniquerow$RECAP_DATE <- 176 
      uniquerow$NRECAP <- numrecap
      natvarfinal <- rbind(natvarfinal, uniquerow)
     }else if (natvar[natvar$ID == uniqueID, 30] == 0){
        numrecap <- numrecap + 0
    }
  }else if(is.na(natvar[natvar$ID == uniqueID, 30]) == TRUE){
    numrecap <- numrecap + 0
  }
  if(is.na(natvar[natvar$ID == uniqueID, 31]) == FALSE){
    if(natvar[natvar$ID == uniqueID, 31] == 1){
      numrecap <- numrecap + 1
      uniquerow$RECAP_DATE <- 177 
      uniquerow$NRECAP <- numrecap
      natvarfinal <- rbind(natvarfinal, uniquerow)
    }else if (natvar[natvar$ID == uniqueID, 31] == 0){
    numrecap <- numrecap + 0
    }
  }else if(is.na(natvar[natvar$ID == uniqueID, 31]) == TRUE){
    numrecap <- numrecap + 0
  }
  if(is.na(natvar[natvar$ID == uniqueID, 32]) == FALSE){
    if(natvar[natvar$ID == uniqueID, 32] == 1){
      numrecap <- numrecap + 1
      uniquerow$RECAP_DATE <- 178 
      uniquerow$NRECAP <- numrecap
      natvarfinal <- rbind(natvarfinal, uniquerow)
   }else if (natvar[natvar$ID == uniqueID, 32] == 0){
    numrecap <- numrecap + 0
   }
  }else if(is.na(natvar[natvar$ID == uniqueID, 32]) == TRUE){
    numrecap <- numrecap + 0
  }
}

write.csv(natvarfinal, file = "~/Desktop/OPUS 2021/Natural Variation /Corfu.NatVar.1989.longcleaned.18Aug2022.csv", row.names = FALSE)
