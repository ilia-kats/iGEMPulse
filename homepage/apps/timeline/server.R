require(rCharts)
require(plyr)
load("../../data/DataFromJSON.RData")

# load data and clean up a bit, to transform into data frame for timeline
# convert gazillion of names for north american teams to one common one
dat <- DATParametersFromJSON
dat$year <- as.numeric(dat$year)
dat$region <- gsub("Canada", "America", dat$region)
dat$region <- gsub("US", "America", dat$region)
dat$region <- gsub("Americas East", "America", dat$region)
dat$region <- gsub("Americas West", "America", dat$region)
dat$region <- gsub("Latin America", "America", dat$region)
dat$region <- gsub("Americas", "America", dat$region)

# temporary hack, but don't want "specify region" to appear in charts :P
dat = dat[dat$region != "--Specify Region--",]
# temporary hack, but remove the 1 african team
dat = dat[dat$region != "Africa",]

# big function, which takes as input the split data.frames by ddply and returns different summary statistics
timelineDatGenerator <- function(x) {
	output = data.frame(
		Teams = nrow(x),
		Students = sum(x$students_count),
		Advisors = sum(x$advisors_count),
		Instructors = sum(x$instructors_count),
		ChampionshipAwards = sum(x$awards_championship_count))
	return(output)
}

# ok let's create new data.frame
timelineDat = ddply(dat, c("year","region"), timelineDatGenerator)


shinyServer(function(input, output) {
  output$myChart <- renderChart({
    timelinePlot <- nPlot(as.formula(paste0(input$x,"~year")),
    	 group =  "region", data = timelineDat, type = "stackedAreaChart", id = "chart", dom = "myChart")
    return(timelinePlot)
  })
})