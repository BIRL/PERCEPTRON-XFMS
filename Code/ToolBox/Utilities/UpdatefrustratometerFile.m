%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             PERCEPTRON-XFMS                             %
%                             Version 1.0.0.0                             %
% Copyright (c) Biomedical Informatics & Engineering Research Laboratory, %
%         Lahore University of Management Sciences Lahore (LUMS),         %
%                                Pakistan.                                %
%                    (http://biolabs.lums.edu.pk/BIRL)                    %
%                         (safee.ullah@gmail.com)                         %
%                      Last Modified on: 21-Dec-2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function UpdatefrustratometerFile(WorkingDirPath, FullNameoffrustratometeRFile, frustratometerFolder, PDBFullFileName, QueryResultFullPath, PdbChain, ResultFolderName)
% Results folder
%UpdatefrustratometeRfile();

%Change paths according to WSL convention

%In which  drive code is present?  Drive letter
DriveLetter = extractBefore(WorkingDirPath, ':');
LowerDriveLetter = lower( DriveLetter );

Wsl = "/mnt/" + LowerDriveLetter;

PreparePdbFilePath = extractAfter(PDBFullFileName, ':');
PreparePdbFilePath = PreparePdbFilePath.replace('\','/');
PDBFullFileNameInWsl = Wsl + PreparePdbFilePath;

PrepareQueryResultPath =  extractAfter(QueryResultFullPath + ResultFolderName, ':');
PrepareQueryResultPath = PrepareQueryResultPath.replace('\','/');
QueryResultPathInWsl = Wsl + PrepareQueryResultPath;

%%%Read frustratometeR File
FileContent = readlines(FullNameoffrustratometeRFile);

%%WARNING BELOW IS A CASE SENSITIVE
StringForInputPdbFullFileChange = 'InputPdbFullFile = "';
StringForResultsPath = 'ResultsPath = "';
StringForPdbChainChange = 'PdbChain = "';

DynamicChangeInInputPdbFullFileLine = string([ StringForInputPdbFullFileChange  char(PDBFullFileNameInWsl) '";']);
DynamicChangeInResultsPath = string([ StringForResultsPath  char(QueryResultPathInWsl) '";']);
DynamicChangeInPdbChainChange = string([ StringForPdbChainChange  char(PdbChain) '";']);
%%WARNING ABOVE IS A CASE SENSITIVE

%Updating the frustratometeR.R file based on the User's 
% input PDB file, Results folder, and Pdb Chain
for index=1: size(FileContent,1)
    if contains(FileContent(index,1), string(StringForInputPdbFullFileChange))
        FileContent(index,1) = DynamicChangeInInputPdbFullFileLine;
    end

    if contains(FileContent(index,1), string(StringForResultsPath))
        FileContent(index,1) = DynamicChangeInResultsPath;
    end
    if contains(FileContent(index,1), string(StringForPdbChainChange))
        FileContent(index,1) = DynamicChangeInPdbChainChange;
    end
%     if(FileContent(index,1) == "")  %#Future
%         FileContent(index,1) = [];  %A null assignment can have only one non-colon index.
%     end
end

fileID = fopen(FullNameoffrustratometeRFile, "w");  %%fopen(FullNameofRFile, 'w');
fprintf(fileID, '%s\n', FileContent);
fclose(fileID);

end
