library(frustratometeR)

InputPdbFullFile = "/mnt/d/PerceptronXfmsInputFolder/00000000-0000-0000-0000-000000000000/MiscInputFiles/PDB.pdb";
ResultsPath = "/mnt/d/PerceptronXfmsResultFolder/Result_00000000-0000-0000-0000-000000000000/frustratometeR_Results";
PdbChain = "A";

Pdb_conf <- calculate_frustration(PdbFile = InputPdbFullFile, Chain = PdbChain, ResultsDir = ResultsPath);
view_frustration_pymol(Pdb_conf);