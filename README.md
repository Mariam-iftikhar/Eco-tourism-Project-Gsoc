# Eco-tourism-Project-Gsoc-2025

This repository is the starting point for the Ecotourism Data Package project, which will be expanded as part of the GSoC 2025 initiative. The goal of this project is to develop a detailed data package that connects tourism records with sightings of endangered wildlife.

## 🔍 Easy Project Description: Mapping Platypus Sightings in Australia (2024):

### 💡Objective:
This project aims to gather occurrence data for the Platypus (Ornithorhynchus anatinus) from the Atlas of Living Australia (ALA) and create a visual map showcasing where these fascinating creatures were spotted in 2024.

### 🛠️ Approach & Steps Taken:

➡️ Installed & Loaded Required Packages:
   
- Set up and loaded essential packages like galah, ggplot2, sf, rnaturalearth, and ggspatial to help with data retrieval, spatial processing, and mapping.

➡️ Configured ALA API Access:
   
- Configured API access using galah_config() to connect with the Atlas of Living Australia (ALA).

➡️ Retrieved Platypus Occurrence Data:
   
- Identified the platypus taxon by using search_taxa("Ornithorhynchus anatinus").
- Queried the ALA database with galah_call() to filter for sightings from 2024.
- Focused on selecting only the relevant latitude and longitude columns for mapping.

➡️ Converted Data into a Spatial Format:
   
- Transformed the filtered dataset into a spatial feature (sf object) using st_as_sf().

➡️ Plotted the Data on a Map:
   
- Created a base map of Australia using ggplot2.
- Marked the platypus sightings as green points with geom_sf().
- Enhanced the visualization with a minimalistic theme (theme_minimal()).

### 🎯 Outcome:
The final map beautifully illustrates the spatial distribution of platypus sightings across Australia for 2024, offering valuable insights into their habitat locations.

## 🔍 Medium Project Description: Identifying Weather Patterns Near Platypus Sightings in Victoria, Australia:

### 💡 Objective:
This project aims to utilize GSODR to download a year’s worth of daily weather data, focusing on temperature and precipitation, from a weather station in Victoria, Australia, particularly in areas where Platypus (Ornithorhynchus anatinus) sightings are frequent.

### 🛠️ Approach & Steps Taken:

➡️ Loaded Required Libraries & Data:
   
- Started off by installing and loading the GSODR, geosphere, and other packages, which are essential for pulling weather data and performing spatial calculations.

➡️ Filtered for Victoria, Australia Stations:
   
- Sifted through the isd_history dataset to extract weather stations located in Australia. Using ozmaps::ozmap_states, the location is narrowed down to those specifically in Victoria. After that, it converted the station coordinates into a spatial format (sf) and performed an intersection to ensure we only kept the stations within Victoria.

➡️ Identified Nearest Stations to Platypus Sightings:
   
- To find the closest weather stations to the platypus sightings, the distance matrix with geosphere::distm() is calculated while using the code from part 1. We then used apply() to pinpoint the nearest station for each sighting.

➡️ Determined Stations with Most Platypus Occurrences:
   
- Assigned the nearest station ID and name to each platypus sighting, grouped by station ID, and counted how many sightings occurred at each station. From there, we selected the top stations with the highest number of platypus sightings.

➡️ Fetched Weather Data for the Top Stations:
    
- Retrieved daily weather data for 2024 using GSODR::get_GSOD(), including temperature and precipitation, etc., for our stations.

➡️ Saved Weather Data to CSV:
    
- Finally, exported the weather dataset to a CSV file using write_csv() and stored it in the project's "Exported data" directory.

### 🎯 Outcome:
The dataset we created offers valuable insights into weather conditions near the locations where platypuses are often seen, aiding researchers in understanding the environmental factors that may influence their habitat.
