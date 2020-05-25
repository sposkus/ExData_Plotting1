# Code for producing plot 3: Energy sub metering over time as plot3.png
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

feb_data$Sub_metering_1 <- 
    as.numeric(levels(feb_data$Sub_metering_1))[feb_data$Sub_metering_1]
feb_data$Sub_metering_2 <- 
    as.numeric(levels(feb_data$Sub_metering_2))[feb_data$Sub_metering_2]

# open the png writer
png("plot3.png", width = 480, height = 480, unit = "px")

# plot the data
with(feb_data, plot(DateTime, Sub_metering_1, type = "n", 
                      ylab = "Energy sub metering", xlab = ""))
with(feb_data, lines(DateTime, Sub_metering_1))
with(feb_data, lines(DateTime, Sub_metering_2, col = "red"))
with(feb_data, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lwd = 1)

# close the png writer
dev.off()
