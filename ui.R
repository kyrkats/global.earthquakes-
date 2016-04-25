
library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(ggplot2)

#shinyUI(

    
header <- dashboardHeader(
      title="Earthquakes"
    )
    
sidebar <- dashboardSidebar(width = 272,
  sidebarMenu(
    menuItem("Map", tabName="map", icon = icon("map-o")),
    menuItem(dateRangeInput("dateRange", "Select Date Range", width = "110%",                            min = "2016-01-01", 
                            max = Sys.Date(), 
                            start = "2016-01-01", 
                            end = Sys.Date(),
                            format = "dd M yyyy"
                            )  #ftiaxnei ti mpara me tis imerominies
            # actionButton("updateButton", "Update Graphs")
    ),
    menuItem("Graphs", tabName="graphs", icon = icon("bar-chart")
             ),
    actionButton("updateButton", "Update Graphs", width = "100%", style = "opacity: 0.7"),
    menuItem("Databases", tabName="data", icon = icon("database")),
    menuItem("About", tabName="about", icon = icon("info"))
  )
)
    
body <- dashboardBody(
  #tags$head(),
  
  tabItems(
    tabItem(tabName="map",
            #tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
            #htmlOutput("countQuake", inline = FALSE),
            leafletOutput("map", width="100%", height=830),
            htmlOutput("countQuake", inline = FALSE),
            absolutePanel(style = "opacity: 1", fixed = TRUE,
                          draggable = TRUE, 
                          top = 80, left = "auto", right = 10, bottom = "auto",
                          width = 330, height = "auto",
                          
                          sliderInput("range", "Magnitudes", min(eq$mag), max(eq$mag),
                                       value = range(eq$mag), step = 0.1
                          )
                  )
              
          ),
    tabItem(tabName="graphs",
            column(width=12,
                   box(title='Quake timeline', solidHeader=TRUE,
                       background = "red",
                       width = NULL,
                       collapsible = TRUE,
                       plotOutput("timeline", height=300)
                       # actionButton("refreshButton", "Draw timeline")
                   )
                   
            ),
            column(width=8,
                   box(title="Histogram",
                       background = "red",
                       solidHeader = TRUE,
                       width=NULL,
                       # status = "success",
                       collapsible=TRUE,
                       plotOutput("magHist", height = 300)
                       # actionButton("histButton", "Draw histogram")
                   )),
            column(width=4, #3
                   box(title="Frequency table",
                       background = "red",
                       # status="success",
                       solidHeader = TRUE,
                       width=NULL,
                       collapsible=TRUE,
                       tableOutput("outFrequency")
                   ))
    ),
    tabItem(tabName="data",
            fluidRow(
              datatable(eq, colnames = c('Magnitude'='mag', 
                               'Significance'='sig', 
                               'Epicentre'='place')) %>% 
                      formatDate('Local.Time', "toUTCString")
            ))
))
   
dashboardPage(skin='red',
header,
sidebar,
body
)

  