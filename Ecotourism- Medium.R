# Install required packages if not already installed
install.packages("sf", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)
install.packages("galah", dependencies = TRUE)
install.packages("rnaturalearth", dependencies = TRUE)
install.packages("ggspatial", dependencies = TRUE)
install.packages("readr", dependencies = TRUE) 
install.packages("GSODR", dependencies = TRUE)
install.packages("geosphere", dependencies = TRUE)
install.packages("ozmaps",dependencies = TRUE)


# Load libraries
library(galah)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(ggspatial)
library(GSODR)
library(dplyr)
library(ozmaps)
library(geosphere)
library(stringr)
library(readr)
load(system.file("extdata", "isd_history.rda", package = "GSODR"))

#------------------------ Code used from Easy Part -------------------------------------

# Set up Galah configuration with your email
galah_config(email = "mariamiftikhar127@gmail.com")  

# Search for Platypus occurrences
platypus_taxon <- search_taxa("Ornithorhynchus anatinus")  # Platypus scientific name


# Applying filter for 2024
platypus_data <- galah_call() |>
  galah_identify(platypus_taxon) |>
  galah_filter(year == 2024) |>
  galah_select("decimalLatitude", "decimalLongitude") |>
  atlas_occurrences()


platypus_sf <- platypus_data %>%
  filter(!is.na(decimalLatitude) & !is.na(decimalLongitude)) %>%
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)

-------------------------------------------------------------------------------------------

# Convert weather station data into spatial format for Australia
stations_sf <- isd_history |>
  filter(COUNTRY_NAME == "AUSTRALIA") |>
  sf::st_as_sf(coords = c("LON", "LAT"), crs = 4326)

# Victoria's  boundary 

victoria_sf <- ozmaps::ozmap_states |>
  filter(str_detect(NAME, "Victoria")) |>
  sf::st_transform(crs = 4326)

victoria_stations_data <- sf::st_intersection(stations_sf, victoria_sf)

distance_matrix <- geosphere::distm(
  st_coordinates(platypus_sf), 
  st_coordinates(victoria_stations_data), 
)

# Nearest station 
nearest_station <- apply(distance_matrix, 1, which.min)

platypus_stations <- platypus_sf |>
  mutate(
    station_id = victoria_stations_data$STNID[nearest_station],
    station_name = victoria_stations_data$NAME[nearest_station]
  )

# Stations with the most Platypus occurrences
Stations <- platypus_stations |>
  group_by(station_id, station_name) |>
  summarise(n = n(), .groups = "drop") |>
  arrange(desc(n))  |> 
  slice_head(n = 5)

# Finding data for 2024
weather_data <- GSODR::get_GSOD(years = 2024, station = Stations$station_id)

# Exporting data in csv
write.csv(weather_data,"weatherdata.csv")


