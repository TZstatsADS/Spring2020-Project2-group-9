# UI

# Load all the required libraries 
packages.used <- c("shiny", "shinydashboard", 
                   "leaflet", "shinyWidgets","plotly","shinythemes","wordcloud2", "DT")
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
library(wordcloud2)
library(DT)
####
###
load("www/na_drop.RData")
na_drop$`Posting Date` <- as.Date(na_drop$`Posting Date`, "%m/%d/%Y")

dashboardPage(
  skin = "blue",
  dashboardHeader(title = "NYC Government Job Posting"),
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "Home", icon = icon("dashboard")),
    menuItem("MAP", tabName = "MAP", icon = icon("compass")),
    menuItem("Facts", tabName = "Facts", icon = icon("industry")),
    menuItem("Report", tabName = "Report", icon = icon("pencil-ruler"),startExpanded = TRUE,
             menuSubItem("Salary",tabName = "Salary", icon = icon("dollar-sign")),
             menuSubItem("Year",tabName = "Year",icon = icon("address-book")),
             menuSubItem("Other",tabName = "Other",icon = icon("award"))        
             ),
    menuItem("Job search", tabName = "job", icon = icon("clipboard")),
    menuItem("About", tabName = "about", icon = icon("sign-out"))
  )),
  dashboardBody(fill = FALSE,tabItems(
    ## Mengying About --------------------------------------------------------------------------------------------------------
    tabItem(tabName = "about",
            fluidPage(
              mainPanel( width=12,
                         img(src="../career.jpg", width = "100%", height = "100%"),
                         
                         h1(strong("What you'll find here"),align = "center"),
                         column(12,
                                tags$ul(
                                  tags$li(h4("In this project, we designed a shiny app with information about government job postings in NYC. We want to utilize the visualization tools in R and give potential job seekers information about government jobs in NYC." )), 
                                  tags$li(h4("By NYC Government Job shiny app, we can easily find the information about job postings, job information and job salary, etc. What's more, we can get personalized information by clicking the option next to the graphs.")), 
                                  tags$li(h4("Now, and into the future, we want to be a magnet for top talent and be an employer of choice."))
                                )
                         ),
                         br(),
                         h1(strong("About the Data"),align = "center"),
                         column(12,
                         h4(" We used the data \"NYC Jobs\" from NYC open data website.This dataset contains current job postings available on the City of New York’s official jobs site.
                         The data is from Jan.09,2014 to Feb.17,2020. We cleaned the data before further exploration."),
                         hr(),
                         img(src="../data.png", width = "100%", height = "30%",align = "center")),
                         br(),
                         column(12,
                         h1(strong("About the team"),align = "center"),
                         h4("The NYC Government Job Posting App is creadted by
                           Shuyi Chen; Jia Li; Ran Lu; Mengying Shi; Zhiyuan Zhang; Ryan Walters.",align = "center"),
                         h4("Thanks the help of ADS teaching team.",align = "center"),
                         br(),br()
              )),
              ),
            
    ),
    
    ## about end --------------------------------------------------------------------------------------------------------
    #Mengying home --------------------------------------------------------------------------------------------------------
    tabItem(tabName = "Home",
            fluidRow(
              valueBoxOutput("total_title"),
              valueBoxOutput("total_position"),
              valueBoxOutput("max_salary")
            ),
            fluidRow(box(width = 12,title = "Word Cloud of Job Title",status = "primary",solidHeader = TRUE,
                         mainPanel(
                           wordcloud2Output(outputId = "WC1", height = "380",width = "520"))
            ),
            tags$style(HTML("

                .box.box-solid.box-primary{

                background:url('../nyc8.jpg') no-repeat;background-size: 100% 100%;opacity: 0.85
                }

                "))
            ),
            fluidRow(box(width = 6,height = "50%",h2(strong("Make a difference"),align = "center"),
                         background = "teal",solidHeader = TRUE,
                         h3(hr()),
                         h3("City government is filled with opportunities for talented people 
                            who want to improve their communities and make an important difference 
                            in the lives of their fellow New Yorkers."),
                         h3("Employees appointed to civil service positions enjoy stable,
                            long-term employment with the City.")),
            column(width = 6,img(src="../nyc1.jpg",width = "100%", height = "35%"),align = "right")
            ),
            fluidRow(column(width = 6,img(src="../nyc2.png",width = "100%", height = "35%"),align = "left"),
            
            box(side = "left",solidHeader = TRUE,width = 6,h2(strong("Do what you're passionate about"),align = "center"),
                         background = "navy",hr(),
                         
                         h3("Are you interested in public health, community engagement, 
                            or disaster response? From civil engineering to forestry 
                            and technology innovation, we have it all."),
                h3("Every day, the City's 325,000 employees serve millions of residents and visitors. 
                   They improve infrastructure, provide important social services, and make the city safer.
                   Help to shape the future of NYC."))
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
                                 selected = c("Operation & Maintenance", "Finance","Public Safety",
                                              "Clerical & Administrative Support", "Technology & Data",
                                              "Community","Social Service","Health","Policy, Research & Analysis",
                                              "Engineering, Architecture, & Planning","Communications & Intergovernmental",
                                              "Legal"),
                                 ),
                actionButton("select_all", "Select All"),
                actionButton("select_none", "Select None"),
                
                checkboxGroupButtons("Full/Part", "Choose Part/Full Time:", choices = c("F","P"), selected = "F"),
                checkboxGroupInput("borough", "Choose Borough:",
                                   choices = c("Bronx","Queens", "Manhattan", "Brooklyn", "Staten Island"), 
                                   selected = c("Bronx","Queens", "Manhattan", "Brooklyn", "Staten Island"))
              ),
              absolutePanel(id = "controls", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                            top = 170, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                            selectInput("Career Level", label = h3("Select Career Level"), 
                                        choices = list("Career Level" = list("Entry-Level", "Executive","Experienced (non-manager)",
                                                                         "Manager", "Student")), selected = "Experienced (non-manager)"),
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
    
### Johnson/Suzie statistical analysis part begin-------------------------------------------------
#sub1 begin---------------------------------------------------------------------------------------   
tabItem(tabName = "Salary",
          fluidPage(
            fluidRow(column(12,
                            h3("Interactive Dashboard"),
                            h4("In this part, we analyze the critical statistics of the NYC job salary level and visualize the data by interactive dashboard."),
                            tags$div(tags$ul(
                              tags$li(h4("The first dot chart demonstrates the salary of different career levels in various categories. ")),
                              tags$li(h4("The second bar plot shows the number of government jobs available with a specific salary range in different years."))
                            )),
                          
                            fluidRow(column(width =  12, title = "Job count from 2013 to 2020", 
                                            plotlyOutput("job_salary_col"))),
                            fluidRow(column(width =  12, title = "Salary level of jobs from 2013 to 2020", 
                                            plotlyOutput("job_salary_count")))
                            
            
            )))),
 
#sub1 end---------------------------------------------------------------------------------------           

#sub2 begin----------------------------------------------------------------------------------------
tabItem(tabName = "Year",
        fluidPage(
          fluidRow(column(12,
                          h3("Interactive Dashboard"),
                          h4("In this part, we focus on the statistics of the NYC job in chronological order."),
                          tags$div(tags$ul(
                            tags$li(h4("Both chats illustrate that there are more jobs available in 2019.")),
                            tags$li(h4("More importantly, the number of technology&Data related  positions increases significantly "))
                          )),
                          
                          fluidRow(column(width =  12, title = "Category count from 2013 to 2020", 
                                          plotlyOutput("job_time_category"))),
                          fluidRow(column(width =  12, title = "Job count from 2013 to 2020", 
                                          plotlyOutput("job_time_count")))
                          
                   
          )))),

#sub2 end-------------------------------------------------------------------------------------------
  
#sub3 begin------------------------------------------------------------------------------------------
tabItem(tabName = "Other",
        fluidPage(
          fluidRow(column(12,
                          h3("Interactive Dashboard"),
                          h4("In this part, we pay attention to the critical statistics of the NYC job and visualize the data by interactive dashboard."),
                          tags$div(tags$ul(
                            tags$li(h4("The pie charts indicate that most of the jobs available are full-time, experienced-hire in the community and technology data category in Manhatton.")),
                            tags$li(h4("The donut chart illustrates that the department of environmental protection hires most people among other agencies."))
                          )),
                          
                          fluidRow(column(width =  12, title = "Job count from 2013 to 2020", 
                                          plotlyOutput("job_pie"))),
                           fluidRow(column(width =  12, title = "Job count from 2013 to 2020", 
                                           plotlyOutput("job_donut")))
                          
          )))),



#sub3 end--------------------------------------------------------------------------------------------

### Johnson statistical analysis part end------------------------------------------------
### Stephen statistical analysis part begin------------------------------------------------
  tabItem(tabName = "Facts",
          fluidPage(
            fluidRow(
              (tabBox(
                width=12,
                title = "Available Jobs",
                # The id lets us use input$tabset1 on the server to find the current tab
                id = "tabset1",
                tabPanel("Jobs Title", plotlyOutput("avai_title")),
                tabPanel("Agency", plotlyOutput("avai_agen"))
              ))),
            
            fluidRow(
              (tabBox(
                width=12,
                title = "High Salary",
                # The id lets us use input$tabset1 on the server to find the current tab
                tabPanel("Jobs Title", plotlyOutput("salary_title")),
                tabPanel("Agency", plotlyOutput("salary_agency")))
              )
              
              
            )
          )
  ),
### Stephen statistical analysis part end------------------------------------------------

#Job search -----------------------------------------------------------------------------------------
  tabItem(tabName = "job",
            fluidPage(box(width = 12,height = 350,status = "info",searchInput("job_table",
                                    h2(strong(br(),br(),br(),"Find A Job in New York City Government:",align = "center"), style = "color:white"),
                                    btnSearch = icon("search"))),
                      tags$style(HTML(".box.box-info{
                        background:url('../nyc7.png');background-size: 100% 100%;opacity: 0.9}")),
                      
                      fluidRow(width = 4, height = 1,status = "primary", height = "575",solidHeader = T,
                               column(12,
                                 dataTableOutput("job_table")
                                 )
                      )
            
            )

          )
# Job search end -----------------------------------------------------------------------------------------

)
)
)