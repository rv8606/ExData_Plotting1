#library(dplyr)
#library(tidyr)

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
hpc4 <- read.table(longname, sep=";", stringsAsFactors = FALSE, header=TRUE)
# head(hpc4) 

#### PLOTTING PART: 
# Extract the interval
hpc4$Date <- as.Date(strptime(hpc4$Date, format = "%d/%m/%Y"))
my_interval <- hpc4[((as.Date(hpc4$Date) >= as.Date("2007-02-01")) & (as.Date(hpc4$Date) < as.Date("2007-02-03"))),]
# head(my_interval)

# Let's fuse the date and time columns
my_interval <- unite(my_interval, "Date_Time", Date, Time, sep = " ")
# Do not forget to convert it to a proper date and time
my_interval$Date_Time <- strptime(my_interval$Date_Time, "%Y-%m-%d %H:%M:%S")

# Now we detrmine the ranges for the Y scale values:
myrange_Gap <- range(c(as.numeric(my_interval$Global_active_power)))
myrange_Volt <- range(c(as.numeric(my_interval$Voltage)))
myrange_Sub <- range(c(as.numeric(my_interval$Sub_metering_1), as.numeric(my_interval$Sub_metering_2), as.numeric(my_interval$Sub_metering_3)))
myrange_Grp <- range(c(as.numeric(my_interval$Global_reactive_power)))

png(filename="plot4.png", width = 480, height = 480)
par(mfrow = c(2,2), oma=c(2,2,0,0))
with(my_interval, {
    plot(Date_Time, Global_active_power, type="l", ylim = c(as.numeric(myrange_Gap[1]), as.numeric(myrange_Gap[2])), xlab="", ylab="Global Active Power")
    plot(Date_Time, Voltage, type="l", ylim = c(as.numeric(myrange_Volt[1]), as.numeric(myrange_Volt[2])), xlab="datetime", ylab="Global Active Power")
    plot(my_interval$Date_Time, my_interval$Sub_metering_1, type="n", ylim = c(as.numeric(myrange_Sub[1]), as.numeric(myrange_Sub[2])), xlab="", ylab="Energy sub metering")
        lines(my_interval$Date_Time, my_interval$Sub_metering_1)
        lines(my_interval$Date_Time, my_interval$Sub_metering_2, col="red")
        lines(my_interval$Date_Time, my_interval$Sub_metering_3, col="blue")
        legend("topright", 
           legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           lwd=1,
           col=c("black", "red", "blue"),
           bty="n",
           xjust=1,
           y.intersp=0.5)
        plot(Date_Time, Global_reactive_power, type="l", ylim = c(as.numeric(myrange_Grp[1]), as.numeric(myrange_Grp[2])), xlab="datetime")
})
dev.off()
