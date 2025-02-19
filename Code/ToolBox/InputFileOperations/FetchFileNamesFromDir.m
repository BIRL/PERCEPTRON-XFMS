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
function InputFilesInfo = FetchFileNamesFromDir(QueryFullFolderPath, InsideExp, RepNum)


% This function will fetch the name of the .d &/or mzXML files from the directory 
% This function will check the existance of number of replicates and files
% along with their names


% %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME
% 
% QueryFullFolderPath = "D:\PerceptronXfmsInputFolder\0b284da3-b2ff-481a-9384-fa8fd99961d9";
% RepNum = "Replicate1";
% InsideExp = "\Exp\";
% 
% %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME


RepPath = QueryFullFolderPath + InsideExp + RepNum;
if (exist(RepPath) == 7)  %%  || (exist(Rep1Path) == 0)  %%% Checks only for folders.
    DFiles = dir(fullfile(RepPath, '*.d'));
    MzxmlFiles = dir(fullfile(RepPath, '*.mzxml'));

    InputFilesInfo = [];
    if size({DFiles.name},1) ~=0 %~isempty({DFiles.name})
        InputFilesInfo = [InputFilesInfo; StructuringFileNames(DFiles)];
    end

    if size({MzxmlFiles.name},1) ~=0 %~isempty({MzxmlFiles.name})
        InputFilesInfo = [InputFilesInfo; StructuringFileNames(MzxmlFiles)];
    end

    if size(InputFilesInfo,1) == 0

        % Throw error here..
        %  ME = MException(['FileNotFound:' char(RepNum) ' do not contain any file'], 'Input file not found', 'Invalid input replicate folder');
        %
        % throw(ME)
        % Dear user, your provided input Replicate 'X' (RepNum) does not
        % contain any file which should have .d and/or .mzXML format so
        % please provide a required file format data and then proceed.
    end
end

end



