function CopyingDataToResultsFolder(FastaFullFileName, QueryResultFullPath)
%Copying Fasta File from Input Folder to Results Folder

[status,message,messageId] = copyfile(FastaFullFileName, QueryResultFullPath);


if(status ~= 1) % status of 1 and an empty message and messageId confirm the copy was successful

    %throw exception
    %Maybe we can write file that unable to provide fasta file information
end

end

