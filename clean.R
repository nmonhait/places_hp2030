library(RSocrata)
library(tidyverse)
library(tigris)
library(sf)

#sensitive info to encrypt when deployed
token <- "HjmpNFriNeZLinjGja4YYp9UQ"
places_df <- read.socrata("https://chronicdata.cdc.gov/resource/cwsq-ngmh.csv", app_token = token)

#LHI full dataset
lhi_df <- places_df %>% 
    filter(stateabbr == "CO") %>% 
    filter(measureid %in% c("DIABETES", "CSMOKING", "BPHIGH",
                          "COLON_SCREEN", "PHLTH", "BINGE")) %>% 
    select(geolocation, data_value, year, stateabbr, data_value_type,
           countyname, countyfips, category, measure,
           short_question_text) 

rm(places_df)

#separate lat/lon col for mapping
lhi_df_geo <- lhi_df %>% 
    separate(geolocation, into = c("delete", "lon", "lat"),
             sep = " ") 

lhi_df_geo <- lhi_df_geo %>% 
    mutate(lon = str_sub(lhi_df_geo$lon, 2),
           lon = as.numeric(lon),
           lat = str_sub(lhi_df_geo$lat, 1, -2),
           lat = as.numeric(lat)) %>% 
    select(- delete) %>% 
    rename(NAME = countyname)

#tigris colorado counties
co_counties <- counties(state = "CO", cb = TRUE) %>% 
    select(NAME, geometry)

#join
lhi_df_poly <- left_join(co_counties, lhi_df_geo, by = "NAME")

test <- lhi_df_poly %>% 
    select(-lat, -lon)


