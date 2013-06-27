require(rCharts)
load("DataFromJSON.RData")
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    #names(iris) = gsub("\\.", "", names(iris))
    p1 <- rPlot(input$x, input$y, data = DATParametersFromJSON, color = "year", 
      type = 'point')
    p1$addParams(dom = 'myChart')
    return(p1)
  })
})