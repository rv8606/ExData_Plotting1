library(dplyr)
library(tidyr)

# Collect and access the data from internet:
if(!exists("./04_data")){dir.create("./04_data")}
if(!exists("exdata_data_household_power_consumption.zip")){
    fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "exdata_data_household_power_consumption.zip", method = "curl")}

filename <- unzip("exdata_data_household_power_consumption.zip", exdir="./04_data", list=TRUE)[1]$Name # I take only the name of the first file, because I know I need this one
longname = paste("./04_data", filename, sep="/")
if(!exists(longname)){
    unzip("exdata_data_household_power_consumption.zip", exdir="./04_data")}


# Create the dataset:
hpc2 <- read.table(longname, sep=";", stringsAsFactors = FALSE, header=TRUE)
head(hpc2) 

#### PLOTTING PART

hpc2$Global_active_power <- as.numeric(hpc2$Global_active_power)
# delete NA's
hpc2 <- hpc2[!is.na(hpc2$Global_active_power),]
head(hpc2)
# Extract the interval
hpc2$Date <- as.Date(strptime(hpc2$Date, format = "%d/%m/%Y"))
my_interval <- hpc2[((as.Date(hpc2$Date) >= as.Date("2007-02-01")) & (as.Date(hpc2$Date) < as.Date("2007-02-03"))),]
head(my_interval)

# We fuse the date and time columns
my_interval <- unite(my_interval, "Date_Time", Date, Time, sep = " ")
# Do not forget to convert it to a proper date and time
my_interval$Date_Time <- strptime(my_interval$Date_Time, "%Y-%m-%d %H:%M:%S")

png(filename="plot2.png", width = 480, height = 480)
with(my_interval, 
     plot(Date_Time, Global_active_power, type="l", ylab="Global Active Power (Kilowatts)", xlab="")
     )
dev.off()
