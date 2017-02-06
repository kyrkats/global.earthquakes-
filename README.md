# Exploratory Data Analysis and Visualisaton of Global Earthquakes

Link to the application: https://kyrkats.shinyapps.io/quakes_app/

This shiny application implemented in R is an interactive system used for both visualization and exploratory analysis of earthquake data. Exploratory data analysis is an approach to data analysis for summarizing and visualizing the important characteristics of a data set. Data visualization is useful for more than just exploratory data analysis. It is an excellent way of presenting complex relationships in data to an audience that is not statistically sophisticated. A good picture may say far more than the results of any numeric analysis

The earthquake data are being downloaded online, in real time, from http://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php in geoJson format. Then the application manipulates them in order to take the final dataset that includes only the necessary variables. The names of the variables are Local.Time, magnitude, significance, place, longitude, langitude and depth.

The app provides an interactive map, where the earthquakes are visualised. The user can select the date range and the magnitudes of the earthquakes he/she wants to visualise. Different size and colour circle markers indicate the point of each earthquake on the map.

In addition there are several graphs visualising how earthquake events are spared over time, the frequency of the magnitudes, as well as the corellations between magnitudes and depths of the events.

Finally, the app provides a datatable with all the earthquakes from the downloaded dataset. More information about the variables can be found at http://earthquake.usgs.gov/earthquakes/feed/v1.0/glossary.php#metadata_generated.
