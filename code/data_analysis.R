# ================================================================================#
# Title: Final Project: Data Analysis
# Author: Jennifer Vu 23453383
# Data: Basin IBTrACS Dataset
# Description: Hurdat Format
# ================================================================================#

# Load packages
library(readr)
library(stringr)

# Read the data
storm <- read.csv('../data/storm.csv', stringsAsFactors = FALSE)
tracks <- read.csv('../data/tracks.csv', stringsAsFactors = FALSE)

# ================================================================================#
# Setting Up for the Data Analysis
# ================================================================================#

# To make the analysis a little easier, let's extract certain values from 
# our clean data

# Add a 'month' and 'year' column to storm 
storm$year <- as.numeric(unlist(str_extract_all(storm$date, '\\d{4}')))
storm$month <- as.numeric(unlist(substr(storm$date, start = 1, stop = 2)))

# Extract the years 1980-2010 for the IDs, the years, and the months
storm_ids <- unique(storm$id[storm$year %in% 1980:2010])
stormsperyear <- storm$year[storm$year %in% 1980:2010]
stormspermonth <- storm$month[storm$year %in% 1980:2010]

# Next let's create a variable that gives the ids of the max winds of each 
# storm from 1980-2010
max_winds <- sapply(storm_ids, function(x) max(tracks$wind[x == tracks$id]))

# Create a data frame with the storm id, wind, year, and month
storm <- data.frame('id' = storm_ids,
                    'wind' = max_winds,
                    'year' = stormsperyear,
                    'month' = stormspermonth)


# ================================================================================#
# Data Analysis: Wind Speed of Storms By Year
# ================================================================================#

# Frequency and barplot of storms per year
table(stormsperyear)
barplot(table(stormsperyear), main = "Barplot of Storms Per Year", xlab = "Year", ylab = "Number of Storms", col = '#7AC5CD')


# Frequency and barplot of storms per year with winds >= 35 knots
winds_35_yr <- tapply(storm$id[storm$wind >= 35], storm$year[storm$wind >= 35], length)
winds_35_yr
barplot(winds_35_yr, 
        main = "Barplot of Storms Per Year with Winds >= 35 Knots", 
        cex.main = 1, 
        xlab = "Year", 
        ylab = "Number of Storms",
        col = rgb(0, 0.55, 0.55))

# Number of storms per year with winds >= 64 knots
winds_64_yr <- tapply(storm$id[storm$wind >= 64], storm$year[storm$wind >= 64], length)
winds_64_yr
barplot(winds_64_yr, 
        main = "Barplot of Storms Per Year with Winds >= 64 Knots", 
        cex.main = 1,  
        xlab = "Year", 
        ylab = "Number of Storms",
        col = rgb(0.6, 0.96, 1))


# Number of storms per year with winds >= 96 knots
winds_96_yr <- tapply(storm$id[storm$wind >= 96], storm$year[storm$wind >= 96], length)
winds_96_yr
barplot(winds_96_yr,
        main = "Barplot of Storms Per Year with Winds >= 96 Knots", 
        cex.main = 1,  
        xlab = "Year", 
        ylab = "Number of Storms",
        col = '#6495ED')


# ================================================================================#
# Data Analysis: Wind Speed of Storms By Month
# ================================================================================#

# Number of storms per month
table(stormspermonth)
barplot(table(stormspermonth), 
        main = "Barplot of Storms Per Month", 
        cex.main = 1,  
        xlab = "Month", 
        ylab = "Number of Storms",
        col = '#7AC5CD')


# Number of storms per month with winds >= 35 knots
winds_35_mth <- tapply(storm$id[storm$wind >= 35], storm$month[storm$wind >= 35], length)
winds_35_mth
barplot(winds_35_mth, 
        main = "Barplot of Storms Per Month with Winds >= 35 Knots", 
        cex.main = 1,  
        xlab = "Month", 
        ylab = "Number of Storms",
        col = rgb(0, 0.55, 0.55))


