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
function InputFilesData = ValidateAndFetchInputFilesInfo(QueryFullFolderPath, DoseResponseFile, InsideExp, RepArr)


% This function will check the names of the input files/folders and the directory's structure

% This function will check the Number of Replicates, number and type of doses

% Number and type of doses in each replicate should be equal otherwise
% THROW ERROR



% %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME
% 
% QueryFullFolderPath = "D:\PerceptronXfmsInputFolder\0b284da3-b2ff-481a-9384-fa8fd99961d9";
% RepNum = "Replicate1";
% InsideExp = "\Exp\";
% DoseResponseFile = "D:\PerceptronXfmsInputFolder\0b284da3-b2ff-481a-9384-fa8fd99961d9\DoseResponseInfo.txt";
% GUID = "0b284da3-b2ff-481a-9384-fa8fd99961d9";
% RepArr = ["Rep1"; "Rep2"; "Rep3"];
% 
% 
% S = readlines( DoseResponseFile )
% 
% %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME

% DoseResponseInfoTable = readtable(DoseResponseFile, 'Format', '%s', 'ReadVariableNames',false);
% DoseResponseInfo = DoseResponseInfoTable(:,1);
DoseResponseInfo = ReadDoseResponseFile(DoseResponseFile);


InputFilesData = [];

for iterRep = 1: size(RepArr,1)

RepNum = RepArr(iterRep);
InputFilesInfo = FetchFileNamesFromDir(QueryFullFolderPath, InsideExp, RepNum);

%Check if user provided two different format files of same dose then throw error
DuplicationInputFilesCheck(InputFilesInfo, RepNum);

%Compare the files (.d & .mzXML) with the given Dose Response File Info
CompareDoseAndInputFileName(InputFilesInfo, DoseResponseInfo, RepNum);

ConcatRepNum = strings(size(InputFilesInfo,1),1);
ConcatRepNum(:,1) = RepNum;

InputFilesData = [InputFilesData; InputFilesInfo, ConcatRepNum];

end


end


