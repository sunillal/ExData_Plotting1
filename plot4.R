library(data.table)
library(lubridate)

#Locate the starting position of the data recorded for 1/2/2007
startPos <- head(grep("^1/2/2007",readLines("household_power_consumption.txt")),1)
#From the starting position only read 2880 records which corresponds to 2 days (1/2/2007 & 2/2/2007) of recorded data
powerData <- fread("household_power_consumption.txt",sep=";",header=FALSE,skip=startPos-1, nrows=2880)

#Set suitable coumn names in the data table
setnames(powerData,c("Date","Time", "Global_Active_Power", "Global_Reactive_Power","Voltage","Global_Intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"))

png("plot4.png",width=480, height=480)

par(mfrow = c(2,2))

#Plot the four graphs together
with(powerData, {
    #Plot a time series showing Global Active Power utilization across the two day period
    plot(dmy_hms(paste(Date,Time)),Global_Active_Power, type="l",xlab="",ylab="Global Active Power (kilowatts)")
    
    #Plot a time series showing Voltage across the two day period
    plot(dmy_hms(paste(Date,Time)), Voltage,type="l",xlab="datetime",ylab="Voltage")
    
    #Plot energy consumption per sub metering group
    {plot(dmy_hms(paste(Date,Time)),Sub_metering_1,type="l",ylab="", xlab="")
    points(dmy_hms(paste(Date,Time)),Sub_metering_2,type="l",col="red", ylab="", xlab="")
    points(dmy_hms(paste(Date,Time)),Sub_metering_3,type="l",col="blue", ylab="", xlab="")
    title(ylab="Energy sub metering")
    legend("topright",lty=1,bty="n",col=c("black","red","blue"),legend=c("Sub metering 1","Sub metering 2","Sub metering 3"))}
    
    #Plot a time series showing Global Reactive Power utilization across the two day period
    plot(dmy_hms(paste(Date,Time)),Global_Reactive_Power, type="l",xlab="datetime",ylab="Global Reactive Power")
 
})

dev.off()
