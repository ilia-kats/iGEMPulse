require(rCharts)
load("DataFromJSON.RData")
shinyServer(function(input, output) {
		
	output$myChart <- renderPlot({
		p1 <- plot(	DATParametersFromJSON[[input$x]],
				DATParametersFromJSON[[input$y]],
				xlim=c(0,max(DATParametersFromJSON[[input$x]])),
				ylim=c(0,max(DATParametersFromJSON[[input$y]])),
				type = "p",
				pch = 19)
		return(p1)
	})
})