#### Filter Elements ####
#########################

#### global.R ####
load("../../data/DataFromJSON.RData")
dat <- DATParametersFromJSON

## big ass filter
bbqSauceFilter <- function(data, input){
	data <- FilterForYear(data, input)
	data <- FilterForTeamName(data, input)
	data <- FilterForAbstract(data, input)
	data <- FilterForMedal(data, input)
	data <- FilterForRegion(data, input)
	data <- FilterForTrack(data, input)
	data <- FilterForScore(data, input)
	data <- FilterForInformation_content(data, input)
	data <- FilterForBiobrick_count(data, input)
	data <- FilterForStudents_count(data, input)
	data <- FilterForAdvisors_count(data, input)
	data <- FilterForInstructors_count(data, input)
	data <- FilterForRegionalAwards(data, input)
	data <- FilterForChampionshipAwards(data, input)
	return(data)
}

## List of choices for Filtering options:
myChoicesForRegion <- levels(as.factor(dat$region))
myChoicesForTrack <- levels(as.factor(DATParametersFromJSON$track))
myChoicesForScore <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
myChoicesForMedal <- c("", "Bronze", "Silver", "Gold")
myChoicesForRegional_awards <- c("", "Grand Prize", "Regional Finalist", "Best Wiki", "Best Poster", "Best Presentation", "Best Human Practices Advance", "Best Experimental Measurement Approach", "Best Foundational Advance", "Best New BioBrick Part, Natural", "Best New BioBrick Device, Engineered", "Best Model", "Best New Standard", "Safety Commendation")
myChoicesForChampionship_awards <- c("", "Grand Prize", "1st Runner Up", "2nd Runner Up", "Best Rookie Team", "Advance to Software Jamboree", "Advance to Championship", "Finalist", "Best Wiki", "Best Poster", "Best Presentation", "Best Human Practices Advance", "Best Experimental Measurement", "Best Foundational Advance", "Best New BioBrick Part, Natural", "Best New BioBrick Part or Device, Engineered", "Best Model", "Best New Standard", "Safety Commendation", "Best Food & Energy Project", "Best New Application Project", "Best Environment Project", "Best Health & Medicine Project", "Best Manufacturing Project", "Best Software", "Best Requirements Engineering", "Best Eugene Based Design", "Best SBOL Based Tool", "Best Genome Compiler Based Design", "Best Clotho App", "Best Information Processing Project", "Best Interaction with the Parts Registry", "iGEMers Prize")
myChoicesForBB_count <- c(0, 5, 10, 20, 50, 100, 200, ">200")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForStudents_count <- c(0, 5, 10, 15, 20, ">20")
myChoicesForAdvisors_count <- c(0, 2, 4, 6, 8, 10, 12, 14, ">14")
myChoicesForInstructors_count <- c(0, 2, 5, 10, 15, ">15")
myChoicesForInformation_content <- c("0", "0.4", "0.45", "0.5", "0.55", "0.6")
myChoicesForYear <- c(2007,2008,2009,2010,2011,2012)

