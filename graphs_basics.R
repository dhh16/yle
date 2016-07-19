library(data.table)
setwd("/Users/yaman/Desktop/yle")
getwd()
View(yle.full_5_Kekkonen) 

DF <- data.frame(yle.full_5)
plot(DF[!is.na(DF$program_type),]$program_type, col = 1:14)

DF[DF$program_type=="",]$program_type<-NA
levels(DF[DF$program_type=="",]$program_type)
y<- droplevels(DF[!is.na(DF$program_type),]$program_type)

plot(y, col= rainbow(20), main= "Number of Program Types", las=2)
plot(y, col= rainbow(20), main= "Number of Program Types", las=1)

levels(DF[!is.na(DF$classification_main),]$classification_main)
z <- droplevels(DF[!is.na(DF$classification_main),]$classification_main)

View(yle.full_5.UKK)
plot(yle.full_5.UKK$program_type, col= rainbow(20), main= "Programs with mention of Kekkonen", las=0)

yle.full_5_olympialaiset <- read.delim("~/Desktop/yle/yle-full_5_olympialaiset.tsv")
View(yle.full_5_olympialaiset)

v <- as.integer(substr(yle.full_5_olympialaiset$firstrun_date,1,4))
v_f <- as.factor(v)
plot(v_f)
counts <- table(yle.full_5_olympialaiset$program_type, v_f)
barplot(counts, col= 1:8, legend = rownames(counts))
barplot(counts, col= 1:8, legend = c("No Data", "AJAN", "ASIA", "KULT", "LAST", "LIFE", "URHE", "UUTI"), main = "Olympics over the Years and Program Type")

yle.full_5.tsv.elections <- read.delim("~/Desktop/yle/yle-full_5-tsv-elections.tsv")
View(yle.full_5.tsv.elections)
l <- as.integer(substr(yle.full_5.tsv.elections$firstrun_date,1,4))
l_f<- as.factor(l)
plot(l_f)
plot(l_f, main="Mentions of elections over years", col=rainbow(30), cex.main=2.0)

