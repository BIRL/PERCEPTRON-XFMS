using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PerceptronXfmsSimulationService.Utilities
{
    public class Call2ExcelFileReader
    {

        public string Call2ExcelFileReaderMatlab(string MatlabScriptsFullPath, string ResultFolderPath, string subName, string QueryID, string ExcelFileNameForReading)
        {
            //string JsonSearchQuery = JsonConvert.SerializeObject(new { Json = SearchQuery });

            string ExcelFullFileName = ResultFolderPath + "\\" + subName + QueryID + "\\"  + ExcelFileNameForReading;
            // Create the MATLAB instance 
            MLApp.MLApp matlab2 = new MLApp.MLApp();
            matlab2.Visible = 1; // Make MATLAB visible


            // Change to the directory where the function is located 
            matlab2.Execute("cd " + MatlabScriptsFullPath);
            

            // Define the output 
            object MatlabPipelineResults = null;

            // Call the MATLAB function myfunc
            matlab2.Feval("ExcelFileReaderMatab", 1, out MatlabPipelineResults, ExcelFullFileName);



            // Display result 
            object[] MatlabPipelineResultsObj = MatlabPipelineResults as object[];

            matlab2.Quit();

            return MatlabPipelineResultsObj[0].ToString();

        }
    }
}
