%function [outputArg1,outputArg2] = Base64DecoderMatlabProcessing(inputArg1,inputArg2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[MascotFileName, MascotFilePath] = uigetfile({'*.xlsx'}, 'Select Mascot File'); 
[~,~,MascotFile] = xlsread(string(MascotFilePath) + string(MascotFileName));    %xlsread('3ChY_MASCOT_File.xlsx');       % Updated 202211221622
MascotData = [double(string((MascotFile(2:end,14))))];
UniqueMascotData = unique(MascotData, 'rows');
%%% Update to the folder containg the json files 
cd 'D:\PERCEPTRON-XFMS\Base64DecoderRAndMatlabProcessing\Base64DecoderRAndMatlabProcessing\mzxml_data'
listOfTXTfiles=dir('*.txt')
tic;
for number_of_list= 1: length(listOfTXTfiles)
fileID = fopen(listOfTXTfiles(number_of_list).name,'r');
JsonFileData = fscanf(fileID,'%s');
fclose(fileID);
Data = jsondecode(JsonFileData);

locationofDecimal= strfind(listOfTXTfiles(number_of_list).name,'.txt');
Name=extractBetween(listOfTXTfiles(number_of_list).name,1,locationofDecimal-1);
FullName= string(Name)+'.csv';
OutputFile = FullName;
delete(OutputFile);
%writematrix(["RT_sec", "mz", "Int", "RT_min"] ,OutputFile);
%mex_WriteMatrix(OutputFile,["RT_sec", "mz", "Int", "RT_min"],'%s',',','a+');
NoOfScans = size(Data,1);


for index = 1:NoOfScans
    Masses = Data(index).spectrum.mass;
    Intensities = Data(index).spectrum.intensity;
    RTsec = Data(index).metaData.retentionTime;
for iter = 1: size(Masses,1)
if any(floor(Masses(iter))== floor(UniqueMascotData))

    MzValue = Masses(iter);
    IntValue = Intensities(iter);
    RTmin = RTsec/60;
    writematrix([RTsec, MzValue, IntValue, RTmin], OutputFile, 'WriteMode', 'append');
    % append it transposed to 'magic.txt' 
    %mex_WriteMatrix(OutputFile,[RTsec, MzValue, IntValue, RTmin],'%d',',','a+');
end

    % ADD HERE IF CONDITION 

    
end
end


end
toc
%end


