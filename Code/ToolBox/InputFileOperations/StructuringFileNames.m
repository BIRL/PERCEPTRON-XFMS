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
function InputFilesInfo = StructuringFileNames(UnStructFiles)

%This function is used for extracting information from MATLAB struct and
%store into MATLAB matrices


Name = {UnStructFiles.name};
FullFolderPath = {UnStructFiles.folder};

Size = size(Name,2);
InputFilesInfo = strings(Size,4);

for index = 1: Size

[~, OnlyFileName, FileExt] = fileparts(Name(index));
InputFilesInfo(index,:) = [OnlyFileName, Name(index), FileExt, FullFolderPath(index)];

end

end