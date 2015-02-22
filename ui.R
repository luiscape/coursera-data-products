library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Funding UN's Ebola response."),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("contribution",
                  "Millions of dollars:",
                  min = 1,
                  max = 2000,
                  value = 50),
      
      p("The United Nations launched an appeal that requests $2.27 billion dollars in order to fully fund the Ebola response and recovery operations. Funds to build treatment centers, medicine, pay doctors, serve food, etc."),
      strong("How much do you think will be necessary to fully fund those operations?"),
      p(),
      p(),
      h3(textOutput("ctotal"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h5("Forecast for donation coverage of UN's Ebola response."),
      plotOutput("distPlot"),
      textOutput("days")
    )
  )
))