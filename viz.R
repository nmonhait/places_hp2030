library(leaflet)

pal <- colorNumeric(palette = "YlOrRd", domain = lhi_df_poly_test$data_value)

lhi_df_poly_test <- lhi_df_poly %>% 
    filter(year == 2018 & short_question_text == "Binge Drinking") %>% 
    select(geometry, short_question_text, measure, NAME, data_value) %>% 
    mutate(data_value = as.numeric(data_value))


leaflet(data = lhi_df_poly_test) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>% 
    addPolygons(color = "white", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.3, dashArray = "3",
                fillColor = ~pal(data_value),
                highlightOptions = highlightOptions(color = "#666",
                                                    dashArray = "",
                                                    weight = 5,
                                                    bringToFront = TRUE),
                label = ~paste0(NAME, " ", "County", ": ",
                                "Crude Prevalence = ", data_value)) %>% 
    addLegend(pal = pal, values = ~data_value, opacity = 0.7, title = "Crude Prevalance",
              position = "bottomright")


    
