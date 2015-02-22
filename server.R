library(shiny)
library(forecast)
library(dplyr)
library(RcppArmadillo)
library(BH)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Reading the data from a local path.
  data <- read.csv("data/fts-ebola-coverage.csv")
  data <- data[order(data$Value, decreasing = TRUE),]
    
  
  calculateDonaton <- function(i) {
    current_requirements = 2270000000  
    funding = 1300621500
    r = (i + funding) / current_requirements
    it <- data.frame(CHD_Indicator_Code = "CHD.FUN.142",
                     Date = as.character(Sys.Date()),
                     Value = r,
                     Indicator_Name = "Ebola Virus Outbreak - Overview of Needs and Requirements (inter-agency plan for Guinea, Liberia, Sierra Leone, Region) (Coverage)")
    new_data <- rbind(data,it)
    new_data <- new_data[order(new_data$Value, decreasing = TRUE),]
    return(new_data)
  }
  
  calculateDays <- function(df) {
    fit <- ets(df[order(df$Value),]$Value)
    f <- data.frame(forecast(fit, 200))
    x <- f %>%
      subset(Point.Forecast > 1)
    
    # Calculating how many days will be left.
    days  <- as.numeric(row.names(x[1,])) - 148
    return(days)
  }
  
  plotForecast <- function(df) {
    fit <- ets(df[order(df$Value),]$Value)
    f <- data.frame(forecast(fit, 170))
    plot(forecast(fit, 200))
    abline(h=1,col=4,lty=2)
    title(ylab = "Number of appeal days", xlab = "Coverage ratio")
  }
  
  output$ctotal <- renderText({
    ctotal = input$contribution
    paste0("Contribution: $", ctotal, " million US dollars.")
  })
  
  output$days <- renderText({
    # Calculating how contribution helps.
    c = input$contribution * 1000000
    tdata <- calculateDonaton(c)
    days <- calculateDays(tdata)
    paste("At current donation rates,", days, "days will still be necessary before the Ebola response is fully funded.")
  })
  
  output$distPlot <- renderPlot({
    # Calculating how contribution helps.
    c = input$contribution * 1000000
    tdata <- calculateDonaton(c)
    days <- calculateDays(tdata)
    
    # draw the histogram with the specified number of bins
    plotForecast(tdata)
  })
})