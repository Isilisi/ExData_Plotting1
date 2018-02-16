library(data.table)
library(lubridate)
library(tidyr)

# download
if (!file.exists("household_power_consumption.txt")) {
        temp <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
        unzip(temp)
        unlink(temp)
}

# clean
column_names <- fread("household_power_consumption.txt", header=TRUE, nrows=0)
data <- fread("household_power_consumption.txt", header=FALSE, na.strings="?", skip=66637, nrows=2880)
names(data) <- names(column_names)
data <- unite(data, "datetime", Date, Time)
data$datetime <- dmy_hms(data$datetime)
rm(column_names)

# plot
png("plot1.png")
hist(data$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
dev.off()