library(shiny)

# Define UI for application that draws graphs of app data in the Google Play Store
shinyUI(fluidPage(
  titlePanel("Google Play Store Analysis (Zikai Song, Allen Mui, Heewon Song)"),
  
  mainPanel(
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Introduction",
                           p("The dataset we will be working with is called Google Play Store apps. The dataset includes about 
                              10,000 applications that are on the Google Play Store and detailed information about each application. 
                              The dataset is from ", a("kaggle.com", href = 'https://www.kaggle.com/lava18/google-play-store-apps'), 
                              "and it has more than 600 upvotes. According to kaggle, Lavanya Gupta, a software engineer at HSBC 
                              Software Development scraped the data for developer use in \"analysing the Android market\". She found that 
                              many of the public datasets on kaggle were about the Apple App Store so she decided to collect Google Play 
                              Store data for the public and app-making businesses to use. With Shiny, we have created data 
                              visualizations with advertising companies looking for the right apps to advertise their products on in mind."),
                           img(src = "google-play.png", height = "70%", width = "70%")
                           ),
                  
                  tabPanel("Popular App Categories", 
                           plotOutput("totalAppCategoryBarPlot"),
                           textOutput("summary")
                           ),
                  
                  tabPanel("Top Apps",
                           # Sidebar with radio and select inputs for price, category, and index for user to create top apps graph
                           sidebarLayout(sidebarPanel(
                                           radioButtons("Price", "Free/Paid Apps", choices = c("All", "Free", "Paid"), selected = "Free"),
                                           
                                           br(),
                                           
                                           selectInput("Category", "Choose a Category", choices = c("All", "Art & Design", "Auto & Vehicles", "Beauty", "Books & Reference", 
                                                                                                    "Business", "Comics", "Communication", "Dating", "Education", 
                                                                                                    "Entertainment", "Events", "Family", "Finance", "Food & Drink", 
                                                                                                    "Game", "Health & Fitness", "House & Home", "Libraries & Demo", 
                                                                                                    "Lifestyle", "Maps & Navigation", "Medical", "News and Magazines", 
                                                                                                    "Parenting", "Personalization", "Photography", "Productivity", 
                                                                                                    "Shopping", "Social", "Sports", "Tools", "Travel & Local", 
                                                                                                    "Videoplayers", "Weather"), width = "150px"),
                                           
                                           br(),
                                           
                                           radioButtons("Index", 
                                                        "Select Index", 
                                                        choices = c("Installs", "Reviews"))
                                         ),
                                         
                                         mainPanel(
                                           plotOutput("topAppsBarPlot")
                                         )
                           )
                  )
      )
    )
  )
)