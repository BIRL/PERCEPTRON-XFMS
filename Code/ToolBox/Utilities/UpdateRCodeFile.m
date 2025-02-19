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
function [] = UpdateRCodeFile(SetWorkingDirForRCall, MzxmlPath, FullNameofRFile)
% #FUTUREPERSPECTIVES %%HANDLE EXCEPTION IF SAME OR ANYOTHER LINE ALSO CONTAINS  " #setwd "
% ContainsString =  contains(FileContent(:,1), ["setwd", "#setwd"]);

%%
% cd Rcall\
FileContent = readlines(FullNameofRFile);

SetWorkingDirFormattedForRCall = strrep(SetWorkingDirForRCall, '\', '\\');

DynamicSetWorkingDirForRCall = string(['setwd(' '"'  char(SetWorkingDirFormattedForRCall) '"' ')' ]);

StringForChange = 'MzxmlFullFileNamePath = "';   %%WARNING THIS IS CASE SENSITIVE

MzxmlFormattedPath = strrep(MzxmlPath, '\', '\\');
MzxmlFilesPath = string([ StringForChange  char(MzxmlFormattedPath) '"']);

for index=1: size(FileContent,1)
    if contains(FileContent(index,1), "setwd")
        FileContent(index,1) = DynamicSetWorkingDirForRCall;
    end

    if contains(FileContent(index,1), string(StringForChange))
        FileContent(index,1) = MzxmlFilesPath;
    end
end

fileID = fopen(FullNameofRFile, 'w');
fprintf(fileID, '%s\n', FileContent);
fclose(fileID);



end