library(frustratometeR)


MainPath = "D:\\GitHub\\02_WebTool\\WebTool\\ToolBox\\_frustratometeR\\Examples"


PdbFile <- paste(c(MainPath, "\\1n0r.pdb"), collapse = "")
ResultsDir <- paste(c(MainPath, "\\Results"), collapse = "")


dir.create(file.path(ResultsDir))

# Calculate frustration for a givenfile
Pdb_conf <- calculate_frustration(PdbFile = PdbFile, Mode = "configurational", ResultsDir = ResultsDir, Graphics = TRUE)

# Calculate frustration for a structure to be downloaded from the PDB
Pdb_sing <- calculate_frustration(PdbID = "1vkx", Mode = "singleresidue", ResultsDir = ResultsDir, Graphics = FALSE)

#Calculate frustration for a particular chain in a structure to be downloaded from the PDB
Pdb_mut <- calculate_frustration(PdbID = "1ikn", Chain = "D", Mode = "mutational", ResultsDir = ResultsDir)

# Visualisations
plot_5Andens(Pdb_conf)
plot_5Adens_proportions(Pdb_conf)
plot_contact_map(Pdb_mut, Chain = "D")

view_frustration_pymol(Pdb_conf)
