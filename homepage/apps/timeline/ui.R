require(rCharts)

myChoices = c('Students',
      'Teams', 'Instructors', 'Advisors', 'ChampionshipAwards')


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
                choices = myChoices,
                selected = "Teams")
            ),
            div(class="row-fluid",
                mainPanel(
                    showOutput("myChart","nvd3")
                )
            )
        )
    )
)
