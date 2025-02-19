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
function FilesInfo = CallRCode(SetWorkingDirForRCall, mzXMLFilesInfo,FullNameofRFile)

%This code is using third party library named as % Rcall: An R interface for MATLAB. % Copyright (C) 2022, Janine Egert and Clemens Kreutz

%Before using this library install R in your system and add into the
%Environmental variable path

%% PLACEHOLDER FOR TESTING   %% PLACEHOLDER FOR TESTING
%mzXMLFilesInfo(1,2) = "D:\GitHub\02_WebTool\WebTool\ToolBox\Rcall\";
% SetWorkingDirForRCall = pwd + "\Rcall";
% FullNameofRFile = pwd + "\Rcall\mzXMLtocsvConverter.R";
%% PLACEHOLDER FOR TESTING   %% PLACEHOLDER FOR TESTING

VectorForTXTfiles = strings(size(mzXMLFilesInfo,1),1);

cd Rcall\;
for index = 1: size(mzXMLFilesInfo,1)
    MzxmlPath = mzXMLFilesInfo(index,2) + "\"+ mzXMLFilesInfo(index,3); %%mzXMLFilesInfo(index,2);

    UpdateRCodeFile(SetWorkingDirForRCall, MzxmlPath, FullNameofRFile);
    Rclear;
    Rinit;
    Rrunfile(char(FullNameofRFile));
    Rexec;
    VectorForTXTfiles(index) = strrep(MzxmlPath, ".mzXML", ".txt");
end
cd ..;

FilesInfo = [mzXMLFilesInfo, VectorForTXTfiles];

end
