install.packages(c("dygraphs","plotly","metricsgraphics","highcharter"))
devtools::install_github("hrbrmstr/metricsgraphics")

library(dygraphs)
dygraph(eq, main = "New Haven Temperatures") %>% 
  dyRangeSelector(dateWindow = c("1990-01-01", "2016-04-27"))

library(metricsgraphics)
eq %>%
  mjs_plot(x=Local.Time, y=mag) %>%
  mjs_line()


library(plotly)
plot_ly(eq, x = mag, y = dep, text = paste("Place: ", place),
        mode = "markers", color = dep, size = mag)

plot_ly(data = eq, x = Local.Time, y = mag, size = mag, mode = "markers",
        color = -dep, colors = "Spectral")
  
  
plot_ly(data = eq, x = Local.Time, y = -dep, size = mag, mode = "markers",
          color = mag, colors = "Reds")

plot_ly(eq, x = eq$long, y = eq$lat, z = eq$dep, type = "scatter3d", mode="markers")


ggplot(eq, aes(Local.Time, mag)) +
  geom_linerange(color='grey', ymin=1, ymax=eq$mag) + 
  geom_point(color='blue', size=1) +
  scale_y_continuous(name='Magnitude', limits=c(1,8)) +
  scale_x_datetime(name = 'Date') +
  theme_bw()
ggplotly()