# Number of storms per month with winds >= 64 knots
winds_64_mth <- tapply(storm$id[storm$wind >= 64], storm$month[storm$wind >= 64], length)
winds_64_mth
barplot(winds_64_mth, 
        main = "Barplot of Storms Per Month with Winds >= 64 Knots", 
        cex.main = 1,  
        xlab = "Month", 
        ylab = "Number of Storms",
        col = rgb(0.6, 0.96, 1))


# Number of storms per month with winds >= 96 knots
winds_96_mth <- tapply(storm$id[storm$wind >= 96], storm$month[storm$wind >= 96], length)
winds_96_mth
barplot(winds_96_mth, 
        main = "Barplot of Storms Per Month with Winds >= 96 Knots", 
        cex.main = 1,  
        xlab = "Month", 
        ylab = "Number of Storms",
        col = '#6495ED')


# ================================================================================#
# Average Number of Storms by Wind Speed
# ================================================================================#

# Load the package
library(dplyr)

# Average number of storms with wind >= 35 knots
ave_storms_35 <- data.frame(
  'mean' = mean(winds_35_yr),
  'standard deviation' = sd(winds_35_yr),
  '25th' = quantile(winds_35_yr, probs = .25),
  '50th' = quantile(winds_35_yr, probs = .5),
  '75th' = quantile(winds_35_yr, probs = .75))

# Average number of storms with wind >= 64 knots
ave_storms_64 <- data.frame(
  'mean' = mean(winds_64_yr),
  'standard deviation' = sd(winds_64_yr),
  '25th' = quantile(winds_64_yr, probs = 0.25),
  '50th' = quantile(winds_64_yr, probs = 0.5),
  '75th' = quantile(winds_64_yr, probs = 0.75))

# Average number of storms with wind >= 96 knots
ave_storms_96 <- data.frame(
  'mean' = mean(winds_96_yr),
  'standard deviation' = sd(winds_96_yr),
  '25th' = quantile(winds_96_yr, probs = 0.25),
  '50th' = quantile(winds_96_yr, probs = 0.5),
  '75th' = quantile(winds_96_yr, probs = 0.75))

# Use the function 'rbind_all' from the 'dplyr' 
# package to make a table
ave_storms_table <- rbind_all(list(ave_storms_35, ave_storms_64, ave_storms_96))
ave_storms_table <- rename(ave_storms_table, 
                           'std dev' = standard.deviation, 
                           '25th' = X25th, 
                           '50th' = X50th, 
                           '75th' = X75th)

# Add column names
ave_storms_table$row_name <- c('35 knots', '64 knots', '96 knots')
ave_storms_table <- ave_storms_table[ , c(6, 1, 2, 3, 4, 5)]

#---------------------------------------------------------------------------------#
# Save table images
#---------------------------------------------------------------------------------#

# Table of storms per year
table_stormsperyear = table(stormsperyear)
save(table_stormsperyear, file = "../images/table_stormsperyear.rda")

# Table of storms per year with winds >= 35
table_winds35yr = winds_35_yr
save(table_winds35yr, file = "../images/table_winds35yr.rda")

# Table of storms per year with winds >= 64
table_winds64yr = winds_64_yr
save(table_winds64yr, file = "../images/table_winds64yr.rda")

# Table of storms per year with winds >= 96
table_winds96yr = winds_96_yr
save(table_winds96yr, file = "../images/table_winds96yr.rda")

# Table of storms per month
table_stormspermonth = table(stormspermonth)
save(table_stormspermonth, file = "../images/table_stormspermonth.rda")

# Table of storms per month with winds >= 35
table_winds35mth = winds_35_mth
save(table_winds35mth, file = "../images/table_winds35mth.rda")

# Table of storms per month with winds >= 64
table_winds64mth = winds_64_mth
save(table_winds64mth, file = "../images/table_winds64mth.rda")

