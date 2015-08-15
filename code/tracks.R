# =================================== #
# Title: Final Project
# Author: Jennifer Vu 23453383
# Data: Basin IBTrACS Dataset
# Description: Hurdat Format
# =================================== #

# -------------------------------------------------------------------- #
# This file will contain the data from the HEADER and DAILY DATA of each 
# storm. The goal is to create a table with 8 columns: id, date, period, 
# stage, lat, long wind, and press.
# -------------------------------------------------------------------- #

# Let's load any packages needed below:
library(stringr)

# The raw data has already been downloaded into the 'rawdata' subdirectory
# from the skeleton.R script
# Load the text file from the data source
tracks <- readLines("data.hdat")


# The variables 'header' and 'daily_data' extract the HEADER
# and DAILY DATA rows in the raw data
header <- grep(pattern = 'SNBR', 
               x = tracks, 
               value = TRUE)
daily_data<- grep(pattern = '\\d+/\\d+[*SEWL]', 
                  x = tracks, 
                  value = TRUE)


# The variable 'id' contains the storm number since 1851
## The variable 'duration' gives hte number of days that 
## the storm lasted
duration <- str_sub(header, 
                    start = 20, 
                    end = 22)
duration <- as.numeric(gsub(' ', '', duration))

id <- rep(str_sub(header, 
                  start = 31, end = 35), 
          times = duration*4)


# The variable 'date' gives the date of the storm
date <- rep(str_sub(header, 
                    start = 7, 
                    end = 17), 
            times = duration*4)


# The variable 'period' gives the hour of the storm
period <- rep(x = c('00h', '06h', '12h', '18h'), 
  times = sum(duration))


# The variable 'stage' gives the stage type of the storm
stage <- str_sub(
  rep(daily_data, each = 4), 
      start = c(12, 29, 46, 63), 
      end = c(12, 29, 46, 63))

for (i in 1:length(stage)) {
  stage[i] <- switch(stage[i], 
    '*' = 'cyclone', 
    'S' = 'subtropical', 
    'E' = 'extratropical', 
    'W' = 'wave', 
    'L' = 'low')
}


# The variable 'lat' gives the latitudes of the storms
lat <- str_extract_all(daily_data, '[\\*SEWL][[:blank:]]*\\d{1,3}')
lat <- as.numeric(unlist(lapply(lat, 
    function(x) gsub('[\\*SEWL][[:blank:]]*', '', x))))/10


# The variable 'long' gives the longitude of the storm, where negative numbers indicate West
long <- 
  (as.numeric(unlist(
  str_sub(string = rep(daily_data, each = 4), 
          start = c(16, 33, 50, 67), 
          end = c(19, 36, 53, 71))))/10) - 360
    

# The variable 'wind' gives the wind speed of the storm
wind <- as.numeric(str_sub(rep(daily_data, each = 4), 
                start = c(21, 38, 55, 72), 
                end = c(24, 41, 58, 75)))


# The variable 'press' gives the surface pressure of the storm
press <- str_extract_all(daily_data, 
  "[^/[:digit:]][[:digit:]]+[*SEWL]")

press <- as.numeric(unlist(
  lapply(press, 
    function(x) as.numeric(
      gsub('[ *SEWL]', '', x)))))


# Make a table with the variables 'id', 'date', 'period', 'stage', 'lat', 'long', 'wind', and 'press'
tracks_table <- data.frame(
  id = id,
  date = date,
  period = period,
  stage = stage,
  lat = lat,
  long = long,
  wind = wind,
  press = press
)


# Remove the observations that are '0' in lat, long, wind, and press
tracks_table <- tracks_table[!(tracks_table$lat == 0 & tracks_table$long == -360 & tracks_table$wind == 0 & tracks_table$press == 0), ] 

# Write the csv file
write.csv(tracks_table, "tracks.csv")

