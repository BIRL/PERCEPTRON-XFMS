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
function [AAstartId_U,AAendId_U]=UnoxidizeMZ(Unoxi_index, ind, Oxi_index,file1,Oxidize_mz)
%fetches the start and end Id of unoxidized mz block
IDx=1;
CounterID=1;
for   j =1:length(Unoxi_index)
    for i=1:length(ind)
        if ind(i)==Unoxi_index(j)
            AAstartId_U(IDx)=Unoxi_index(j);
            CounterID=AAstartId_U(IDx);
            while ~contains(file1( CounterID,2),string(Oxidize_mz))
               counter= CounterID;
                AAendId_U(IDx)=counter;
                CounterID=CounterID+1;
                if  CounterID>length(file1)
                    break
                end
            end
            IDx=IDx+1;
        end
    end
end