## filtering functions:
FilterForYear <- function(data, input) {
	delete <- which(data$year < input$FILyear_min | data$year > input$FILyear_max)
	if (length(delete) != 0) data <- data[-delete,]
	rm(delete)
	return(data)
}
FilterForTeamName <- function(data, input) {
	keepteams <- c()
	Names <- unlist(strsplit(input$FILname, ", "))
	Names <- unlist(strsplit(Names, ","))
	for (i in 1:length(Names)) {
		keepteams <- c(keepteams, grep(Names[i], data$name))
	}
	if (length(keepteams) != 0) data <- data[keepteams,]
	rm(keepteams)
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
FilterForAbstract <- function(data, input) {
	if (input$FILabstract == FALSE) return(data)
	delete <- c()
	for (i in 1:length(row.names(data))) {
		if (DATContentsFromJSON[[row.names(data)[i]]]$abstract == "-- No abstract provided yet --") delete <- c(delete, i)
	}
	if(length(delete) != 0) data <- data[-delete,]
	rm(delete)
	return(data)
}
FilterForInformation_content <- function(data, input) {
	if (length(which(data$information_content < as.numeric(input$FILinformation_content))) != 0)	data <- data[-which(data$information_content < as.numeric(input$FILinformation_content)),]
	return(data)
}
FilterForMedal <- function(data, input) {
	matchMedal <- rep(0, times=length(data$medal))
	for (i in 1:length(input$FILmedal)) {
		matchMedal[which(data$medal == input$FILmedal[i])] <- 1
	}
	delete <- which(matchMedal == 0)
	if (length(delete) != 0) data <- data[-delete,]
	rm(matchMedal)
	rm(delete)
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
	if (length(grep("NA\\.", row.names(data), perl=TRUE)) != 0 ) data <- data[-grep("NA\\.", row.names(data), perl=TRUE),]
	if (length(which(row.names(data) == "NA")) == 1) data <- data[-which(row.names(data) == "NA"),]
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
	if (length(grep("NA\\.", row.names(data), perl=TRUE)) != 0 ) data <- data[-grep("NA\\.", row.names(data), perl=TRUE),]
	if (length(which(row.names(data) == "NA")) == 1) data <- data[-which(row.names(data) == "NA"),]
	rm(keepteams)
	rm(Contents)
	rm(deleteindex)
	return(data)
}

#### ui.R ####
			div(class="container-fluid", id="Filters",
				div(class="row-fluid",
					p("Filtering options", id="FilterLabel"),
					tags$ul(id="FilterUl",
						tags$li(a(id="ShowYear", href="#", onclick="Filter.Show('FilterYear', 'ShowYear');return(false);", "Year")),
						tags$li(a(id="ShowRegion", href="#", onclick="Filter.Show('FilterRegion', 'ShowRegion');return(false);", "Region")),
						tags$li(a(id="ShowTrack", href="#", onclick="Filter.Show('FilterTrack', 'ShowTrack');return(false);", "Track")),
						tags$li(a(id="ShowName", href="#", onclick="Filter.Show('FilterName', 'ShowName');return(false);", "Name")),
						tags$li(a(id="ShowAwards", href="#", onclick="Filter.Show('FilterAwards', 'ShowAwards');return(false);", "Awards")),
						tags$li(a(id="ShowScore", href="#", onclick="Filter.Show('FilterScore', 'ShowScore');return(false);", "Score")),
						tags$li(a(id="ShowBiobricks", href="#", onclick="Filter.Show('FilterBiobricks', 'ShowBiobricks');return(false);", "Biobricks")),
						tags$li(a(id="ShowAbstract", href="#", onclick="Filter.Show('FilterAbstract', 'ShowAbstract');return(false);", "Abstract")),
						tags$li(a(id="ShowStudents", href="#", onclick="Filter.Show('FilterStudents', 'ShowStudents');return(false);", "Students")),
						tags$li(a(id="ShowAdvisors", href="#", onclick="Filter.Show('FilterAdvisors', 'ShowAdvisors');return(false);", "Advisors")),
						tags$li(a(id="ShowInstructors", href="#", onclick="Filter.Show('FilterInstructors', 'ShowInstructors');return(false);", "Instructors")),
						div(style="clear:both;")
					)
				),
				div(class="container-fluid", id="AllFilters",
					div(class="row-fluid", id="FilterYear",
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
					div(class="row-fluid", id="FilterRegion",
						selectInput(
							inputId="FILregion",
							label="select regions (hold ctrl for multiple)",
							choices=myChoicesForRegion,
							selected=myChoicesForRegion,
							multiple=TRUE )),
					div(class="row-fluid", id="FilterTrack",
						selectInput(
							inputId="FILtrack",
							label="select tracks (hold ctrl for multiple)",
							choices=myChoicesForTrack,
							selected=myChoicesForTrack,
							multiple=TRUE )),
					div(class="row-fluid", id="FilterName",
						textInput(
							inputId="FILname",
							label="enter team names (, -separated)",
							value="Name1, Name2")
					),
					div(class="row-fluid", id="FilterAwards",
						div(class="span4", selectInput(
							inputId="FILawards_championship",
							label="select championship awards (hold ctrl for multiple)",
							choices=myChoicesForChampionship_awards,
							selected=myChoicesForChampionship_awards,
							multiple=TRUE )),
						div(class="span4", selectInput(
							inputId="FILawards_regional",
							label="select regional awards (hold ctrl for multiple)",
							choices=myChoicesForRegional_awards,
							selected=myChoicesForRegional_awards,
							multiple=TRUE )),
						div(class="span4", selectInput(
							inputId="FILmedal",
							label="select medals (hold ctrl for multiple)",
							choices=myChoicesForMedal,
							selected=myChoicesForMedal,
							multiple=TRUE ))
					),
					div(class="row-fluid", id="FilterScore",
						div(class="span4", selectInput(
							inputId="FILscore_min",
							label="minimum score",
							choices=myChoicesForScore,
							selected=min(myChoicesForScore) )),
						div(class="span4", selectInput(
							inputId="FILscore_max",
							label="maximum score",
							choices=myChoicesForScore,
							selected=max(myChoicesForScore) ))
					),
					div(class="row-fluid", id="FilterBiobricks",
						div(class="span4", selectInput(
							inputId="FILbiobrick_count_min",
							label="minimum biobricks submitted",
							choices=myChoicesForBB_count,
							selected="0" )),
						div(class="span4", selectInput(
							inputId="FILbiobrick_count_max",
							label="maximum biobricks submitted",
							choices=myChoicesForBB_count,
							selected=">200" ))
					),
					div(class="row-fluid", id="FilterAbstract",
						div(class="span4", checkboxInput(
							inputId="FILabstract",
							label="Only display teams who submitted an abstract",
							value=FALSE)),
						div(class="span4", selectInput(
							inputId="FILinformation_content",
							label="Minimum information content of abstract",
							choices=myChoicesForInformation_content,
							selected="0"))
					),
					div(class="row-fluid", id="FilterStudents",
						div(class="span4", selectInput(
							inputId="FILstudents_count_min",
							label="minimum students number",
							choices=myChoicesForStudents_count,
							selected="0" )),
						div(class="span4", selectInput(
							inputId="FILstudents_count_max",
							label="maximum students number",
							choices=myChoicesForStudents_count,
							selected=">20" ))
					),
					div(class="row-fluid", id="FilterAdvisors",
						div(class="span4", selectInput(
							inputId="FILadvisors_count_min",
							label="minimum advisors number",
							choices=myChoicesForAdvisors_count,
							selected="0" )),
						div(class="span4", selectInput(
							inputId="FILadvisors_count_max",
							label="maximum advisors number",
							choices=myChoicesForAdvisors_count,
							selected=">14" ))
					),
					div(class="row-fluid", id="FilterInstructors",
						div(class="span4", selectInput(
							inputId="FILinstructors_count_min",
							label="minimum instructors number",
							choices=myChoicesForInstructors_count,
							selected="0" )),
						div(class="span4", selectInput(
							inputId="FILinstructors_count_max",
							label="maximum instructors number",
							choices=myChoicesForInstructors_count,
							selected=">15" ))
					)
				)
			)


#### Elements for Team Table display ####
#########################################

#### global.R ####
myChoicesForTeamDisplay <- c("0", "5", "10", "20", "50", "100", "all")
myChoicesForTeamSort <- c("Year", "Alphabetic", "Score")

#### ui.R ####
			div(class="container-fluid",
				div(class="row-fluid",
					div(class="span4",
						selectInput(
							inputId="TeamDisplay",
							label="Display table of teams",
							choices=myChoicesForTeamDisplay,
							selected="all" )),
					div(class="span4",
						selectInput(
							inputId="TeamSort",
							label="Sorted by",
							choices=myChoicesForTeamSort,
							selected="Score" ))
				),
				tableOutput(outputId="TeamList")
			)

#### server.R ####
dat2 <- reactive({bbqSauceFilter(dat, input)})
output$TeamList <- renderTable({
	if (input$TeamDisplay == "0") return()
	else {
		outputData <- dat2()
		if (input$TeamSort == "Year") outputData <- outputData[order(outputData$year, decreasing = TRUE),]
		else if (input$TeamSort == "Score") outputData <- outputData[order(outputData$score, decreasing = TRUE),]
		else outputData <- outputData[order(outputData$name),]
		outputData <- data.frame(Name=outputData$name, Year=outputData$year, Wiki=outputData$wiki)
		if (input$TeamDisplay == "all") return(outputData)
		else {
			outputData <- head(outputData, n=as.numeric(input$TeamDisplay))
			return(outputData)
		}
	}
})