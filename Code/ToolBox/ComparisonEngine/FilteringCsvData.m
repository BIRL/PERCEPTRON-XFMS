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
function FilteringCsvData(MascotFile,OutputDir, CsvInputFilesBeforeFilter)

%Reading mascot file
MascotData = double(string((MascotFile(2:end,14))));
UniqueMascotData = unique(MascotData, 'rows');
FormattingHeaderNewCSV = [ "Mass Hunter m/z", "Mass Hunter RT (min)", "Mass Hunter Int"];


% CsvInputFilesBeforeFilter = uigetdir(pwd,'Select mzXML Data Folder' );
files = dir(CsvInputFilesBeforeFilter);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];

% Extract only those that are directories.
Replicates = files(dirFlags); % A structure with extra info.

AllReplicate = {};
for number=1:size(Replicates,1)
    CurrentReplicate = Replicates(number).name;
    if(strcmp (CurrentReplicate, '.') || isempty(CurrentReplicate) || strcmp (CurrentReplicate, '..'))
        %do nothing
    else
        AllReplicate = [AllReplicate; CurrentReplicate];

        %1. Go into directory of Peptide and find the sub directories of
        %  Relicates
        dir_sub= char(strcat(CsvInputFilesBeforeFilter,strcat('\',Replicates(number).name)));
        PeakFiles= dir(dir_sub);
        % Read the replicates directory one after other
        AllPeakfiles = {};
        for num=1:size(PeakFiles,1)
            CurrentPeakFiles = PeakFiles(num).name;
            if (strcmp (CurrentPeakFiles, '.') || isempty(CurrentPeakFiles) || strcmp (CurrentPeakFiles, '..'))
                %do nothing
            else
                AllPeakFiles = [AllPeakfiles; CurrentPeakFiles];
                dir_file= char(strcat(dir_sub,strcat('\',PeakFiles(num).name)));

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                MassHunterFilePath=dir_file;
                MassHunterFileName=  CurrentPeakFiles;
                MassHunterData = readmatrix(string(MassHunterFilePath));
                %colNames = {'MASCOT m/z','MASCOT m/z','Difference','MASSHunter m/z','MASSHunter RT','MASSHunter Intensity'};
                Dose_start = strfind(string(CurrentPeakFiles),'-');
                Dose_start=Dose_start(1);
                Dose_end =strfind(string(CurrentPeakFiles),'-MS1');
                Dose  = extractBetween( string(CurrentPeakFiles),Dose_start+1,Dose_end-1);

                if ~isfolder(strcat(OutputDir,'\DataCSV'))
                    mkdir(strcat(OutputDir,'\DataCSV'));
                end
            
                if ~isfolder(strcat(OutputDir,'\DataCSV','\',CurrentReplicate))
                    mkdir(strcat(OutputDir,'\DataCSV','\',CurrentReplicate));
                end
      


                Name_end = strfind(string(CurrentPeakFiles),'-');
                Name_end=Name_end(1);
                Updated_name  = extractBetween( string(CurrentPeakFiles),1,Name_end-1);

                %colNames = {'RT_sec','m/z','Int','RT_min'};
                UpdatedCSVFileName = Updated_name+'_TC'+Dose+'.csv';
                ResultsPath=strcat(OutputDir,'\DataCSV','\',CurrentReplicate,'\');

                writematrix([FormattingHeaderNewCSV], ResultsPath +UpdatedCSVFileName, 'WriteMode','append');
                for i= 1: length(UniqueMascotData)
                    mzvalue_indecimal= UniqueMascotData(i);
                    IDForExtractionAfterDecimal_MASSHUNTER = strfind(string(mzvalue_indecimal),'.');
                    if isempty(IDForExtractionAfterDecimal_MASSHUNTER)
                        mzvalue =string( mzvalue_indecimal);

                    else
                        mzvalue = extractBetween( string(mzvalue_indecimal),1,IDForExtractionAfterDecimal_MASSHUNTER+1);
                    end
                    %id=find(contains(string(MassHunterData(:,4)),mzvalue))
                    ExtractedFile=MassHunterData(find(contains(string(MassHunterData(:,2)),mzvalue)),:);
                    ExtractedFile= ExtractedFile(:,2:4);
                     writematrix([ExtractedFile], ResultsPath + UpdatedCSVFileName, 'WriteMode','append');
                    
                end
                
            end
        
        end
    end
  

end
