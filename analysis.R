## Analysis for R project

source("supportingFunctions.R")

# Installing packages
library(ggplot2)
library(cowplot)

# Compile all data into a .csv file
# dir X is to the csvCombine for country X
# dir Y is to the csvCombine for country Y
# desiredDir is where the combined file for both countries should go

combineCountries = function(dirX,dirY,desiredDir){
  countryXdf=read.csv(dirX)
  countryYdf=read.csv(dirY)
  countryData=rbind(countryXdf,countryYdf)
  setwd(desiredDir)
  write.csv(countryData,file="countryData.csv")
}

# Process data to answer questions and provide graphical evidence

## In which country (X or Y) did the outbreak likely begin?
# Cases over time in country X
countryXcases=data.frame(matrix(nrow=,ncol=2))
colnames(countryXcases)=c("dayofYear","dailyCases")

for (d in 120:175){
  dailyCases=sum(rowSums(countryXdf[countryXdf$dayofYear %in% d, 3:12]))
  dailyCases=data.frame(d,dailyCases)
  colnames(dailyCases)=c("dayofYear","dailyCases")
  countryXcases=rbind(countryXcases,dailyCases)
}
countryXcases=na.omit(countryXcases)

# Cases over time in country Y
countryYcases=data.frame(matrix(nrow=,ncol=2))
colnames(countryYcases)=c("dayofYear","dailyCases")

for (d in 120:175){
  dailyCases=sum(rowSums(countryYdf[countryYdf$dayofYear %in% d, 3:12]))
  dailyCases=data.frame(d,dailyCases)
  colnames(dailyCases)=c("dayofYear","dailyCases")
  countryYcases=rbind(countryYcases,dailyCases)
}
countryYcases=na.omit(countryYcases)

# Plot infections over time in each country (compare on a plot)
outbreak=ggplot()+
  geom_line(data=countryXcases, aes(x=dayofYear,y=dailyCases,color="X"))+
  geom_line(data=countryYcases, aes(x=dayofYear,y=dailyCases,color="Y"))+
  labs(color="Country")+
  xlab("Day of Year")+
  ylab("Number of Cases")+
  ggtitle("Disease Outbreak in Countries X and Y")

outbreakFigure=plot_grid(outbreak)
outbreakFigure

# Based on the line graph (titled "outbreakFigure"), it is clear that the disease outbreak likely began in Country X.
# This is because the number of cases was higher initially and increased more rapidly at the beginning in Country X.
# In Country Y, however, there was a lag to the increase and cases were low or nonexistent at the beginning.

## If Country Y develops a vaccine for the disease, is it likely to work for Country X?
# Focused on the end of data (types and strains of bacteria in countries now)
