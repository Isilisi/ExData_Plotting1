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

# plot 1
png("plot1.png")
hist(data$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
dev.off()

# plot 2
png("plot2.png")
plot2 <- function(){
        plot(data$datetime, data$Global_active_power, ylab="Global Active Power (kilowatts)", xlab="", type="l")
}
plot2()
dev.off()

# plot 3
png("plot3.png")
plot3 <- function(){
        plot(data$datetime, data$Sub_metering_1, ylab="Energy sub metering", xlab="", type="n")
        lines(data$datetime, data$Sub_metering_1, col="black")
        lines(data$datetime, data$Sub_metering_2, col="red")
        lines(data$datetime, data$Sub_metering_3, col="blue")
        legend("topright", lty=c(1,1,1), col=c("black", "red", "blue"),
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
}
plot3()
dev.off()

# plot 4
png("plot4.png")
par(mfcol=c(2,2))
plot2()
plot3()
with(data, plot(datetime, Voltage, type="l"))
with(data, plot(datetime, Global_reactive_power, type="l"))
dev.off()



