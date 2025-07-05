server <- function(input, output, session) {
  
  # map
  output$zipmap <- renderLeaflet({
    leaflet(map_sf) |>
      addProviderTiles("CartoDB.Positron") |>
      addPolygons(
        fillColor = ~pal(median_price),
        weight    = 0.4,
        color     = "#444",
        fillOpacity = 0.8,
        label     = labels,
        highlight = highlightOptions(weight = 2, color = "#000",
                                     fillOpacity = 0.9, bringToFront = TRUE)
      ) |>
      addLegend(pal = pal, values = ~median_price,
                title = "Median sale price",
                position = "bottomright",
                labFormat = labelFormat(prefix = "$", big.mark = ","))
  })
  
  # histogram
  output$histPrice <- renderPlot({
    hist(data$price, xlab="Sale price (USD)", col="steelblue", border="white",
         main="Distribution of Prices")
      
  })
  
  # line graph
  output$yearLine <- renderPlot({
    plot(avg_by_year$yr_built, avg_by_year$avg_price,
         type = "l", pch = 19, lwd = 2, col = "steelblue",
         main = "Average Sale Price by Year Built",
         xlab = "Year", ylab = "Average price (USD)")
  })
  
  output$heatViewCond <- renderPlot({
    ggplot(heat_df, aes(view_f, cond_f, fill = avg_price)) +
      geom_tile(color = "white") +

    scale_fill_gradientn(
      colours = c("#c9d9ec", "#97b4d6", "#6b90c0", "#406da9", "#2B5A87"),
      name    = "Avg price",
      labels  = scales::dollar_format()
    ) +
      
      labs(
        x     = "View Rating",
        y     = "Condition Rating",
        title = "Average Sale Price by View & Condition"
      ) +
      theme_minimal() +
      theme(
        plot.title   = element_text(size = 14, face = "bold", hjust = .5),
        axis.title   = element_text(size = 12),
        legend.title = element_text(size = 11),
        legend.position = "right"
      )
  })
  
}