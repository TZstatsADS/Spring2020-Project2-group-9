# server
library(shiny)
library(leaflet)
library(readr)
shinyServer(function(input,output, session){
  load("../data/na_drop.RData")
   category <- reactive(na_drop[which(na_drop$category==input$category),])
   output$map <- renderLeaflet({
     map <- leaflet() %>% addTiles() %>% addCircleMarkers(lng = category()$lon, lat = category()$lat,
                                                          clusterOptions = markerClusterOptions()) %>%
       addProviderTiles(providers$CartoDB.Positron)
   })

})