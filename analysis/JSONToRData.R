###########################################################
#### R script to convert json file produced by scrapy to 
#### dtaa sets and list contianing the information.
#### -> One data sets with all single value parameters
#### -> One list contianing all multiple value parameters
#### Requires package RJSONIO + methods
###########################################################

require(RJSONIO)
#### Import from .json file (Change to appropriate filename
JSONList <- fromJSON("../scraper/data/test.json")
#names(JSONList[[2]])

### naive scoring function
scoringFunc <- function(tomatchList, scoresDataFrame) {
	sum(
		apply(scoresDataFrame, MARGIN=1, function(item){
			resVec <- grep(item[1], tomatchList, ignore.case=TRUE, perl=TRUE)
			as.integer(item[2])*length(resVec)
		})
	)
}

### hardcoded Score_List for naive Scoring function
awardScores <- data.frame(
	rbind(
	# FINAL
	c("Grand Prize Winner",324.8),
	c("1st runner up",154.0),
	c("2nd runner up",123.7),
	c("Advance to Championship",33.9),
	c("Finalist",62.1), 
	c("Best Wiki",35.2),
	c("Best Poster",30.1),
	c("Best Presentation",33.4),
	c("Best Human Practice Advance",32.0),
	c("Best Experimental Measurement Approach",35.7),
	c("Best Foundational Advance",40.8),
	c("Best New BioBrick Part, Natural",38.0),
	c("Best New BioBrick Device, Synthetic",38.5),
	c("Best Model",40.8),
	c("Best New Standard",41.7),
	c("Safety Commendation",40.8),
	c("Best Food or Energy Project",56.5),
	c("Best New Application Project",65.7),
	c("Best Environment Project",59.2),
	c("Best Health or Medicine Project",63.9),
	c("Best Foundational Advance Project",65.7),
	c("Best Manufacturing Project",56.8),
	c("Best Software",54.0),
	c("Best Software Tool",54.0),
	c("Best Requirements Engineering",36.7),
	c("Best Eugene Based Design",34.3),
	c("Best SBOL Based Tool",34.7),
	c("Best Genome Compiler Based Design",31.4),
	c("Best Clotho App",32.1),
	c("Best Information Processing Project",42.5),
	c("Best Interaction with the Parts Registry",43.1),
	# REGIONAL
	c("Grand Prize Winner, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",83.5),
	c("Best Wiki, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",14.8),
	c("Best Poster, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",13.0),
	c("Best Presentation, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",15.3),
	c("Best Human Practice Advance, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",15.3),
	c("Best Experimental Measurement Approach, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",16.7),
	c("Best Foundational Advance, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",17.0),
	c("Best New BioBrick Part, Natural, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",17.6),
	c("Best New BioBrick Device, Synthetic, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",17.6),
	c("Best Model, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",17.7),
	c("Best New Standard, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",18.9),
	c("Safety Commendation, (?=Americas|Asia|Europe|Latin America|Americas West|Americas East)",15.7),
	# MEDALS
	c("gold",15.6),
	c("silver",9.3),
	c("bronze",4.4)
	)
)

#### Produce empty Parameters data frame
DATParametersFromJSON <- data.frame()

#### Go through all teams and write parameters to dataframe
#### Add queries for single value parameters here
#### Watch out for empty parameters! (e.g. track)
for (i in 1:length(JSONList)) {
	name <- paste(JSONList[[i]]$name, JSONList[[i]]$year, sep = "")
	DATParametersFromJSON[name, "name"] <- JSONList[[i]]$name
	DATParametersFromJSON[name, "year"] <- as.numeric(JSONList[[i]]$year)
	DATParametersFromJSON[name, "region"] <- JSONList[[i]]$region
	if(length(JSONList[[i]]$track) == 0) DATParametersFromJSON[name, "track"] <- ""
	else DATParametersFromJSON[name, "track"] <- JSONList[[i]]$track
	DATParametersFromJSON[name, "students_count"] <- length(JSONList[[i]]$students)
	DATParametersFromJSON[name, "advisors_count"] <- length(JSONList[[i]]$advisors)
	DATParametersFromJSON[name, "instructors_count"] <- length(JSONList[[i]]$instructors)
	DATParametersFromJSON[name, "wiki"] <- JSONList[[i]]$wiki
	DATParametersFromJSON[name, "url"] <- JSONList[[i]]$url
	DATParametersFromJSON[name, "awards_regional_count"] <- length(JSONList[[i]]$awards_regional)
	DATParametersFromJSON[name, "awards_championship_count"] <- length(JSONList[[i]]$awards_championship)
	DATParametersFromJSON[name, "biobrick_count"] <- length(JSONList[[i]]$parts)
	DATParametersFromJSON[name, "information_content"] <- as.numeric(JSONList[[i]]$information_content)
	## use naive scoring function to calculate certain scores
	DATParametersFromJSON[name, "score"] <- as.numeric(scoringFunc(c(JSONList[[i]][["awards_regional"]],JSONList[[i]][["awards_championship"]],JSONList[[i]][["medal"]]), awardScores))
	#str(c(JSONList[[i]][["awards_regional"]],JSONList[[i]][["awards_championship"]],JSONList[[i]][["medal"]]))
}
### normalize by year
for(y in min(DATParametersFromJSON$year):max(DATParametersFromJSON$year) ) {
	m <- max(DATParametersFromJSON$score[DATParametersFromJSON$year==y])
	DATParametersFromJSON$score[DATParametersFromJSON$year==y] <-DATParametersFromJSON$score[DATParametersFromJSON$year==y]/m
}

#### Produce empty Parameters data frame
DATContentsFromJSON <- list()

#### Go through all teams and write parameters to list
#### Add queries for multiple value parameters here
#### Watch out for empty parameters!
for (i in 1:length(JSONList)) {
	name <- paste(JSONList[[i]]$name, JSONList[[i]]$year, sep = "")
	DATContentsFromJSON[[name]][["year"]] <- JSONList[[i]]$year
	if (length(JSONList[[i]]$awards_regional) == 0) DATContentsFromJSON[[name]][["awards_regional"]] <- ""
	else DATContentsFromJSON[[name]]["awards_regional"] <- JSONList[[i]]["awards_regional"]
	if (length(JSONList[[i]]$awards_championship) == 0) DATContentsFromJSON[[name]][["awards_championship"]] <- ""
	else DATContentsFromJSON[[name]]["awards_championship"] <- JSONList[[i]]["awards_championship"]
	if (length(JSONList[[i]]$parts_range) == 0) DATContentsFromJSON[[name]][["parts_range"]] <- ""
	else DATContentsFromJSON[[name]]["parts_range"] <- JSONList[[i]]["parts_range"]
	if (length(JSONList[[i]]$parts) == 0) DATContentsFromJSON[[name]][["parts"]] <- ""
	else DATContentsFromJSON[[name]][["parts"]] <- JSONList[[i]]$parts
	DATContentsFromJSON[[name]]["advisors"] <- JSONList[[i]]["advisors"]
	DATContentsFromJSON[[name]]["project"] <- JSONList[[i]]["project"]
	DATContentsFromJSON[[name]]["abstract"] <- JSONList[[i]]["abstract"]
	## Meshterms is named numeric vector of term-counts
	if (length(JSONList[[i]]$meshterms) == 0) DATContentsFromJSON[[name]]["meshterms"] <- c()
	else DATContentsFromJSON[[name]]["meshterms"] <- JSONList[[i]]["meshterms"]
}

#### Write dataframe and list to one .RData file
save(DATParametersFromJSON, DATContentsFromJSON, file = "../homepage/data/DataFromJSON.RData")
