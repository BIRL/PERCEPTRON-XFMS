


if (!require("BiocManager", quietly=TRUE))
  install.packages(BiocManager)

if (!require("readMzXmlData", quietly=TRUE))
  install.packages(readMzXmlData)


###library(mzR)
###library(msdata)
library(readMzXmlData)
###library(Spectra)
###library("RforProteomics")

#library(tidyverse)
########## Reading Files #########
#setwd('D:\\Supercomputing\\MATLAB\\mzxml_Files_CheY')

setwd('D:\\GitHub\\02_WebTool\\WebTool\\mzXMLtocsvConverter\\InputReplicate3')

pwd=getwd()

list_of_files <- list.files(path = pwd, pattern = "\\.mzXML$");

#list_of_files=list.files(pwd)

Header <- t(c("RT_sec" , "mz" , "Int" ,"RT_min" ))

for ( fileNum in 1: length(list_of_files) )
{
  
  list_of_files[fileNum]
  FileName = list_of_files[fileNum]
  
  Name = tools::file_path_sans_ext(FileName)
  
  CsvFileName<-paste(Name,'.csv', sep ="")
  
  write.table(Header, CsvFileName, sep = ",", row.names = FALSE, col.names = FALSE, !file.exists(CsvFileName), append = T) 

  
  mzxml<-readMzXmlFile(FileName, removeMetaData = FALSE, verbose = FALSE)
  
  TotalScans = length(mzxml)
  for (NoOfScan in  1:TotalScans)
  {
    Masses <- mzxml[[NoOfScan]]$spectrum$mass
    Intensities <- mzxml[[NoOfScan]]$spectrum$intensity
    RTsec <- mzxml[[NoOfScan]]$metaData$retentionTime
    
    iter = length(Masses)
    for(index in 1:iter){
      MZ <- Masses[index]
      Int <- Intensities[index]
      RTmin <- RTsec/60
      Data <- t(c(RTsec, MZ, Int, RTmin))
      #write.csv(Data,NameFile, row.names = FALSE, col.names = Header)
      write.table(Data, CsvFileName, sep = ",", row.names = FALSE, col.names = FALSE, !file.exists(CsvFileName), append = T)
    }
  }
}
  
  
  
  
  
  
  
  
  
  #plot(mzxml[[1]]$spectrum$mass, mzxml[[1]]$spectrum$intensity, type="l")
  # mzxml[1]
  ##################################################
  #chromatogram(rtime= mzxml[[1]]$metaData$retentionTime   ,mz=mzxml[[1]]$spectrum$mass, intensity=mzxml[[1]]$spectrum$intensity)
  
  # mz=t(t(mzxml[[1]]$spectrum$mass))
  # Int=t(t(mzxml[[1]]$spectrum$intensity))
  
  
 

  
  
  ##########################
  # # where a is rowIndex of Data
  # a=1
  # 
  # data<-data.frame()
  # # Y is from 1 to 6275 i.e. no of spectras in mzxml 
  # for (y in 1: length (mzxml)) {
  #   rt=0
  #   # i is the number of m/z obtain in one spectra 
  #   for (i in 1: length(mzxml[[y]]$spectrum$mass)) {
  #     rt[i]=(mzxml[[y]]$metaData$retentionTime)
  #   }
  #   rt=t(t(rt))
  #   data[a:(a+length(mzxml[[y]]$spectrum$mass)-1),1:3]= data.frame( rt=  t(t(rt)) ,mz =c( t(t(mzxml[[y]]$spectrum$mass))),Int=c(t(t(mzxml[[y]]$spectrum$intensity))))
  #   a=a+length(mzxml[[y]]$spectrum$mass)
  # }
  # #################################################
  # 
  # for (len in 1 : nrow(data))
  # {
  #   data[len,4]= data[len,1]/60
  # }
  # 
  # # WILL USE BELOW
  # colnames(data)<-c("RT_sec" , "mz" , "Int" ,"RT_min" )
  # 
  # DecimalPosition=as.integer(gregexpr(pattern = ".", FileName, fixed = TRUE))
  # Name=substring(FileName,1,DecimalPosition-1)
  # NameFile<-paste(Name,'.csv', sep ="")
  # write.csv(data,NameFile, row.names = FALSE)
  # rm(data)
  
  # WILL USE ABOVE
  

#####################
#data[data$mz >592.333 & data$mz <=592.339 , ]
#data[data$RT_sec==1.08  , ]
#data %>% filter(mz > 339.5000, mz <= 339.4000)
#chromatogram(data, mz= 339.5)
#data$mz = '339.5'

##########################################################################################################


