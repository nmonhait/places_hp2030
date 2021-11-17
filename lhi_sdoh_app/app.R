library(shiny)
library(leaflet)

ui <- fluidPage(

    titlePanel("Social Determinants of Health Indicators in Colorado"),
    
    
    sidebarLayout(
        sidebarPanel(
            selectInput("sdoh", "Indicator", choices = c("Binge Drinking",
                                                       "Colorectal Cancer Screening",
                                                       "Current Smoking",
                                                       "Diabetes",
                                                       "Physical Health")
        ),
        radioButtons("measure_year", "Year", choices = c("2017" = "2017",
                                                            "2018" = "2018"))
    ),
    mainPanel(
        leafletOutput("comap")
)))

server <- function(input, output, session) {
    
    sdoh_values <- reactive({
        lhi_df_poly %>% 
        filter(short_question_text == input$sdoh & year == input$measure_year) %>% 
            select(geometry, short_question_text, measure, NAME, data_value) %>% 
            mutate(data_value = as.numeric(data_value))
        
        })

    
    output$comap <- renderLeaflet({
        
        pal <- colorNumeric(palette = "YlOrRd", domain = sdoh_values()$data_value)
        
            leaflet(sdoh_values()) %>% 
            addProviderTiles(providers$CartoDB.Positron) %>% 
            addPolygons(
                        color = "white", weight = 1, smoothFactor = 0.5,
                        opacity = 1.0, fillOpacity = 0.3, dashArray = "3",
                        fillColor = ~pal(data_value),
                        highlightOptions = highlightOptions(color = "#666",
                                                            dashArray = "",
                                                            weight = 5,
                                                            bringToFront = TRUE),
                        label = ~paste0(NAME, " ", "County", ": ",
                                        "Crude Prevalence = ", data_value)) %>% 
            addLegend(pal = pal, values = ~data_value, opacity = 0.7, title = "Crude Prevalance",,
                      position = "bottomright")
    })
}

shinyApp(ui, server)