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
function FileMergeNew(UniqueSequence)
datamatch=[];

for peptideIndextomatch= 1:length(UniqueSequence)


    match=find(contains(UniqueSequence,UniqueSequence(peptideIndextomatch)));
    datamatch(peptideIndextomatch,1:length(match))= match;

end
PeptidetoMatch= datamatch(:,2) == 0   % for which rows is column 3 larger than 5
datamatch(PeptidetoMatch,:) = [];
myFolder= char(strcat(pwd,strcat('\','Results_matched')));
% Get a list of all files in the folder with the desired file name pattern.
FilePattern = fullfile(myFolder, '**\*.xlsx');
TheFiles = dir(FilePattern);
location=cell(10, 1);
for peptide = 1 : length(TheFiles)
    % Extracting the name of file with extension
    BaseFileName = TheFiles(peptide).name;
    % Extracting the complete name (Location + Name)
    FullFileName = fullfile(TheFiles(peptide).folder, BaseFileName);
    location(peptide)={fullfile(TheFiles(peptide).folder, BaseFileName)};
    % Read the .xlsx file;
    [num, txt, File{peptide}] = xlsread(FullFileName);
    % Extracting the Name of file without the extension
    [myFolder,name,ext] = fileparts(FullFileName);
    fprintf(1, 'Now reading %s\n', FullFileName);
    % File=File(:,any(~ismissing(File(2:length(File),:))))
    %Get size of file
    SizeOfFile = size(File);
end
length(File);
idxx=1;
for i= 1: length(datamatch)
    pep= datamatch(i,:);
    pep( :, ~any(pep,1) ) = [];
    if length(pep)==2
        j= 1;
        name=strcat("Peptide"+pep(j)+"\");
        Pep_ToMatch= find(contains(location,name));
        if ~isempty(Pep_ToMatch)
            [num, txt, FileMat] = xlsread(string(location(Pep_ToMatch(1))));
            name2=strcat("Peptide"+pep(j+1)+"\");
            Pep_ToMatch2= find(contains(location,name2));
            if ~isempty(Pep_ToMatch2)

                [num, txt, FileMat2] = xlsread(string(location(Pep_ToMatch2(1))));
                num=0;
                num2=0;
                [row_ind1, row_end1] = XRayDosageDataBlockIndicesCaseOne(FileMat);
                [row_ind2, row_end2] = XRayDosageDataBlockIndicesCaseTwo(FileMat2);

                for pos=1:length(row_ind1)
                    %Extracting rows between the index of first row and the last row within a block of X-ray dosage
                    row= row_ind1(pos): row_end1(pos);
                    length(row);
                    %%%%%%%%%%%%%%%%%%%%%%%
                    %saving the rows and columns having same dosage and
                    %same residue in new file
                    row2= row_ind2(pos): row_end2(pos);
                    index=5;
                    data(row_ind1(pos)+num: row_end1(pos)+num,1:4)= FileMat(row_ind1(pos): row_end1(pos),1:4);
                    data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,1:4)= FileMat2(row_ind2(pos): row_end2(pos),1:4);
                    FileMat2(row_ind2(pos): row_end2(pos),1:4)= {0};
                    % add the length
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% for residues
                    % it replaces Zeros at postiosn thta have beem merged
                    % so the ultimately the whole file has nothing but zero
                    %  and it cannot be resued again
                    for index2= 5: size(FileMat2,2)
                        if string(FileMat2(1,index2))== string(FileMat(1,index))
                            data(row_ind1(pos)+num: row_end1(pos)+num,index2)= FileMat(row_ind1(pos): row_end1(pos),index);
                            data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,index2)= FileMat2(row_ind2(pos): row_end2(pos),index2);
                            FileMat2(row_ind2(pos): row_end2(pos),index2)={0};
                            index=min(size(FileMat,2),index+1);
                        else
                            data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,index2)= FileMat2(row_ind2(pos): row_end2(pos),index2);
                            FileMat2(row_ind2(pos): row_end2(pos),index2)={0};
                        end
                    end
                    num=num+length(row2);
                    num2=num2+length(row);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %emptythe file
                FirstColumn = data(:,1);
                Storage = [];
                for index = 1:size(FirstColumn,1)
                    CellTemp = FirstColumn(index);
                    if iscellstr(CellTemp)
                        strTemp = string(CellTemp);
                        Storage = [Storage; [strTemp index] ];
                    end
                end
                idx=[];
                jidx=1;
                for id= 2:2:size(Storage,1)
                    idx(jidx)= Storage(id,2);
                    jidx=jidx+1;
                end
                data(idx,:)=[];
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Make new folder to save newly made merged file
                if ~isfolder(strcat(pwd,'\\Resultsnew1'))
                    mkdir('Resultsnew1');
                end

                cd ('Resultsnew1')
                Header = string(FileMat2(1,:));
                %Location of the files that are merged
                loc= location(Pep_ToMatch(1));
                out=regexp(loc,'\','split');
                out=out{1};
                length(out);
                % creating the folder with appropriate peptide name
                CurrentPeptide=out{length(out)-2};
                CurrentReplicate=out{length(out)-1};
                mkdir(CurrentPeptide);
                cd(CurrentPeptide);
                mkdir(CurrentReplicate);
                cd(CurrentReplicate);
                directories{idxx}=CurrentPeptide;
                idxx=idxx+1;
                delete([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx']);
                temp = data(:,5: size(data,2));
                temp(cellfun(@(x)isscalar(x) && isnan(x),temp)) = {0};
                data(:,5: size(data,2)) = temp;
                tf=cellfun('isempty',data );
                data(tf)={0};
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx'],data, 'Sheet1', 'A1');
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx'],Header, 'Sheet1', 'A1');
                clear data;
                cd ..\..\..
                cd('Results_matched');
                loc= location(Pep_ToMatch2(1));
                out=regexp(loc,'\','split');
                out=out{1};
                length(out);
                CurrentPeptide=out{length(out)-2};
                CurrentReplicate=out{length(out)-1};
                cd(CurrentPeptide);
                cd(CurrentReplicate);
                directories{idxx}=CurrentPeptide;
                idxx=idxx+1;
                delete([strcat(CurrentPeptide, CurrentReplicate),'.xlsx']);
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'.xlsx'],FileMat2, 'Sheet1', 'A1');
                Header = string(FileMat2(1,:));
                Header = cell(1,length(Header));
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'.xlsx'],Header, 'Sheet1', 'A1');
                cd ..\..\..
            end
        end
    end
end

for i= 1: length(datamatch)
    pep= datamatch(i,:);
    pep( :, ~any(pep,1) ) = [];
    if length(pep)==2
        j= 1;
        name=strcat("Peptide"+pep(j)+"\");
        Pep_ToMatch= find(contains(location,name));
        if ~isempty(Pep_ToMatch)
            [num, txt, FileMat] = xlsread(string(location(Pep_ToMatch(2))));
            name2=strcat("Peptide"+pep(j+1)+"\");
            if ~isempty(Pep_ToMatch2)
                Pep_ToMatch2= find(contains(location,name2));
                [num, txt, FileMat2] = xlsread(string(location(Pep_ToMatch2(2))));

num=0;
            num2=0;
                [row_ind1, row_end1] = XRayDosageDataBlockIndicesCaseOne(FileMat);
                [row_ind2, row_end2] = XRayDosageDataBlockIndicesCaseTwo(FileMat2);

                for pos=1:length(row_ind1)
                    %Extracting rows between the index of first row and the last row within a block of X-ray dosage
                    row= row_ind1(pos): row_end1(pos);
                    length(row);
                    %%%%%%%%%%%%%%%%%%%%%%%
                    %saving the rows and columns having same dosage and
                    %same residue in new file
                    row2= row_ind2(pos): row_end2(pos);
                    index=5;
                    data(row_ind1(pos)+num: row_end1(pos)+num,1:4)= FileMat(row_ind1(pos): row_end1(pos),1:4);
                    data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,1:4)= FileMat2(row_ind2(pos): row_end2(pos),1:4);
                    FileMat2(row_ind2(pos): row_end2(pos),1:4)= {0};
                    % add the length
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% for residues
                    % it replaces Zeros at postiosn thta have beem merged
                    % so the ultimately the whole file has nothing but zero
                    %  and it cannot be resued again
                    for index2= 5: size(FileMat2,2)
                        if string(FileMat2(1,index2))== string(FileMat(1,index))
                            data(row_ind1(pos)+num: row_end1(pos)+num,index2)= FileMat(row_ind1(pos): row_end1(pos),index);
                            data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,index2)= FileMat2(row_ind2(pos): row_end2(pos),index2);
                            FileMat2(row_ind2(pos): row_end2(pos),index2)={0};
                            index=min(size(FileMat,2),index+1);
                        else
                            data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,index2)= FileMat2(row_ind2(pos): row_end2(pos),index2);
                            FileMat2(row_ind2(pos): row_end2(pos),index2)={0};
                        end
                    end
                    num=num+length(row2);
                    num2=num2+length(row);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %emptythe file
                FirstColumn = data(:,1);
                Storage = [];
                for index = 1:size(FirstColumn,1)
                    CellTemp = FirstColumn(index);
                    if iscellstr(CellTemp)
                        strTemp = string(CellTemp);
                        Storage = [Storage; [strTemp index] ];
                    end
                end
                idx=[];
                jidx=1;
                for id= 2:2:size(Storage,1)
                    idx(jidx)= Storage(id,2);
                    jidx=jidx+1;
                end
                data(idx,:)=[];
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Make new folder to save newly made merged file
                if ~isfolder(strcat(pwd,'\\Resultsnew1'))
                    mkdir('Resultsnew1');
                end

                cd ('Resultsnew1')
                Header = string(FileMat2(1,:));
                %Location of the files that are merged
                loc= location(Pep_ToMatch(2));
                out=regexp(loc,'\','split');
                out=out{1};
                length(out);
                % creating the folder with appropriate peptide name
                CurrentPeptide=out{length(out)-2};
                CurrentReplicate=out{length(out)-1};
                mkdir(CurrentPeptide);
                cd(CurrentPeptide);
                mkdir(CurrentReplicate);
                cd(CurrentReplicate);
                directories{idxx}=CurrentPeptide;
                idxx=idxx+1;
                delete([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx']);
                temp = data(:,5: size(data,2));
                temp(cellfun(@(x)isscalar(x) && isnan(x),temp)) = {0};
                data(:,5: size(data,2)) = temp;
                tf=cellfun('isempty',data );
                data(tf)={0};
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx'],data, 'Sheet1', 'A1');
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx'],Header, 'Sheet1', 'A1');
                clear data;
                cd ..\..\..
                cd('Results_matched');
                loc= location(Pep_ToMatch2(2));
                out=regexp(loc,'\','split');
                out=out{1};
                length(out);
                CurrentPeptide=out{length(out)-2};
                CurrentReplicate=out{length(out)-1};
                cd(CurrentPeptide);
                cd(CurrentReplicate);
                directories{idxx}=CurrentPeptide;
                idxx=idxx+1;
                delete([strcat(CurrentPeptide, CurrentReplicate),'.xlsx']);
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'.xlsx'],FileMat2, 'Sheet1', 'A1');
                Header = string(FileMat2(1,:));
                Header = cell(1,length(Header));
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'.xlsx'],Header, 'Sheet1', 'A1');
                cd ..\..\..
            end
        end
    end
end

for i= 1: length(datamatch)
    pep= datamatch(i,:);
    pep( :, ~any(pep,1) ) = [];
    if length(pep)==2
        j= 1;
        name=strcat("Peptide"+pep(j)+"\");
        Pep_ToMatch= find(contains(location,name));
        if ~isempty(Pep_ToMatch)
            [num, txt, FileMat] = xlsread(string(location(Pep_ToMatch(3))));
            name2=strcat("Peptide"+pep(j+1)+"\");
            Pep_ToMatch2= find(contains(location,name2));
            if ~isempty(Pep_ToMatch2)
                [num, txt, FileMat2] = xlsread(string(location(Pep_ToMatch2(3))));

num=0;
            num2=0;
                [row_ind1, row_end1] = XRayDosageDataBlockIndicesCaseOne(FileMat);
                [row_ind2, row_end2] = XRayDosageDataBlockIndicesCaseTwo(FileMat2);

                for pos=1:length(row_ind1)
                    %Extracting rows between the index of first row and the last row within a block of X-ray dosage
                    row= row_ind1(pos): row_end1(pos);
                    length(row);
                    %%%%%%%%%%%%%%%%%%%%%%%
                    %saving the rows and columns having same dosage and
                    %same residue in new file
                    row2= row_ind2(pos): row_end2(pos);
                    index=5;
                    data(row_ind1(pos)+num: row_end1(pos)+num,1:4)= FileMat(row_ind1(pos): row_end1(pos),1:4);
                    data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,1:4)= FileMat2(row_ind2(pos): row_end2(pos),1:4);
                    FileMat2(row_ind2(pos): row_end2(pos),1:4)= {0};
                    % add the length
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% for residues
                    % it replaces Zeros at postiosn thta have beem merged
                    % so the ultimately the whole file has nothing but zero
                    %  and it cannot be resued again
                    for index2= 5: size(FileMat2,2)
                        if string(FileMat2(1,index2))== string(FileMat(1,index))
                            data(row_ind1(pos)+num: row_end1(pos)+num,index2)= FileMat(row_ind1(pos): row_end1(pos),index);
                            data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,index2)= FileMat2(row_ind2(pos): row_end2(pos),index2);
                            FileMat2(row_ind2(pos): row_end2(pos),index2)={0};
                            index=min(size(FileMat,2),index+1);
                        else
                            data(row_ind2(pos)+length(row)+num2: row_end2(pos)+length(row)+num2,index2)= FileMat2(row_ind2(pos): row_end2(pos),index2);
                            FileMat2(row_ind2(pos): row_end2(pos),index2)={0};
                        end
                    end
                    num=num+length(row2);
                    num2=num2+length(row);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %emptythe file
                FirstColumn = data(:,1);
                Storage = [];
                for index = 1:size(FirstColumn,1)
                    CellTemp = FirstColumn(index);
                    if iscellstr(CellTemp)
                        strTemp = string(CellTemp);
                        Storage = [Storage; [strTemp index] ];
                    end
                end
                idx=[];
                jidx=1;
                for id= 2:2:size(Storage,1)
                    idx(jidx)= Storage(id,2);
                    jidx=jidx+1;
                end
                data(idx,:)=[];
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Make new folder to save newly made merged file
                if ~isfolder(strcat(pwd,'\\Resultsnew1'))
                    mkdir('Resultsnew1');
                end

                cd ('Resultsnew1')
                Header = string(FileMat2(1,:));
                %Location of the files that are merged
                loc= location(Pep_ToMatch(3));
                out=regexp(loc,'\','split');
                out=out{1};
                length(out);
                % creating the folder with appropriate peptide name
                CurrentPeptide=out{length(out)-2};
                CurrentReplicate=out{length(out)-1};
                mkdir(CurrentPeptide);
                cd(CurrentPeptide);
                mkdir(CurrentReplicate);
                cd(CurrentReplicate);
                directories{idxx}=CurrentPeptide;
                idxx=idxx+1;
                delete([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx']);
                temp = data(:,5: size(data,2));
                temp(cellfun(@(x)isscalar(x) && isnan(x),temp)) = {0};
                data(:,5: size(data,2)) = temp;
                tf=cellfun('isempty',data );
                data(tf)={0};
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx'],data, 'Sheet1', 'A1');
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'o.xlsx'],Header, 'Sheet1', 'A1');
                clear data;
                cd ..\..\..
                cd('Results_matched');
                loc= location(Pep_ToMatch2(3));
                out=regexp(loc,'\','split');
                out=out{1};
                length(out);
                CurrentPeptide=out{length(out)-2};
                CurrentReplicate=out{length(out)-1};
                cd(CurrentPeptide);
                cd(CurrentReplicate);
                directories{idxx}=CurrentPeptide;
                idxx=idxx+1;
                delete([strcat(CurrentPeptide, CurrentReplicate),'.xlsx']);
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'.xlsx'],FileMat2, 'Sheet1', 'A1');
                Header = string(FileMat2(1,:));
                Header = cell(1,length(Header));
                xlswrite([strcat(CurrentPeptide, CurrentReplicate),'.xlsx'],Header, 'Sheet1', 'A1');
                cd ..\..\..
            end
        end
    end

end




if isfolder(strcat(pwd,'\\Resultsnew1'))
    cd('Results_matched');
    %% removing the merge directories
directories=unique(directories);
    for RowIndexMergeFile=1:size(directories,2)
        rmdir(string(directories(RowIndexMergeFile)),'s');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % saving the unmodified folders in new Directories
    cd ..
    direc= char(strcat(pwd,strcat('\Results_matched')));
    copyfile(direc,'Resultsnew1');
else
    % do nothing
end