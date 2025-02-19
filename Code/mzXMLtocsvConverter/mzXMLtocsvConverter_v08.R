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
if (!require("readMzXmlData", quietly=TRUE))
  install.packages("readMzXmlData")

if (!require("jsonlite", quietly=TRUE))
  install.packages("jsonlite")

library(readMzXmlData)  
library(jsonlite)


MzxmlFullFileNamePath = "D:\\PerceptronXfmsIntermediateProcessingFolder\\11000000-0000-0000-0000-000000000000\\Exp\\Replicate1\\Dose0.mzXML"

Name = tools::file_path_sans_ext(MzxmlFullFileNamePath)
CsvFileName<-paste(Name,".csv", sep ="")
mzxml<-readMzXmlFile(MzxmlFullFileNamePath, removeMetaData = FALSE, verbose = FALSE)
JsonString = toJSON(mzxml)
Location<-unlist(gregexpr(".mzXML", MzxmlFullFileNamePath))
OutputFileName<-substring(MzxmlFullFileNamePath,1,Location-1)
OutputFileFullName<-paste(OutputFileName,".txt",sep ="")
fileConn<-file(  OutputFileFullName)
writeLines(JsonString, fileConn)
close(fileConn)

