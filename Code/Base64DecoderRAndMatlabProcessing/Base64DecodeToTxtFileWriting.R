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

MzxmlFullFileNamePath = "D:\\GitHub\\02_WebTool\\WebTool\\ToolBox\\FileFormatConverters\\Dose0.mzXML"


FileName <- MzxmlFullFileNamePath

Name = tools::file_path_sans_ext(FileName)

CsvFileName<-paste(Name,".csv", sep ="") #Updated 20221214 #CsvFileName<-paste(Name,".csv", sep ="")

# Add time clocks
mzxml<-readMzXmlFile(FileName, removeMetaData = FALSE, verbose = FALSE)

# Add time clocks
JsonString = toJSON(mzxml)


# Add time clocks
fileConn<-file("output.txt")
writeLines(JsonString, fileConn)
close(fileConn)






