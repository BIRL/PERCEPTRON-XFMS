using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using PerceptronXfmsSimulationService.DTO;

namespace PerceptronXfmsSimulationService.EngineCalling
{
    public class Calling2Engine
    {

        public Call2MATLABDto Call2MATLAB(string MatlabMainFileFullPath, SearchXfmsQueryDto SearchQuery)
        {
            //string JsonSearchQuery = JsonConvert.SerializeObject(new { Json = SearchQuery });

            // Create the MATLAB instance 
            MLApp.MLApp matlab = new MLApp.MLApp();
            matlab.Visible = 1; // Make MATLAB visible

            // Change to the directory where the function is located 
            matlab.Execute(@"cd " + MatlabMainFileFullPath);
          

            // Define the output 
            object MatlabPipelineResults = null;
            Console.WriteLine($"QueryID: {SearchQuery.QueryID}");
            Console.WriteLine($"isBridgeEnabled: {SearchQuery.isBridgeEnabled}");
            Console.WriteLine($"isFrustratometerEnabled: {SearchQuery.isFrustratometerEnabled}");

            // Call the MATLAB function myfunc
            matlab.Feval("Main", 3, out MatlabPipelineResults, SearchQuery.QueryID, SearchQuery.isBridgeEnabled, SearchQuery.isFrustratometerEnabled);

            // Display result 
            object[] MatlabPipelineResultsObj = MatlabPipelineResults as object[];

            var Call2MatlabDataObj = new Call2MATLABDto()
            {
                QueryResultFullPath = MatlabPipelineResultsObj[0].ToString(),
                Error = MatlabPipelineResultsObj[1].ToString(),
                ErrorLog = MatlabPipelineResultsObj[2].ToString()
            };

            matlab.Quit();

            if (Call2MatlabDataObj.Error == "True")
            {
                throw (new Exception(Call2MatlabDataObj.ErrorLog));
            }

            return Call2MatlabDataObj;
        }
    }
}


//Console.WriteLine(res[0]);
//Console.WriteLine(res[1]);
//// Get user input to terminate program
//Console.ReadLine();