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
  app_data <- fread("googleplaystore.csv", stringsAsFactors = FALSE)
  app_data <- subset(app_data, !duplicated(app_data$App))
  app_data$Category = str_replace_all(app_data$Category, "_", " ")
  app_data$Category = str_to_title(app_data$Category)
  app_data$Installs = gsubfn(".", list("+" = "", "," = ""), app_data$Installs)
  app_data$Installs = as.integer(app_data$Installs)
  
  # 
  output$totalAppCategoryBarPlot <- renderPlot({
    overall_category_count <- group_by(app_data, Category) %>% summarize(count=n())
    
    ggplot(overall_category_count) + geom_bar(aes(x = reorder(Category, count), y = count, fill = Category), stat = "identity") + 
      labs(title = "Total Number of Google Play Store Apps by Category", x = "Category", y = "Number of Apps") + 
      coord_flip() + theme(legend.position = "none")
  })
  
  #
  output$topAppsBarPlot <- renderPlot({
    topTwenty <- filter(app_data, Type == "Free")
    #if(input$Category != "All") {
      #topTwenty <- filter(topTwenty, Category == input$Category)
    #}
    #if(input$Index == "Installs"){
      topTwenty <- arrange(topTwenty, desc(Installs))
    #} else if(input$Index == "Rating"){
      #topTwenty <- arrange(topTwenty, Rating)
    #}
    topTwenty <- head(topTwenty, 20)
    
    ggplot(topTwenty) + geom_bar(aes(x = App, y = Installs, fill = App), stat = "identity") +
      labs(title = "Top Twenty Apps", x = "App", y = "Number of Installs") + 
      coord_flip() + theme(legend.position = "none")
  })
  
  # Sets subset based on input category
  
  # Creates summary text 
  output$summary <- renderText({
    paste0("For later")
  })
})
