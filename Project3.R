#install.packages(RColorBrewer)
#install.packages("gplots")
library(gplots)
#library(RColorBrewer)


GPU <- read.table(file="C:\\Users\\Mauri\\Documents\\CIS 677\\GPU programming\\project 3\\ParallelDensityArray.txt", header=FALSE, sep = " ")
sequential <- read.table(file="C:\\Users\\Mauri\\Documents\\CIS 677\\GPU programming\\project 3\\DensityArray.txt", header=FALSE, sep = " ")

GPU <- GPU[-257]
sequential <- sequential[-257]

diff <- abs(GPU-sequential)
sum <- sum(diff)
sum

newGPU <- data.frame(index=1:256,concentration=t(GPU),y=rep(1,times=length(GPU)))

# creates a 5 x 5 inch image
png("C:\\Users\\Mauri\\Documents\\CIS 677\\GPU programming\\project 3\\heatmaps_in_r.png",    # create PNG for the heat map        
    width = 5*300,        # 5 x 300 pixels
    height = 2*300,
    res = 300,            # 300 pixels per inch
    pointsize = 8)        # smaller font size

## remove background and axis from plot
# theme_change <- theme(
#   axis.text.y = element_blank(),
#   axis.title.y = element_blank()
# )

ggplot(newGPU,aes(x=index,y=y,fill=concentration))+geom_tile()

dev.off()


