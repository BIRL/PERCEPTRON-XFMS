if (!require("BiocManager", quietly=TRUE))
  install.packages(BiocManager)

if (!require("readMzXmlData", quietly=TRUE))
  install.packages(readMzXmlData)

library(readMzXmlData)

setwd("D:\\GitHub\\02_WebTool\\WebTool\\mzXMLtocsvConverter\\InputReplicate3")

pwd=getwd()

list_of_files <- list.files(path = pwd, pattern = "\\.mzXML$");

Header <- t(c("RT_sec" , "mz" , "Int" ,"RT_min" ))

for ( fileNum in 1: length(list_of_files) )
{
  
  list_of_files[fileNum]
  FileName = list_of_files[fileNum]
  
  Name = tools::file_path_sans_ext(FileName)
  
  CsvFileName<-paste(Name,".csv", sep ="")
  
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

