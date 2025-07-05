library(shiny)
library(readxl)
library(dplyr)
library(tigris)
library(sf)
library(leaflet)
library(scales)
library(bslib)
library(ggplot2)
library(viridis)
library(stringr)

options(tigris_use_cache = TRUE, tigris_class = "sf")

data <- read_excel("housedata.xlsx")

# view vs condition heatmap
heat_df <- data %>%
  mutate(
    view      = str_to_title(str_trim(view)),
    condition = str_to_title(str_trim(condition)),
    
    
    condition = str_replace_all(condition, "-\\s+", "-"),
    
    
    condition = recode(condition,
                       "Poor-Worn Out"   = "Poor",
                       "Fair-Badly Worn" = "Fair"),
    
    
    condition = ifelse(condition %in% c("Poor", "Fair", "Average", "Good", "Very Good"),
                       condition, NA_character_),
    
    
    view_f = factor(view,
                    levels = c("No View", "Fair", "Average", "Good", "Excellent")),
    cond_f = factor(condition,
                    levels = c("Poor", "Fair", "Average", "Good", "Very Good"))
  ) %>%
  group_by(view_f, cond_f) %>%
  summarise(avg_price = mean(price, na.rm = TRUE), .groups = "drop")


# average price by year 
avg_by_year <- data |>
  group_by(yr_built) |>
  summarise(avg_price = mean(price, na.rm = TRUE), .groups = "drop")

# median house price 
med <- data |>
  mutate(zipcode = sprintf("%05d", zipcode)) |>
  group_by(zipcode) |>
  summarise(median_price = median(price, na.rm = TRUE), .groups = "drop")

target_zips <- unique(med$zipcode)
prefixes    <- unique(substr(target_zips, 1, 3))

map_sf <- zctas(starts_with = prefixes, year = 2020) |>
  st_transform(4326) |>
  filter(ZCTA5CE20 %in% target_zips) |>
  left_join(sales, by = c("ZCTA5CE20" = "zipcode"))

pal <- colorNumeric("YlGnBu", domain = map_sf$median_price, na.color = "#cccccc")

labels <- sprintf(
  "<strong>%s</strong><br/>Median: %s",
  map_sf$ZCTA5CE20,
  dollar(map_sf$median_price, accuracy = 1)
) |> lapply(htmltools::HTML)