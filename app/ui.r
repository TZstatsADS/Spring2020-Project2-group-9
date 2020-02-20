# UI
library(shiny)
library(shinydashboard)
library(leaflet)

####
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()
###
load("../data/na_drop.RData")


dashboardPage(
  dashboardHeader(title = "NYC Government Job Posting"),
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "Home", icon = icon("dashboard")),
    menuItem("MAP", tabName = "MAP", icon = icon("compass")),
    menuItem("DashBoard", tabName = "DashBoard", icon = icon("dashboard")),
    menuItem("Explore", tabName = "Explore", icon = icon("industry"))
  )),
  dashboardBody(tabItems(
    #home
    tabItem(tabName = "Home",
            fluidPage(
              fluidRow(
                box(width = 15, title = "Introduction", status = "warning",
                    solidHeader = TRUE, h3("NYC Government Job Posting"),
                    h4("By Mengying Shi, XXXXXXXXXXXXX"),
                    h5("Introduction"),
                    h5("XXXXXXXXX"))),
              fluidRow(box(width = 15, title = "web decribtion", status = "warning",
                           solidHeader = TRUE, h3("What Does This Map Do?"),
                           tags$div(tags$ul(
                             tags$li("MAP: "),
                             tags$li("DashBoard: "),
                             tags$li("Explore:")
                           ))))
            )),
    # MAP
    tabItem(tabName = "MAP",
      fluidPage(
        # wellPane(
          # selectInput("category", label = h3("Select Category"),
          #             choices = list("Category" = list("Operation & Maintenance", "Finance","Public Safety",
          #                                              "Clerical & Administrative Support", "Technology & Data",
          #                                              "Community","Social Service","Health","Policy, Research & Analysis",
          #                                              "Engineering, Architecture, & Planning","Communications & Intergovernmental",
          #                                              "Legal"))),
          #             leafletOutput("map")
        
        
        checkboxGroupInput("category", "Choose Category:",
                           choiceNames =
                             list("Operation & Maintenance", "Finance","Public Safety",
                                  "Clerical & Administrative Support", "Technology & Data",
                                  "Community","Social Service","Health","Policy, Research & Analysis",
                                  "Engineering, Architecture, & Planning","Communications & Intergovernmental",
                                  "Legal"
                                  ),
                           choiceValues =
                             list("Operation & Maintenance", "Finance","Public Safety",
                                  "Clerical & Administrative Support", "Technology & Data",
                                  "Community","Social Service","Health","Policy, Research & Analysis",
                                  "Engineering, Architecture, & Planning","Communications & Intergovernmental",
                                  "Legal")
        ),
        leafletOutput("map")
        
        
        
                      )
        )
      # )
    
    ####
  )
  
  ))

