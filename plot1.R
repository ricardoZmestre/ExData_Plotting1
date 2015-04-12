# Coursera course on Exploratory Data Analysis, Data Science specialisation
# This is Project 1 (week 1) in the course
# The goal is to replicate four charts obtained with R's base plotting system
# Each chart must be produced with a stand-alone R macro; hence, the first part
# of each of the four macros load the same data and is identical across macros.
# The relevant files are stored on Github.
# For ease of replication, the final data set is stored on Github also, to enable
# running the mecros without long delays downloading the data and loading it in
# memeory; nevertheless, deleting the stored data set will recreate it, such that 
# the data set is not essential to replicate results.

# Clean-up
rm(list=ls())

# Useful libraries (seen in a previous course of the specialisation)
library(lubridate)
library(dplyr)

## initial data handling

# Check the initial zip file exists, if not download and unpack it.
# Beware! The download takes quite a bit of time.
# Beware! The download.file below does not work with no method (or method='auto'),
# nor method='curl'. Only method='wget' did work for me. 
# (I'm on linux, your mileage may vary on Windows.)
zipfilename <- 'exdata%2Fdata%2Fhousehold_power_consumption.zip'
if (!file.exists(zipfilename)) {
  # the code below does not work under R 3.1.3, because of wrongly formated url. (?)
  #download.file(cat('https://d396qusza40orc.cloudfront.net/', zipfilename, sep=''),
  #              filename, method='wget')
  url <- paste0('https://d396qusza40orc.cloudfront.net/', zipfilename)
  download.file(url, zipfilename, method='wget')
}

# get list of files, including their paths, from the unzipped file
filename <- unzip(zipfilename, list = TRUE)[,1]

# if the file with the full dataset does not exists, unzip the ZIP file
if (!file.exists(filename)) {
  unzip(zipfilename)
}

# Finally, if the short data set 'data.txt' used as input does not exist, create it
if (!file.exists('data.txt')) {
  # read the entire file (beware: takes quite some time)
  df <- read.table(file = filename, header = TRUE, sep = ';', na.strings = '?',
                   stringsAsFactors=FALSE)
  # rid yourself of unwanted observations (using function from dplyr), 
  # previous to doing other operations on the data
  df <- filter(df, Date=='1/2/2007' | Date=='2/2/2007')
  # create extra column with date and time in POSIXct format (using lubridate)
  #df <- mutate(x, Date=dmy(Date), Time=hms(Time))
  df <- mutate(df, period=dmy_hms(paste(Date, Time), tz = 'UTC'))
  # create data set with actual inputs for charts
  write.table(df, file = 'data.txt', sep = ';', na = '?', row.names=FALSE)
} else {
  # if the final data set 'data.txt' does exist, simply load it
  df <- read.table(file = 'data.txt', header = TRUE, sep = ';', na.strings = '?',
                   colClasses=c('character','character','numeric','numeric','numeric',
                                'numeric','numeric','numeric','numeric','POSIXct'),
                   stringsAsFactors=FALSE, )
}

# Create the requested chart
# Chart 1: simple histogram
png(filename = 'plot1.png', width = 480, height = 480)
hist(df$Global_active_power, xlab = 'Global Active Power (kilowatts)', main='Global Active Power', col='red')
dev.off()
