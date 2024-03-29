## get all stuff in global up and running
source("global.R")

shinyServer(function(input, output) {

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

timelineNvd3Gen <- function(x) {
	timelineDat <- ddply(x, c("year","region"), timelineDatGenerator)
	#now another hack to make sure even teams/categories not present in all years can be represented by nvd3
	for (year in unique(timelineDat$year)) {
		for (region in unique(timelineDat$region)) {
			if (length(which(timelineDat$year == year & timelineDat$region == region)) == 0) {
				newEntry = data.frame(year = year, region = region, Teams= 0, Students= 0, Advisors = 0, Instructors = 0, ChampionshipAwards=0)
				timelineDat = rbind(timelineDat, newEntry)
			}
		}
	}
	timelineDat = timelineDat[order(timelineDat$year),]
	timelineDat
}
timelineNvd3GenTrack <- function(x) {
	timelineDat <- ddply(x, c("year","track"), timelineDatGenerator)
	#now another hack to make sure even teams/categories not present in all years can be represented by nvd3
	for (year in unique(timelineDat$year)) {
		for (track in unique(timelineDat$track)) {
			if (length(which(timelineDat$year == year & timelineDat$track == track)) == 0) {
				newEntry = data.frame(year = year, track = track, Teams= 0, Students= 0, Advisors = 0, Instructors = 0, ChampionshipAwards=0)
				timelineDat = rbind(timelineDat, newEntry)
			}
		}
	}
	timelineDat = timelineDat[order(timelineDat$year),]
	timelineDat
}

# ok time for some reactive ACTION
dat2 <- reactive({bbqSauceFilter(dat, input)})
timelineDatRegion <- reactive({timelineNvd3Gen(dat2())})
timelineDatTrack <- reactive({timelineNvd3GenTrack(dat2())})
timelineDatMedal <- reactive({timelineNvd3GenMedal(dat2())})

output$myChart <- renderTable({
	if (input$Sort == "Region") return(timelineDatRegion())
	else if (input$Sort == "Track") return(timelineDatTrack())
	else if (inout$Sort == "Medal") return(timelineDatMedal())
})
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

#end shinyServer
})