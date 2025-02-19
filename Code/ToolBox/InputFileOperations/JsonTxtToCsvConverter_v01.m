function CsvFileInfo = JsonTxtToCsvConverter(FilesInfo, MascotFile)

% [MascotFileName, MascotFilePath] = uigetfile({'*.xlsx'}, 'Select Mascot File');
% [~,~,MascotFile] = xlsread(string(MascotFilePath) + string(MascotFileName));    %xlsread('3ChY_MASCOT_File.xlsx');       % Updated 202211221622

MascotData = [double(string((MascotFile(2:end,14))))];
UniqueMascotData = unique(MascotData, 'rows');
%%% Update to the folder containg the json files

VectorForCsvOnlyFileNames = strings(size(FilesInfo,1),1);

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
            end
        end
    end

    VectorForCsvOnlyFileNames(number_of_list) = fName + fext;

end

CsvFileInfo = [FilesInfo(:,1), FilesInfo(:,2), VectorForCsvOnlyFileNames];

