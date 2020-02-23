# UI
library(plotly)
library(shinythemes)

# Load all the required libraries 
packages.used <- c("shiny", "shinydashboard", 
                   "leaflet", "shinyWidgets")
# check packages that need to be installed.
packages.needed <- setdiff(packages.used, 
                           intersect(installed.packages()[,1], 
                                     packages.used))
# install additional packages
if(length(packages.needed) > 0){
  install.packages(packages.needed, dependencies = TRUE)
}


library(shiny)
library(shinydashboard)
library(leaflet)
library(shinyWidgets)

####
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()
###
load("../data/na_drop.RData")
na_drop$`Posting Date` <- as.Date(na_drop$`Posting Date`, "%m/%d/%Y")

dashboardPage(
  dashboardHeader(title = "NYC Government Job Posting"),
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "Home", icon = icon("dashboard")),
    menuItem("MAP", tabName = "MAP", icon = icon("compass")),
    menuItem("Facts", tabName = "Facts", icon = icon("dashboard")),
    menuItem("Report", tabName = "Report", icon = icon("industry")),
    menuItem("Job search", tabName = "job search", icon = icon("industry"))
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
 
              leafletOutput("map",width="100%",height=750),
              absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                            top = 140, left = "auto", right = "auto", bottom = "auto", width = 250, height = "auto",
                checkboxGroupInput("category", "Choose Category:",
                                 choices = c("Operation & Maintenance", "Finance","Public Safety",
                                        "Clerical & Administrative Support", "Technology & Data",
                                        "Community","Social Service","Health","Policy, Research & Analysis",
                                        "Engineering, Architecture, & Planning","Communications & Intergovernmental",
                                        "Legal"),
                                 selected = "Finance"),
                checkboxGroupButtons("Full/Part", "Choose Part/Full Time:", choices = c("F","P"), selected = "F"),
                checkboxGroupInput("borough", "Choose Borough:",
                                   choices = c("Bronx","Queens", "Manhattan", "Brooklyn", "Staten Island"), 
                                   selected = c("Bronx","Queens", "Manhattan", "Brooklyn", "Staten Island"))
              ),
              absolutePanel(id = "controls", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                            top = 170, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                            selectInput("Career Level", label = h3("Select Career Level"), 
                                        choices = list("Career Level" = list("Entry-Level", "Executive","Experienced (non-manager)",
                                                                         "Manager", "Student")), selected = "Entry-Level"),
                            dateInput("Posting Date", "Choose start date:",
                                     value = "2014-01-01",
                                     min = min(na_drop$`Posting Date`),
                                     max = max(na_drop$`Posting Date`)),
                            sliderInput("Salary Range To", "Highest Salary Offered Higher Than: ", min=floor(min(na_drop$`Salary Range To`)),
                                        max=floor(max(na_drop$`Salary Range To`))-100000, value=2000, step=20)
                            
              )
            )
    ),
    
    ### MAP Part Done
    
  ### Johnson statistical analysis part begin-------------------------------------------------
  tabItem(tabName = "Report",
          fluidPage(
            fluidRow(column(12,
                            h3("Interactive Dashboard"),
                            "In this part, we analysis the critical statistics of the NYC job and visualize the data by interactive dashboard.",
                            tags$div(tags$ul(
                              tags$li("*****"),
                              tags$li("*****")
                            )),
                            #htmlOutput("d3"))),
                            fluidRow(column(width =  12, title = "Salary Range Statistics by different job category(box plot)", 
                                            plotlyOutput("job_salary_box"))) ,
                            fluidRow(column(width =  12, title = "Salary Range Statistics by different job category(bar plot)", 
                            plotlyOutput("job_salary_col"))),
                            fluidRow(column(width =  12, title = "Job count from 2013 to 2020", 
                                            plotlyOutput("job_time_count"))),
                            fluidRow(column(width =  12, title = "Salary level of jobs from 2013 to 2020", 
                                            plotlyOutput("job_salary_count")))
                            
            
            ))))
            
    
  ### Johnson statistical analysis part end------------------------------------------------

)
)
)