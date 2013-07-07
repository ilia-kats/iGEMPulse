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
						inputId="FILregion",
						label="select regions (hold ctrl for multiple)",
						choices=myChoicesForRegion,
						selected=c("Europe","America","Asia"),
						multiple=TRUE )),
					div(class="span3", selectInput(
						inputId="FILtrack",
						label="select tracks (hold ctrl for multiple)",
						choices=myChoicesForTrack,
						selected=myChoicesForTrack,
						multiple=TRUE ))
				),
				"Autofillable text entry for team names"
			),
			div(class="container-fluid",
				"Filter team success",
				#div(class="row-fluid",
				#	div(class="span4", selectInput(
				#		inputId="FILawards_regional",
				#		label="select regional awards (hold ctrl for multiple)",
				#		choices=myChoicesForRegional_awards,
				#		selected=myChoicesForRegional_awards,
				#		multiple=TRUE )),
				#	div(class="span4", selectInput(
				#		inputId="FILawards_championship",
				#		label="select championship awards (hold ctrl for multiple)",
				#		choices=myChoicesForChampionship_awards,
				#		selected=myChoicesForChampionship_awards,
				#		multiple=TRUE ))
				#),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILscore_min",
						label="minimum score",
						choices=myChoicesForScore,
						selected=min(myChoicesForScore) )),
					div(class="span3", selectInput(
						inputId="FILscore_max",
						label="maximum score",
						choices=myChoicesForScore,
						selected=max(myChoicesForScore) ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILbiobrick_count_min",
						label="minimum biobricks submitted",
						choices=myChoicesForBB_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILbiobrick_count_max",
						label="maximum biobricks submitted",
						choices=myChoicesForBB_count,
						selected=">200" ))
				),
				"Only those with abstract submitted"
			),
			div(class="container-fluid",
				"Filter team composition",
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILstudents_count_min",
						label="minimum students number",
						choices=myChoicesForStudents_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILstudents_count_max",
						label="maximum students number",
						choices=myChoicesForStudents_count,
						selected=">20" ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILadvisors_count_min",
						label="minimum advisors number",
						choices=myChoicesForStudents_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILadvisors_count_max",
						label="maximum advisors number",
						choices=myChoicesForStudents_count,
						selected=">15" ))
				),
				div(class="row-fluid",
					div(class="span3", selectInput(
						inputId="FILinstructors_count_min",
						label="minimum instructors number",
						choices=myChoicesForInstructors_count,
						selected="0" )),
					div(class="span3", selectInput(
						inputId="FILinstructors_count_max",
						label="maximum instructors number",
						choices=myChoicesForInstructors_count,
						selected=">15" ))
				)
			)
        )
    )
)