if (!require("BiocManager", quietly=TRUE))
  install.packages("BiocManager")

if (!require("readMzXmlData", quietly=TRUE))
  install.packages("readMzXmlData")

library(readMzXmlData)

MzxmlPath = "D:\\PerceptronXfmsIntermediateProcessingFolder\\0b284da3-b2ff-481a-9384-fa8fd99961d9\\Replicate0"

list_of_files <- list.files(path = MzxmlPath, pattern = "\\.mzXML$");  #Updated 202212121700

Header <- t(c("RT_sec" , "mz" , "Int" ,"RT_min" ))

for ( fileNum in 1: length(list_of_files) )
{
  
  list_of_files[fileNum]
  FileName <- paste(MzxmlPath, "\\", list_of_files[fileNum], sep ="")   #Updated 20221214
  
  Name = tools::file_path_sans_ext(FileName)

  CsvFileName<-paste(Name,".csv", sep ="") #Updated 20221214 #CsvFileName<-paste(Name,".csv", sep ="")
  
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








