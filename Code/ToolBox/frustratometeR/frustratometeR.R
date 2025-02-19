library(frustratometeR)

#WARNING; DO NOT CHANGE THE BELOW LINES BY HAND
InputPdbFullFile = "/mnt/d/PerceptronXfmsInputFolder/07e26b3e-ffe2-47ab-bc4f-99ee576fe72b/MiscInputFiles/PDB.pdb";
ResultsPath = "/mnt/d/PerceptronXfmsResultFolder/Result_07e26b3e-ffe2-47ab-bc4f-99ee576fe72b/frustratometeR_Results";
PdbChain = "A";
#WARNING; DO NOT CHANGE THE ABOVE LINES BY HAND

Pdb_conf <- calculate_frustration(PdbFile = InputPdbFullFile, Chain = PdbChain, ResultsDir = ResultsPath);
#view_frustration_pymol(Pdb_conf);






































