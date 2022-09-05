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
hpc <- read.table(longname, sep=";", stringsAsFactors = FALSE)
head(hpc) 
# The first line contains the columns names, so we affect these names to the dataframe column names
names(hpc) <- lapply(hpc[1,], as.character)
hpc <- hpc[-1,] # Deletes the first line of the rows used now as cols titles


## NOW WE CAN BEGIN OUR PLOTTING THINGS
# Plot 1 : Global Active Power

hpc$Global_active_power <- as.numeric(hpc$Global_active_power)
# delete NA's
hpc <- hpc[!is.na(hpc$Global_active_power),]

# Convert the Date values to date
hpc$Date <- as.Date(strptime(hpc$Date, format = "%d/%m/%Y"))

# Now I build our subset:
## mydate_interval <- hpc[((as.Date(hpc$Date) >= as.Date("2007-02-01")) & (as.Date(hpc$Date) < as.Date("2007-02-03"))),]
## mydate_interval

## hist(mydate_interval$Global_active_power, main="Global Active Power", 
##      xlab="Global Active Power (kilowatts)", col="red")

# render the plot in a png file with the with function
png(filename="plot1.png", width = 480, height = 480)
with(hpc[((as.Date(hpc$Date) >= as.Date("2007-02-01")) & (as.Date(hpc$Date) < as.Date("2007-02-03"))),], 
     hist(Global_active_power, main="Global Active Power", 
          xlab="Global Active Power (kilowatts)", col="red"))
dev.off()

## The names of days are in French, due to some parameter of RStudio. Sorry for the inconvenience.