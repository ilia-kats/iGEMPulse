require(rCharts)

myChoicesForX = c("Students", "Teams", "Instructors", "Advisors", "ChampionshipAwards")
myChoicesForYear <- levels(as.factor(DATParametersFromJSON$year))
myChoicesForRegion <- levels(as.factor(DATParametersFromJSON$region))
myChoicesForTrack <- levels(as.factor(DATParametersFromJSON$track))

shinyUI(
    bootstrapPage(
        # basic application container divs
        div(
            class="container-fluid",
            div(class="row-fluid",
                headerPanel("iGEM42 TimeLine")
            ),
            div(class="row-fluid",
                selectInput(inputId = "x",
                label = "Choose Variable",
                choices = myChoicesForX,
                selected = "Teams")
            ),
            div(class="row-fluid",
                div(class="span4",
                    showOutput("myChart","nvd3")
                )
            ),
			div(class="container-fluid",
				"General filter options",
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILyear_min",
						label="minimum year",
						choices=myChoicesForYear,
						selected=min(myChoicesForYear) )),
					div(class="span3", selectInput(
						inputId="FILyear_max",
						label="maximum year",
						choices=myChoicesForYear,
						selected=max(myChoicesForYear) ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILregion",
						label="select regions (hold ctrl for multiple)",
						choices=myChoicesForRegion,
						selected=myChoicesForRegion,
						multiple=TRUE )),
					div(class="span3", selectInput(
						inputId="FILtrack",
						label="select tracks (hold ctrl for multiple)",
						choices=myChoicesForTrack,
						selected=myChoicesForTrack,
						multiple=TRUE ))
				),
				"Autofillable text entry for team names"
			)
        )
    )
)