# Table of storms per month with winds >= 96
table_winds96mth = winds_96_mth
save(table_winds96mth, file = "../images/table_winds96mth.rda")

# Table of average storms by wind speeds
table_avgstorms = ave_storms_table
save(table_avgstorms, file = "../images/table_avgstorms.rda")

# ================================================================================#
# Regression Analysis
# ================================================================================#

# Remove all the 0 values from the data set
tracks <- tracks[!tracks %in% 0, ]

#---------------------------------------------------------------------------------#
# Regression line 1: mean
#---------------------------------------------------------------------------------#

avg_wind <- sapply(storm$id, function(x) mean(tracks$wind[x == storm_ids]))
avg_press <- sapply(storm$id, function(x) mean(tracks$press[x == storm_ids]))

# Plot the regression line of the mean
par(bg = '#8B7D6B')
plot(avg_wind, avg_press, main = "Mean Pressure and Wind Speed Per Storm", 
     xlab = 'wind speed', ylab = 'pressure', 
     col = '#F0F8FF')
abline(lm(avg_press ~ avg_wind), col = '#000000')

#---------------------------------------------------------------------------------#
# Regression line 2: median
#---------------------------------------------------------------------------------#

med_wind <- sapply(storm_ids, function(x) median(tracks$wind[x == storm_ids]))
med_press <- sapply(storm_ids, function(x) median(tracks$press[x == storm_ids]))

# Plot the regression line of the median
plot(med_wind, med_press, 
     main = "Median Pressure and Wind Speed Per Storm", 
     xlab = 'wind speed', ylab = 'pressure', 
     col = '#F0F8FF')
abline(lm(avg_press ~ avg_wind), col = '#000000')


# ================================================================================#
# Visualizations: NA and EP Basin Data Cleaning
# ================================================================================#

# The csv files for the North Atlantic and East Pacific Basins has already
# been downloaded in the 'rawdata' subdirectory from the skeleton.R script

# Read csv's into the script
north_atlantic <- read.csv(file = 'north_atlantic', 
                           stringsAsFactors = FALSE, 
                           header = TRUE, skip = 1)[-1,]
east_pacific <- read.csv(file = 'east_pacific', 
                         stringsAsFactors = FALSE, 
                         header = TRUE, skip = 1)[-1,]

# Extract the months in the 'north_atlantic' dataset
dateandtime <- str_split(north_atlantic$ISO_time, " ")
date <- unlist(lapply(dateandtime, function(x) x[1]))
month <- as.numeric(str_sub(string = date, start = 6, end = 7))
north_atlantic$month <- factor(month, labels = c(month.name))

# Extract the months in the 'east_pacific' dataset
dateandtime <- str_split(east_pacific$ISO_time, " ")
date <- unlist(lapply(dateandtime, function(x) x[1]))
month <- as.numeric(str_sub(string = date, start = 6, end = 7))
east_pacific$month <- factor(month, labels = c(month.name)[-4])

# Merge data frames together
na_ep_storms <- rbind(north_atlantic, east_pacific)
na_ep_storms$Season <- as.numeric(na_ep_storms$Season)
na_ep_storms$Longitude <- as.numeric(na_ep_storms$Longitude)
na_ep_storms$Latitude <- as.numeric(na_ep_storms$Latitude)
na_ep_storms$Wind.WMO. <- as.numeric(na_ep_storms$Wind.WMO.)

#--------------------------------------------------------------------------------#
# Pre-plot Data Processing
#--------------------------------------------------------------------------------#

# Extract the years from 1980-2010 
storms_fraction <- na_ep_storms[na_ep_storms$Season %in% 1980:2010, ]

# Create an ID column with the name and season
storms_fraction$ID <- as.factor(paste(storms_fraction$Name, 
                                      storms_fraction$Season, sep = '_'))

# Rewrite the names column as a factor
storms_fraction$Name <- as.factor(storms_fraction$Name)


# ================================================================================#
# Visualization: ggplot and maps
# ================================================================================#

