%%%For matching mz values of Mascot and Mass Hunter data
%Mascot values be fetched from mascot file
%Mass Hunter data values will be fetched from csv file (generated by .d folder to mzXML and then csv file)

%This Code is compatible with MATLAB R2022a or higher
clc;
clear all;
disp("This Code is compatible with MATLAB R2022a or higher.");
%setwd('C:\Users\Maham\Dropbox\SpecOxi\NAR-WebServer\DataConversion\R\CheY')
tic;

Factor = 10^-2;      % Updated 202211222028

MatchTolerance = Factor;          % 0.0001;  % Updated 202211221613
MisMatchTolerance = Factor * 9;   % 0.0009;   % Updated 202211221613
OffTargetTolerance = 1;

TempDateAndTime = string(datetime('now','TimeZone','local','Format','yyyyMMddHHmmss'));
SubResultFolder = TempDateAndTime + "_Results_Tol_" + Factor;
MainResultFolder = pwd + "\Results\";
ResultsPath =  MainResultFolder + SubResultFolder + "\"; % TempDateAndTime + "_Results" + "\";       % Updated 202211221641
mkdir(fullfile(MainResultFolder,SubResultFolder));

%Reading Mass Hunter File
[MassHunterFileName, MassHunterFilePath] = uigetfile({'*.csv'}, 'Select Mass Hunter File');   % Updated 202211221622
MassHunterData = readmatrix(string(MassHunterFilePath) + string(MassHunterFileName));   % 'CheY_100.csv'     % Updated 202211221622
%colNames = {'RT_sec','m/z','Int','RT_min'};

%Reading mascot file
[MascotFileName, MascotFilePath] = uigetfile({'*.xlsx'}, 'Select Mascot File');   % Updated 202211221622
[~,~,MascotFile] = xlsread(string(MascotFilePath) + string(MascotFileName));    %xlsread('3ChY_MASCOT_File.xlsx');       % Updated 202211221622
Unique_Mascot_mz = double(unique(string(MascotFile(2:end,14))));

%Sorting Mass Hunter and Mascot Values
sortMassHunterData = sortrows(MassHunterData,2, 'ascend');
sortMascotData = sortrows(Unique_Mascot_mz,1, 'ascend');

%Size of sorted Matrices
sizeOfMassHunterData = size(sortMassHunterData,1);
sizeOfMascotData = size(sortMascotData,1);
NoOfRows = sizeOfMassHunterData * sizeOfMascotData;


% Need to check
% % % %Initializing Matrices
% % % ResultantMatrixMatches = strings(NoOfRows, 3);
% % % ResultantMatrixMisMatches = strings(NoOfRows, 3);


MatchIndex = 1;
MisMatchIndex = 1;

CombinedResultsMatchFile = "CombinedMatchResults.csv";
CombinedResultsMisMatchFile = "CombinedMisMatchResults.csv";

%Summarizing Data for Combined Matches File
MatchMzsWithCount = [];

NoMatchMzsFoundWithCount = [];

%Summarizing Data for Combined MisMatches File
MisMatchMzsWithCount = [];

NoMisMatchMzsFoundWithCount = [];



