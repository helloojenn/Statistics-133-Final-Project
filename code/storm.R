# =================================== #
# Title: Final Project
# Author: Jennifer Vu 23453383
# Data: Basin IBTrACS Dataset
# Description: Hurdat Format
# =================================== #

# -------------------------------------------------------------------- #
# This file will contain the data from the HEADER of each storm. The 
# goal is to create a table with 4 columns: id, date, days and name.
# -------------------------------------------------------------------- #

# Let's load any packages needed below:
library(readr)
library(stringr)

# The raw data has already been downloaded into the 'rawdata' subdirectory
# from the skeleton.R script
# Load the text file from the data source
storm_ibtracs <- read.csv(
  file = "data.hdat", 
  stringsAsFactors = FALSE, 
  header = FALSE)

# The variable 'id' contains the storm number since 1851
id <- str_extract_all(
  as.character(str_extract_all(as.character(storm_ibtracs),
    'SNBR=[[:blank:]]*\\d+')), 
  "\\d+")

# The variable 'date' is written in the format MM/DD/YYYY
date <- str_extract_all(
  as.character(storm_ibtracs), 
  '\\d\\d/\\d\\d/\\d\\d\\d\\d')

# The variable 'days' contains the number of days in which the positions are available
days <- str_extract_all(as.character(
  str_extract_all(as.character(storm_ibtracs), 
    'M=[[:blank:]]*\\d+')), 
  '\\d+')

# The variable 'name' gives the name of the storm
name <- str_extract_all(as.character(
  str_extract_all(as.character(storm_ibtracs),
    '=[[:blank:]]*\\d+[[:blank:]]*[[:upper:]]+[[:punct:]]*[[:upper:]]*[[:blank:]]')), 
  '[[:upper:]]+[[:punct:]]*[[:upper:]]*')

# Create a table with the variables 'id', 'date', 'days', 'name' s.t. there is one storm per row
storm_table <- data.frame(
  id = id[[1]],
  date = date[[1]],
  days = days[[1]],
  name = name[[1]]
)

# Write a csv file with the 
write.csv(x = storm_table, "storm.csv")
