function TransferFoldersAndFile(WorkingDirPath, MainProcessingDir, QueryResultFullPath)
%FoldersToCheck = ["Result"; "Results_matched"; "Results_matched_intermediate"; "Resultsnew1"];

FoldersToCheck = ["Results_matched"; "Results_matched_intermediate"; "Resultsnew1"];

WorkingDirPathInString = string(WorkingDirPath);

for index = 1: size(FoldersToCheck, 1)
    if (exist(WorkingDirPathInString  + "\" + FoldersToCheck(index, 1), "dir") == 7)
        [status, msgbox] = copyfile(WorkingDirPathInString  + "\" + FoldersToCheck(index, 1), MainProcessingDir + "\" + FoldersToCheck(index, 1));
        [status, msgbox] = rmdir(WorkingDirPathInString  + "\" + FoldersToCheck(index, 1), 's');
    end
end

if (exist(WorkingDirPathInString  + "\Result", "dir") == 7)
    [status, msgbox] = copyfile(WorkingDirPathInString  + "\Result", QueryResultFullPath);
    [status, msgbox] = rmdir(WorkingDirPathInString  + "\Result", 's');

end

if exist(WorkingDirPathInString  + "\" + "PeptideInfo.xls","file") == 2
    copyfile(WorkingDirPathInString  + "\" + "PeptideInfo.xls", QueryResultFullPath);
    delete(WorkingDirPathInString  + "\" + "PeptideInfo.xls");
end

end

