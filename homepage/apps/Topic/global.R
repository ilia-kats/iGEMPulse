FilterForTopic <- function(data, input) {
	matchTopic <- rep(0, times=length(data$Topic))
	for (i in 1:length(input$FILTopic)) {
		matchTopic[which(data$Topic == input$FILtopic[i])] <- 1
	}
	data <- data[which(matchTopic == 1),]
	rm(matchTopic)
	return(data)
}
FilterForMaintheme <- function(data, input) {
	matchMaintheme <- rep(0, times=length(data$Maintheme))
	for (i in 1:length(input$FILMaintheme)) {
		matchMaintheme[which(data$tMaintheme == input$FILMaintheme[i])] <- 1
	}
	data <- data[which(matchMaintheme == 1),]
	rm(matchMaintheme)
	return(data)
}