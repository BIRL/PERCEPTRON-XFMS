setwd("D:/FARHAN/00_LocalGitHub/WebTool/ToolBox/Rcall")
tryCatch({

### Load packages ###
tryCatch({
 library(R.matlab)
},error=function(e) {
 tryCatch({
  tryCatch({
   install.packages("R.matlab", repos="http://cran.us.r-project.org")
   library(R.matlab)
  },error=function(e) {
   BiocManager::install("R.matlab")
   library(R.matlab)
  })
 },error=function(e) {
  sink("Rerrorinstalltmp.txt")
  cat("Error in Rrun.R : Installation of package R.matlab was not successfull. Try package installation in R beforehand. If your package has been installed, check if the R version and the R libraries are set in the system environmental variables. ", conditionMessage(e))
  sink()
})})

### Load data ###
rm(list=ls())
if(!file.exists("Rrun.Rdata"))
    save.image(file="Rrun.Rdata")
data_Rpush <- readMat("Rpush.mat")
attach(data_Rpush)

###  cmds  ###
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
MzxmlFullFileNamePath = "D:\\PerceptronXfmsIntermediateProcessingFolder\\07e26b3e-ffe2-47ab-bc4f-99ee576fe72b\\Exp\\Replicate3\\Dose75.mzXML"
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

### save ###
varnames <- unique(setdiff(ls(),c("data_Rpush","tmp","cellstrs")))
save(file="Rrun.Rdata",list=varnames)

### error output ###
},error=function(e) {
sink("Rerrortmp.txt")
cat("Error in Rrun.R :", conditionMessage(e))
sink() })
