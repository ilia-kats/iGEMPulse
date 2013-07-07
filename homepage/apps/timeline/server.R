shinyServer(function(input, output) {
## Filter data:
dat <- data.frame()
timelineDat <- data.frame()
# General filters:
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
reactive(quote(dat <- FilterForRegion(DATParametersFromJSON)))
reactive(quote(dat <- FilterForTrack(dat)))
# Success filters:
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
reactive(quote(dat <- FilterForScore(dat)))
reactive(quote(dat <- FilterForRegionalAwards(dat)))
#reactive(quote(dar <- FilterForChampionshipAwards(dat)))
#reactive(quote(dat <- FilterForBiobrick_count(dat)))
# Composition filters:
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

filter <- reactive(quote(dat <- FilterForStudents_count(dat)))
reactive(quote(dat <- FilterForAdvisors_count(dat)))
reactive(quote(dat <- FilterForInstructors_count(dat)))

## Put regions together:
#dat$region <- gsub("Canada", "America", dat$region)
#dat$region <- gsub("US", "America", dat$region)
#dat$region <- gsub("Americas East", "America", dat$region)
#dat$region <- gsub("Americas West", "America", dat$region)
#dat$region <- gsub("Latin America", "America", dat$region)
#dat$region <- gsub("Americas", "America", dat$region)
# temporary hack, but don't want "specify region" to appear in charts :P
#dat = dat[dat$region != "--Specify Region--",]
# temporary hack, but remove the 1 african team
#dat = dat[dat$region != "Africa",]

# big function, which takes as input the split data.frames by ddply and returns different summary statistics
timelineDatGenerator <- function(x) {
	output = data.frame(
		"Teams" = nrow(x),
		"Students" = sum(x$students_count),
		"Advisors" = sum(x$advisors_count),
		"Instructors" = sum(x$instructors_count),
		"ChampionshipAwards" = sum(x$awards_championship_count))
	return(output)
}

# ok let's create new data.frame
reactive(quote(timelineDat <- ddply(dat, c("year","region"), timelineDatGenerator)))

  output$myChart <- renderChart({
    timelinePlot <- nPlot(as.formula(paste0(input$x,"~year")),
    	 group =  "region", data = timelineDat, type = "stackedAreaChart", id = "chart", dom = "myChart")
    return(timelinePlot)
  })
})