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

#### Part for global.R:
# big ass filter
bbqSauceFilter <- function(data, input){
	data <- FilterForRegionalAwards(data, input)
	data <- FilterForChampionshipAwards(data, input)
	data <- FilterForRegion(data, input)
	data <- FilterForTrack(data, input)
	data <- FilterForScore(data, input)
	data <- FilterForBiobrick_count(data, input)
	data <- FilterForStudents_count(data, input)
	data <- FilterForAdvisors_count(data, input)
	data <- FilterForInstructors_count(data, input)
	return(data)
}

## fix region specifications
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

## List of choices for Filtering options:
myChoicesForRegion <- levels(as.factor(dat$region))
myChoicesForTrack <- levels(as.factor(DATParametersFromJSON$track))
myChoicesForScore <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
myChoicesForRegional_awards <- c("", "Grand Prize", "Best Wiki", "Best Poster", "Best Presentation", "Best Human Practice Advance", "Best Experimental Measurement Approach", "Best Foundational Advance", "Best New BioBrick Part, Natural", "Best New BioBrick Device, Synthetic", "Best Model", "Best New Standard", "Safety Commendation")
myChoicesForChampionship_awards <- c("", "Grand Prize", "1st runner up", "2nd runner up", "Advance to Championship", "Finalist", "Best Wiki", "Best Poster", "Best Presentation", "Best Human Practice Advance", "Best Experimental Measurement Approach", "Best Foundational Advance", "Best New BioBrick Part, Natural", "Best New BioBrick Device, Synthetic", "Best Model", "Best New Standard", "Safety Commendation", "Best Food or Energy Project", "Best New Application Project", "Best Environment Project", "Best Health or Medicine Project", "Best Manufacturing Project", "Best Software", "Best Requirements Engineering", "Best Eugene Based Design", "Best SBOL Based Tool", "Best Genome Compiler Based Design", "Best Clotho App", "Best Information Processing Project", "Best Interaction with the Parts Registry")
myChoicesForBB_count <- c(0, 5, 10, 20, 50, 100, 200, ">200")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForAdvisors_count <- c(0, 2, 4, 6, 8, 10, 12, 14, ">14")
myChoicesForInstructors_count <- c(0, 2, 5, 10, 15, ">15")
myChoicesForYear <- c(2007,2008,2009,2010,2011,2012)

