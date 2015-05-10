library(data.table)
## Read the head 10 lines so we can determine the colClasses of the dataset quickly.
EPC_head <- read.table(file = "household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE, nrows = 10)
EPCcolClasses <- sapply(EPC_head, class)
## Use fread to read the dataset. As far as I know, It is the fastest way to load a large dataset.
EPC_all <- fread(input = "household_power_consumption.txt", sep = ";", header = TRUE, colClasses = EPCcolClasses, na.strings = c("NA", "N/A", "?"))
## Select the data whose date is between 2007-02-01 to 2007-02-02.
EPC_20070201_20070202 <- EPC_all[EPC_all$Date %in% c("1/2/2007", "2/2/2007"), ]
EPC_20070201_20070202 <- EPC_20070201_20070202[complete.cases(EPC_20070201_20070202), ]
## As fread function will coerce the coloum from numeric to character if the dataset cantains NA, so we choose to write the selected data without NA
## and then use fread to load the dataset.
write.table(EPC_20070201_20070202, file = "EPC_20070201_20070202.txt", sep = ";", col.names = TRUE, quote = FALSE, eol = "\n", row.names = FALSE)
EPC_20070201_20070202 <- fread(input = "EPC_20070201_20070202.txt", sep = ";", header = TRUE, colClasses = EPCcolClasses, na.strings = c("NA", "N/A", "?"))

## Combine date and time in order to make plots
EPC_20070201_20070202_DATETIME <- strptime(paste(as.Date(EPC_20070201_20070202$Date, "%d/%m/%Y"), EPC_20070201_20070202$Time), format = "%Y-%m-%d %H:%M:%S")
## Making plots and save it to a png file
png(filename = "plot2.png", width = 480, height = 480)
plot(EPC_20070201_20070202_DATETIME, EPC_20070201_20070202$Global_active_power, xlab = "", ylab = "Global Active Power(kilowatts)", type = "n")
lines(EPC_20070201_20070202_DATETIME, EPC_20070201_20070202$Global_active_power)
##title(main = "Global Active Power")
dev.off()
