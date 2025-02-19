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
function RemoveDirectories(IntermediateProcessingFolderPath, ResultFolderPath, GUID)


% % % % %Below will BE shown to the user "SO WILL GO TO THE Results FOLDER"
% % % % Result    % for displaying to the user
% % % % PeptideInfo.xls  % for displaying to the user
% % % % 
% % % % %Below will not show to the user "SO WILL GO TO THE INTERMEDIATE FOLDER"
% % % % Results_matched
% % % % Results_matched_intermediate
% % % % Resultsnew1


% To save Result Folder that contain Dose response plot
%GUID = "0b284da3-b2ff-481a-9384-fa8fd99961d9";
%ResultFolderPath = "D:\PerceptronXfmsResultFolder";
FinalResults=strcat(ResultFolderPath +'\' +GUID);
if ~isfolder(FinalResults)
    mkdir(FinalResults);
end

if ~isfolder(strcat(FinalResults,strcat('\FinalResult')))
    mkdir(strcat(FinalResults,strcat('\FinalResult')));
end
Directory=strcat(FinalResults,strcat('\FinalResult'))
copyfile('Result',Directory);
rmdir('Result','s');




% To save Intermediate Folders not needed by user
topLevelFolder = pwd; % or whatever, such as 'C:\Users\John\Documents\MATLAB\work'
% Get a list of all files and folders in this folder.
files = dir(topLevelFolder);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags); % A structure with extra info.

%IntermediateProcessingFolderPath =  "D:\PerceptronXfmsIntermediateProcessingFolder";
NewIntermediateProcessingFolderPath=strcat(IntermediateProcessingFolderPath +'\' +GUID);
if ~isfolder(NewIntermediateProcessingFolderPath)
    mkdir(NewIntermediateProcessingFolderPath);
end

% Optional fun : Print folder names to command window.
for number=1:size(subFolders,1)
    CurrentFolder = subFolders(number).name;
    if(strcmp (CurrentFolder, '.') || isempty(CurrentFolder) || strcmp (CurrentFolder, '..'))
        %do nothing
    else
        CurrentFolder = subFolders(number).name;

        if ~isfolder(strcat(NewIntermediateProcessingFolderPath+'\'++ '\'+CurrentFolder))
            mkdir(strcat(NewIntermediateProcessingFolderPath + '\'+CurrentFolder));
        end
        Directory=strcat(NewIntermediateProcessingFolderPath+ '\'+CurrentFolder);
        copyfile(CurrentFolder,Directory);
        rmdir(CurrentFolder,'s');
    end
end




