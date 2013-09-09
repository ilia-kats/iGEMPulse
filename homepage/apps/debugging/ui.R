shinyUI(
    bootstrapPage(
        # basic application container divs
		includeHTML("style.css"),
		h2("Timeline"),
        div(class="container-fluid",
			div(class="container-fluid", id="Output",
				div(class="Output-hori", id="Select",
					div(class="row-fluid",
						selectInput(inputId = "x",
						label = "Choose Variable",
						choices = myChoicesForX,
						selected = "Teams")
					),
					div(class="row-fluid",
						selectInput(inputId = "Sort",
						label = "Choose Categories",
						choices = myChoicesForSort,
						selected = "Region")
					)
				),
				div(class="Output-hori", id="Chart",
					tableOutput("myChart")
				)
			),
			div(class="container-fluid", id="Filters",
				div(class="row-fluid",
					p("Filtering options", id="FilterLabel"),
					tags$ul(id="FilterUl",
						tags$li(a(id="ShowRegion", href="#", onclick="Filter.Show('FilterRegion', 'ShowRegion');return(false);", "Region")),
						tags$li(a(id="ShowTrack", href="#", onclick="Filter.Show('FilterTrack', 'ShowTrack');return(false);", "Track")),
						tags$li(a(id="ShowName", href="#", onclick="Filter.Show('FilterName', 'ShowName');return(false);", "Name")),
						tags$li(a(id="ShowAwards", href="#", onclick="Filter.Show('FilterAwards', 'ShowAwards');return(false);", "Awards")),
						tags$li(a(id="ShowScore", href="#", onclick="Filter.Show('FilterScore', 'ShowScore');return(false);", "Score")),
						tags$li(a(id="ShowBiobricks", href="#", onclick="Filter.Show('FilterBiobricks', 'ShowBiobricks');return(false);", "Biobricks")),
						tags$li(a(id="ShowAbstract", href="#", onclick="Filter.Show('FilterAbstract', 'ShowAbstract');return(false);", "Abstract")),
						tags$li(a(id="ShowStudents", href="#", onclick="Filter.Show('FilterStudents', 'ShowStudents');return(false);", "Students")),
						tags$li(a(id="ShowAdvisors", href="#", onclick="Filter.Show('FilterAdvisors', 'ShowAdvisors');return(false);", "Advisors")),
						tags$li(a(id="ShowInstructors", href="#", onclick="Filter.Show('FilterInstructors', 'ShowInstructors');return(false);", "Instructors")),
						div(style="clear:both;")
					)
				),
				div(class="container-fluid", id="AllFilters",
					div(class="row-fluid", id="FilterRegion",
						selectInput(
							inputId="FILregion",
							label="select regions (hold ctrl for multiple)",
							choices=myChoicesForRegion,
							selected=myChoicesForRegion,
							multiple=TRUE )),
					div(class="row-fluid", id="FilterTrack",
						selectInput(
							inputId="FILtrack",
							label="select tracks (hold ctrl for multiple)",
							choices=myChoicesForTrack,
							selected=myChoicesForTrack,
							multiple=TRUE )),
					div(class="row-fluid", id="FilterName",
						textInput(
							inputId="FILname",
							label="enter team names (, -separated)",
							value="Name1, Name2")
					),
					div(class="row-fluid", id="FilterAwards",
						div(class="span4", selectInput(
							inputId="FILawards_regional",
							label="select regional awards (hold ctrl for multiple)",
							choices=myChoicesForRegional_awards,
							selected=myChoicesForRegional_awards,
							multiple=TRUE )),
						div(class="span4", selectInput(
							inputId="FILawards_championship",
							label="select championship awards (hold ctrl for multiple)",
							choices=myChoicesForChampionship_awards,
							selected=myChoicesForChampionship_awards,
							multiple=TRUE ))
					),
					div(class="row-fluid", id="FilterScore",
						div(class="span4", selectInput(
							inputId="FILscore_min",
							label="minimum score",
							choices=myChoicesForScore,
							selected=min(myChoicesForScore) )),
						div(class="span4", selectInput(
							inputId="FILscore_max",
							label="maximum score",
							choices=myChoicesForScore,
							selected=max(myChoicesForScore) ))
					),
					div(class="row-fluid", id="FilterBiobricks",
						div(class="span4", selectInput(
							inputId="FILbiobrick_count_min",
							label="minimum biobricks submitted",
							choices=myChoicesForBB_count,
							selected="0" )),
						div(class="span4", selectInput(
							inputId="FILbiobrick_count_max",
							label="maximum biobricks submitted",
							choices=myChoicesForBB_count,
							selected=">200" ))
					),
					div(class="row-fluid", id="FilterAbstract",
						div(class="span4", checkboxInput(
							inputId="FILabstract",
							label="Only display teams who submitted an abstract",
							value=FALSE)),
						div(class="span4", selectInput(
							inputId="FILinformation_content",
							label="Minimum information content of abstract",
							choices=myChoicesForInformation_content,
							selected="0"))
					),
					div(class="row-fluid", id="FilterStudents",
						div(class="span4", selectInput(
							inputId="FILstudents_count_min",
							label="minimum students number",
							choices=myChoicesForStudents_count,
							selected="0" )),
						div(class="span4", selectInput(
							inputId="FILstudents_count_max",
							label="maximum students number",
							choices=myChoicesForStudents_count,
							selected=">20" ))
					),
					div(class="row-fluid", id="FilterAdvisors",
						div(class="span4", selectInput(
							inputId="FILadvisors_count_min",
							label="minimum advisors number",
							choices=myChoicesForAdvisors_count,
							selected="0" )),
						div(class="span4", selectInput(
							inputId="FILadvisors_count_max",
							label="maximum advisors number",
							choices=myChoicesForAdvisors_count,
							selected=">14" ))
					),
					div(class="row-fluid", id="FilterInstructors",
						div(class="span4", selectInput(
							inputId="FILinstructors_count_min",
							label="minimum instructors number",
							choices=myChoicesForInstructors_count,
							selected="0" )),
						div(class="span4", selectInput(
							inputId="FILinstructors_count_max",
							label="maximum instructors number",
							choices=myChoicesForInstructors_count,
							selected=">15" ))
					)
				)
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
        ),
		includeHTML("javascript.js")
    )
)