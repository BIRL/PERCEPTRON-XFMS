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
%Update me 
%%this code will take ResultsBridge.xlsx and unmodified PDB and as a result
%%will modify the PDB
InputDir = uigetdir(pwd,'Select the Input folder' );

%Define PDB full file path (BELOW)
PDBDir=uigetfile({'*pdb;*.fasta;*.xlsx'},'Select a PDB File' );
dir_PDB= char(strcat(InputDir,strcat('\',PDBDir)));
%Define PDB full file path (ABOVE)

PDBFile = pdbread(dir_PDB);
%%%%%%%%%%%%%%%%%%%%%%%

%%% write the path to centrality files 
CentralityDir = uigetfile({'*xls;*.txt;*.xlsx'},'Select a Centrality file ' );
dir_Centrality= char(strcat(InputDir,strcat('\',CentralityDir)));
FileCentrality=readtable(dir_Centrality);
TfileMain = table2cell(FileCentrality)
chain= extractBefore(string(TfileMain(:,1)),'-') ;
Residue= extractBetween(string(TfileMain(:,1)),'-','-') ;
position=extractAfter(string(TfileMain(:,1)),6) ;
TableMerged=[chain,Residue,position];
TableRedunced=TfileMain(:,2:9);

TfileString=[TableMerged,TableRedunced];
Tfile=cellstr(TfileString);

PDBFile = pdbread(dir_PDB)

Pfile = PDBFile;

Tfile=string(Tfile);

%%%%%% remove the temp values 
for index= 1: length(Pfile.Model.Atom)
    Pfile.Model.Atom(index).tempFactor= '';
end
for index= 1: length(Pfile.Model.HeterogenAtom)
    Pfile.Model.HeterogenAtom(index).tempFactor= '';
end
%%%%% find the position of alpha carbon
pos=find( strcmp({Pfile.Model.Atom(:).chainID},'A'));
pos2=find(strcmp({Pfile.Model.HeterogenAtom(:).AtomName},'CA')& strcmp({Pfile.Model.HeterogenAtom(:).chainID},'A'));
pos3=find(strcmp({Pfile.Model.HeterogenAtom(:).AtomName},'O')& strcmp({Pfile.Model.HeterogenAtom(:).chainID},'A'));
% loop to replace the temp values by the PF value
for ind = 1: length(pos)
    j_ind=pos(ind);
ind2= Pfile.Model.Atom(j_ind).resSeq; 
i=find(Tfile(:,3)==string(ind2))
if isempty(i)
    %nothing
else
Pfile.Model.Atom(j_ind).tempFactor = Tfile(i,11);
end

end
% loop to repalce missing values with blanks 
for ind= 1: length(Pfile.Model.Atom)
if ismissing( Pfile.Model.Atom(ind).tempFactor)
    Pfile.Model.Atom(ind).tempFactor = '';
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in case of heterogenous atoms 
for ind = 1: length(pos3)
    j_ind=pos3(ind);
ind2= Pfile.Model.HeterogenAtom(j_ind).resSeq; 
i=find(Tfile(:,3)==string(ind2))
if isempty(i)
    %nothing
else

Pfile.Model.HeterogenAtom(j_ind).tempFactor = Tfile(i,11);
end
end

for ind= 1: length(Pfile.Model.HeterogenAtom)
if ismissing( Pfile.Model.HeterogenAtom(ind).tempFactor)
    Pfile.Model.HeterogenAtom(ind).tempFactor = '';
end
end


pdbwrite('CentralityModified.pdb',Pfile)
