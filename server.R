#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#

library(shiny)
library(dplyr)
library(data.table)
library(ggplot2)
library(stringr)
library(R.utils)
library(mapproj)

# Define server logic required to draw bar graphs of Google Play Store app data
shinyServer(function(input, output) {
  
  # Reads Google Play Store data and filters/cleans it to show categories and their respective app counts in the store
  table_data <-  fread("googleplaystore.csv", stringsAsFactors = FALSE)
  # Sets subset based on input category
  
  # Creates summary text 
  output$summary <- renderText({
    paste0("For later")
  })
})
