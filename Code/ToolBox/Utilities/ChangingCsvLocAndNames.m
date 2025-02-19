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
function [] = ChangingCsvLocAndNames(CsvFileInfo, ReplaceStringFrom, ReplaceStringWithDataCsv)
%%Code for replacing the filenames based on current Comparison Engine
%%conventions i.e. Dose-100-MS1.csv

% StartString = "Dose-";
% EndString = "-MS1";
StartString = "Dose_P";


NoOfRows = size(CsvFileInfo,1);
NoOfCols =  size(CsvFileInfo,2);

CsvFilesInfo = strings(NoOfRows, NoOfCols);
CsvFilesInfo(:,1) = CsvFileInfo(:,1);

OldCsvNameVector = strcat(extractBefore(CsvFileInfo(:,3), '.txt'), '.csv');
NewCsvNameVector = strcat(StartString, extractBetween(OldCsvNameVector(:,1), "Dose", ".csv"), ".csv");

for index = 1: NoOfRows

    OldCsvFileName = strcat(CsvFileInfo(index,2), '\' ,OldCsvNameVector(index,1));
    NewCsvFileName = strcat(CsvFileInfo(index,2), '\' ,NewCsvNameVector(index,1));
    movefile(OldCsvFileName, NewCsvFileName);
    DestinationCsvName = strrep(CsvFileInfo(index,2), ReplaceStringFrom, ReplaceStringWithDataCsv);
    mkdir(DestinationCsvName);
    movefile(NewCsvFileName, DestinationCsvName);

end

end
