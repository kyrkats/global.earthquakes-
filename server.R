
(function(input, output, session) {

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
      palette = "Spectral",
      domain = eq$dep
    )
    
    qm <- function() {
      quake.map <- mapQuakes()
      
      ## create html for popup
      pu <- paste("<b>Place:</b>", as.character(quake.map$place), "<br>",
                  "<b>Magnitude:</b>", as.character(quake.map$mag), "<br>",
                  "<b>Depth:</b>", as.character(quake.map$dep), "km<br>",
                  "<b>Date&Time:</b>", format(quake.map$Local.Time, "%a %d %b %Y %X %Z"), "<br>"
                  #"<br>","<b>ID:</b>", quake.get$id,"<br>",
                  #"<b>Place:</b>", quake.get$place #noticed some pecularities with the place, need to re-check
      )
      
      tempmap <- leaflet(data=quake.map) %>% 
        addProviderTiles("CartoDB.Positron") %>% #Esri.WorldGrayCanvas
        setView(23.90,28, 2) %>% 
        addCircleMarkers(lng = ~long, lat = ~lat,
               popup = pu,
               radius = ~mag^3/15,
               color = ~pal(dep),
               stroke = FALSE, 
               fillOpacity = 0.8) %>%
        addLegend(
              "bottomright", pal = pal,
               values = sort(quake.map$dep),
               title = "Depth (km)"
               # labFormat = labelFormat()
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
   
    #  ggplot(quake.graphs, aes(Local.Time, mag, ymin=0.1, ymax=mag)) +
    #    geom_linerange(color='grey') + 
    #    geom_point(color='blue', size=0.6) +
    #    scale_y_continuous(name='Magnitude', limits=c(1,8)) +
    #    scale_x_datetime(name = 'Date') + 
    #    theme_bw()  
    #  ggplotly()
      
      plot_ly(data = eq, x = Local.Time, y = mag, size = mag, mode = "markers",
              color = -dep, colors = "Spectral") %>%
        layout(title = "Time series scatter plot",
               scene = list(
                 xaxis = list(title = "Date"), 
                 yaxis = list(title = "Magnitude")
               ))
        
 }
)
    output$timeline <- renderPlotly(timeline())
   
#histogram 
    histogram <- eventReactive(input$updateButton, {
      quake.graphs <- myQuakes()
      plot_ly(x = quake.graphs$mag, type = "histogram") %>%
        layout(title = "Histogram of the magnitudes frequency",
               scene = list(
                 xaxis = list(title = "Magnitude")
               ))
  }
)
 output$magHist <- renderPlotly(histogram())
   
#freqTable 
freqTable <- eventReactive(input$updateButton, {
  quake.graphs <- myQuakes()
      summary(quake.graphs)
  }
)
  output$outFrequency <- renderTable(freqTable())
  
#scatter plot depth-mag html widget 'plotly'
scatter_m <- eventReactive(input$updateButton, {
  quake.graphs <- myQuakes()
  plot_ly(quake.graphs, x = mag, y = dep, text = paste("Place: ", place),
          mode = "markers", color = sig, size = mag) %>%
    layout(title = "Magnitude vs Depth Scatter plot",
           scene = list(
             xaxis = list(title = "Magnitude"), 
             yaxis = list(title = "Depth")
           ))
}
)
  output$outScatter_m <- renderPlotly(scatter_m())
  
#scatter plot time-depth html widget 'plotly'  
  scatter_d <- eventReactive(input$updateButton, {
    quake.graphs <- myQuakes()
    plot_ly(data = quake.graphs, x = Local.Time, y = -dep, size = mag, mode = "markers",
            color = mag, colors = "Reds") %>%
      layout(title = "Depth scatter plot over time",
             scene = list(
               xaxis = list(title = "Date"), 
               yaxis = list(title = "Depth")
             ))
  }
  )
  output$outScatter_d <- renderPlotly(scatter_d())
  
  
  
## Graphs ##  
##-------------------------------------------------------------------------------##
  
## html quakes counter under maps ##  
  output$countQuake <- renderText(paste("The total number of earthquakes from <b>",
                                        format(input$dateRange[1], "%d %B %Y"),
                                        "</b>to<b>", format(input$dateRange[2], "%d %B %Y"),
                                        "</b>was<b>", nrow(myQuakes()),"</b>.<br>"))

  dt <- function(){
    eq$Local.Time <- format(eq$Local.Time, "%a %d %b %Y %X %Z")
    colnames(eq) = head(c('Date and Time',
                          'Magnitude', 
                          'Significance', 
                          'Epicentre',
                         # 'Tsunami',
                          'Longitude',
                          'Latitude',
                          'Depth'
                          ), ncol(eq))
    datatable(eq) #%>% formatDate('Date and Time', "toString")
     
  }
  output$eqtable <- DT::renderDataTable(dt()) #%>% formatDate('Date and Time', "toString"))
})  

  
