shinyServer(function(input, output) {
source("global.R")
timelineDatGenerator <- function(x) {
	output = data.frame(
		"Teams" = nrow(x),
		"Maintheme" = sum(x$Maintheme_count),
		"Topic" = sum(x$Topic_count))
	return(output)
}
dat2 <- reactive({bbqSauceFilter(dat, input)})
timelineDat <- reactive({timelineNvd3Gen(dat2())})


  output$myChart <- renderChart({
  	

    timelinePlot <- nPlot(as.formula(paste0(input$x,"~year")),
    	 group =  "Maintheme", data = timelineDat(), type = "stackedAreaChart", id = "chart", dom = "myChart")
    return(timelinePlot)
  })
}
