require(rCharts)
load("../../data/DataFromJSON.RData")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForAdvisors_count <- c(0, 2, 5, 10, 15, ">15")
myChoicesForScore <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
myChoicesForYear <- levels(as.factor(DATParametersFromJSON$year))
myChoicesForRegion <- levels(as.factor(DATParametersFromJSON$region))
myChoicesForInstructors_count <- c(0, 2, 5, 10, 15, ">15")
myChoicesForBB_count <- c(0, 5, 10, 20, 50, 100, 200, ">200")
myChoicesForTrack <- levels(as.factor(DATParametersFromJSON$track))
myChoicesForRegional_awards <- levels(as.factor(DATParametersFromJSON$awards_regional))
myChoicesForChampionship_awards <- levels(as.factor(DATParametersFromJSON$awards_championship))
myChoices = list("Number of Students"='students_count',
      "Number of Advisors"='advisors_count',
      "Number of Instructors"='instructors_count',
      "Number of regional awards" = 'awards_regional_count',
      "Number of championship awards"='awards_championship_count')
