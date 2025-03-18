using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PerceptronXfmsAPI.Engine;

namespace PerceptronXfmsAPI.Models
{
    public class ResultsDownloadFileNames
    {
        public string QueryId;
        public string ResultsFileName;
        public List<string> ImageFileNames;

        public ResultsDownloadFileNames(string cQueryId, string cResultsFileName, List<string> cImageFileNames)
        {
            QueryId = cQueryId;
            ResultsFileName = cResultsFileName;
            ImageFileNames = cImageFileNames;
        }
    }
}