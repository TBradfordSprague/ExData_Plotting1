#############################################################################
#
#                     IMPORTANT! Please note!
#
#     The data file must be in the same directory as this script.
#     
#     The data file must either be named household_power_consumption.txt
#         or the filename may be changed in the read.csv() command below.
#
#############################################################################
# The data filename is set here
table <- read.csv("household_power_consumption.txt", sep=";")
#
#############################################################################

# Convert date & time columns to POSIX formats
timeString <- as.character(table$Time)
POSIXdate <- as.Date(as.character(table$Date), format = "%d/%m/%Y")

# The transformation below rewrites the dates strings in standard format
dateString <- as.character(as.Date(as.character(table$Date), format = "%d/%m/%Y"))

DateTime <- paste(dateString, timeString, sep=" ")
DateTime <- strptime(DateTime, format = "%Y-%m-%d %H:%M:%S")
table <- cbind(POSIXdate, DateTime, table)

# read.csv() creates factor variables. Convert them to numeric types
table$Global_active_power <- as.double(as.character(table$Global_active_power))
table$Voltage <- as.double(as.character(table$Voltage))

table$Sub_metering_1 <- as.double(as.character(table$Sub_metering_1))
table$Sub_metering_2 <- as.double(as.character(table$Sub_metering_2))
table$Sub_metering_3 <- as.double(as.character(table$Sub_metering_3))

# Extract the rows we want to study; store in new dataframe, pwrTbl
FEB_1_2007 <- as.Date("2007-2-1")
FEB_2_2007 <- as.Date("2007-2-2")
theRows <- table$POSIXdate >= FEB_1_2007 & table$POSIXdate <= FEB_2_2007
pwrTbl <- table[theRows, ]

############################################################################
#
#                         Construct Plot 3
#
############################################################################
png(filename = "plot3.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white",  res = NA)
plot(pwrTbl$DateTime, pwrTbl$Sub_metering_1, type="n", 
     xlab="", ylab="Energy sub metering" )
lines(pwrTbl$DateTime, pwrTbl$Sub_metering_1, col="black")
lines(pwrTbl$DateTime, pwrTbl$Sub_metering_2, col="red")
lines(pwrTbl$DateTime, pwrTbl$Sub_metering_3, col="blue")

legend("topright", 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1,1,1),
       text.col = c( "black", "blue", "red" )
      )
dev.off()
