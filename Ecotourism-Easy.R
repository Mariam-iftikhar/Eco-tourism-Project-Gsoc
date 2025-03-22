# Install required packages if not already installed
install.packages("sf", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)
install.packages("galah", dependencies = TRUE)
install.packages("rnaturalearth", dependencies = TRUE)
install.packages("ggspatial", dependencies = TRUE)

# Load libraries
library(galah)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(ggspatial)

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

# Plotting the graph
ggplot() +
  borders("world", regions = "Australia", fill = "lightgray", colour = "black", size = 0.6) +  
  geom_sf(data = platypus_sf, aes(geometry = geometry), 
          color = "darkgreen", alpha = 0.6, shape = 21) +  
  labs(
    title = "Platypus Sightings in Australia (2024)",
    subtitle = "Data sourced from Atlas of Living Australia",
    caption = "Visualization by Mariam"
  ) +
  theme_minimal(base_size = 14) +  # Larger base font for better readability
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    plot.subtitle = element_text(hjust = 0.5, size = 12, color = "blue"),
    plot.caption = element_text(size = 10, hjust = 1, color = "black"),
    panel.grid = element_blank()  # Remove unnecessary grid lines
  ) 