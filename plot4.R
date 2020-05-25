# Code for producing plot 4: a multiplot layout as plot4.png
# upper left is global active power over time, lower left is 
# energy sub metering over time, upper right is voltage over time, and
# lower right is global reactive power over time
# In order for this code to work, the data file: 
# "household_power_consumption.txt" should be in the same folder as this file

# WARNING: This imports the entirety of the +2 million lines of data, please
# be aware of potential memory issues on older systems

# Read in the data from the file
datafile <- file("household_power_consumption.txt", open = "r")
raw_data <- read.table(datafile, sep = ";", header = TRUE)

# subset it to get only the data for February 1, 2007 thru February 2, 2007
feb_data <- subset(raw_data, Date == "1/2/2007" | Date == "2/2/2007")
rm(raw_data) # reclaiming memory

# clean and format the dataset to get rid of invalid data
feb_data$DateTime <- as.POSIXct(paste(feb_data$Date, feb_data$Time), 
                                format="%d/%m/%Y %H:%M:%S")

feb_data <- droplevels(feb_data[!feb_data$Sub_metering_1 == '?',])
feb_data <- droplevels(feb_data[!feb_data$Sub_metering_2 == '?',])

feb_data$Global_active_power <- 
    as.numeric(
        levels(feb_data$Global_active_power))[feb_data$Global_active_power]
feb_data$Global_reactive_power <- 
    as.numeric(
        levels(feb_data$Global_reactive_power))[feb_data$Global_reactive_power]
feb_data$Voltage <- 
    as.numeric(levels(feb_data$Voltage))[feb_data$Voltage]
feb_data$Sub_metering_1 <- 
    as.numeric(levels(feb_data$Sub_metering_1))[feb_data$Sub_metering_1]
feb_data$Sub_metering_2 <- 
    as.numeric(levels(feb_data$Sub_metering_2))[feb_data$Sub_metering_2]

# open the png writer
png("plot4.png", width = 480, height = 480, unit = "px")

# plot the data
par(mfcol = c(2,2)) 

# upper left
with(feb_data, plot(DateTime, Global_active_power, type = "n", 
                    ylab = "Global Active Power (kilowatts)", xlab = ""))
with(feb_data, lines(DateTime, Global_active_power))

# lower left
with(feb_data, plot(DateTime, Sub_metering_1, type = "n", 
                    ylab = "Energy sub metering", xlab = ""))
with(feb_data, lines(DateTime, Sub_metering_1))
with(feb_data, lines(DateTime, Sub_metering_2, col = "red"))
with(feb_data, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lwd = 1, bty="n")

# upper right
with(feb_data, plot(DateTime, Voltage, type = "n", 
                    ylab = "Voltage", xlab = "datetime"))
with(feb_data, lines(DateTime, Voltage))

# lower right
with(feb_data, plot(DateTime, Global_reactive_power, type = "n", 
                    ylab = "Global_reactive_power", xlab = "datetime"))
with(feb_data, lines(DateTime, Global_reactive_power))

# close the png writer
dev.off()
