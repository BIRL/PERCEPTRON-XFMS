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
function [QueryResultFullPath, Error, ErrorLog] = Main(GUID, isBridgeEnabled, isFrustratometerEnabled)
%
% %%DEL ME
% GUID = "8ecbd72f-5188-4a4f-b1b7-4d27f9bd7136";
%GUID = "11000000-0000-0000-0000-000000000000";
%GUID = "00000000-0000-0000-0000-000000000000";
% isBridgeEnabled = "True";
% isFrustratometerEnabled = "True";
PdbChain = "A";
% MAIN FUNCTION OF THIS PIPELINE

% this function will input data into other function/tool after computation
% we will get output results and then this Main.m (function) will call
% further for computations


% We will have two options either cal

%%%% Write a function for local deployment that will create all directories beforehand
try

    %Object is coming from C#


    Error = "False";
    ErrorLog = "";
    DistributionName = "";

    %% PLACEHOLDERS  %% PLACEHOLDERS  %% PLACEHOLDERS  %% PLACEHOLDERS  %% PLACEHOLDERS  %% PLACEHOLDERS
    %% PLACEHOLDERS DATA WILL BE DELETED AFTER API INTEGRATION
    %%%%%GUID = "0b284da3-b2ff-481a-9384-fa8fd99961d9";

    %% PLACEHOLDERS FOR DEVELOPMENT & TESTING   %% PLACEHOLDERS FOR DEVELOPMENT & TESTING   %% PLACEHOLDERS FOR DEVELOPMENT & TESTING
    RepArr = ["Replicate1"; "Replicate2"; "Replicate3"];  %%% ["Replicate0"];   %%%%

    %% PLACEHOLDERS FOR DEVELOPMENT & TESTING   %% PLACEHOLDERS FOR DEVELOPMENT & TESTING   %% PLACEHOLDERS FOR DEVELOPMENT & TESTING

    %% Setting up paths
    InputFolderPath = "D:\PerceptronXfmsInputFolder";
    mkdir(InputFolderPath);

    PerceptronXfmsExceptionLog = "D:\PerceptronXfmsExceptionLog";
    mkdir(PerceptronXfmsExceptionLog);

    ResultFolderPath = "D:\PerceptronXfmsResultFolder";
    mkdir(ResultFolderPath);

    IntermediateProcessingFolderPath = "D:\PerceptronXfmsIntermediateProcessingFolder";
    MainProcessingDir = IntermediateProcessingFolderPath + '\' + GUID;
    mkdir(MainProcessingDir);

    MiscInputFiles = '\MiscInputFiles';
    QueryFullFolderPath = InputFolderPath + "\" + GUID;


    QueryResultFullPath = ResultFolderPath + "\Result_" + GUID;

    %MATLAB DOCUMENTATION: https://www.mathworks.com/help/matlab/ref/exist.html#d124e420733
    % 2 — name is a file with extension .m, .mlx, or .mlapp, or name is the name of a file with a non-registered file extension (.mat, .fig, .txt). & 7 — name is a folder.

    if (exist(QueryResultFullPath) == 7)
        rmdir(QueryResultFullPath, 's');
    end

    mkdir(QueryResultFullPath);
    SetWorkingDirForRCall = pwd + "\Rcall";
    FullNameofRFile = pwd + "\FileFormatConverters\mzXMLtocsvConverter.R";


    DoseResponseFile = QueryFullFolderPath  + MiscInputFiles+ "\DoseResponseInformation.txt";
    MascotFullFileName = QueryFullFolderPath + MiscInputFiles + "\Mascot.xlsx";
    FastaFullFileName = QueryFullFolderPath  + MiscInputFiles + "\Fasta.fasta";
    SASAFullFileName = QueryFullFolderPath  + MiscInputFiles + "\Sasa.xlsx";
    PDBFullFileName = QueryFullFolderPath  + MiscInputFiles + "\PDB.pdb";
    ComparisonEngineOutDir = IntermediateProcessingFolderPath + "\" + GUID + '\OutDir';
    mkdir(ComparisonEngineOutDir);

    ComparisonEngineFolder = "ComparisonEngine";
    tempInsideExp = "\Exp"; %For the time being...
    InsideExp = "\Exp\";  %For the time being...
    ReplaceStringFrom = InsideExp;

    ReplaceStringWith = "\CsvFilesBeforeFilter\";
    ReplaceStringWithDataCsv = "\OutDir\DataCSV\";
    %CsvInputFilesBeforeFilter = IntermediateProcessingFolderPath + "\" + GUID + tempInsideExp;
    CsvPathBeforeFilter = IntermediateProcessingFolderPath + "\" + GUID + "\CsvFilesBeforeFilter";

    %IntermediateProcessingFolderPath + "\" + GUID;

    %Bridge2 ""  \Bridge2\InputParametersForBridge2  ""
    WorkingDirPath = pwd;
    BridgePyFolder =  [pwd '\' 'Bridge2'];
    InputParamForBridge2 =  [ pwd  '\' 'Bridge2\InputParametersForBridge2.txt' ]; %Same for local and online deployment

    BridgeOutputResults = QueryResultFullPath + "\" + "ResultsBridge.xlsx";
    PythonExePath = [ pwd '\' 'Bridge2\python3env\Scripts\python.exe'];     %%#Convenience
    PythonExeFolder = [ pwd '\' 'Bridge2\python3env\Scripts\'];

    ResultFolderName = "\frustratometeR_Results";
    FullNameoffrustratometeRFile = pwd + "\frustratometeR\frustratometeR.R";
    frustratometerFolder = [pwd '\' 'frustratometeR'];


    LocalDeployment = false;
    %%
    if (LocalDeployment)

        %User's current directory should be the ToolBox, where a Main.m file
        %exists to work tool properly


        % #FUTURE: How user will run its own jobs using local deployment

        %[InFilePath, InFileName, InExt] = fileparts('D:\GitHub\02_WebTool\WebTool\ToolBox\InputTestFile\CheY-100-MS1-r-001.d');     %% For local deployment - SelectDFolder = uigetdir(path,'Select .d Folder');

        %FOR LOCAL DEPLOYMENT: USER SHOULD SELECT THE INPUT FOLDER FOR PROCESSING
        QueryFullFolderPath = uigetdir(pwd,'PERCEPTRON-XFMS: Please select the input folder');

        DoseResponseFile = uigetfile(pwd, 'PERCEPTRON-XFMS: Please select dose response info file'); %% SHOULD BE IN TXT FORMAT
        ReplicatesInfoFile = uigetfile(pwd, 'PERCEPTRON-XFMS: Please select replicates info file'); %% SHOULD BE IN TXT FORMAT

        RepArr = []; % Work on it... like this >>>>>  ["Rep1", "Rep2", "Rep3"];   format

        %FOR LOCAL DEPLOYMENT: USER SHOULD SELECT THE INTERMEDIATE PROCESSING FOLDER FOR SAVING ALL TYPES OF PROCESSING
        IntermediateProcessingFolderPath = uigetdir(pwd,'PERCEPTRON-XFMS: Please select the intermediate processing folder');

        %FOR LOCAL DEPLOYMENT: USER SHOULD SELECT THE RESULT FOLDER FOR PROCESSING
        QueryResultFullPath = uigetdir(pwd,'PERCEPTRON-XFMS: Please select the result folder');

        %% ComparisonEngine Files
        % MASCOT FILE
        % Get the directory from user and read the Mascot file
        InputDir = uigetdir(pwd,'Select the Input folder' );
        MascotDir = uigetfile({'*xls;*.fasta;*.xlsx'},'Select a Mascot File' );
        MascotFullFileName= char(strcat(InputDir,'\',MascotDir));

        % FASTA FILE
        %select the fasta file
        FASTADir = uigetfile({'*xls;*.fasta;*.xlsx'},'Select a FASTA File' );
        FastaFullFileName = char(strcat(InputDir,strcat('\',FASTADir)));

        % SASA FILE
        SASADir = uigetfile({'*xls;*.fasta;*.xlsx'},'Select a SASA File' );
        SASAFullFileName = char(strcat(InputDir,strcat('\',SASADir)));

        % PDB File
        PDBDir=uigetfile({'*pdb;*.fasta;*.xlsx'},'Select a PDB File' );
        PDBFullFileName = char(strcat(InputDir,strcat('\',PDBDir)));

        ComparisonEngineOutDir = uigetdir(pwd,'Select the Output folder' );

        CsvInputFilesBeforeFilter = uigetdir(pwd,'Select the output folder where your filtered CSV files will be placed.' );
        %% ComparisonEngine Files

        msgbox('If you are running either multiple instances of WSL (on WSL2) or using WSL1 then, please set the default distribution where frustratometeR is installed (option available only in WSL2) or input the name of your distribution into the command window.', 'PERCEPTRON-XFMS', 'modal');
        DistributionName = string(input('Please enter your distribution name (case sensitive): ', 's'));


    end

    %% Sub tools paths
    MSConvertCMDPath = [pwd '\ProteoWizard'];
    SpectrumXfmsPath = [pwd '\SPECTRUM-XFMS_v1.0.0.0'];
    CallingRCodePath = '';


    %% HERE HARD CODE THE INPUT FOLDER BUT WILL ASK FROM USER AS UIGET


    addpath("Bridge2\");
    addpath(ComparisonEngineFolder + "\");
    addpath("FileFormatConverters\");
    addpath("frustratometeR\");
    addpath("InputFileOperations\");
    addpath("ProteoWizard\");
    addpath("Rcall\");
    addpath("Utilities\");

    %ToolBox should be the Main folder if not then ask user to set this first...


    %Deleting folders and files that can be exist due to previously failed simulation
    RemovePreviousJobData(WorkingDirPath, ComparisonEngineFolder);

    % % % %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%
    % % % %% THESE COMMENTS SHOULD UN COMMENT FOR USING
    % % % %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%

    InputFilesData = ValidateAndFetchInputFilesInfo(QueryFullFolderPath, DoseResponseFile, InsideExp, RepArr);

    %% Creating File Directory for Intermediate Processing...
    MainProcessingFolder = IntermediateProcessingDir(MainProcessingDir, InsideExp, RepArr);

    %% Converting .d folder into mzXML file, keeping already provided input .mzXML files and
    mzXMLFilesInfo = ConversionIntoMzxml(InputFilesData, MSConvertCMDPath, MainProcessingFolder);


    %%%msgbox("R installation path MUST NOT CONTAINS AN EMPTY SPACE.", "R Installation Guidelines", "warn");

    %%Here will come R code integration for converting .mzXML file to .csv
    FilesInfo = CallRCode(SetWorkingDirForRCall, mzXMLFilesInfo,FullNameofRFile);


    %%Comparison Engine will initialize from here
    [MascotFile, wholeSeq, FileSASA, PDBFile] = ReadingMiscInputFiles(MascotFullFileName, FastaFullFileName, SASAFullFileName, PDBFullFileName);

    %% #GPUINTEGRATION #FUTURE
    %%% Call Here code for generating csv Files
    tic;
    CsvFileInfo = JsonTxtToCsvConverter(FilesInfo, MascotFile);
    a0 = toc

    %%%%  R code ki csv files
    % % % % % % % Copy them and
    % % % % % % % mkdir and paste their
    % % % % % % % That new folder will be Project Data

    ChangingCsvLocAndNames(CsvFileInfo, ReplaceStringFrom, ReplaceStringWithDataCsv);
    %FilteringCsvData(MascotFile,ComparisonEngineOutDir, CsvPathBeforeFilter);
    tic;
    GeneratingMassHunterFiles(RepArr, MascotFile,ComparisonEngineOutDir);
    a = toc;

    tic;
    MainCalculation(MascotFile,ComparisonEngineOutDir,wholeSeq,FileSASA,PDBFile, LocalDeployment);
    b = toc
    %%%
    %RemoveDirectories(IntermediateProcessingFolderPath, ResultFolderPath, GUID);


    if (isBridgeEnabled == "True")
        %%% Calling Bridge2
        InitializeAndCallBridge(WorkingDirPath, PythonExeFolder, PythonExePath, BridgePyFolder, InputParamForBridge2, PDBFullFileName, BridgeOutputResults);
    end


    if (isFrustratometerEnabled == "True")

        %Initialize & Calling FrustratormeteR using WSL cmd
        InitializeAndCallfrustratometeR(DistributionName, WorkingDirPath, FullNameoffrustratometeRFile, frustratometerFolder, PDBFullFileName, QueryResultFullPath, PdbChain, ResultFolderName);

    end

    if ~(LocalDeployment)
        %Copying the fasta file to the results folder for visualization purpose
        CopyingDataToResultsFolder(FastaFullFileName, QueryResultFullPath);
        TransferFoldersAndFile(WorkingDirPath,MainProcessingDir, QueryResultFullPath);

    end

catch exception
    Error = "True";
    ErrorLog = exception;
    FullFileName = PerceptronXfmsExceptionLog + "\" + string(datetime("now", 'Format', 'yyyyMMddHHmmss')) + "_" + GUID + ".txt";
    if exist(FullFileName) == 2 
        delete(FullFileName);
    end
    writematrix(exception.identifier, FullFileName, 'WriteMode','append');
    writematrix(exception.message, FullFileName, 'WriteMode','append');
end

end