## filtering functions:
FilterForYear <- function(data) {
	delete <- which(data$year < input$FILyear_min | data$year > input$FILyear_max)
	if (length(delete) != 0) data <- data[-delete,]
	rm(delete)
	return(data)
}
FilterForRegion <- function(data, input) {
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
FilterForTrack <- function(data, input) {
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
FilterForStudents_count <- function(data, input) {
	if (input$FILstudents_count_min == ">20") data <- data[-which(data$students_count < 20),]
	else if (input$FILstudents_count_max == ">20" & input$FILstudents_count_min != "0") data <- data[-which(data$students_count < as.numeric(input$FILstudents_count_min)),]
	else if (input$FILstudents_count_max == ">20" & input$FILstudents_count_min == "0") return(data)
	else data <- data[-which(data$students_count < as.numeric(input$FILstudents_count_min) | data$students_count > as.numeric(input$FILstudents_count_max)),]
	return(data)
}
FilterForAdvisors_count <- function(data, input) {
	if (input$FILadvisors_count_min == ">14") data <- data[-which(data$advisors_count < 14),]
	else if (input$FILadvisors_count_max == ">14" & input$FILadvisors_count_min != "0") data <- data[-which(data$advisors_count < as.numeric(input$FILadvisors_count_min)),]
	else if (input$FILadvisors_count_max == ">14" & input$FILadvisors_count_min == "0") return(data)
	else data <- data[-which(data$advisors_count < as.numeric(input$FILadvisors_count_min) | data$advisors_count > as.numeric(input$FILadvisors_count_max)),]
	return(data)
}
FilterForInstructors_count <- function(data, input) {
	if (input$FILinstructors_count_min == ">15") data <- data[-which(data$instructors_count < 15),]
	else if (input$FILinstructors_count_max == ">15" & input$FILinstructors_count_min != "0") data <- data[-which(data$instructors_count < as.numeric(input$FILinstructors_count_min)),]
	else if (input$FILinstructors_count_max == ">15" & input$FILinstructors_count_min == "0") return(data)
	else data <- data[-which(data$instructors_count < as.numeric(input$FILinstructors_count_min) | data$instructors_count > as.numeric(input$FILinstructors_count_max)),]
	return(data)
}
FilterForScore <- function(data, input) {
	delete <- which(data$score < as.numeric(input$FILscore_min)/100 | data$score > as.numeric(input$FILscore_max)/100)
	if (length(delete) != 0) data <- data[-delete,]
	rm(delete)
	return(data)
}
FilterForBiobrick_count <- function(data, input) {
	if (input$FILbiobrick_count_min == ">200") data <- data[-which(data$biobrick_count < 200),]
	else if (input$FILbiobrick_count_max == ">200" & input$FILbiobrick_count_min != "0") data <- data[-which(data$biobrick_count < as.numeric(input$FILbiobrick_count_min)),]
	else if (input$FILbiobrick_count_max == ">200" & input$FILbiobrick_count_min == "0") return(data)
	else data <- data[-which(data$biobrick_count < as.numeric(input$FILbiobrick_count_min) | data$biobrick_count > as.numeric(input$FILbiobrick_count_max)),]
	return(data)
}
FilterForRegionalAwards <- function(data, input) {
	keepteams <- c()
	Contents <- DATContentsFromJSON
	for (i in 1:length(input$FILawards_regional)) {
		deleteindex <- c()
		if (input$FILawards_regional[i] == "") {
			for (j in 1:length(names(Contents))) {
				if (Contents[[j]]$awards_regional[1] == "") {
					keepteams <- c(keepteams, names(Contents)[j])
					deleteindex <- c(deleteindex, j)
				}
			}
			if (length(deleteindex) != 0) Contents <- Contents[-deleteindex]
		} else {
			for (j in 1:length(names(Contents))) {
				if (length(grep(input$FILawards_regional[i], Contents[[j]]$awards_regional)) != 0) {
					keepteams <- c(keepteams, names(Contents)[j])
					deleteindex <- c(deleteindex, j)
				}
			}
			if (length(deleteindex) != 0) Contents <- Contents[-deleteindex]
		}
	}
	if (length(keepteams) != 0) data <- data[keepteams,]
	if (length(grep("NA.", row.names(data))) != 0 ) data <- data[-grep("NA.", row.names(data)),]
	if (length(match("NA", row.names(data))) != 0) data <- data[-which(length(match("NA", row.names(data))) != 0),]
	rm(keepteams)
	rm(Contents)
	rm(deleteindex)
	return(data)
}
FilterForChampionshipAwards <- function(data, input) {
	keepteams <- c()
	Contents <- DATContentsFromJSON
	for (i in 1:length(input$FILawards_championship)) {
		deleteindex <- c()
		if (input$FILawards_championship[i] == "") {
			for (j in 1:length(names(Contents))) {
				if (Contents[[j]]$awards_championship[1] == "") {
					keepteams <- c(keepteams, names(Contents)[j])
					deleteindex <- c(deleteindex, j)
				}
			}
			if (length(deleteindex) != 0) Contents <- Contents[-deleteindex]
		} else {
			for (j in 1:length(names(Contents))) {
				if (length(grep(input$FILawards_championship[i], Contents[[j]]$awards_championship)) != 0) {
					keepteams <- c(keepteams, names(Contents)[j])
					deleteindex <- c(deleteindex, j)
				}
			}
			if (length(deleteindex) != 0) Contents <- Contents[-deleteindex]
		}
	}
	if (length(keepteams) != 0) data <- data[keepteams,]
	if (length(grep("NA.", row.names(data))) != 0 ) data <- data[-grep("NA.", row.names(data)),]
	if (row.names(data)[1] == "NA") data <- data[-1,]
	rm(keepteams)
	rm(Contents)
	rm(deleteindex)
	return(data)
}

#### Part for ui.R:
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
				),
				"Only those with abstract"
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
						choices=myChoicesForAdvisors_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILadvisors_count_max",
						label="maximum advisors number",
						choices=myChoicesForAdvisors_count,
						selected=">14" ))
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