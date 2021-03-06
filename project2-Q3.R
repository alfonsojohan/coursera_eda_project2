# Question:
#   Have total emissions from PM2.5 decreased in the  Baltimore City, Maryland 
#   ( fips == 24510 ) from 1999 to 2008? 

downloadedfile = "data.zip"
src_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")

# load libraries
library(dplyr)
library(ggplot2)

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
df <- as_tibble(pm25)

# subset for baltimore  
baltimore <- subset(df, fips == "24510")

# calculate the totals grouped by year, type
year_totals <- baltimore %>% 
  group_by(year, type) %>% 
  summarise(pm25total = sum(Emissions), .groups = "keep")

# output to png device
png(filename = "q3.png")

# generate the plot
qplot(year, pm25total, data = year_totals, 
      geom = c("point", "line"), 
      color = type,
      xlab = "Year",
      ylab = "PM 2.5 Total (tons)",
      main = "PM 2.5 Emission by Type for Baltimore City, Maryland")

# close and save png device
dev.off()
