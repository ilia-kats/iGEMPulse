shinyServer(function(input, output) {
## get all stuff in global up and running
source("global.R")

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
			if (max(timelineDat$year == year & timelineDat$region == region) == 0) {
				newEntry = data.frame(year = year, region = region, Teams= 0, Students= 0, Advisors = 0, Instructors = 0, ChampionshipAwards=0)
				timelineDat = rbind(timelineDat, newEntry)
			}
		}
	}
	timelineDat
}

# ok time for some reactive ACTION
dat2 <- reactive({bbqSauceFilter(dat)})
timelineDat <- reactive({timelineNvd3Gen(dat2())})


  output$myChart <- renderChart({
  	

    timelinePlot <- nPlot(as.formula(paste0(input$x,"~year")),
    	 group =  "region", data = timelineDat(), type = "stackedAreaChart", id = "chart", dom = "myChart")
    return(timelinePlot)
  })
})