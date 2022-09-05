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
hpc3 <- read.table(longname, sep=";", stringsAsFactors = FALSE, header=TRUE)
head(hpc3) 

#### PLOTTING PART: Energy submeterind in 3 parts
# Extract the interval
hpc3$Date <- as.Date(strptime(hpc3$Date, format = "%d/%m/%Y"))
my_interval <- hpc3[((as.Date(hpc3$Date) >= as.Date("2007-02-01")) & (as.Date(hpc3$Date) < as.Date("2007-02-03"))),]
head(my_interval)

# Let's fuse the date and time columns
my_interval <- unite(my_interval, "Date_Time", Date, Time, sep = " ")
# Do not forget to convert it to a proper date and time
my_interval$Date_Time <- strptime(my_interval$Date_Time, "%Y-%m-%d %H:%M:%S")

# Define the range for the Y scale values
myrange <- range(c(as.numeric(my_interval$Sub_metering_1), as.numeric(my_interval$Sub_metering_2), as.numeric(my_interval$Sub_metering_3)))

png(filename="plot3.png", width = 480, height = 480)
par(mfrow = c(1,1), oma=c(0,2,0,0))
plot(my_interval$Date_Time, my_interval$Sub_metering_1, type="n", ylim = c(as.numeric(myrange[1]), as.numeric(myrange[2])), xlab="", ylab="")
lines(my_interval$Date_Time, my_interval$Sub_metering_1)
lines(my_interval$Date_Time, my_interval$Sub_metering_2, col="red")
lines(my_interval$Date_Time, my_interval$Sub_metering_3, col="blue")
mtext("Energy sub metering", outer=TRUE, side=2)
legend("topright", 
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lwd=1,
       col=c("black", "red", "blue")
       )
dev.off()
