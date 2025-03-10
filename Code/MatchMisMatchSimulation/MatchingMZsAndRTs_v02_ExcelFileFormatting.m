%%%For matching mz ????????????????????????? values of Mascot and Mass Hunter data
%Mascot values be fetched from mascot file
%Mass Hunter data values will be fetched from csv file (generated by .d folder to mzXML and then csv file)

%This Code is compatible with MATLAB R2022a or higher
clc;
clear all;
disp("This Code is compatible with MATLAB R2022a or higher.");

tic;

%For MZ
FactorForMz = 10^-2;      % Updated 202211222028
MatchToleranceForMz = FactorForMz;          % 0.0001;  % Updated 202211221613
MisMatchToleranceForMz = FactorForMz * 9;   % 0.0009;   % Updated 202211221613
OffTargetToleranceForMz = 1;


%For RT
FactorForRT = 10^-2;     
MatchToleranceForRT = FactorForRT;
MisMatchToleranceForRT = FactorForRT * 9; 
OffTargetToleranceForRT =  1;




TempDateAndTime = string(datetime('now','TimeZone','local','Format','yyyyMMddHHmmss'));
SubResultFolder = TempDateAndTime + "_Results_MZTol_" + FactorForMz + "_RTTol_" + FactorForRT;
MainResultFolder = pwd + "\Results\";
ResultsPath =  MainResultFolder + SubResultFolder + "\"; % TempDateAndTime + "_Results" + "\";       % Updated 202211221641
mkdir(fullfile(MainResultFolder,SubResultFolder));

%Reading Mass Hunter File
[MassHunterFileName, MassHunterFilePath] = uigetfile({'*.csv'}, 'Select Mass Hunter File');   % Updated 202211221622
MassHunterData = readmatrix(string(MassHunterFilePath) + string(MassHunterFileName));   % 'CheY_100.csv'     % Updated 202211221622


%Reading mascot file
[MascotFileName, MascotFilePath] = uigetfile({'*.xlsx'}, 'Select Mascot File');   % Updated 202211221622
[~,~,MascotFile] = xlsread(string(MascotFilePath) + string(MascotFileName));    %xlsread('3ChY_MASCOT_File.xlsx');       % Updated 202211221622




%string([MascotFile(2:end,14), extractBetween(MascotFile(2:end,27), 'at ', ' mins ')])


% Preparing Mascot Data
% mz value |||| RT value (in Mins)
MascotData = [double(string((MascotFile(2:end,14)))), double(string(extractBetween(MascotFile(2:end,27), 'at ', ' mins ')))];
UniqueMascotData = unique(MascotData, 'rows');
MascotDataSorted = sortrows(UniqueMascotData,[1,2], 'ascend');


% Preparing Mass Hunter Data
MassHunterMZs = double(string((MassHunterData(2:end,2))));             % Mzs 
MassHunterRTsecs = double(string((MassHunterData(2:end,1))));          % RTs in seconds 
MassHunterRTmins = double(string((MassHunterData(2:end,1)))) ./ 60;    % RTs in minutes
MassHunterInts = double(string((MassHunterData(2:end,3))));            % Intensities

% mz value |||| RT value (in Mins) |||| Intensity
MassHunterData = [MassHunterMZs, MassHunterRTmins, MassHunterInts];
MassHunterDataSorted = sortrows(MassHunterData,[1,2], 'ascend');

%Size of sorted Matrices
sizeOfMassHunterData = size(MassHunterDataSorted,1);
sizeOfMascotData = size(MascotDataSorted,1);
NoOfRows = sizeOfMassHunterData * sizeOfMascotData;

%%%%%%%%%%%%%%%%%%%%% DONE AT THAT POINT

MatchIndex = 1;
MisMatchIndex = 1;

CombinedResultsMatchFile = "CombinedMatchResults.csv";
CombinedResultsMisMatchFile = "CombinedMisMatchResults.csv";


%%%Excel File Formatted Results
ResultSheet1 = "ResultSheet1.csv";
ResultSheet2 = "ResultSheet2.csv";
ResultSheet3 = "ResultSheet3.csv";

DataResultSheet1n2 = [];
DataResultSheet3 = [];

%%%Excel File Formatted Results



%Summarizing Data for Combined Matches File
MatchMzsWithCount = [];

NoMatchMzsFoundWithCount = [];

%Summarizing Data for Combined MisMatches File
MisMatchMzsWithCount = [];

NoMisMatchMzsFoundWithCount = [];

Header = ["Mascot MZ", "MassHunter MZ", "MZ Difference", "Mascot RT", "MassHunter RT", "RT Difference" ];
EmptyString = ["","",""];


