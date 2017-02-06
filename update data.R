
##----------------------------------------------------------------------------------##
## Upload geojson ##
url_json <- function(url) {
  jsonlite::fromJSON(url)
}

url <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson"
data.json <- url_json(url)

#manipulate json data
myData <- function() {
  json.Time <- data.json$features$properties$time
  json.TimeZone <- data.json$features$properties$tz
  Local.Time <- as.POSIXct((json.Time+(json.TimeZone*60000)+0.1)/1000, origin = "1970-01-01", tz = "UTC")
  
  # turn json data into a data frame
  data <- as.data.frame(data.json$features$properties)
  data$Local.Time <- Local.Time
  
  # keep only necessary variables getting the final database
  variables <- c('Local.Time','mag', 'sig', 'place')
  eq_data <- data[,variables]
  
  # drop rows with missing values
  eq_data <- na.omit(eq_data)
  
  place0 <- as.data.frame.list(data.json$features$geometry$coordinates, row.names = c("long", "lat", "dep"))
  place <- as.data.frame(t(place0))
  eq1 <- cbind(eq_data, place[,c("long","lat")])
  
  return(eq1)
}

eq <- myData()

saveRDS(eq, file="eq.Rda")
