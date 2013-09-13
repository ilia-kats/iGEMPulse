load("../../data/DataFromJSON.RData")
dat <- DATParametersFromJSON

myChoicesForTeamDisplay <- c("0", "5", "10", "20", "50", "100", "all")
myChoicesForTeamSort <- c("Year", "Alphabetic", "Score")
							
FilterForTopics <- function(data, input) {
	keepteams <- c()
	Contents <- DATContentsFromJSON
	for	(i in 1:length(DATContentsFromJSON)) {
		if (length(which(names(Contents[[i]]$meshterms) == input$FILTopic)) != 0) keepteams <- c(keepteams, names(Contents)[i])
	}
	if (length(keepteams) != 0) data <- data[keepteams,]
	else return(data.frame("name" = "No", "year" = "Teams", "wiki" = "with this topic", "score"=c("Teams", "for this method")))
	if (length(grep("NA\\.", row.names(data), perl=TRUE)) != 0 ) data <- data[-grep("NA\\.", row.names(data), perl=TRUE),]
	if (length(which(row.names(data) == "NA")) == 1) data <- data[-which(row.names(data) == "NA"),]
	rm(keepteams)
	rm(Contents)
	return(data)
}