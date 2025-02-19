function CsvFileInfo = JsonTxtToCsvConverter(FilesInfo, MascotFile)

%[MascotFileName, MascotFilePath] = uigetfile({'*.xlsx'}, 'Select Mascot File');
%[~,~,MascotFile] = xlsread(string(MascotFilePath) + string(MascotFileName));    %xlsread('3ChY_MASCOT_File.xlsx');       % Updated 202211221622

MascotData = [double(string((MascotFile(2:end,14))))];
UniqueMascotData = unique(MascotData, 'rows');



for i= 1: length(UniqueMascotData)   % Extracting after exact 1 decimal value - e.g 10.5 & 10.59 so fetching both
    mzvalue_indecimal= UniqueMascotData(i)
    IDForExtractionAfterDecimal_MASSHUNTER = strfind(string(mzvalue_indecimal),'.');
    if isempty(IDForExtractionAfterDecimal_MASSHUNTER)
        MascotUnique_mzvalue(i) =string( mzvalue_indecimal);

    else
        MascotUnique_mzvalue(i) = extractBetween( string(mzvalue_indecimal),1,IDForExtractionAfterDecimal_MASSHUNTER+1);
    end
end
MascotUnique_mzvalue=MascotUnique_mzvalue'

VectorForCsvOnlyFileNames = strings(size(FilesInfo,1),1);

%%% Update to the folder containg the json files
% DirectoryofJson= 'D:\PERCEPTRON-XFMS\Code\Inputfile\mzxml_data'
% cd (DirectoryofJson)

for number_of_list= 1: length(FilesInfo)

    File = FilesInfo(number_of_list,4);
    [path, fName, fext] = fileparts(File);

    fileID = fopen(File,'r');
    JsonFileData = fscanf(fileID,'%s');
    fclose(fileID);
    Data = jsondecode(JsonFileData);

    locationofDecimal= strfind(File,'.txt');
    Name=extractBetween(File,1,locationofDecimal-1);
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
            IDForExtraction = strfind(string(Masses(iter)),'.');
            if isempty(IDForExtraction)
                MASS_value =string(Masses(iter));
            else
                MASS_value = extractBetween( string(Masses(iter)),1,IDForExtraction+1);
            end
            if any(MASS_value== MascotUnique_mzvalue)

                MzValue = Masses(iter);
                IntValue = Intensities(iter);
                RTmin = RTsec/60;
                writematrix([MzValue, IntValue, RTmin], OutputFile, 'WriteMode', 'append');   %Updated 202301121608
                % append it transposed to 'magic.txt'
                %mex_WriteMatrix(OutputFile,[RTsec, MzValue, IntValue, RTmin],'%d',',','a+');
            end
            clear MASS_value;
            % ADD HERE IF CONDITION


        end
    end
     VectorForCsvOnlyFileNames(number_of_list) = fName + fext;

end
CsvFileInfo = [FilesInfo(:,1), FilesInfo(:,2), VectorForCsvOnlyFileNames];

end


