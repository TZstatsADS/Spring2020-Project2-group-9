# server
packages.used <- c("shiny","leaflet")
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
shinyServer(function(input,output, session){
   load("../data/na_drop.RData")
   na_drop$`Posting Date` <- as.Date(na_drop$`Posting Date`, "%m/%d/%Y")
   
   category <- reactive(na_drop[which(na_drop$category %in% input$category & na_drop$`Full/Part` %in% input$`Full/Part`&
                                      na_drop$`Career Level` %in% input$`Career Level` & na_drop$borough %in% input$borough &
                                      na_drop$`Posting Date` >= input$`Posting Date` & na_drop$`Salary Range To` >= input$`Salary Range To`),])

   output$map <- renderLeaflet({
     map <- leaflet() %>% setView(-73.9578,40.72348,zoom = 11) %>% addTiles() %>% addCircleMarkers(lng = category()$lon, lat = category()$lat, 
                                                          clusterOptions = markerClusterOptions()) %>%
       addProviderTiles(providers$CartoDB.Positron)
     
     
   })

})