progressbar('Processing...');
for i=1:sizeOfMascotData
    
    TempMatch = [];
    TempMisMatch = [];
    
    progressbar(i/sizeOfMascotData);
    for j=1:sizeOfMassHunterData
        MatchDiff = sortMascotData(i,1) - sortMassHunterData(j,2);
        
        AbsMatchDiff = abs(MatchDiff);
        
        if(AbsMatchDiff >= OffTargetTolerance)
            continue;
        end
        
        
        if AbsMatchDiff <= MatchTolerance  %Match
            TempMatch = [TempMatch; sortMascotData(i,1), sortMassHunterData(j,2), MatchDiff];
            
        elseif (MatchTolerance < AbsMatchDiff && AbsMatchDiff < MisMatchTolerance)  %MisMatch
            TempMisMatch = [TempMisMatch; sortMascotData(i,1), sortMassHunterData(j,2), MatchDiff];
        end
    end
    MatchCount = size(TempMatch,1);
    MisMatchCount = size(TempMisMatch,1);
    TempMainMatchMatrix = [];
    if MatchCount ~= 0
        
        %%%% For Temp File Testing "TempMatch"
        TempMainMatchMatrix = string([sortMascotData(i,1), MatchCount, "";"Mascot_mz", "MassHunter_mz", "Difference"]);
        TempMainMatchMatrix = [ TempMainMatchMatrix; string(TempMatch); "","",""];
        writematrix(TempMainMatchMatrix, ResultsPath + sortMascotData(i,1) +"_Match.csv");
        
        MatchMzsWithCount = [MatchMzsWithCount; sortMascotData(i,1), MatchCount];
        % Need to check
        % % %                 ResultantMatrixMatches(MatchIndex:MatchIndex+1,:) = string([sortMascotData(i,1), MatchCount, ""; "Mascot_mz", "MassHunter_mz", "Difference"]);
        % % %                 MatchIndex = MatchIndex + 2;
        % % %                 ResultantMatrixMatches(MatchIndex:MatchIndex+MatchCount - 1,:) = string(TempMatch);
        % % %                 MatchIndex = MatchIndex + MatchCount;
    else
        TempMainMatchMatrix = string([sortMascotData(i,1), MatchCount, "";"Mascot_mz", "MassHunter_mz", "Difference"]);
        TempMainMatchMatrix = [ TempMainMatchMatrix; "No match found", "", ""; "","",""];
        writematrix(TempMainMatchMatrix, ResultsPath + sortMascotData(i,1) +"_Match.csv");
        
        NoMatchMzsFoundWithCount = [NoMatchMzsFoundWithCount; sortMascotData(i,1), MatchCount];
    end
    writematrix(TempMainMatchMatrix, ResultsPath + CombinedResultsMatchFile, 'WriteMode','append');

    TempMainMisMatchMatrix = [];
    if MisMatchCount ~= 0
        
        %%%% For Temp File Testing "TempMisMatch"
        TempMainMisMatchMatrix = string([sortMascotData(i,1), MisMatchCount, ""; "Mascot_mz", "MassHunter_mz", "Difference"]);
        TempMainMisMatchMatrix = [TempMainMisMatchMatrix; string(TempMisMatch); "","",""];
        writematrix(TempMainMisMatchMatrix, ResultsPath + sortMascotData(i,1)+"_MisMatch.csv");
        
        MisMatchMzsWithCount = [MisMatchMzsWithCount; sortMascotData(i,1), MisMatchCount];
        
        % Need to check
        % % %                 ResultantMatrixMisMatches(MisMatchIndex: MisMatchIndex+1,:) = string([sortMascotData(i,1), MisMatchCount, ""; "Mascot_mz", "MassHunter_mz", "Difference"]);
        % % %                 MisMatchIndex = MisMatchIndex + 2;
        % % %                 ResultantMatrixMisMatches(MisMatchIndex:MisMatchIndex+MisMatchCount-1,:) = string(TempMisMatch);
        % % %                 MisMatchIndex = MisMatchIndex + MisMatchCount;
    else
        TempMainMisMatchMatrix = string([sortMascotData(i,1), MisMatchCount, ""; "Mascot_mz", "MassHunter_mz", "Difference"]);
        TempMainMisMatchMatrix = [TempMainMisMatchMatrix; "No mismatch found", "", ""; "","",""];
        writematrix(TempMainMisMatchMatrix, ResultsPath + sortMascotData(i,1)+"_MisMatch.csv");
        
        NoMisMatchMzsFoundWithCount = [NoMisMatchMzsFoundWithCount; sortMascotData(i,1), MisMatchCount];
    end
    writematrix(TempMainMisMatchMatrix, ResultsPath + CombinedResultsMisMatchFile, 'WriteMode','append');

end

SummarizingMatchData = ["",""; "Summarizing Match Data", "" ;"Matched Mzs", "Count"; MatchMzsWithCount; "","" ; "No Matched Mzs Found", "Count"; NoMatchMzsFoundWithCount];
writematrix(SummarizingMatchData, ResultsPath + CombinedResultsMatchFile, 'WriteMode','append');


SummarizingMisMatchData = ["","" ; "Summarizing Mismatch Data", "" ;"Mismatched Mzs", "Count"; MisMatchMzsWithCount; "","" ; "No Mismatched Mzs Found", "Count"; NoMisMatchMzsFoundWithCount];
writematrix(SummarizingMisMatchData, ResultsPath + CombinedResultsMisMatchFile, 'WriteMode','append');


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