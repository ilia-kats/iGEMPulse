## Packages:
require(rCharts)
require(plyr)

## Load Data:
load("../../data/DataFromJSON.RData")

## Layout choice lists:
myChoicesForX = c("Students", "Teams", "Instructors", "Advisors", "ChampionshipAwards")
myChoicesForRegion <- levels(as.factor(DATParametersFromJSON$region))
myChoicesForTrack <- levels(as.factor(DATParametersFromJSON$track))
myChoicesForScore <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
#myChoicesForRegional_awards <- levels(as.factor(DATContentsFromJSON$awards_regional))
#myChoicesForChampionship_awards <- levels(as.factor(DATContentsFromJSON$awards_championship))
myChoicesForBB_count <- c(0, 5, 10, 20, 50, 100, 200, ">200")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForAdvisors_count <- c(0, 2, 5, 10, 15, ">15")
myChoicesForInstructors_count <- c(0, 2, 5, 10, 15, ">15")