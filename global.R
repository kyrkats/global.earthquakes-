library(shiny)
library(ggplot2)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(data.table)
library(jsonlite)
library(DT)
library(plotly)
library(curl)

##----------------------------------------------------------------------------------##
## myData function to read and manipulate json data ##
myData <- function(url) {
  # Upload geojson #
  #jsonlite::fromJSON(url)
  data.json <- jsonlite::fromJSON(url)
  
  # change date format #
  json.Time <- data.json$features$properties$time
  #json.TimeZone <- data.json$features$properties$tz
  Local.Time <- as.POSIXct((json.Time+0.1)/1000, origin = "1970-01-01", tz = "GMT")
  
  # turn json data into a data frame #
  data <- as.data.frame(data.json$features$properties)
  data$Local.Time <- Local.Time
  
  # keep only necessary variables getting the final database #
  variables <- c('Local.Time','mag', 'sig', 'place')
  eq_data <- data[,variables]
  
  # drop rows with missing values
  #eq_data <- na.omit(eq_data)
  
  # put coordinates into the dataframe #
  place0 <- as.data.frame.list(data.json$features$geometry$coordinates, row.names = c("long", "lat", "dep"))
  place <- as.data.frame(t(place0))
  eq1 <- cbind(eq_data, place[,c("long","lat","dep")])
  
  return(eq1)
}

# give url json data...
url <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/1.0_month.geojson"
# make the dataframe with function myData
eq <- myData(url)


country <- function(x){
  x <- deparse(substitute(x))
  eq[grep(x, eq$place),]
}

gr_eq <- country(Greece)

