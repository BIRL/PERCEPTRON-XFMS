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
function MainProcessingFolder = IntermediateProcessingDir(MainProcessingDir, InsideExp, RepArr)

% %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME
% GUID = "0b284da3-b2ff-481a-9384-fa8fd99961d9";
% RepArr = ["Rep1"; "Rep2"; "Rep3"];
% IntermediateProcessingFolderPath = "D:\PerceptronXfmsIntermediateProcessingFolder";
% %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME   %% DEL ME


MainProcessingFolder = MainProcessingDir + InsideExp;

mkdir(MainProcessingFolder);

for index = 1: size(RepArr,1)
RepPath = MainProcessingFolder + RepArr(index);
mkdir(RepPath);
end

end

