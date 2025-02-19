function RemovePreviousJobData(WorkingDirPath, ComparisonEngineFolder)

%Deleting folders and files that can be exist due to previously failed simulation
% % % % Result    % for displaying to the user
% % % % PeptideInfo.xls  % for displaying to the user
% % % %
% % % % %Below will not show to the user "SO WILL GO TO THE INTERMEDIATE FOLDER"
% % % % Results_matched
% % % % Results_matched_intermediate
% % % % Resultsnew1

%% Deleting below folders
FoldersToCheck = ["Result"; "Results_matched"; "Results_matched_intermediate"; "Resultsnew1"];

WorkingDirFullPathInString = string(WorkingDirPath);
ComparisonEngineFullPath = WorkingDirPath + "\" + ComparisonEngineFolder;

for index = 1: size(FoldersToCheck, 1)
    if (exist(WorkingDirFullPathInString  + "\" + FoldersToCheck(index, 1), "dir") == 7)
        [status, msgbox] = rmdir(WorkingDirFullPathInString  + "\" + FoldersToCheck(index, 1), 's');
    end
    if (exist(ComparisonEngineFullPath  + "\" + FoldersToCheck(index, 1), "dir") == 7)
        [status, msgbox] = rmdir(ComparisonEngineFullPath  + "\" + FoldersToCheck(index, 1), 's');
    end
end


%% Deleting PeptideInfo.xls
if exist(WorkingDirFullPathInString  + "\" + "PeptideInfo.xls","file") == 2
    delete(WorkingDirFullPathInString  + "\" + "PeptideInfo.xls");
end
if exist(ComparisonEngineFullPath  + "\" + "PeptideInfo.xls","file") == 2
    delete(ComparisonEngineFullPath  + "\" + "PeptideInfo.xls");
end

end

