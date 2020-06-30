# Question:
#   Compare emissions from motor vehicle sources in Baltimore City with emissions 
#   from motor vehicle sources in Los Angeles County
downloadedfile = "data.zip"
src_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")
png_file <- "q6.png"

# load libraries
library(dplyr)

# Download the zip file if it does not exist yet
if (!file.exists(downloadedfile)) {
  cat("Downloading data files...\n")
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
              destfile = downloadedfile)
}

# Extract the data files from the zip files if needed
if (!(file.exists(src_files[[1]]) & 
      file.exists(src_files[[2]]))) {
  cat("Unzipping dowloaded file...\n")
  unzip(downloadedfile)
}

# Read the RDS Files
pm25 <- readRDS(src_files[[2]])

# convert to tibble to simplify things
dftibl <- as_tibble(pm25)

# subset for baltimore and type == on-road
baltimore <- subset(dftibl, fips == "24510" & type == "ON-ROAD")
losangeles <- subset(dftibl, fips == "06037" & type == "ON-ROAD")

# output to png device
png(filename = png_file)

# generate the plot. put it side by side for comparison
# plot on log scale so that can see the difference

# get the min/max range for y axis
yrange = range(baltimore$Emissions, losangeles$Emissions)

# side by side plot
par(mfrow = c(1,2), oma = c(0,0,2,1))
par(mar = c(2,4,2,0))

# plot baltimore and add the mean line
plot(Emissions~year, data = baltimore, ylim = yrange, xlab = "", 
     ylab = "PM 2.5 Emissions (log10 tons)", log = "y", 
     col = alpha("black", 0.5))
mtext("Baltimore City")
abline(h = mean(baltimore$Emissions), lwd = 3, 
       col = alpha("red", 0.5))

# plot LA and add the mean line
plot(Emissions~year, data = losangeles, ylim = yrange, 
     xlab = "", ylab = "", log = "y", col = alpha("black", 0.5), 
     yaxt = "n")
mtext("Los Angeles County")
abline(h = mean(losangeles$Emissions), lwd = 3, 
       col = alpha("red", 0.5))

# Add main title
mtext("Motor Vehicle Emissions: Baltimore City vs LA County", outer = TRUE, font = 2)

# close and save png device
dev.off()
