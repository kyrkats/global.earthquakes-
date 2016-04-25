library(jsonlite)
library(data.table)
library(DT)
library(dplyr)

## get online geojson data irectly from usgs.gov ##
##---------------------------------------##
month_usgs.json <- fromJSON("http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson")

#manipulate time
json.Time <- month_usgs.json$features$properties$time
json.TimeZone <- month_usgs.json$features$properties$tz
Local.Time <- as.POSIXct((json.Time+(json.TimeZone*60000)+0.1)/1000, origin = "1970-01-01", tz = "UTC")

# turn json data into a data frame
month_usgs.data <- as.data.frame(month_usgs.json$features$properties)
month_usgs.data$Local.Time <- Local.Time

# keep only necessary variables getting the final database
variables <- c('Local.Time','mag', 'sig', 'place')
eq_data <- month_usgs.data[,variables]

# drop rows with missing values
eq_data <- na.omit(eq_data)

place0 <- as.data.frame.list(month_usgs.json$features$geometry$coordinates, row.names = c("long", "lat", "dep"))
place <- as.data.frame(t(place0))
eq <- cbind(eq_data, place[,c("long","lat")])

#### trying to get place as a new variable
#mag_place <- strsplit(eq_data$place, ',')
#countries <- as.data.frame.list(mag_place, row.names = c("city","country"))

#countries <- as.data.frame(t(countries))
#country <- countries$country



