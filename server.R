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
library(gsubfn)

# Define server logic required to draw bar graphs of Google Play Store app data
shinyServer(function(input, output) {
  
  # Reads Google Play Store data and filters/cleans the data for duplicates, correct category titles, and well-formatted install numbers
  app_data <- fread("googleplaystore.csv", stringsAsFactors = FALSE)
  app_data <- subset(app_data, !duplicated(app_data$App))
  
  app_data$App = str_to_title(app_data$App)
  
  app_data$Category = str_replace_all(app_data$Category, "_", " ")
  app_data$Category = str_to_title(app_data$Category)
  app_data$Category = str_replace_all(app_data$Category, "And", "&")
  
  app_data$Installs = gsubfn(".", list("+" = "", "," = ""), app_data$Installs)
  app_data$Installs = as.integer(app_data$Installs)
  
  # Plots categories of apps on the Google Play Store based on how many apps fall under those categories
  output$totalAppCategoryBarPlot <- renderPlot({
    overall_category_count <- group_by(app_data, Category) %>% summarize(count=n())
    
    ggplot(overall_category_count) + geom_bar(aes(x = reorder(Category, count), y = count, fill = Category), stat = "identity") + 
      labs(title = "Total Number of Google Play Store Apps by Category", x = "Category", y = "Number of Apps") + 
      scale_y_continuous(labels = scales::comma) +
      coord_flip() + theme(legend.position = "none")
  })
  
  # Plots dynamic bar graph of top Google Play Store apps at a given price, in a given category, by a specific popularity index 
  output$topAppsBarPlot <- renderPlot({
    graph_title <- "Top"
    
    # Filters data by price
    if(input$Price == "All"){
      topApps <- app_data
    } else if(input$Price == "Free"){
      graph_title <- paste0(graph_title, " Free")
      topApps <- filter(app_data, Type == "Free")  
    } else if (input$Price == "Paid") {
      graph_title <- paste0(graph_title, " Paid")
      topApps <- filter(app_data, Type == "Paid") 
    }
    
    # Filters data by category
    if(input$Category != "All") {
      graph_title <- paste0(graph_title, " ", input$Category)
      topApps <- filter(topApps, Category == input$Category)
    }
    
    # Filters data by installs and graphs top apps
    if(input$Index == "Installs"){
      graph_title <- paste0(graph_title, " Apps by Installs")
      topApps <- arrange(topApps, desc(Installs))
      topApps <- head(topApps, 20)
      
      ggplot(topApps) + geom_bar(aes(x = reorder(App, Installs), y = Installs, fill = App), stat = "identity") +
        labs(title = graph_title, x = "App", y = "Number of Installs") + 
        scale_y_continuous(labels = scales::comma) +
        coord_flip() + theme(legend.position = "none")
    
    # Filters data by reviews and graphs top apps  
    } else if(input$Index == "Reviews"){
      graph_title <- paste0(graph_title, " Apps by Reviews")
      topApps <- arrange(topApps, desc(Reviews))
      topApps <- head(topApps, 20)

      ggplot(topApps) + geom_bar(aes(x = reorder(App, Reviews), y = Reviews, fill = App), stat = "identity") +
        labs(title = graph_title, x = "App", y = "Number of Reviews") + 
        scale_y_continuous(labels = scales::comma) +
        coord_flip() + theme(legend.position = "none")
    }
  })
  
  # Creates intro text 
  #output$intro <- renderText({
    #paste0("The dataset we will be working with is called Google Play Store Apps. The dataset includes about 
           #10,000 applications that are on the Google Play Store and detailed information about each application. 
           #The dataset is from kaggle.com and it has more than 600 upvotes. According to kaggle, Lavanya Gupta, a software 
           #engineer at HSBC Software Development scraped the data for developer use in "analysing the Android market". 
           #She found that many of the public datasets on kaggle were about the Apple App store so decided to collect Google Play 
           #Store data for the public and app-making businesses to use. We have created data visualizations with advertising
           #companies looking for the right apps to advertise their products on in mind.")
  #})
  
  # Creates summary text
  output$summary <- renderText({
    paste0("There are 33 app categories on the Google Play Store platform. 
           The top three categories with most apps are Family, Game, and Tools. 
           The Family category has ", sum(app_data$Category == "Family"), " apps; Game category has ",
           sum(app_data$Category == "Game"), " apps; Tools category has ", sum(app_data$Category == "Tools"),
           " apps. Advertisement companies tasked with marketing family, game, and tool products 
           will find a plethora of apps on the Google Play Store that they can advertise their products on.")
  })
})
