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
%Picking up reside names from Row 1 in the input file
function [Index_var, colname] =  NumberOfColumns(file)
%Fine cells that are empty
Index_var=find( cellfun( @isempty, file(1,:) ) ==0);
%Storage variable for non-empty column names
colname=string({ });
%For all columns in the first row that are not empty
for i=1: length(Index_var)
    %Read data from file
    ColumnInfo= file(1,Index_var(i));
    %Store column name
    colname(1,Index_var(i))=ColumnInfo;
end
end