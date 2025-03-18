using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using Newtonsoft.Json;

namespace PerceptronXfmsSimulationService.Utilities
{
    public class FetchPathsForFrustratometerResults
    {
        public string FetchFilePathsOfFrustratometerResults(string QueryResultFullPath, string FrustratometerFolder, string FrustratometerImageResultsFolder)
        {

            string path = QueryResultFullPath + "\\" + FrustratometerFolder;

            var dir = new DirectoryInfo(path);
            var FrustratometerResultsSubFolder = dir.GetDirectories()[0].Name;

            string ImagesFullPath = path + "\\" + FrustratometerResultsSubFolder + "\\" + FrustratometerImageResultsFolder;
            var getfile = new DirectoryInfo(ImagesFullPath);
            var temp = getfile.GetFiles();

            var ListOfPaths = new List<string>() {"", "", ""};
            string tempString = "";
            for (int i = 0; i < temp.Length; i++)
            {
                
                //Just for the safety measures hard coding the symmetry of the files name into the list
                tempString = temp[i].ToString();
                if (tempString.Contains("around.png"))
                {
                    ListOfPaths[0] = ImagesFullPath + "\\" + tempString;
                }
                if (tempString.Contains("dens.png"))
                {
                    ListOfPaths[1] = ImagesFullPath + "\\" + tempString;
                }
                if (tempString.Contains("configurational_map"))
                {
                    ListOfPaths[2] = ImagesFullPath + "\\" + tempString;
                }
            }
            string FrustratometerImagesFullPaths = JsonConvert.SerializeObject(ListOfPaths);

            return FrustratometerImagesFullPaths;
        }



    }
}
