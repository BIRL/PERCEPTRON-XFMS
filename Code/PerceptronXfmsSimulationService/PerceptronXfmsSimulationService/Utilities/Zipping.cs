using System;
using System.IO;
using System.Collections.Generic;
using System.IO.Compression;
using PerceptronXfmsSimulationService.Constants;

namespace PerceptronXfmsSimulationService.Utilities
{
    public class Zipping
    {
        public string ZippingOutputFiles(string ResultFolderPath, string QueryResultFullPath, string Title, string QueryID)
        {
            string ZipFullFileName = ResultFolderPath + "\\" + Title + "_" + QueryID + ".zip";
            if (File.Exists(ZipFullFileName))
            {
                File.Delete(ZipFullFileName); //Deleted Pre-existing file
            }


            string sa = Path.GetFileName(QueryResultFullPath);

            ZipFile.CreateFromDirectory(QueryResultFullPath, ZipFullFileName);

            return ZipFullFileName;
        }
    }
}