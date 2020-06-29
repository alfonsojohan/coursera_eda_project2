downloadedfile = "data.zip"
src_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")

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
scc <- readRDS(src_files[[1]])
pm25 <- readRDS(src_files[[2]])

# convert to tibble to simplify things
library(dplyr)
df <- as_tibble(pm25)

# calculate the totals grouped by year
year_totals <- df %>% group_by(year) %>% summarise(pm25total = sum(Emissions), 
                                                   .groups = "keep")
# output to png device
png(filename = "pm25byyear.png")

# generate the plot
plot(year_totals$year, year_totals$pm25total, 
     xlab = "Year", 
     ylab="PM 2.5 Total Emission (tons)", 
     main = "Total PM2.5 Emissions by Year in the US", 
     pch=19, 
     type = "o", 
     lwd = 2)

# close and save png device
dev.off()
