function Output = ExcelFileReaderMatab(ExcelFilePath)
% Add here remove missing true or false

%ExcelFilePath = "D:\PerceptronXfmsResultFolder\Result_8ecbd72f-5188-4a4f-b1b7-4d27f9bd7136\PF_SASA_tab.xls";

[~, ~, ExcelFileContent] = xlsread(ExcelFilePath);

Output = string(ExcelFileContent(:,:));
Output = rmmissing( Output );  % Removing missing values (NaN)

Output = jsonencode(Output);

Output = strrep(Output, '"', '''');

end


% Rows = Size(1,1) + 1;
% Cols = Size(1,2);
% Output = strings(Rows, Cols);
% Output = strings(Size); 
% ExcelFileContent(cellfun(@(cell) any(isnan(cell(:))),ExcelFileContent))=[];

% % tableA = readtable(ExcelFilePath);
% % Output=tableA(~any(ismissing(tableA),2),:);