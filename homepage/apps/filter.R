## List of names matching IDs
MatchNamesIDs <- list(	year = "FILyear_min",
						year = "FILyear_max",
						region = "FILregion",
						track = "FILtrack",
						students_count = "FILstudents_count_min",
						students_count = "FILstudents_count_max",
						advisors_count = "FILadvisors_count_min",
						advisors_count = "FILadvisors_count_max",
						instructors_count = "FILinstructors_count_min",
						instructors_count = "FILinstructors_count_max",
						score = "FILscore_min",
						score = "FILscore_max",
						biobrick_count = "FILbiobrick_count_min",
						biobrick_count = "FILbiobrick_count_max",
						awards_regional = "FILawards_regional",
						awards_championship = "FILawards_championship" )

#### Part for server.R:
load("../../data/DataFromJSON.RData")
## enter "datafiltered <- FilterForXY(previousdataset)" for filtering the dataset
## filtering functions:
FilterForYear <- function(data) {
	data <- data[-which(data$year < input$FILyear_min | data$year > input$FILyear_max),]
	return(data)
}
FilterForRegion <- function(data) {
	matchRegion <- rep(0, times=length(data$region))
	for (i in 1:length(input$FILregion)) {
		matchRegion[which(data$region == input$FILregion[i])] <- 1
	}
	data <- data[-which(matchRegion == 0),]
	rm(matchRegion)
	return(data)
}
FilterForTrack <- function(data) {
	matchTrack <- rep(0, times=length(data$track))
	for (i in 1:length(input$FILtrack)) {
		matchTrack[which(data$track == input$FILtrack[i])] <- 1
	}
	data <- data[-which(matchTrack == 0),]
	rm(matchTrack)
	return(data)
}
FilterForStudents_count <- function(data) {
	if (input$FILstudents_count_min == ">20") data <- data[-which(data$students_count < 20),]
	else if (input$FILstudents_count_max == ">20") data <- data[-which(data$students_count < input$FILstudents_count_min),]
	else data <- data[-which(data$students_count < input$FILstudents_count_min | data$students_count > input$FILstudents_count_max),]
	return(data)
}
FilterForAdvisors_count <- function(data) {
	if (input$FILadvisors_count_min == ">15") data <- data[-which(data$advisors_count < 15),]
	else if (input$FILadvisors_count_max == ">15") data <- data[-which(data$advisors_count < input$FILadvisors_count_min),]
	else data <- data[-which(data$advisors_count < input$FILadvisors_count_min | data$advisors_count > input$FILadvisors_count_max),]
	return(data)
}
FilterForInstructors_count <- function(data) {
	if (input$FILinstructors_count_min == ">15") data <- data[-which(data$instructors_count < 15),]
	else if (input$FILinstructors_count_max == ">15") data <- data[-which(data$instructors_count < input$FILinstructors_count_min),]
	else data <- data[-which(data$instructors_count < input$FILinstructors_count_min | data$instructors_count > input$FILinstructors_count_max),]
	return(data)
}
FilterForScore <- function(data) {
	data <- data[-which(data$score < input$FILscore_min | data$score > input$FILscore_max),]
	return(data)
}
FilterForBiobrick_count <- function(data) {
	if (input$FILbiobrick_count_min == ">200") data <- data[-which(data$biobrick_count < 200),]
	else if (input$FILbiobrick_count_max == ">200") data <- data[-which(data$biobrick_count < input$FILbiobrick_count_min),]
	else data <- data[-which(data$biobrick_count < input$FILbiobrick_count_min | data$biobrick_count > input$FILbiobrick_count_max),]
	return(data)
}
FilterForRegionalAwards <- function(data) {
	matchRegionalAw <- rep(0, times=length(data$awards_regional))
	for (i in 1:length(input$FILawards_regional)) {
		matchRegionalAw[which(data$awards_regional == input$FILawards_regional[i])] <- 1
	}
	data <- data[-which(matchRegionalAw == 0),]
	rm(matchRegionalAw)
	return(data)
}
FilterForChampionshipAwards <- function(data) {
	matchChampionshipAw <- rep(0, times=length(data$awards_championship))
	for (i in 1:length(input$FILawards_championship)) {
		matchChampionshipAw[which(data$awards_championship == input$FILawards_championship[i])] <- 1
	}
	data <- data[-which(matchChampionshipAw == 0),]
	rm(matchChampionshipAw)
	return(data)
}

#### Part for ui.R:
## List of choices for Filtering options:
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

## ui html elements:
			div(class="container-fluid",
				"General filter options",
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILyear_min",
						label="minimum year",
						choices=myChoicesForYear,
						selected=min(myChoicesForYear) )),
					div(class="span3", selectInput(
						inputId="FILyear_max",
						label="maximum year",
						choices=myChoicesForYear,
						selected=max(myChoicesForYear) ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILregion",
						label="select regions (hold ctrl for multiple)",
						choices=myChoicesForRegion,
						selected=myChoicesForRegion,
						multiple=TRUE )),
					div(class="span3", selectInput(
						inputId="FILtrack",
						label="select tracks (hold ctrl for multiple)",
						choices=myChoicesForTrack,
						selected=myChoicesForTrack,
						multiple=TRUE ))
				),
				"Autofillable text entry for team names"
			),
			div(class="container-fluid",
				"Filter team success",
				div(class="row-fluid",
					div(class="span4", selectInput(
						inputId="FILawards_regional",
						label="select regional awards (hold ctrl for multiple)",
						choices=myChoicesForRegional_awards,
						selected=myChoicesForRegional_awards,
						multiple=TRUE )),
					div(class="span4", selectInput(
						inputId="FILawards_championship",
						label="select championship awards (hold ctrl for multiple)",
						choices=myChoicesForChampionship_awards,
						selected=myChoicesForChampionship_awards,
						multiple=TRUE ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILscore_min",
						label="minimum score",
						choices=myChoicesForScore,
						selected=min(myChoicesForScore) )),
					div(class="span3", selectInput(
						inputId="FILscore_max",
						label="maximum score",
						choices=myChoicesForScore,
						selected=max(myChoicesForScore) ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILbiobrick_count_min",
						label="minimum biobricks submitted",
						choices=myChoicesForBB_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILbiobrick_count_max",
						label="maximum biobricks submitted",
						choices=myChoicesForBB_count,
						selected=">200" ))
				)
			),
			div(class="container-fluid",
				"Filter team composition",
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILstudents_count_min",
						label="minimum students number",
						choices=myChoicesForStudents_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILstudents_count_max",
						label="maximum students number",
						choices=myChoicesForStudents_count,
						selected=">20" ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILadvisors_count_min",
						label="minimum advisors number",
						choices=myChoicesForStudents_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILadvisors_count_max",
						label="maximum advisors number",
						choices=myChoicesForStudents_count,
						selected=">15" ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILinstructors_count_min",
						label="minimum instructors number",
						choices=myChoicesForInstructors_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILinstructors_count_max",
						label="maximum instructors number",
						choices=myChoicesForInstructors_count,
						selected=">15" ))
				)
			)