progressbar('Processing...');
for i=1:sizeOfMascotData
    
    TempMatch = [];
    TempMisMatch = [];
    
    progressbar(i/sizeOfMascotData);
    for j=1:sizeOfMassHunterData
        MatchDiffMz = MascotDataSorted(i,1) - MassHunterDataSorted(j,1);
        AbsMatchDiffMz = abs(MatchDiffMz);
        
        if(AbsMatchDiffMz >= OffTargetToleranceForMz)
            continue;
        end

        MatchDiffRT = MascotDataSorted(i,2) - MassHunterDataSorted(j,2);
        AbsMatchDiffRT = abs(MatchDiffRT);

        %%%%
        if(AbsMatchDiffRT >= OffTargetToleranceForRT)
            continue;
        end
        
        % Checking Match & RT
        if (AbsMatchDiffMz <= MatchToleranceForMz && AbsMatchDiffRT <= MatchToleranceForRT)
            TempMatch = [TempMatch; MascotDataSorted(i,1), MassHunterDataSorted(j,1), MatchDiffMz, MascotDataSorted(i,2), MassHunterDataSorted(j,2), MatchDiffRT];
          

            DataResultSheet1n2 = [DataResultSheet1n2; MascotDataSorted(i,2), MatchDiffRT,MascotDataSorted(i,1)];

        % Checking Mismatch & RT    
        elseif ((MatchToleranceForMz < AbsMatchDiffMz && AbsMatchDiffMz < MisMatchToleranceForMz) &&  (MatchToleranceForRT < AbsMatchDiffRT && AbsMatchDiffRT < MisMatchToleranceForRT))
            TempMisMatch = [TempMisMatch; MascotDataSorted(i,1), MassHunterDataSorted(j,1), MatchDiffMz, MascotDataSorted(i,2), MassHunterDataSorted(j,2), MatchDiffRT];
        end
    end
    MatchCount = size(TempMatch,1);
    MisMatchCount = size(TempMisMatch,1);
    TempMainMatchMatrix = [];
    if MatchCount ~= 0

        %%%% For Temp File Testing "TempMatch"
        TempMainMatchMatrix = string([MascotDataSorted(i,1), MascotDataSorted(i,2), MatchCount, EmptyString; Header]);   %  "Mascot_mz", "MassHunter_mz", "Difference"
        TempMainMatchMatrix = [ TempMainMatchMatrix; string(TempMatch); EmptyString, EmptyString];

%         %%No need of individual files
%         writematrix(TempMainMatchMatrix, ResultsPath + MascotDataSorted(i,1) +"_Match.csv");
%         %%No need of individual files

        MatchMzsWithCount = [MatchMzsWithCount; MascotDataSorted(i,1), MascotDataSorted(i,2), MatchCount];
        % Need to check
        % % %                 ResultantMatrixMatches(MatchIndex:MatchIndex+1,:) = string([sortMascotData(i,1), MatchCount, ""; "Mascot_mz", "MassHunter_mz", "Difference"]);
        % % %                 MatchIndex = MatchIndex + 2;
        % % %                 ResultantMatrixMatches(MatchIndex:MatchIndex+MatchCount - 1,:) = string(TempMatch);
        % % %                 MatchIndex = MatchIndex + MatchCount;

    else

        DataResultSheet3 = [DataResultSheet3; MascotDataSorted(i,2)];
        TempMainMatchMatrix = string([MascotDataSorted(i,1),  MascotDataSorted(i,2), MatchCount,EmptyString; Header]);
        TempMainMatchMatrix = [ TempMainMatchMatrix; "No match found", EmptyString, "", ""; EmptyString, EmptyString];
        
%         %%No need of individual files
%         writematrix(TempMainMatchMatrix, ResultsPath + MascotDataSorted(i,1) +"_Match.csv");
%         %%No need of individual files

        NoMatchMzsFoundWithCount = [NoMatchMzsFoundWithCount; MascotDataSorted(i,1), MatchCount];

    end
    writematrix(TempMainMatchMatrix, ResultsPath + CombinedResultsMatchFile, 'WriteMode','append');

    TempMainMisMatchMatrix = [];
    if MisMatchCount ~= 0
        
        %%%% For Temp File Testing "TempMisMatch"
        TempMainMisMatchMatrix = string([MascotDataSorted(i,1), MascotDataSorted(i,2), MisMatchCount, EmptyString; Header]);
        TempMainMisMatchMatrix = [TempMainMisMatchMatrix; string(TempMisMatch); EmptyString, EmptyString];
        
%         %%No need of individual files
%         writematrix(TempMainMisMatchMatrix, ResultsPath + MascotDataSorted(i,1)+"_MisMatch.csv");
%         %%No need of individual files


        MisMatchMzsWithCount = [MisMatchMzsWithCount; MascotDataSorted(i,1), MascotDataSorted(i,2), MisMatchCount];


        
        
        % Need to check
        % % %                 ResultantMatrixMisMatches(MisMatchIndex: MisMatchIndex+1,:) = string([sortMascotData(i,1), MisMatchCount, ""; "Mascot_mz", "MassHunter_mz", "Difference"]);
        % % %                 MisMatchIndex = MisMatchIndex + 2;
        % % %                 ResultantMatrixMisMatches(MisMatchIndex:MisMatchIndex+MisMatchCount-1,:) = string(TempMisMatch);
        % % %                 MisMatchIndex = MisMatchIndex + MisMatchCount;
    
        %Not Required FOR NOW BELOW
    else
        
        TempMainMisMatchMatrix = string([MascotDataSorted(i,1), MascotDataSorted(i,2), MisMatchCount, EmptyString; Header]);
        TempMainMisMatchMatrix = [TempMainMisMatchMatrix; "No mismatch found", EmptyString, "", ""; EmptyString, EmptyString];