# Load packages
library(ggplot2)
library(maps)

#--------------------------------------------------------------------------------#
# Global Visualizations
#--------------------------------------------------------------------------------#

# Create a plot with all the storm trajectories from 1980-2010
ggplot(storms_fraction, aes(x = Longitude, y = Latitude, group = ID)) + 
  geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group),
               fill = '#CDB79E', color = '#8B7D6B', size = 0.5) + 
  geom_path(aes(colour = Wind.WMO.), alpha = 0.25, size = 0.8) + 
  coord_cartesian(xlim = c(-140, -20), ylim = c(0, 50)) +
  ggtitle("Hurricane Trajectories from 1980-2010") +
  labs(x = "Longitude", y = "Latitude") +
  theme(panel.background = element_rect(fill = '#8B8378'),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())


# Create a map showing the storm trajectories per month from 1980-2010
ggplot(storms_fraction, aes(x = Longitude, y = Latitude, group = ID)) + 
  geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group), 
               fill ='#CDB79E', color = '#8B7D6B', size = 0.5) + 
  geom_path(aes(colour = Wind.WMO.), alpha = 0.25, size = 0.8) + 
  coord_cartesian(xlim = c(-140, -20), ylim = c(0, 50)) + 
  ggtitle("Hurricane Trajectories by Month from 1980-2010") +
  labs(x = "Longitude", y = "Latitude") +
  theme(panel.background = element_rect(fill = '#8B8378'),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  facet_wrap(~ month)


#--------------------------------------------------------------------------------#
# Visualizations Per Decade
#--------------------------------------------------------------------------------#

# Create data frames for each decade
decade_1980 <- as.data.frame(storms_fraction[storms_fraction$Season %in% 1980:1989, ])
decade_1990 <- as.data.frame(storms_fraction[storms_fraction$Season %in% 1990:1999, ])
decade_2000 <- as.data.frame(storms_fraction[storms_fraction$Season %in% 2000:2010, ])

# Trajectory of storms in 1980
ggplot(decade_1980, aes(x = Longitude, y = Latitude, group = ID)) + 
  geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group), 
               fill ='#CDB79E', color = '#8B7D6B', size = 0.5) + 
  geom_path(aes(colour = Wind.WMO.), alpha = 0.25, size = 0.8) + 
  coord_cartesian(xlim = c(-140, -20), ylim = c(0, 50)) + 
  ggtitle("Hurricane Trajectories in the 1980s") +
  labs(x = "Longitude", y = "Latitude") +
  theme(panel.background = element_rect(fill = '#8B8378'),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  facet_wrap(~ Season)


# Trajectory of storms in 1990
ggplot(decade_1990, aes(x = Longitude, y = Latitude, group = ID)) + 
  geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group), 
               fill ='#CDB79E', color = '#8B7D6B', size = 0.5) + 
  geom_path(aes(colour = Wind.WMO.), alpha = 0.25, size = 0.8) + 
  coord_cartesian(xlim = c(-140, -20), ylim = c(0, 50)) + 
  ggtitle("Hurricane Trajectories in the 1990s") +
  labs(x = "Longitude", y = "Latitude") +
  theme(panel.background = element_rect(fill = '#8B8378'),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  facet_wrap(~ Season)

# Trajectory of storms in 2000
ggplot(decade_2000, aes(x = Longitude, y = Latitude, group = ID)) + 
  geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group), 
               fill ='#CDB79E', color = '#8B7D6B', size = 0.5) + 
  geom_path(aes(colour = Wind.WMO.), alpha = 0.25, size = 0.8) + 
  coord_cartesian(xlim = c(-140, -20), ylim = c(0, 50)) + 
  ggtitle("Hurricane Trajectories in the 2000s") +
  labs(x = "Longitude", y = "Latitude") +
  theme(panel.background = element_rect(fill = '#8B8378'),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  facet_wrap(~ Season)


