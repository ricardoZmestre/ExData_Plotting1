# djhfjdf
rm(list=ls())

library(lubridate)
library(dplyr)

## initial data handling

# Check the zip file exists, if not download and unpack it.
# Beware! The download takes quite a bit of time.
# Beware! The download.file below does not work with no method (or method='auto'),
# nor method='curl'. Only method='wget' did work for me
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

# Finally, if the short data set 'data.txt' does not exist, create it
if (!file.exists('data.txt')) {
  df <- read.table(file = filename, header = TRUE, sep = ';', na.strings = '?',
                   stringsAsFactors=FALSE)
  df <- filter(df, Date=='1/2/2007' | Date=='2/2/2007')
  #df <- mutate(x, Date=dmy(Date), Time=hms(Time))
  df <- mutate(df, period=dmy_hms(paste(Date, Time), tz = 'UTC'))
  write.table(df, file = 'data.txt', sep = ';', na = '?', row.names=FALSE)
} else {
  df <- read.table(file = 'data.txt', header = TRUE, sep = ';', na.strings = '?',
                   colClasses=c('character','character','numeric','numeric','numeric',
                                'numeric','numeric','numeric','numeric','POSIXct'),
                   stringsAsFactors=FALSE, )
}

# Create the requested chart
png(filename = 'plot1.png', width = 480, height = 480)
hist(df$Global_active_power, xlab = 'Global Active Power (kilowatts)', main='Global Active Power', col='red')
dev.off()

png(filename = 'plot2.png', width = 480, height = 480)
plot(df$period, df$Global_active_power, type = 'l', xlab='', ylab = 'Global Active Power (kilowatts)')
dev.off()

plot(df$period, df$Sub_metering_1, type = 'l', col='black', xlab='', ylab = 'Energy sub metering')
lines(df$period, df$Sub_metering_2, type = 'l', col='red')
lines(df$period, df$Sub_metering_3, type = 'l', col='blue')
legend(x='topright', legend=c('Sub metering 1', 'Sub metering 2', 'Sub metering 3'), 
       lwd=2, col=c('black', 'red', 'blue'))

png(filename = 'plot3.png', width = 480, height = 480)
matplot(df$period, cbind(df$Sub_metering_1, df$Sub_metering_2, df$Sub_metering_3), type = 'l',
       col=c('black', 'red', 'blue'), xlab='', ylab = 'Energy sub metering', xaxt='n')
axis.POSIXct(1, df$period)
legend(x='topright', legend=c('Sub metering 1', 'Sub metering 2', 'Sub metering 3'), 
       lwd=2, col=c('black', 'red', 'blue'))
dev.off()

png(filename = 'plot4.png', width = 480, height = 480)
par(mfrow = c(2,2))
plot(df$period, df$Global_active_power, type = 'l', xlab='', ylab = 'Global Active Power (kilowatts)')
plot(df$period, df$Voltage, type = 'l', xlab='', ylab = 'Voltage')
matplot(df$period, cbind(df$Sub_metering_1, df$Sub_metering_2, df$Sub_metering_3), type = 'l',
        col=c('black', 'red', 'blue'), xlab='', ylab = 'Energy sub metering', xaxt='n')
axis.POSIXct(1, df$period)
legend(x='topright', legend=c('Sub metering 1', 'Sub metering 2', 'Sub metering 3'), 
       lwd=2, col=c('black', 'red', 'blue'))
plot(df$period, df$Global_reactive_power, type = 'l', xlab='', ylab = 'Global Reactive Power (kilowatts)')
dev.off()