%         %%No need of individual files
%         writematrix(TempMainMisMatchMatrix, ResultsPath + MascotDataSorted(i,1)+"_MisMatch.csv");
%         %%No need of individual files

        NoMisMatchMzsFoundWithCount = [NoMisMatchMzsFoundWithCount; MascotDataSorted(i,1), MisMatchCount];

        %Not Required FOR NOW ABOVE

    end
    writematrix(TempMainMisMatchMatrix, ResultsPath + CombinedResultsMisMatchFile, 'WriteMode','append');

end

SummarizingMatchData = [EmptyString; "Summarizing Match Data", "", ""; "Matched Mzs", "Matched RTs", "Count"; MatchMzsWithCount];  % "","" ; "No Matched Mzs Found", "Count"; NoMatchMzsFoundWithCount];
writematrix(SummarizingMatchData, ResultsPath + CombinedResultsMatchFile, 'WriteMode','append');


SummarizingMisMatchData = [EmptyString; "Summarizing Mismatch Data", "", "" ;"Mismatched Mzs", "Mismatched RTs", "Count"; MisMatchMzsWithCount];  %; "","" ; "No Mismatched Mzs Found", "Count"; NoMisMatchMzsFoundWithCount];
writematrix(SummarizingMisMatchData, ResultsPath + CombinedResultsMisMatchFile, 'WriteMode','append');




%%%Excel File Formatted Results

%%% Below Uncomment when MZ needed
% FormattingHeaderSheet1 = ["Unique MASCOT (mz)", "Difference (mz)"];
% FormattingHeaderSheet2 = ["Unique MASCOT (mz)", "Difference (mz)", "MASCOT RT (mins)"];



%%% Below Uncomment when RT needed
FormattingHeaderSheet1 = ["Unique MASCOT RT (mins)", "Difference RT (mins)"];
FormattingHeaderSheet2 = ["Unique MASCOT RT (mins)", "Difference RT (mins)", "MASCOT (mz)"];



DataResultSheet1Prep = DataResultSheet1n2(:,[1,2]);
writematrix([FormattingHeaderSheet1; DataResultSheet1Prep], ResultsPath + ResultSheet1, 'WriteMode','append');


DataResultSheet2Prep = DataResultSheet1n2';
writematrix([FormattingHeaderSheet2', DataResultSheet2Prep], ResultsPath + ResultSheet2, 'WriteMode','append');



FormattingHeaderSheet3 = ["Unique RT (mins)"];

if size(DataResultSheet3,1) == 0
    DataResultSheet3 = ["No unmatched RT (mins) found."];
end
writematrix([FormattingHeaderSheet3; DataResultSheet3], ResultsPath + ResultSheet3, 'WriteMode','append');




% Need to check
% % % EmptyMatchRowIndex = find(cellfun('isempty',ResultantMatrixMatches(:,1)));
% % % ResultantMatrixMatches(EmptyMatchRowIndex(1):end,:) = [];
% % %
% % % EmptyMisMatchRowIndex = find(cellfun('isempty',ResultantMatrixMisMatches(:,1)));
% % % ResultantMatrixMisMatches(EmptyMisMatchRowIndex(1):end,:) = [];
% % %
% % %
% % % DateAndTime = string(datetime('now','TimeZone','local','Format','yyyyMMddHHmmss'));
% % %
% % % %Write csv file
% % % MatchFileName = DateAndTime + "_MatchFile.csv";
% % % if(size(ResultantMatrixMatches,1) ~= 0)
% % %     writematrix(ResultantMatrixMatches, MatchFileName);
% % %
% % % else
% % %     disp("No match found");
% % % end
% % %
% % %
% % % MisMatchFileName = DateAndTime + "_MisMatchFile.csv";
% % % if(size(ResultantMatrixMisMatches,1) ~= 0)
% % %     writematrix(ResultantMatrixMisMatches, MisMatchFileName);
% % % else
% % %     disp("No mismatch found");
% % % end

toc;

a = 1;
% % PeakFiles_mz = PeakFiles(:,2);
% % mascotfile_mz = mascotfile(:,14)
% % unique_mascot_mz=unique(mascotfile_mz)
% % unique_peak_mz=string(unique(PeakFiles_mz))
% %
% %
% %     for i= 1:length(unique_peak_mz)
% %         for len = 1: length(unique_mascot_mz)
% %         if  unique_peak_mz(i)== unique_mascot_mz(len)
% %             unique_peak_mz(i,2)=1
% %         else
% %             unique_peak_mz(i,2)=0
% %         end
% %     end
% % end