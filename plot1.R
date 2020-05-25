# Code for producing plot 1: Global Active Power histogram as plot1.png
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

feb_data$Global_active_power <- 
    as.numeric(
        levels(feb_data$Global_active_power))[feb_data$Global_active_power]

# open the png writer
png("plot1.png", width = 480, height = 480, unit = "px")

# plot the data
hist(feb_data$Global_active_power, col = "red", 
     xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

# close the png writer
dev.off()