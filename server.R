
library(shiny)
library(ggplot2)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(data.table)
library(jsonlite)

##----------------------------------------------------------------------------------##
## Upload geojson ##

eq <- readRDS("./eq.Rda")

shinyServer(function(input, output, session) {

## Upload geojson ##
##------------------------------------------------------------------------------------##  
## map with date range ##
  
  ##subset quakes by date range
    myQuakes <- function() {
      startDate <- as.POSIXlt((input$dateRange[1]),"00:00:01")
      endDate <- as.POSIXlt((input$dateRange[2]),"23:59:59")
      quakes <- eq[eq$Local.Time >= startDate &
                            eq$Local.Time <= endDate,]
    return(quakes)
    }
    
    mapQuakes <- function() {
      startDate <- as.POSIXlt((input$dateRange[1]),"00:00:01")
      endDate <- as.POSIXlt((input$dateRange[2]),"23:59:59")
      minMag <- input$range[1]
      maxMag <- input$range[2]
      quakes <- eq[eq$Local.Time >= startDate & eq$Local.Time <= endDate &
                      eq$mag >= minMag & eq$mag <= maxMag,]
      return(quakes)
    }
  
  ##leaflet quake map
    ##create a colour palette
    pal <- colorNumeric(
      palette = "Reds",
      domain = eq$mag
    )
    
    qm <- function() {
      quake.map <- mapQuakes()
      
      ## create html for popup
      pu <- paste("<b>Place:</b>", as.character(quake.map$place), "<br>",
                  "<b>Mag:</b>", as.character(quake.map$mag), "<br>",
                  "<b>Depth:</b>", as.character(quake.map$Dep), "km<br>",
                  "<b>Time:</b>", as.character(quake.map$Local.Time), "NST"
                  #"<br>","<b>ID:</b>", quake.get$id,"<br>",
                  #"<b>Place:</b>", quake.get$place #noticed some pecularities with the place, need to re-check
      )
      
      tempmap <- leaflet(data=quake.map) %>% 
        addProviderTiles("Esri.WorldGrayCanvas") %>% 
        setView(23.90, 38.90, 2) %>% 
        addCircleMarkers(lng = ~long, lat = ~lat,
               popup = pu,
               radius = ~mag^2,
               color = ~pal(mag),
               stroke = FALSE, 
               fillOpacity = 0.8
               #clusterOptions = markerClusterOptions()
    )
 }
    output$map <- renderLeaflet(qm())

## map with date range ##
##------------------------------------------------------------------------------##  
  
##------------------------------------------------------------------------------##  
## Graphs ##

#timeline    
    timeline <- eventReactive(input$updateButton, {
      quake.graphs <- myQuakes()
   
      ggplot(quake.graphs, aes(Local.Time, mag, ymin=4, ymax=mag)) +
        geom_linerange(color='grey') + 
        geom_point(color='blue', size=1) +
        scale_y_continuous(name='Magnitude', limits=c(4,8)) +
        scale_x_datetime(name = 'Date') + 
        theme_bw()  
 }
)
    output$timeline <- renderPlot(timeline())
   
#histogram 
    histogram <- eventReactive(input$updateButton, {
      quake.graphs <- myQuakes()
 
      hist(quake.graphs$mag, 50, col = heat.colors(50), xlab = 'Magnitude', ylab = 'Frequency')
 }
)
 output$magHist <- renderPlot(histogram())
   
#freqTable 
freqTable <- eventReactive(input$updateButton, {
  quake.graphs <- myQuakes()
      summary(quake.graphs)
  }
)
  output$outFrequency <- renderTable(freqTable())
  
## Graphs ##  
##-------------------------------------------------------------------------------##
  
## html quakes counter under maps ##  
  output$countQuake <- renderText(paste("The total number of earthquakes from <b>",
                                        format(input$dateRange[1], "%d %B %Y"),
                                        "</b>to<b>", format(input$dateRange[2], "%d %B %Y"),
                                        "</b>was<b>", nrow(myQuakes()),"</b>.<br>"))

})  

  
