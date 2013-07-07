## Packages:
require(rCharts)
require(plyr)

## Load Data:
load("../../data/DataFromJSON.RData")

# fix regional stuff
dat <- DATParametersFromJSON
dat$region <- gsub("Canada", "America", dat$region)
dat$region <- gsub("US", "America", dat$region)
dat$region <- gsub("Americas East", "America", dat$region)
dat$region <- gsub("Americas West", "America", dat$region)
dat$region <- gsub("Latin America", "America", dat$region)
dat$region <- gsub("Americas", "America", dat$region)
# temporary hack, but don't want "specify region" to appear in charts :P
dat = dat[dat$region != "--Specify Region--",]
# temporary hack, but remove the 1 african team
#dat = dat[dat$region != "Africa",]

## Layout choice lists:
myChoicesForX = c("Students", "Teams", "Instructors", "Advisors", "ChampionshipAwards")
#myChoicesForRegion <- levels(as.factor(DATParametersFromJSON$region))
myChoicesForRegion <- c("Europe", "Asia", "America", "Africa")

myChoicesForTrack <- levels(as.factor(DATParametersFromJSON$track))
myChoicesForScore <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
#myChoicesForRegional_awards <- levels(as.factor(DATContentsFromJSON$awards_regional))
#myChoicesForChampionship_awards <- levels(as.factor(DATContentsFromJSON$awards_championship))
myChoicesForBB_count <- c(0, 5, 10, 20, 50, 100, 200, ">200")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForAdvisors_count <- c(0, 2, 5, 10, 15, ">15")
myChoicesForInstructors_count <- c(0, 2, 5, 10, 15, ">15")

# big ass filter
bbqSauceFilter <- function(data, input){
    data <- FilterForRegion(data, input)
    data <- FilterForTrack(data, input)
	#data <- FilterForScore(data, input)
	#data <- FilterForBiobrick_count(data, input)
	#data <- FilterForStudents_count(data, input)
	#data <- FilterForAdvisors_count(data, input)
	#data <- FilterForInstructors_count(data, input)
}
# General filters:
FilterForRegion <- function(data, input) {
	matchRegion <- rep(0, times=length(data$region))
	for (i in 1:length(input$FILregion)) {
		matchRegion[which(data$region == input$FILregion[i])] <- 1
	}
	data <- data[which(matchRegion == 1),]
	rm(matchRegion)
	return(data)
}
FilterForTrack <- function(data, input) {
	matchTrack <- rep(0, times=length(data$track))
	for (i in 1:length(input$FILtrack)) {
		matchTrack[which(data$track == input$FILtrack[i])] <- 1
	}
	data <- data[which(matchTrack == 1),]
	rm(matchTrack)
	return(data)
}

# Success filters:
FilterForScore <- function(data, input) {
	data <- data[-which(data$score < input$FILscore_min | data$score > input$FILscore_max),]
	return(data)
}
FilterForBiobrick_count <- function(data, input) {
	if (input$FILbiobrick_count_min == ">200") data <- data[-which(data$biobrick_count < 200),]
	else if (input$FILbiobrick_count_max == ">200") data <- data[-which(data$biobrick_count < input$FILbiobrick_count_min),]
	else data <- data[-which(data$biobrick_count < input$FILbiobrick_count_min | data$biobrick_count > input$FILbiobrick_count_max),]
	return(data)
}
#FilterForRegionalAwards <- function(data) {
#	matchRegionalAw <- rep(0, times=length(data$awards_regional))
#	for (i in 1:length(input$FILawards_regional)) {
#		matchRegionalAw[which(data$awards_regional == input$FILawards_regional[i])] <- 1
#	}
#	data <- data[-which(matchRegionalAw == 0),]
#	rm(matchRegionalAw)
#	return(data)
#}
#FilterForChampionshipAwards <- function(data) {
#	matchChampionshipAw <- rep(0, times=length(data$awards_championship))
#	for (i in 1:length(input$FILawards_championship)) {
#		matchChampionshipAw[which(data$awards_championship == input$FILawards_championship[i])] <- 1
#	}
#	data <- data[-which(matchChampionshipAw == 0),]
#	rm(matchChampionshipAw)
#	return(data)
#}

# Composition filters:

FilterForStudents_count <- function(data, input) {
	if (input$FILstudents_count_min == ">20") data <- data[-which(data$students_count < 20),]
	else if (input$FILstudents_count_max == ">20") data <- data[-which(data$students_count < input$FILstudents_count_min),]
	else data <- data[-which(data$students_count < input$FILstudents_count_min | data$students_count > input$FILstudents_count_max),]
	return(data)
}
FilterForAdvisors_count <- function(data, input) {
	if (input$FILadvisors_count_min == ">15") data <- data[-which(data$advisors_count < 15),]
	else if (input$FILadvisors_count_max == ">15") data <- data[-which(data$advisors_count < input$FILadvisors_count_min),]
	else data <- data[-which(data$advisors_count < input$FILadvisors_count_min | data$advisors_count > input$FILadvisors_count_max),]
	return(data)
}
FilterForInstructors_count <- function(data, input) {
	if (input$FILinstructors_count_min == ">15") data <- data[-which(data$instructors_count < 15),]
	else if (input$FILinstructors_count_max == ">15") data <- data[-which(data$instructors_count < input$FILinstructors_count_min),]
	else data <- data[-which(data$instructors_count < input$FILinstructors_count_min | data$instructors_count > input$FILinstructors_count_max),]
	return(data)
}
