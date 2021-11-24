library(pins)
library(tidyverse)
library(readxl)
library(leaflet)
library(tigris)

poverty_income <- read_excel("est18all.xls",
                             skip = 3, col_names = TRUE)

poverty_income <- poverty_income %>% 
    filter(`Postal Code` == "CO") %>% 
    select(`State FIPS Code`, `County FIPS Code`, Name, `Poverty Estimate, All Ages`,
           `Poverty Percent, All Ages`, `Median Household Income`) %>% 
    rename(state_fips = `State FIPS Code`,
           county_fips = `County FIPS Code`,
           NAME = Name,
           poverty_estimate = `Poverty Estimate, All Ages`,
           poverty_percent = `Poverty Percent, All Ages`,
           median_income = `Median Household Income`) %>% 
    mutate(poverty_estimate = as.numeric(poverty_estimate),
           poverty_percent = as.numeric(poverty_percent),
           median_income = as.numeric(median_income)) 

poverty_income <- poverty_income %>% 
    mutate(NAME = str_remove_all(NAME, "County")) %>% 
    rename(COUNTYFP = county_fips)

board <- board_local()
lhi_df_co <- pin_read('lhi_df_co', board = board)

#tigris colorado counties
co_counties <- counties(state = "CO", cb = TRUE) %>% 
    select(NAME, geometry, COUNTYFP) 

#left join to keep sf class
income_poverty_poly <- left_join(co_counties, poverty_income, by = "COUNTYFP")

#leaflet----

pal_2 <- colorNumeric(palette = "YlOrRd", domain = income_poverty_poly$poverty_percent)

leaflet(data = income_poverty_poly) %>% 
    addPolygons(color = "white", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.3, dashArray = "3",
                fillColor = ~pal_2(poverty_percent),
                highlightOptions = highlightOptions(color = "#666",
                                                    dashArray = "",
                                                    weight = 5,
                                                    bringToFront = TRUE),
                label = ~paste0(NAME.y, " ", "County", ": ",
                                "Poverty Percent = ", poverty_percent)) %>% 
    addLegend(pal = pal_2, values = ~poverty_percent, opacity = 0.7, title = "Poverty Percent",
              position = "bottomright")
    
    
    
    
