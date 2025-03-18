using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PerceptronXfmsAPI.Engine;
using PerceptronXfmsAPI.Repository;

namespace PerceptronXfmsAPI.Models
{
    public class ResultsDownloadDataCompile
    {
        public string QueryId;
        public string ResultId;
        public string MassSpectrumImageFilePath;
        public string JsonExpThrTable;

        public string JsonExpThrTableFilePath;
        public string CompleteDetailedResultsFilePath;



        public ResultsDownloadDataCompile(string cQueryId, string cResultId, string cMassSpectrumImageFilePath, string cJsonExpThrTable)
        {
            QueryId = cQueryId;
            ResultId = cResultId;
            MassSpectrumImageFilePath = cMassSpectrumImageFilePath;
            JsonExpThrTable = cJsonExpThrTable;
        }

        public ResultsDownloadDataCompile(ResultsDownloadDataCompile Data, string cJsonExpThrTableFilePath, string cCompleteDetailedResultsFilePath)
        {
            QueryId = Data.QueryId;
            ResultId = Data.ResultId;
            MassSpectrumImageFilePath = Data.MassSpectrumImageFilePath;
            JsonExpThrTable = Data.JsonExpThrTable;

            JsonExpThrTableFilePath = cJsonExpThrTableFilePath;
            CompleteDetailedResultsFilePath = cCompleteDetailedResultsFilePath;

        }

    }
}