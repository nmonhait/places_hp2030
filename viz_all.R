lhi_df_all <- places_df %>% 
    #  filter(stateabbr == "CO") %>% 
    filter(measureid %in% c("DIABETES", "CSMOKING", "BPHIGH",
                            "COLON_SCREEN", "PHLTH", "BINGE")) %>% 
    select(stateabbr, data_value_type,
           countyname, category, measure,
           short_question_text, year, data_value) %>% 
    rename(NAME = countyname)

rm(places_df)

#all counties in US
counties_all <- counties(cb = TRUE) %>% 
    select(NAME, geometry)

#left join to keep sf class
lhi_df_poly_all <- left_join(counties_all, lhi_df_all, by = "NAME") 

state.name
