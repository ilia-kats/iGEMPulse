require(rCharts)

myChoices = list("Number of Students"='students_count', 
      "Number of Advisors"='advisors_count', 
      "Number of Instructors"='instructors_count',
      "Number of regional awards" = 'awards_regional_count',
      "Number of championship awards"='awards_championship_count')

shinyUI(pageWithSidebar(
  headerPanel("iGEM Pulse Scatter Plot"),

  sidebarPanel(
    selectInput(inputId = "x",
     label = "Choose X",
     choices = myChoices,
     selected = "Number of Students"),

    selectInput(inputId = "y",
      label = "Choose Y",
      choices = myChoices,
      selected = "Number of Advisors")
  ),
  mainPanel(
    showOutput("myChart", "polycharts")
  )
))
  