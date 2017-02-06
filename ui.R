
#shinyUI(

    
header <- dashboardHeader(
      title="Earthquakes"
    )
    
sidebar <- dashboardSidebar(width = 272,
  sidebarMenu(
    menuItem("Map", tabName="map", icon = icon("map-o")),
    menuItem(dateRangeInput("dateRange", "Select Date Range", 
                            width = "110%",                            
                            min = "2016-01-01", 
                            max = Sys.Date(), 
                            start = min(eq$Local.Time), 
                            end = Sys.Date()+1,
                            format = "dd M yyyy"
                            )  #ftiaxnei ti mpara me tis imerominies
            # actionButton("updateButton", "Update Graphs")
    ),
    menuItem("Graphs", tabName="graphs", icon = icon("bar-chart")
             ),
   # actionButton("updateButton", "Update Graphs", width = "100%", style = "opacity: 0.7"),
    menuItem("Database", tabName="data", icon = icon("database")),
    menuItem("About", tabName="about", icon = icon("info"))
  )
)
    
body <- dashboardBody(
  tabItems(
    tabItem(tabName="map",
            tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
            #htmlOutput("countQuake", inline = FALSE),
            leafletOutput("map", width="100%", height=850),
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
            fluidRow(
            actionButton("updateButton", "Update Graphs", width = "100%", style = "opacity: 0.7"),
            column(width=12,
                   box(title='Quake timeline', 
                      solidHeader=TRUE,
                      # background = "red",
                      # status = "success",
                       width = NULL,
                       collapsible = TRUE,
                       plotlyOutput("timeline", height=400)
                       # actionButton("refreshButton", "Draw timeline")
                   )
                   
            ),
            column(width=12,
                    box(title="Histogram",
                       #background = "red",
                       #solidHeader = TRUE,
                       width=NULL,
                      #  status = "success",
                       collapsible=TRUE,
                       #plotOutput("magHist", height = 400),
                       # actionButton("histButton", "Draw histogram")
                       plotly::plotlyOutput("magHist", width="100%", height=400)
                   )),
            column(width=6, 
                   box(title="Magnitude vs Depth",
                       # background = "red",
                        #solidHeader = TRUE,
                        width=NULL,
                       # status = "success",
                        collapsible=TRUE,
                        plotly::plotlyOutput("outScatter_m", width="100%", height=400) 
            )),
            column(width=6, 
                   box(title="Time vs Depth",
                       # background = "red",
                       # solidHeader = TRUE,
                        width=NULL,
                        #status = "success",
                        collapsible=TRUE,
                        plotly::plotlyOutput("outScatter_d", width="100%", height=400) 
                   ))#,
           # column(width=6,
            #       box(title="Frequency table",
                      # background = "red",
                      # status="success",
                      # solidHeader = TRUE,
             #          width=NULL,
              #         collapsible=TRUE,
               #        tableOutput("outFrequency")
                #   ))
            
    )),
    tabItem(tabName="data",
            DT::dataTableOutput('eqtable')
            ),
    tabItem(tabName="about",
            includeHTML("about.Rhtml")
            )
    
  
))
   
dashboardPage(skin='red',
header,
sidebar,
body
)

  
