require(rCharts)

myChoices = c('Students', 
      'Teams', 'Instructors', 'Advisors', 'ChampionshipAwards')


shinyUI(pageWithSidebar(
  headerPanel("iGEM42 TimeLine"),

  sidebarPanel(
    selectInput(inputId = "x",
     label = "Choose Variable",
     choices = myChoices,
     selected = "Teams")
  ),
  mainPanel(
    showOutput("myChart","nvd3")
  )
))
  