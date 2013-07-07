choicesWithNames <- function(choices) {
  # get choice names
  choiceNames <- names(choices)
  if (is.null(choiceNames))
    choiceNames <- character(length(choices))

  # default missing names to choice values
  missingNames <- choiceNames == ""
  choiceNames[missingNames] <- paste(choices)[missingNames]
  names(choices) <- choiceNames

  # return choices
  return (choices)
}

inlineLabel <- function(controlName, label) {
    tags$label(class = "control-label", style="display:inline", `for` = controlName, label)
}

selectInputInline <- function(inputId,
                        label,
                        choices,
                        selected = NULL,
                        multiple = FALSE) {
  # resolve names
  choices <- choicesWithNames(choices)

  # default value if it's not specified
  if (is.null(selected) && !multiple)
    selected <- names(choices)[[1]]

  # create select tag and add options
  selectTag <- tags$select(id = inputId)
  if (multiple)
    selectTag$attribs$multiple <- "multiple"

  for (i in seq_along(choices)) {
    choiceName <- names(choices)[i]
    optionTag <- tags$option(value = choices[[i]], choiceName)

    if (choiceName %in% selected)
      optionTag$attribs$selected = "selected"

    selectTag <- tagAppendChild(selectTag, optionTag)
  }

  # return label and select tag
  tagList(inlineLabel(inputId, label), selectTag)
}

shinyUI(
    bootstrapPage(
        # basic application container divs
        div(
            class="container-fluid",
            div(class="row-fluid",
                headerPanel("iGEM42 Scatter Plot")
            ),
            div(class="row-fluid",
                selectInputInline(inputId = "x",
                    label = "Choose X",
                    choices = myChoices,
                    selected = "Number of Students"),
                selectInputInline(inputId = "y",
                    label = "Choose Y",
                    choices = myChoices,
                    selected = "Number of Advisors")
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
            ),
            div(class="container-fluid",
                "Filter team success",
                div(class="row-fluid",
                    div(class="span3", selectInput(
                        inputId="FILawards_regional",
                        label="select regional awards (hold ctrl for multiple)",
                                                   choices=myChoicesForRegional_awards,
                                                   selected=myChoicesForRegional_awards,
                                                   multiple=TRUE )),
                    div(class="span3", selectInput(
                        inputId="FILawards_championship",
                        label="select championship awards (hold ctrl for multiple)",
                                                   choices=myChoicesForChampionship_awards,
                                                   selected=myChoicesForChampionship_awards,
                                                   multiple=TRUE ))
                ),
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
                )
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
    ))
