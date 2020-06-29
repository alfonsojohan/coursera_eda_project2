# Question:
#   How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

downloadedfile = "data.zip"
src_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")
png_file <- "q5.png"

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
dftibl <- as_tibble(pm25)

# subset for baltimore and type == on-road
baltimore <- subset(dftibl, fips == "24510" & type == "ON-ROAD")

# calculate the totals grouped by year, type
year_totals <- baltimore %>% 
  group_by(year, type) %>% 
  summarise(pm25total = sum(Emissions), .groups = "keep")

# output to png device
png(filename = png_file)

# generate the plot
qplot(year, pm25total, data = year_totals, 
      geom = c("point", "line"), 
      color = type,
      xlab = "Year",
      ylab = "PM 2.5 Total (tons)",
      main = "Motor Vehicle PM 2.5 Emission in Baltimore, Maryland")

# close and save png device
dev.off()
