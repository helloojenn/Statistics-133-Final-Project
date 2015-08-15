# =================================================================#
# Title: Final Project: Skeleton
# Author: Jennifer Vu 23453383
# Data: Basin IBTrACS Dataset
# Description: Contains the commands to create directories and 
# the README.md file
# =================================================================#

# Create the README.md file
file.create("README.md") 

# Create the project sub-directories
dir.create("code")
dir.create("data")
dir.create("images")
dir.create("rawdata")
dir.create("report")
dir.create("resources")

# Download raw data files into the 'rawdata' directory
data.hdat <- download.file("ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/hurdat_format/basin/Basin.NA.ibtracs_hurdat.v03r06.hdat", destfile = '~/Documents/School/3rd/Summer/Stats_133/HW/Final_Project/rawdata/data.hdat')

north_atlantic <- download.file("ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/csv/basin/Basin.NA.ibtracs_wmo.v03r06.csv", destfile = '~/Documents/School/3rd/Summer/Stats_133/HW/Final_Project/rawdata/north_atlantic')

east_pacific <- download.file("ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/csv/basin/Basin.EP.ibtracs_wmo.v03r06.csv", destfile = '~/Documents/School/3rd/Summer/Stats_133/HW/Final_Project/rawdata/east_pacific')

# Download resources into the 'resources' subdirectories
# Hurdat Formatting URL
file.create("hurdat_formatting.txt")
cat("Contains url on how to read data in HURDAT format", file = 'hurdat_formatting.txt')
cat("\n", file = 'hurdat_formatting.txt', append = TRUE)
cat("http://www.aoml.noaa.gov/hrd/data_sub/hurdat.html", file = 'hurdat_formatting.txt', append = TRUE)
file.rename(from = "~/Documents/School/3rd/Summer/Stats_133/HW/Final_Project/hurdat_formatting.txt", to = "~/Documents/School/3rd/Summer/Stats_133/HW/Final_Project/resources/hurdat_formatting.txt")

# Color Chart URL
file.create("color_chart.txt")
cat("Contains url for a list of colors", file = 'color_chart.txt')
cat("\n", file = 'color_chart.txt', append = TRUE)
cat("http://research.stowers-institute.org/efg/R/Color/Chart/", file = 'color_chart.txt', append = TRUE)
file.rename(from = "~/Documents/School/3rd/Summer/Stats_133/HW/Final_Project/color_chart.txt", to = "~/Documents/School/3rd/Summer/Stats_133/HW/Final_Project/resources/color_chart.txt")


