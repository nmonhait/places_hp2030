library(RSocrata)
library(tidyverse)
library(tigris)
library(sf)

#sensitive info to encrypt when deployed
token <- "HjmpNFriNeZLinjGja4YYp9UQ"
places_df <- read.socrata("https://chronicdata.cdc.gov/resource/cwsq-ngmh.csv", app_token = token)

#LHI full dataset
lhi_df <- places_df %>% 
  #  filter(stateabbr == "CO") %>% 
    filter(measureid %in% c("DIABETES", "CSMOKING", "BPHIGH",
                          "COLON_SCREEN", "PHLTH", "BINGE")) %>% 
    select(stateabbr, data_value_type,
           countyname, category, measure,
           short_question_text, year, data_value) %>% 
    rename(NAME = countyname)

rm(places_df)

#tigris colorado counties
co_counties <- counties(state = "CO", cb = TRUE) %>% 
    select(NAME, geometry)

#left join to keep sf class
lhi_df_poly <- left_join(co_counties, lhi_df, by = "NAME")



