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
function GeneratingMassHunterFiles(RepArr, MascotFile,OutputDir)
SequenceColumn= MascotFile(2:length(MascotFile),23)
UniqueSequence=unique(SequenceColumn)

%%%%%%%%%%%%%%%%%% Read Peak Files
%ProjectData = uigetdir(pwd,'Select PeakList Data Folder' );

ProjectDataDir=strcat(OutputDir,'\DataCSV');   %   ,'\'
files = dir(ProjectDataDir);

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];

% Extract only those that are directories.
Replicates = files(dirFlags); % A structure with extra info.

AllReplicate = {};
for number=1: size(Replicates,1)

    CurrentReplicate = Replicates(number).name;
    if(strcmp (CurrentReplicate, '.') || isempty(CurrentReplicate) || strcmp (CurrentReplicate, '..'))
        %do nothing
    else
        AllReplicate = [AllReplicate; CurrentReplicate];

        %1. Go into directory of Peptide and find the sub directories of
        %  Relicates
        dir_sub= char(strcat(ProjectDataDir,strcat('\',CurrentReplicate)));  %%Replicates(number).name
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
                Dose_start = strfind(string(CurrentPeakFiles),'_');
                Dose_end =strfind(string(CurrentPeakFiles),'.');
                Dose  = extractBetween( string(CurrentPeakFiles),Dose_start+1,Dose_end-1);

                for i= 1:length(UniqueSequence)
                    sequence=UniqueSequence(i);
                    sequence = char(sequence);
                    amino_acids = ['A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'H', 'I', 'L', 'K', 'M', 'F', 'P', 'S', 'T', 'W', 'Y', 'V'];
                    %Average_amino_acid_masses = [71.03779, 156.1857, 114.1026, 115.0874, 103.1429, 129.114, 128.1292, 57.0513, 137.1393, 113.1576, 113.1576,...
                    %128.1723, 131.1961, 147.1739, 97.1152, 87.0773, 101.1039, 186.2099, 163.1733, 99.1311];
                    Monoisotopic_amino_acid_masses = [71.03711, 156.10111, 114.04293, 115.02694, 103.00919, 129.04259, 128.05858, 57.02146, 137.05891, 113.08406, 113.08406,...
                        128.09496, 131.04049, 147.06841, 97.05276, 87.03203, 101.04768, 186.07931, 163.06333, 99.06841];
                    [~, sizeofsequence] = size(sequence);
                    Theoretical_peptide_weight = 0;

                    % along the complete length of sequence
                    for alongsequencesize = 1:sizeofsequence
                        for alongaminoacids = 1:20

                            if amino_acids(alongaminoacids)== sequence(alongsequencesize)
                                Theoretical_peptide_weight = Theoretical_peptide_weight + Monoisotopic_amino_acid_masses(alongaminoacids);
                            end
                        end
                    end
                    Theoretical_peptide_weight = Theoretical_peptide_weight + 18.01524;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%  unoxidize m/z  WITH CHARGE STATE 2 ,3 ,4
                    IndexTable=1;
                    Unoxidize= (Theoretical_peptide_weight + 2)/2;
                    Unoxidize_mz1(IndexTable)= Unoxidize;
                    Unoxidize= (Theoretical_peptide_weight + 3)/3;
                    IndexTable=IndexTable+1;
                    Unoxidize_mz1(IndexTable) = Unoxidize;
                    Unoxidize= (Theoretical_peptide_weight + 4)/4;
                    IndexTable=IndexTable+1;
                    Unoxidize_mz1(IndexTable) = Unoxidize;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%  oxidize m/z
                    %%%%%%%%%%% OXIDATION NUMBER = 2,3,4 and charge state = 2 3
                    IndexTable=1;
                    oxidize= (Theoretical_peptide_weight + 2+16)/2;
                    Oxidize_mz1(IndexTable)= oxidize;
                    oxidize= (Theoretical_peptide_weight + 3+16)/3;
                    IndexTable=IndexTable+1;
                    Oxidize_mz1(IndexTable) = oxidize;
                    oxidize= (Theoretical_peptide_weight + 4+16)/4;
                    IndexTable=IndexTable+1;
                    Oxidize_mz1(IndexTable) = oxidize;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    oxidize= (Theoretical_peptide_weight + 2+32)/2;
                    IndexTable=IndexTable+1;
                    Oxidize_mz1(IndexTable) = oxidize;
                    oxidize= (Theoretical_peptide_weight + 3+32)/3;
                    IndexTable=IndexTable+1;
                    Oxidize_mz1(IndexTable) = oxidize;
                    oxidize= (Theoretical_peptide_weight + 4+32)/4;
                    IndexTable=IndexTable+1;
                    Oxidize_mz1(IndexTable) = oxidize;
                    oxidize= (Theoretical_peptide_weight + 2+48)/2;
                    IndexTable=IndexTable+1;
                    Oxidize_mz1(IndexTable)=oxidize;
                    oxidize= (Theoretical_peptide_weight + 3+48)/3;
                    IndexTable=IndexTable+1;
                    Oxidize_mz1(IndexTable) = oxidize;
                    oxidize= (Theoretical_peptide_weight + 4+48)/4;
                    IndexTable=IndexTable+1;
                    Oxidize_mz1(IndexTable) = oxidize;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%Tolernce for Molecular  weights

                    for index= 1: length(Unoxidize_mz1)
                        mzvalue_indecimal= Unoxidize_mz1(index);
                        IDForExtractionAfterDecimal_MASSHUNTER = strfind(string(mzvalue_indecimal),'.');
                        if isempty(IDForExtractionAfterDecimal_MASSHUNTER)
                            mzvalue =string( mzvalue_indecimal)+'.0';

                        else
                            mzvalue = extractBetween( string(mzvalue_indecimal),1,IDForExtractionAfterDecimal_MASSHUNTER+1);
                        end
                        %id=find(contains(string(MassHunterData(:,4)),mzvalue))
                        new=MassHunterData(find(contains(string(MassHunterData(:,1)),mzvalue)),:);

                        if ~isempty(new)
                            if ~isfolder(strcat(OutputDir,'\\EIC_Result'))
                                mkdir(strcat(OutputDir,'\\EIC_Result'));
                            end


                            currentpeptide='Peptide'+ string(i)
                            if ~isfolder(strcat(OutputDir,'\EIC_Result','\',currentpeptide))
                                mkdir(strcat(OutputDir,'\EIC_Result','\',currentpeptide));
                            end


                            if ~isfolder(strcat(OutputDir,'\EIC_Result','\',currentpeptide,'\',CurrentReplicate))
                                mkdir(strcat(OutputDir,'\EIC_Result','\',currentpeptide,'\',CurrentReplicate));
                            end
                            ResultDir= strcat(OutputDir,'\EIC_Result','\',currentpeptide,'\',CurrentReplicate,'\');
                            Filename= Dose+"_"+mzvalue+'.xlsx';
                            Header= {'MASSHunter m/z','MASSHunter Intensity','MASSHunter RT'};
                            xlswrite(ResultDir+Filename,new, 'Sheet1', 'A2');
                            xlswrite(ResultDir+Filename ,Header, 'Sheet1', 'A1');

                        else
                            %donothing
                        end
                    end

                    for index= 1: length(Oxidize_mz1)
                        mzvalue_indecimal= Oxidize_mz1(index);
                        IDForExtractionAfterDecimal_MASSHUNTER = strfind(string(mzvalue_indecimal),'.');
                        if isempty(IDForExtractionAfterDecimal_MASSHUNTER)
                            mzvalue = string(mzvalue_indecimal)+'.0';

                        else
                            mzvalue = extractBetween( string(mzvalue_indecimal),1,IDForExtractionAfterDecimal_MASSHUNTER+1);
                        end
                        %id=find(contains(string(MassHunterData(:,4)),mzvalue))
                        new=MassHunterData(find(contains(string(MassHunterData(:,1)),mzvalue)),:);
                        if ~isempty(new)
                            if ~isfolder(strcat(OutputDir,'\\EIC_Result'))
                                mkdir(strcat(OutputDir,'\\EIC_Result'));
                            end


                            currentpeptide='Peptide'+ string(i)
                            if ~isfolder(strcat(OutputDir,'\EIC_Result','\',currentpeptide))
                                mkdir(strcat(OutputDir,'\EIC_Result','\',currentpeptide));
                            end


                            if ~isfolder(strcat(OutputDir,'\EIC_Result','\',currentpeptide,'\',CurrentReplicate))
                                mkdir(strcat(OutputDir,'\EIC_Result','\',currentpeptide,'\',CurrentReplicate));
                            end
                            ResultDir= strcat(OutputDir,'\EIC_Result','\',currentpeptide,'\',CurrentReplicate,'\');

                            Filename= Dose+"_"+mzvalue+'.xlsx';
                            Header= {'MASSHunter m/z','MASSHunter Intensity','MASSHunter RT'};
                            xlswrite(ResultDir+Filename,new, 'Sheet1', 'A2');
                            xlswrite(ResultDir+Filename ,Header, 'Sheet1', 'A1');

                        else
                            % donothing
                        end
                    end
                end

            end

        end
    end
end



