source("global.R")

shinyServer(function(input, output) {

dat2 <- reactive({FilterForMethods(dat, input)})

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

})