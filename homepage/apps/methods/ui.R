shinyUI(
	bootstrapPage(
		h2("Find Methods"),
		div(class="container-fluid",
			selectInput(inputId="L1",
				label="Choose Category",
				choices=myChoicesForMethodCluster,
				selected=myChoicesForMethodCluster[1]),
			conditionalPanel(
				condition="input.L1 == 'Preprocessing'",
				selectInput(inputId="L12",
					label="Choose Method",
					choices=myChoicesForMethods$Preprocessing,
					selected=myChoicesForMethods$Preprocessing[1])),
			conditionalPanel(
				condition="input.L1 == 'Processing'",
				selectInput(inputId="L22",
					label="Choose Method",
					choices=myChoicesForMethods$Processing,
					selected=myChoicesForMethods$Processing[1])),
			conditionalPanel(
				condition="input.L1 == 'Analysis'",
				selectInput(inputId="L32",
					label="Choose Method",
					choices=myChoicesForMethods$Analysis,
					selected=myChoicesForMethods$Analysis[1]))
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
		)
	)
)		