library(frustratometeR)

#MainPath = "D:\\GitHub\\02_WebTool\\WebTool\\ToolBox\\_frustratometeR\\Examples"


#MainPath = "D:/GitHub/02_WebTool/WebTool/ToolBox/_frustratometeR/Examples"

MainPath = "/mnt/d/GitHub/02_WebTool/WebTool/ToolBox/_frustratometeR/Examples"

Path <- paste(c(MainPath, "/Results"), collapse = "")
PdbFile <- paste(c(MainPath, "/1n0r.pdb"), collapse = "")

#Path <- "/home/ubuntu18/Desktop/WebServer/frustratometeR/frustratometeR-master/Examples"

#setwd(Path)
Pdb_conf <- calculate_frustration(PdbFile = PdbFile, Chain = "A", ResultsDir = Path)

view_frustration_pymol(Pdb_conf)



getwd()
