# UI

# Load all the required libraries 
packages.used <- c("shiny", "shinydashboard", 
                   "leaflet", "shinyWidgets","plotly","shinythemes")
# check packages that need to be installed.
packages.needed <- setdiff(packages.used, 
                           intersect(installed.packages()[,1], 
                                     packages.used))
# install additional packages
if(length(packages.needed) > 0){
  install.packages(packages.needed, dependencies = TRUE)
}

library(plotly)
library(shinythemes)
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
  skin = "blue",
  dashboardHeader(title = "NYC Government Job Posting"),
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "Home", icon = icon("dashboard")),
    menuItem("MAP", tabName = "MAP", icon = icon("compass")),
    menuItem("Facts", tabName = "Facts", icon = icon("industry")),
    menuItem("Statistical Analysis", tabName = "Report", icon = icon("pencil-ruler")),
    menuItem("Job search", tabName = "job", icon = icon("clipboard")),
    menuItem("About", tabName = "intro", icon = icon("sign-out"))
  )),
  dashboardBody(tabItems(
    ## test
    tabItem(tabName = "intro",
            fluidPage(
              mainPanel( width=12,
                         img(src="../career.jpg", width = "100%", height = "100%"),
                         
                         h1(strong("What you'll find here"),align = "center"),
                         h5("An interactive tool to help you explore the actual paths employees have taken during their County 
                         careers. With information about the popularity of certain paths, salary differences, 
                         and more, you can build your own path based on what is meaningful to you.",align = "center"),
                         hr(),
                         br(),
                         h1("How it can help you",align = "center"),
                         h5("An interactive tool to help you explore the actual paths employees have taken during their County 
                         careers. With information about the popularity of certain paths, salary differences, 
                         and more, you can build your own path based on what is meaningful to you.",align = "center")
              )),
            
    ),
    
    
    
    
    
    
    
    ##
    #home --------------------------------------------------------------------------------------------------------
    tabItem(tabName = "Home",
            fluidRow(
              valueBoxOutput("total_title"),
              valueBoxOutput("total_position"),
              valueBoxOutput("max_salary")
            ),
            fluidRow(box(width = 12,title = "Word Cloud of Job Title",status = "primary",solidHeader = TRUE,
                         mainPanel(
                           wordcloud2Output(outputId = "WC1", height = "300",width = "550"))
            )),
            fluidRow(box(width = 6,h2(strong("Make a difference"),align = "center"),
                         background = "teal",solidHeader = TRUE,
                         h3(hr()),
                         h4("City government is filled with opportunities for talented people 
                            who want to improve their communities and make an important difference 
                            in the lives of their fellow New Yorkers.")),
                     column(width = 6,img(src="../nyc1.jpg",width = "100%", height = 220),align = "left")
            ),
            fluidRow(column(width = 6,img(src="../nyc2.png",width = "100%", height = 250),align = "right"),h3(hr()),
                     solidHeader = TRUE,
                     box(side = "left",width = 6,h2(strong("Do what you're passionate about"),align = "center"),
                         background = "navy",
                         
                         h4("Are you interested in public health, community engagement, 
                            or disaster response? From civil engineering to forestry 
                            and technology innovation, we have it all."))
            )
            
    ),   
    #home end --------------------------------------------------------------------------------------------------------
    # MAP
    tabItem(tabName = "MAP",
            fluidPage(
 ### Ran map ui begin -------------------------------------------------------------------------------------
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
    
### Ran MAP Part Done -------------------------------------------------------------
    
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