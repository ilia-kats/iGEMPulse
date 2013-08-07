shinyUI(
	bootstrapPage(
		class="container-fluid",
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
		div(class="row-fluid",
                    div(class="span3", selectInput(
                        inputId="FILmaintheme",
                        label="Select a main theme (hold ctrl for multiple)",
                        choices=myChoicesForMaintheme,
                        selected=myChoicesForMaintheme,
                        multiple=TRUE )),
                    div(class="span3", selectInput(
                        inputId="FILtopic",
                        label="Specify by choosing a topic (hold ctrl for multiple)",
                        choices=myChoicesForTopic,
                        selected=myChoicesForTopic,
                        multiple=TRUE ))
						
                ),
		)
		)