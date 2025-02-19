# Usage example:
# Rscript Example_Dir_Frustration_Console.R /your/path/here/Pdbs/ configurational A NULL 12 T T /your/path/here/Results/

args = commandArgs(trailingOnly=TRUE)

library(frustratometeR)

#The received parameters are assigned to variables
PdbsDir <- args[1]
Mode <- args[2]
Chain <- args[3]
Electrostatics_K <- args[4]
SeqDist <- args[5]
Graphics <- args[6]
Visualization <- args[7]
ResultsDir <- args[8]

#The data type of the Boolean variables is changed, since strings of characters are received by terminal
if(Chain == "NULL") Chain <- NULL
if(Electrostatics_K == "NULL") Electrostatics_K <- NULL
if(Graphics == "T") Graphics <- T else Graphics <- F
if(Visualization == "T") Visualization <- T else Visualization <- F

#Local energy frustration is calculated
dir_frustration(PdbsDir = PdbsDir, Mode = Mode, Chain = Chain, Electrostatics_K = Electrostatics_K,
                SeqDist = SeqDist, ResultsDir = ResultsDir, Graphics = Graphics, Visualization = Visualization)
