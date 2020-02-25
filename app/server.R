# server
packages.used <- c("shiny","leaflet", "wordcloud2", "DT", "stringr", "dplyr", "tidyverse", "tibble")
# check packages that need to be installed.
packages.needed <- setdiff(packages.used, 
                           intersect(installed.packages()[,1], 
                                     packages.used))
# install additional packages
if(length(packages.needed) > 0){
   install.packages(packages.needed, dependencies = TRUE)
}


library(shiny)
library(leaflet)
library(readr)
library(wordcloud2)
library(DT)
library(stringr)
library(tidyverse)
library(dplyr)
library(tibble)
shinyServer(function(input,output, session){
   load("../data/na_drop.RData")
# Ran map begin ========================================================================================   
   na_drop$`Posting Date` <- as.Date(na_drop$`Posting Date`, "%m/%d/%Y")
   
   category <- reactive(na_drop[which(na_drop$category %in% input$category & na_drop$`Full/Part` %in% input$`Full/Part`&
                                      na_drop$`Career Level` %in% input$`Career Level` & na_drop$borough %in% input$borough &
                                      na_drop$`Posting Date` >= input$`Posting Date` & 
                                         na_drop$`Salary Range To` >= input$`Salary Range To`),])

   output$map <- renderLeaflet({
     map <- leaflet() %>% setView(-73.9578,40.72348,zoom = 11) %>% addTiles() %>% addCircleMarkers(lng = category()$lon, lat = category()$lat, 
           clusterOptions = markerClusterOptions(), popup = paste("<b>", "Job Title:", category()$title, 
                                                                  "<br/>", "<b>", "Salary Range in USD:", category()$`Salary Range From`, "to", category()$`Salary Range To`,
                                                                  "<br/>", "<b>", "Agency:", category()$Agency, 
                                                                  "<br/>", "<b>", "Posting Date:", category()$`Posting Date`,
                                                                  "<br/>", "<b>", "Level:", category()$`Career Level`,
                                                                  "<br/>", "<b>", "Number of Positions Offered:", category()$num_positions,
                                                                  "<br/>", "<b>", "Full/Part Time:", category()$`Full/Part`)) %>%
       addProviderTiles(providers$CartoDB.Positron)
     })
   observeEvent(input$select_all, {
      updateCheckboxGroupInput(session, "category",
                               choices = c("Operation & Maintenance", "Finance","Public Safety",
                                           "Clerical & Administrative Support", "Technology & Data",
                                           "Community","Social Service","Health","Policy, Research & Analysis",
                                           "Engineering, Architecture, & Planning","Communications & Intergovernmental",
                                           "Legal"),
                               selected =c("Operation & Maintenance", "Finance","Public Safety",
                                           "Clerical & Administrative Support", "Technology & Data",
                                           "Community","Social Service","Health","Policy, Research & Analysis",
                                           "Engineering, Architecture, & Planning","Communications & Intergovernmental",
                                           "Legal")
      )
   })
   observeEvent(input$select_none, {
      updateCheckboxGroupInput(session, "category",
                               choices = c("Operation & Maintenance", "Finance","Public Safety",
                                           "Clerical & Administrative Support", "Technology & Data",
                                           "Community","Social Service","Health","Policy, Research & Analysis",
                                           "Engineering, Architecture, & Planning","Communications & Intergovernmental",
                                           "Legal"),
                               selected = NULL)
   })
   # Ran map end ------------------------------------------------------------------ 
   
   # Ran Job search part begin -----------------------------------------------------------
   
   job_search <- na_drop %>% select(`Job ID`, title, category, Agency,
                      `Full/Part`, `Career Level`, `Work Location`) %>%
      apply(2, str_to_lower) %>% as_tibble()
      inputtext <- reactive(input$job_table %>% str_to_lower())

      output$job_table <- renderDataTable({
         datatable(na_drop[str_detect(job_search$title, inputtext())|str_detect(job_search$category, inputtext())|
                       str_detect(job_search$Agency, inputtext())|str_detect(job_search$`Career Level`, inputtext())|
                       str_detect(job_search$`Work Location`, inputtext()), ] %>% 
               select(title, category, Agency, `Full/Part`, `Career Level`, `Work Location`, `Job Description`) %>%
               rename(Title = "title", Category = "category"),
         options = list(searching = FALSE, scrollX = TRUE, pageLength = 5,scrollY = '500px'), rownames= FALSE, height = 2)
         
      })
      observeEvent(input$job_table, {
      updateTextInput(session, "job_table")
   })
   
   
# Ran Part Done ====================================================================================
   

# Jonson plot begin ========================================================================================
   output$job_salary_box <- renderPlotly({
      ggplotly(figure_salary_box)
   })
   output$job_salary_col <- renderPlotly({
      ggplotly(figure_salary_col)
   })
   output$job_time_count <- renderPlotly({
      ggplotly(figure_time)
   })
   output$job_salary_count <- renderPlotly({
      ggplotly(figure_salary_count)
   })

   
# Johnson  plot end=======================================================================================

# Suzie plot begin ---------------------------------------------------------------------------------------
   output$job_pie <- renderPlotly({
      ggplotly(p)
   })
   
   output$job_donut <- renderPlotly({
       ggplotly(q)
    })
   


# Suzie plot begin --------------------------------------------------------------------------------------- 
   
   
# Stephen plot begin ========================================================================================
   output$avai_title<- renderPlotly({
      ggplotly(available_title)
   })
   output$avai_agen<- renderPlotly({
      ggplotly(available_agency)
   })
   output$salary_title<- renderPlotly({
      ggplotly(salary_title)
   })
   output$salary_agency<- renderPlotly({
      ggplotly(salary_agency)
   })
   # Stephen  plot end=======================================================================================
   
   # Mengying home -------------------------------------------------------------------------------------------------------
   ## boxes
   output$total_title <- renderValueBox({
      na_drop %>%
         n_distinct(title)%>%
         valueBox(subtitle = "Total Types of Job Titles",
                  icon = icon("user-circle"),
                  color = "purple")
   })
   
   output$total_position <- renderValueBox({
      na_drop %>%
         summarise(total_position = sum(num_positions))%>%
         .$total_position %>%
         valueBox(subtitle = "Total # of Positions",
                  icon = icon("building"),
                  color = "orange")
   })
   
   output$max_salary <- renderValueBox({
      na_drop %>%
         summarise(max_salary = max(`Salary Range To`))%>%
         .$max_salary %>%
         scales::dollar() %>% 
         valueBox(subtitle = "Max Annually Salary",
                  icon = icon("hourglass-half"),
                  color = "green")
   })
   
   ## wordcloud
   test <- na_drop %>%
      count(title,sort = T)%>%
      top_n(300)
   
   output$WC1 <- renderWordcloud2({
      test %>%
         wordcloud2(shape = "circle",color='skyblue', backgroundColor = "transparent")
   })
   
   
   # Mengying home end -----------------------------------------------------------------------------------------------------
   
   
   
})
