shinyUI(
	bootstrapPage(
		h2("Find Topics"),
		div(class="container-fluid",
			textInput(inputId="FILTopic",
				label="Enter a topic",
				value="Some Topic")
		),
		div(class="container-fluid",
			div(class="row-fluid",
				div(class="span4",
					selectInput(
						inputId="TeamDisplay",
						label="Display table of teams",
						choices=myChoicesForTeamDisplay,
						selected="5" )),
				div(class="span4",
					selectInput(
						inputId="TeamSort",
						label="Sorted by",
						choices=myChoicesForTeamSort,
						selected="Score" ))
			),
			tableOutput(outputId="TeamList")
		),
		includeHTML("javascript.js")
	)
)		