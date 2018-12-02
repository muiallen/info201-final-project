library(shiny)

shinyUI(fluidPage(
  titlePanel("Google Play Store Analysis"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("Price", "Free/Paid Apps", choices = c("All", "Free", "Paid"), selected = "Free"),
      selectInput("Category", "Choose a Category", choices = c("All", "Art & Design", "Auto & Vehicles", "Beauty", "Books & Reference", 
                                                               "Business", "Comics", "Communication", "Dating", "Education", 
                                                               "Entertainment", "Events", "Family", "Finance", "Food & Drink", 
                                                               "Game", "Health & Fitness", "House & Home", "Libraries & Demo", 
                                                               "Lifestyle", "Maps & Navigation", "Medical", "News and Magazines", 
                                                               "Parenting", "Personalization", "Photography", "Productivity", 
                                                               "Shopping", "Social", "Sports", "Tools", "Travel & Local", 
                                                               "Videoplayers", "Weather")),
      radioButtons("Index", 
                  "Select Index", 
                  choices = c("Installs", "Rating"))
    ),
    mainPanel(
      plotOutput("totalAppCategoryBarPlot")
    )
  )
))