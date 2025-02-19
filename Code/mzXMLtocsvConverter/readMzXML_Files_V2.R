library('mzR')
library(msdata)
library(readMzXmlData)
library(Spectra)
library("RforProteomics")
#library(tidyverse)
########## Reading Files #########
#setwd('D:\\Supercomputing\\MATLAB\\mzxml_Files_CheY')


pwd=getwd()

list_of_files <- list.files(path = pwd, pattern = "\\.mzXML$");

#list_of_files=list.files(pwd)

length(list_of_files)
for ( fileNum in 1: length(list_of_files) )
{
  FileName= list_of_files[fileNum]
  mzxml<-readMzXmlFile(FileName, removeMetaData = FALSE, verbose = FALSE)
  
  #plot(mzxml[[1]]$spectrum$mass, mzxml[[1]]$spectrum$intensity, type="l")
  mzxml[1]
  ##################################################
  #chromatogram(rtime= mzxml[[1]]$metaData$retentionTime   ,mz=mzxml[[1]]$spectrum$mass, intensity=mzxml[[1]]$spectrum$intensity)
  
  mz=t(t(mzxml[[1]]$spectrum$mass))
  Int=t(t(mzxml[[1]]$spectrum$intensity))
  
  ##########################
  # where a is rowIndex of Data
  a=1
  
  data<-data.frame()
  # Y is from 1 to 6275 i.e. no of spectras in mzxml 
  for (y in 1: length (mzxml)) {
    rt=0
    # i is the number of m/z obtain in one spectra 
    for (i in 1: length(mzxml[[y]]$spectrum$mass)) {
      rt[i]=(mzxml[[y]]$metaData$retentionTime)
    }
    rt=t(t(rt))
    data[a:(a+length(mzxml[[y]]$spectrum$mass)-1),1:3]= data.frame( rt=  t(t(rt)) ,mz =c( t(t(mzxml[[y]]$spectrum$mass))),Int=c(t(t(mzxml[[y]]$spectrum$intensity))))
    a=a+length(mzxml[[y]]$spectrum$mass)
  }
  #################################################
  
  for (len in 1 : nrow(data))
  {
    data[len,4]= data[len,1]/60
  }
  
  colnames(data)<-c("RT_sec" , "mz" , "Int" ,"RT_min" )
  
  DecimalPosition=as.integer(gregexpr(pattern = ".", FileName, fixed = TRUE))
  Name=substring(FileName,1,DecimalPosition-1)
  NameFile<-paste(Name,'.csv', sep ="")
  write.csv(data,NameFile, row.names = FALSE)
  rm(data)
}
#####################
#data[data$mz >592.333 & data$mz <=592.339 , ]
#data[data$RT_sec==1.08  , ]
#data %>% filter(mz > 339.5000, mz <= 339.4000)
#chromatogram(data, mz= 339.5)
#data$mz = '339.5'

##########################################################################################################


