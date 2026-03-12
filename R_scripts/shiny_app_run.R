library(tidyverse)
library(janitor)
library(naniar)
library(shiny)
library(leaflet)
library(dplyr)
library(raster)
library(shinythemes)
library(akima)
library(viridis)
library(ggmap)
library(maps)


atlantic_argos <- read_csv("../input_files/AtlanticArgos.csv")

pacific_argos <- read_csv("../input_files/PacificArgos.csv")

pacific_tad <- read_csv("../input_files/Pacific_TAD.csv") %>% 
  clean_names()



# --- Raster heatmaps ---
do_interp <- with(pacific_tad,
                  interp(x = lon, y = lat, z = do_depth, duplicate = "mean")
)

do_df <- expand.grid(
  lon = do_interp$x,
  lat = do_interp$y
)

do_df$DO_depth <- as.vector(do_interp$z)

do_raster  <- rasterFromXYZ(do_df[,c("lon","lat","DO_depth")])

sst_interp <- with(pacific_tad,
                   interp(x = lon, y = lat, z = sst, duplicate = "mean")
)

sst_df <- expand.grid(
  lon = sst_interp$x,
  lat = sst_interp$y
)

sst_df$SST <- as.vector(sst_interp$z)

sst_raster <- rasterFromXYZ(sst_df[,c("lon","lat","SST")])

crs(do_raster)  <- "+proj=longlat +datum=WGS84"
crs(sst_raster) <- "+proj=longlat +datum=WGS84"

pal_do <- colorNumeric(
  "viridis",
  values(do_raster),
  na.color = "transparent"
)

pal_sst <- colorNumeric(
  "magma",
  values(sst_raster),
  na.color = "transparent"
)

# --- UI ---
ui <- fluidPage(
  
  theme = shinytheme("cerulean"),
  
  titlePanel("Pacific Mako Shark Habitat Explorer"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        "shark_id",
        "Select Shark ID",
        choices = unique(pacific_tad$id)
      ),
      
      checkboxInput(
        "show_points",
        "Show Points",
        TRUE
      ),
      
      selectInput(
        "heatmap",
        "Heatmap Layer",
        choices = c(
          "None",
          "Hypoxic Boundary Depth",
          "Sea Surface Temperature"
        )
      )
      
    ),
    
    mainPanel(
      leafletOutput("shark_map", height = 700)
    )
    
  )
)

# --- Server ---
server <- function(input, output) {
  
  filtered_data <- reactive({
    pacific_tad %>%
      filter(id == input$shark_id)
  })
  
  # Base map
  output$shark_map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -135, lat = 30, zoom = 4)
  })
  
  # Update map when inputs change
  observe({
    
    data <- filtered_data()
    
    proxy <- leafletProxy("shark_map")
    
    proxy %>%
      clearMarkers() %>%
      clearShapes() %>%
      clearImages() %>%
      clearControls()
    
    # ---- Heatmap toggle ----
    if(input$heatmap == "Hypoxic Boundary Depth"){
      
      proxy %>%
        addRasterImage(
          do_raster,
          colors = pal_do,
          opacity = 0.7
        ) %>%
        addLegend(
          pal = pal_do,
          values = values(do_raster),
          title = "Hypoxic Boundary Depth (m)"
        )
      
    }
    
    if(input$heatmap == "Sea Surface Temperature"){
      
      proxy %>%
        addRasterImage(
          sst_raster,
          colors = pal_sst,
          opacity = 0.7
        ) %>%
        addLegend(
          pal = pal_sst,
          values = values(sst_raster),
          title = "Sea Surface Temp (°C)"
        )
      
    }
    
    # ---- Shark track ----
    proxy %>%
      addPolylines(
        data = data,
        lng = ~lon,
        lat = ~lat,
        color = "black",
        weight = 3
      )
    
    # ---- Shark points ----
    proxy %>%
      addCircleMarkers(
        data = data,
        lng = ~lon,
        lat = ~lat,
        radius = 4,
        color = "tan",
        popup = ~paste0(
          "<b>Date:</b> ", date,
          "<br><b>Depth:</b> ", round(do_depth,1), " m",
          "<br><b>SST:</b> ", round(sst,2)
        ),
        opacity = ifelse(input$show_points, 1, 0)
      )
    
  })
  
}

shinyApp(ui, server)

