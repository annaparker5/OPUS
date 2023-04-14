# OPUS
Code and datasets for Joel Kingsolver's OPUS grant project, started Fall 2020

In this project, we inputted, cleaned, and analyzed existing datasets from the 1990s. This repo contains the cleaning scripts and final cleaned datafiles for each dataset. NOTE: this repo does not contain any analyses or intermediate versions -- just the final datafiles and completed cleaning scripts. The raw datafiles, as well as some intermediate scripts, can be found on Joel's Google Drive folder entitled "OPUS MRR studies". 

## General process for datasets 
Most datasets consisted of two original files: one that contained initial capture data (treatment group, wing condition, mass, etc.), and one that contained subsequent recapture data (behavior when recaptured, time of day, etc.). For each experiment, we followed the same workflow: 

- We scanned and transcribed the field notebooks as written into the two separate files
- We checked for errors by checking for duplicate IDs, mistyped treatment group labels, etc. 
- We concatenated these two datafiles into one long datafile by marking the initial capture as recapture # 0. By doing so, we could keep all of the affiliated data unique to each sample and be able to analyze the recaptures alongside these data. 

Due to the shared workflow, all of the final datafiles have the same structure: a set of initial captures as the beginning rows of the datafile (marked as recapture #0), and then subsequent recaptures (with duplicated identifying data) following in later rows. Many of the column names are also the same across datafiles, while a few are unique to each. Below, we describe these fields and how they differ across datafiles. 

### Common fields and contents

- SPECIES: Species worked with during that study 
- SITE: Site where the individuals were collected
- ID: Unique numeric identifier of that individual 
- SEX: Sex of the individual
- TREAT: Treatment group of the individual (differs by study)
- FWL: Front wing length of the individual at initial capture
- REL_DATE: Date of initial release, in YYYY-MM-DD format
- COND_0: Condition at time of initial release
- RECAP_DATE: Date of (re)capture, in Julian date format
- NRECAP: Number of recapture for that individual and instance 
- NOTEBOOK: Original notebook identifier from which the data came 


### Unique fields per study

Black/Yellow studies 

- BEH: Behavior at time of recapture
- TIME: Time of recapture

CutWing studies 

- BUT_WT: Weight of individual at initial capture 
- BEH: Behavior at time of recapture
- TIME: Time of recapture

Photoperiod (Long day / short day) studies 

- FAM: Numeric identifier for mother/family of that individual 
- AGE: Age at release (numeric from 0-2)
- WEAR: Condition of individual at each recapture event

Weighted studies 

- BUT_WT: Weight of individual at initial capture 
- WTDBUT_WT: Weight of individual with weight attached before release
- BEH: Behavior at time of recapture
- TIME: Time of recapture
- WEAR: Condition of individual at each recapture event



