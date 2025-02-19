#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%                             PERCEPTRON-XFMS                             %
#%                             Version 1.0.0.0                             %
#% Copyright (c) Biomedical Informatics & Engineering Research Laboratory, %
#%         Lahore University of Management Sciences Lahore (LUMS),         %
#%                                Pakistan.                                %
#%                    (http://biolabs.lums.edu.pk/BIRL)                    %
#%                         (safee.ullah@gmail.com)                         %
#%                      Last Modified on: 21-Dec-2022                      %
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (!require("BiocManager", quietly=TRUE))
  install.packages("BiocManager")

if (!require("readMzXmlData", quietly=TRUE))
  install.packages("readMzXmlData")

library(readMzXmlData)


MzxmlFullFileNamePath = "D:\\PerceptronXfmsIntermediateProcessingFolder\\700752d5-8dfc-460d-b9c4-9d1b8cffe493\\Exp\\Replicate1\\Dose0.mzXML"



Header <- t(c("RT_sec" , "mz" , "Int" ,"RT_min" ))



FileName <- MzxmlFullFileNamePath

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














