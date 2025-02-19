function [outputArg1,outputArg2] = Base64DecoderMatlabProcessing(inputArg1,inputArg2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



fileID = fopen('output.txt','r');
JsonFileData = fscanf(fileID,'%s');
fclose(fileID);




Data = jsondecode(JsonFileData);

OutputFile = 'mzXMLConvertedTxtFile.csv';

delete(OutputFile);
%writematrix(["RT_sec", "mz", "Int", "RT_min"] ,OutputFile);
%mex_WriteMatrix(OutputFile,["RT_sec", "mz", "Int", "RT_min"],'%s',',','a+');
NoOfScans = size(Data,1);

tic;
for index = 1:NoOfScans
    Masses = Data(index).spectrum.mass;
    Intensities = Data(index).spectrum.intensity;
    RTsec = Data(index).metaData.retentionTime;
for iter = 1: size(Masses,1)
    MzValue = Masses(iter);
    IntValue = Intensities(iter);
    RTmin = RTsec/60;
    %writematrix([RTsec, MzValue, IntValue, RTmin], OutputFile, 'WriteMode', 'append');
    % append it transposed to 'magic.txt' 
    mex_WriteMatrix(OutputFile,[RTsec, MzValue, IntValue, RTmin],'%d',',','a+');


    % ADD HERE IF CONDITION 

    
end
end

toc
end