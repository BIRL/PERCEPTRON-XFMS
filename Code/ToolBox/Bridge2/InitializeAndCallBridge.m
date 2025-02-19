function InitializeAndCallBridge(WorkingDirPath, PythonExeFolder, PythonExePath, BridgePyFolder, InputParamForBridge2, PDBFullFileName, BridgeOutputResults)


CreateTxtFileForInputBridge(InputParamForBridge2, PDBFullFileName, BridgeOutputResults);


%In which  drive code is present?  Drive letter
Drive = extractBefore(WorkingDirPath, '\');
PathWithDrive = extractAfter(BridgePyFolder, ':');

[status,cmdout] = system([Drive ' & ' 'cd' ' ' Drive PathWithDrive ' & ' 'python3env\Scripts\activate.bat' ' & ' 'python3env\Scripts\python.exe' ' ' BridgePyFolder '\bridge.py']);  %202301201317 Updated now will be used python.exe of python3env

if status ~= 0
    %Exceptions
    %throw(ME)
    %%%Use here cmdout for error related things
    %cmdout

end

end
% % %%PLACEHOLDERS
% % CMD1 = Drive;
% % CMD2 = ['cd' ' ' Drive PathWithDrive];
% % CMD3 = ['cd' ' ' PythonExeFolder];
% % CMD4 = ['python' ' ' BridgePyFolder '\bridge.py'];
% % CMD5 = ['cd' ' ' PythonExeFolder 'activate.bat' ];
% % 
% % CMD1 = Drive;
% % CMD2 = 'cd' ' ' Drive PathWithDrive;
% % CMD3 = ['cd' ' ' PythonExeFolder];
% % CMD4 = ['python' ' ' BridgePyFolder '\bridge.py'];


% % BridgePyFilePath = [Drive PathWithDrive]
% % system(['set PATH=' myPath ' && ' dosCommand])
% % cmd = [PythonExePath  ' ' BridgePyFolder]
% % [status,cmdout] = system(cmd);
% % [status, cmdout] = system([MSConvertCMDPath '\msconvert.exe' ' ' DFolderFullPath ' ' ' --mzXML --v --64 -o ' ' ' char(mzXMLFileOutputDir)]);
% % pyrunfile("bridge.py", filename = PDBFileNameInPySyntax, SaveResults = SaveResults);
% % here = 1
