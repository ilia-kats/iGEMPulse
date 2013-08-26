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
dat$region <- gsub("--Specify Region--", "No region specified", dat$region)
# temporary hack, but remove the 1 african team
#dat = dat[dat$region != "Africa",]

## Layout choice lists:
myChoicesForX = c("Students", "Teams", "Instructors", "Advisors", "ChampionshipAwards")
myChoicesForRegion <- levels(as.factor(dat$region))
myChoicesForTrack <- levels(as.factor(DATParametersFromJSON$track))
myChoicesForScore <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
myChoicesForRegional_awards <- levels(as.factor(DATContentsFromJSON$awards_regional))
myChoicesForChampionship_awards <- levels(as.factor(DATContentsFromJSON$awards_championship))
myChoicesForBB_count <- c(0, 5, 10, 20, 50, 100, 200, ">200")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForAdvisors_count <- c(0, 2, 5, 10, 15, ">15")
myChoicesForInstructors_count <- c(0, 2, 5, 10, 15, ">15")

# big ass filter
bbqSauceFilter <- function(data){
    data <- FilterForRegion(data)
    data <- FilterForTrack(data)
	data <- FilterForScore(data)
	data <- FilterForBiobrick_count(data)
	data <- FilterForStudents_count(data)
	data <- FilterForAdvisors_count(data)
	data <- FilterForInstructors_count(data)
	return(data)
}
FilterForRegion <- function(data) {
	matchRegion <- rep(0, times=length(data$region))
	for (i in 1:length(input$FILregion)) {
		matchRegion[which(data$region == input$FILregion[i])] <- 1
	}
	delete <- which(matchRegion == 0)
	if (length(delete) != 0) data <- data[-delete,]
	rm(matchRegion)
	rm(delete)
	return(data)
}
FilterForTrack <- function(data) {
	matchTrack <- rep(0, times=length(data$track))
	for (i in 1:length(input$FILtrack)) {
		matchTrack[which(data$track == input$FILtrack[i])] <- 1
	}
	delete <- which(matchTrack == 0)
	if (length(delete) != 0) data <- data[-delete,]
	rm(matchTrack)
	rm(delete)
	return(data)
}
FilterForStudents_count <- function(data) {
	if (input$FILstudents_count_min == ">20") data <- data[-which(data$students_count < 20),]
	else if (input$FILstudents_count_max == ">20" & input$FILstudents_count_min != "0") data <- data[-which(data$students_count < as.numeric(input$FILstudents_count_min)),]
	else if (input$FILstudents_count_max == ">20" & input$FILstudents_count_min == "0") return(data)
	else data <- data[-which(data$students_count < as.numeric(input$FILstudents_count_min) | data$students_count > as.numeric(input$FILstudents_count_max)),]
	return(data)
}
FilterForAdvisors_count <- function(data) {
	if (input$FILadvisors_count_min == ">15") data <- data[-which(data$advisors_count < 15),]
	else if (input$FILadvisors_count_max == ">15" & input$FILadvisors_count_min != "0") data <- data[-which(data$advisors_count < as.numeric(input$FILadvisors_count_min)),]
	else if (input$FILadvisors_count_max == ">15" & input$FILadvisors_count_min == "0") return(data)
	else data <- data[-which(data$advisors_count < as.numeric(input$FILadvisors_count_min) | data$advisors_count > as.numeric(input$FILadvisors_count_max)),]
	return(data)
}
FilterForInstructors_count <- function(data) {
	if (input$FILinstructors_count_min == ">15") data <- data[-which(data$instructors_count < 15),]
	else if (input$FILinstructors_count_max == ">15" & input$FILinstructors_count_min != "0") data <- data[-which(data$instructors_count < as.numeric(input$FILinstructors_count_min)),]
	else if (input$FILinstructors_count_max == ">15" & input$FILinstructors_count_min == "0") return(data)
	else data <- data[-which(data$instructors_count < as.numeric(input$FILinstructors_count_min) | data$instructors_count > as.numeric(input$FILinstructors_count_max)),]
	return(data)
}
FilterForScore <- function(data) {
	delete <- which(data$score < input$FILscore_min | data$score > input$FILscore_max)
	if (length(delete) != 0) data <- data[-delete,]
	rm(delete)
	return(data)
}
FilterForBiobrick_count <- function(data) {
	if (input$FILbiobrick_count_min == ">200") data <- data[-which(data$biobrick_count < 200),]
	else if (input$FILbiobrick_count_max == ">200" & input$FILbiobrick_count_min != "0") data <- data[-which(data$biobrick_count < as.numeric(input$FILbiobrick_count_min)),]
	else if (input$FILbiobrick_count_max == ">200" & input$FILbiobrick_count_min == "0") return(data)
	else data <- data[-which(data$biobrick_count < as.numeric(input$FILbiobrick_count_min) | data$biobrick_count > as.numeric(input$FILbiobrick_count_max)),]
	return(data)
}
FilterForRegionalAwards <- function(data) {
	keepteams <- c()
	Contents <- DATContentsFromJSON
	for (i in 1:length(input$FILawards_regional)) {
		deleteindex <- c()
		for (j in 1:length(names(Contents))) {
			if (length(grep(input$FILawards_regional[i], Contents[[j]]$awards_regional)) != 0) {
				keepteams <- c(keepteams, names(Contents)[j])
				deleteindex <- c(deleteindex, j)
			}
		}
		Contents <- Contents[-deleteindex]
	}
	if (length(keepteams) != 0) data <- data[keepteams,]
	if (length(grep("NA", row.names(data))) != 0 ) data <- data[-grep("NA", row.names(data)),]
	rm(keepteams)
	rm(Contents)
	rm(deleteindex)
	return(data)
}
FilterForChampionshipAwards <- function(data) {
	keepteams <- c()
	Contents <- DATContentsFromJSON
	for (i in 1:length(input$FILawards_championship)) {
		deleteindex <- c()
		for (j in 1:length(names(Contents))) {
			if (length(grep(input$FILawards_championship[i], Contents[[j]]$awards_championship)) != 0) {
				keepteams <- c(keepteams, names(Contents)[j])
				deleteindex <- c(deleteindex, j)
			}
		}
		Contents <- Contents[-deleteindex]
	}
	if (length(keepteams) != 0) data <- data[keepteams,]
	if (length(grep("NA", row.names(data))) != 0 ) data <- data[-grep("NA", row.names(data)),]
	rm(keepteams)
	rm(Contents)
	rm(deleteindex)
	return(data)
}
