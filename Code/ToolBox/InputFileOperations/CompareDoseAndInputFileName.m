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
function [] = CompareDoseAndInputFileName(InputFilesInfo, DoseResponseInfo, RepNum)

%Compare the files (.d & .mzXML) with the given Dose Response File Info

if ~isempty(setdiff(InputFilesInfo(:,1), DoseResponseInfo)) ||  ~isempty(setdiff(DoseResponseInfo, InputFilesInfo(:,1)))
% throw(ME)
% Dear Users, Dose response file(txt) and provided input files in Replicate
% 'X' (RepNum) are inconsistant. So, your dose response file and input
% replicate folder should have same number and name of input files (.d /
% .mzXML)

end

end