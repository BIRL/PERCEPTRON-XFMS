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
library(jsonlite)

#### Update to the folder containing the .mzxml files 
setwd ("D:\\PERCEPTRON-XFMS\\Base64DecoderRAndMatlabProcessing\\Base64DecoderRAndMatlabProcessing\\mzxml_data")
files<-list.files( pattern= "\\.mzXML")
length(files)
for (num in 1 : length(files)){
  FileName <- paste(MzxmlFullFileNamePath,"\\",files[num], sep='')
  Name = tools::file_path_sans_ext(FileName)
  CsvFileName<-paste(Name,".csv", sep ="")
  mzxml<-readMzXmlFile(FileName, removeMetaData = FALSE, verbose = FALSE)
  JsonString = toJSON(mzxml)
  Location<-unlist(gregexpr('.mzXML', files[num]))
  OutputFileName<-substring(files[num],1,Location-1)
  OutputFileFullName<-paste(OutputFileName,".txt",sep='')
  fileConn<-file(  OutputFileFullName)
  writeLines(JsonString, fileConn)
  close(fileConn)
  
} 






