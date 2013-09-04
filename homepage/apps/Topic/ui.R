shinyUI(
	bootstrapPage(
		div(class="row-fluid",
			headerPanel("iGEM42 Topic Plot")
		),
		div(class="row-fluid",
			div(class="span4",
				showOutput("myChart","polycharts")
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
		)
	)
)