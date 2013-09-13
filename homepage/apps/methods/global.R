load("../../data/DataFromJSON.RData")
dat <- DATParametersFromJSON

## Calculate Top 10
methods <- c()
for(i in 1:length(DATContentsFromJSON)) methods <- c(methods, names(DATContentsFromJSON[[i]]$methods))
methodslevels <- levels(as.factor(methods))
Top10 <- data.frame(Method=methodslevels, Teams=rep(0, length(methodslevels)))
for(i in 1:length(methodslevels)) {
	Top10$Teams[which(Top10$Method==methodslevels[i])] <- length(which(methods == methodslevels[i]))
}
Top10 <- Top10[order(Top10$Teams, decreasing=TRUE),]
Top10 <- data.frame(Method = Top10$Method, Teams = Top10$Teams)

myChoicesForTeamDisplay <- c("0", "5", "10", "20", "50", "100", "all")
myChoicesForTeamSort <- c("Year", "Alphabetic", "Score")
myChoicesForMethodCluster <- c("Preprocessing", "Processing", "Analysis")
myChoicesForMethods <- list(	"Preprocessing" = c(
									"Fusion Proteins",
									"Primer Design",
									"cloning",
									"preparation of DNA",
									"Restriction Digestion",
									"Insert preparation",
									"cell fractionation",
									"cell counting"),
								"Processing" = c("DNA sequencing",
									"PCR",
									"DNA Microarray",
									"arrays",
									"interaction chromatography",
									"purification",
									"Gel extraction",
									"Ligation",
									"Transformation",
									"FRET",
									"DNA extraction",
									"patch clamp"),
								"Analysis" = c(
									"Northern Blot",
									"Southern Blot",
									"Western blotting",
									"Bioinformatics",
									"ELISA",
									"Chromatography",
									"flow cytometry",
									"X-Ray-crystallography",
									"NMR",
									"Electron microscopy",
									"Molecular dynamics",
									"coimmunoprecipitation",
									"Electrophoretic mobility shift assay",
									"southwestern blotting",
									"size determination",
									"gel electrophoresis",
									"macromolecule blotting and probing",
									"immuno assays",
									"phenotypic analysis",
									"imaging",
									"spectroscopy",
									"spectrometry")
							)
							
FilterForMethods <- function(data, input) {
	keepteams <- c()
	if (input$L1 == "Preprocessing") method <- "L12"
	if (input$L1 == "Processing") method <- "L22"
	if (input$L1 == "Analysis") method <- "L32"
	Contents <- DATContentsFromJSON
	for	(i in 1:length(DATContentsFromJSON)) {
		if (length(which(names(Contents[[i]]$methods) == input[[method]])) != 0) keepteams <- c(keepteams, names(Contents)[i])
	}
	if (length(keepteams) != 0) data <- data[keepteams,]
	else return(data.frame("name" = "No", "year" = "Teams", "wiki" = "using this method", "score"=c("Teams", "for this method")))
	if (length(grep("NA\\.", row.names(data), perl=TRUE)) != 0 ) data <- data[-grep("NA\\.", row.names(data), perl=TRUE),]
	if (length(which(row.names(data) == "NA")) == 1) data <- data[-which(row.names(data) == "NA"),]
	rm(keepteams)
	rm(Contents)
	return(data)
}