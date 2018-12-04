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

# Define server logic required to draw bar graphs of Google Play Store app data
shinyServer(function(input, output) {
  
  # Reads Google Play Store data and filters/cleans the the category titles
  app_data <-  fread("googleplaystore.csv", stringsAsFactors = FALSE)
  app_data$Category = str_replace_all(app_data$Category, "_", " ")
  app_data$Category = str_to_title(app_data$Category)
  
  # 
  output$totalAppCategoryBarPlot <- renderPlot({
    overall_category_count <- group_by(app_data, Category) %>% summarize(count=n())
    
    ggplot(overall_category_count) + geom_bar(aes(x = reorder(Category, count), y = count, fill = Category), stat = "identity") + 
      labs(title = "Total Number of Google Play Store Apps by Category", x = "Category", y = "Number of Apps") + 
      coord_flip() + theme(legend.position = "none")
  })
  
  #
  output$topTenAppsBarPlot <- renderPlot({
    freePaid <- switch()
    index <- switch()
  })
  
  # Sets subset based on input category
  
  # Creates summary text 
  output$summary <- renderText({
    paste0("For later")
  })
})
