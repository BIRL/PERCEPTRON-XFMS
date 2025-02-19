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
function DoseResponseInfo = ReadDoseResponseFile(DoseResponseFile)
%Reading input dose response file (txt)


% DoseResponseInfoTable = readtable(DoseResponseFile, 'Format', '%s', 'ReadVariableNames',false);
% DoseResponseInfo = DoseResponseInfoTable(:,1);

DoseResponseInfo = readlines(DoseResponseFile);

%Remove last row if it is empty string
if DoseResponseInfo(end,1) == ""
DoseResponseInfo = DoseResponseInfo(1:end-1,1);
end

end