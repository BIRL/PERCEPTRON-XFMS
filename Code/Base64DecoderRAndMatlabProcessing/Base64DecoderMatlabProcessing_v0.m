

tic;

fileID = fopen('output.txt','r');
JsonFileData = fscanf(fileID,'%s');
fclose(fileID);

toc


Data = jsondecode(JsonFileData)

