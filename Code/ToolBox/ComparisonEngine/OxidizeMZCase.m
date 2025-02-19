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
function [AAstartId_oxi,AAendId_oxi]=OxidizeMZCase( ind, Oxi_index,FileAfterMatch,Oxidize_mz,Unoxidize_mz,endIdx)

IDx=1;
CounterID=1;
for   j =1:length(Oxi_index)
    for i=1:length(ind)
        if ind(i)==Oxi_index(j)
            AAstartId_oxi(IDx)=Oxi_index(j);
            CounterID=AAstartId_oxi(IDx)+1;
            while ~contains(FileAfterMatch( CounterID,2),string("TC")) && ~contains(FileAfterMatch( CounterID,2),string(Unoxidize_mz))
                counter= CounterID;
                AAendId_oxi(IDx)=counter;
                CounterID=CounterID+1;
                if CounterID> endIdx
                    break
                end
            end
            IDx=IDx+1;
        end
    end
end
end
