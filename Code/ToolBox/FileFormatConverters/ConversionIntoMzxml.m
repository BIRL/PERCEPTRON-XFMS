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
function mzXMLFilesInfo = ConversionIntoMzxml(InputFilesData, MSConvertCMDPath, MainProcessingFolder)
%This function is converting all .d folders into mzXML by further calling
%other function.. And those input files which are already into mzXML file
%format ...is just copying from input folder to the Processing folder...
%Just for maintaining the single source CopyPasting of mzXML is kept here..
%Why copy pasting is required?? Just for homogeneity such that all input
%files should be at same place..

mzXMLFilesInfo = strings(size(InputFilesData,1),3);

for index = 1: size(InputFilesData,1)

    mzXMLFileOutputDir = MainProcessingFolder + InputFilesData(index,5);
    MzxmlFileName = InputFilesData(index,1) + ".mzXML";
    NewMzxmlFullFilename = mzXMLFileOutputDir+ "\" + MzxmlFileName;

    %Just for safety purpose otherwise not needed - first deleting mzXML file if
    %already exists and then creates a new one.
    delete(NewMzxmlFullFilename);

    if InputFilesData(index,3) == ".d"

        CallMSConvertCMD(MSConvertCMDPath, InputFilesData(index,:), mzXMLFileOutputDir);

    elseif (InputFilesData(index,3) == ".mzXML")

        %If input file is mzXML then no need of conversion just copy paste
        %it from Input folder to processing folder
        InputMzxmlPath = InputFilesData(index,4) + "\" + InputFilesData(index,2);
        [status, msg] = copyfile(InputMzxmlPath, mzXMLFileOutputDir);

        %A status of 1 and an empty message and messageId confirm the copy was successful.
        if (status ~= 1)

            % throw(ME)
            %Permission issue while copying the file please change the directory of
            %Processing folder and then proceed
            % #DevUse - print [[  msg  ]] error
        end
    end

    mzXMLFilesInfo(index,:) = [InputFilesData(index,5), mzXMLFileOutputDir, MzxmlFileName];
    
end

end

% 
% 
% 
% %% CONVERTING .D FOLDER TO MZXML FILE AND WILL RETURNS THE FILE PATH
% if (InExt == '.d')     % CONVERTING .D FOLDER TO MZXML FILE AND WILL RETURNS THE FILE PATH
% 
%    
% 
%     %FARHAN - Here should go the list of .d folders with full path
%     DFolderFullPath = [ InFilePath '\' InFileName InExt];
%     MSConvertOutputResultFolder = '.\MSConvertOutputResultFolder';
%     % Using MSConvert .d folder to mzXML
%     mzXMLFullFileName = dFolderToMzxmlConverter(MSConvertCMDPath, DFolderFullPath,MSConvertOutputResultFolder);
% 
%     
% 
% elseif (InExt == '.mzXML')
% 
%         mzXMLFullFileName = [ InFilePath '\' InFileName '\' InExt];
% 
% else
% 
%     msgbox("File format is incompatible. Please either use .d folder or .mzXML file for computations.", "File Format Not Supported", "error");
% 
% end
% 
