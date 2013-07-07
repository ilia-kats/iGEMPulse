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

#### Produce empty Parameters data frame
DATParametersFromJSON <- data.frame()

#### Go through all teams and write parameters to dataframe
#### Add queries for single value parameters here
for (i in 1:length(JSONList)) {
	name <- paste(JSONList[[i]]$name, JSONList[[i]]$year, sep = "")
	DATParametersFromJSON[name, "name"] <- JSONList[[i]]$name
	DATParametersFromJSON[name, "year"] <- as.numeric(JSONList[[i]]$year)
	DATParametersFromJSON[name, "region"] <- JSONList[[i]]$region
	DATParametersFromJSON[name, "students_count"] <- length(JSONList[[i]]$students)
	DATParametersFromJSON[name, "advisors_count"] <- length(JSONList[[i]]$advisors)
	DATParametersFromJSON[name, "instructors_count"] <- length(JSONList[[i]]$instructors)
	DATParametersFromJSON[name, "wiki"] <- JSONList[[i]]$wiki
	DATParametersFromJSON[name, "url"] <- JSONList[[i]]$url
	DATParametersFromJSON[name, "awards_regional_count"] <- length(JSONList[[i]]$awards_regional)
	DATParametersFromJSON[name, "awards_championship_count"] <- length(JSONList[[i]]$awards_championship)
	DATParametersFromJSON[name, "biobrick_count"] <- length(JSONList[[i]]$parts_range)
	DATParametersFromJSON[name, "information_content"] <- as.numeric(JSONList[[i]]$information_content)
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
	DATContentsFromJSON[[name]]["advisors"] <- JSONList[[i]]["advisors"]
	DATContentsFromJSON[[name]]["project"] <- JSONList[[i]]["project"]
	DATContentsFromJSON[[name]]["abstract"] <- JSONList[[i]]["abstract"]
	## Meshterms is named numeric vector of term-counts
	if (length(JSONList[[i]]$meshterms) == 0) DATContentsFromJSON[[name]]["meshterms"] <- c()
	else DATContentsFromJSON[[name]]["meshterms"] <- JSONList[[i]]["meshterms"]
}

#### Write dataframe and list to one .RData file
save(DATParametersFromJSON, DATContentsFromJSON, file = "../homepage/data/DataFromJSON.RData")
