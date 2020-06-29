# Question:
#  Across the United States, how have emissions from coal combustion-related 
#  sources changed from 1999–2008?

downloadedfile = "data.zip"
src_files <- c("Source_Classification_Code.rds", "summarySCC_PM25.rds")
png_file <- "q4.png"

# load libraries
library(dplyr)
# library(ggplot2)

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

# filter the list of coal combustion sources based on the classification code 
coal_scc <- scc[grep("^Fuel Comb.+Coal", scc$EI.Sector), -c(11:15)]
coal_pm25 <- pm25[pm25$SCC %in% coal_scc$SCC, ]

# summarize the coal data
coal_summary <- coal_pm25 %>% group_by(year) %>% 
  summarise(pm25total = sum(Emissions), .groups = "keep")

# output to png device
png(filename = png_file, bg = "white")

# generate the plot
qplot(year, pm25total, data=coal_summary, main = "Coal Combustion Emission", 
      xlab = "Year", ylab = "PM 2.5 Emissions (ton)") + 
  geom_line()

# close and save png device
dev.off()
