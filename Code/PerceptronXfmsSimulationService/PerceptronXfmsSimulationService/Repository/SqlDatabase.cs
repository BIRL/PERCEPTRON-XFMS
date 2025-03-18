using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PerceptronXfmsSimulationService.Models;
using PerceptronXfmsSimulationService.DTO;
using PerceptronXfmsSimulationService.Utilities;

namespace PerceptronXfmsSimulationService.Repository
{
    public class SqlDatabase
    {
        public void RemovePreviousSampleResults(string QueryID)
        {
            using (var db = new PerceptronXfmsDatabaseEntities())
            {

                var dbObjectSearchXfmsQuery = db.SearchXfmsQueries.Where(x=>x.QueryID == QueryID).Select(x => x).FirstOrDefault();

                if (dbObjectSearchXfmsQuery != null)
                {
                    db.SearchXfmsQueries.Remove(dbObjectSearchXfmsQuery);
                }

                var dbObjectRemoveResultFiles = db.SearchResultsFiles.Where(x => x.QueryID == QueryID).Select(x => x).FirstOrDefault();

                if (dbObjectRemoveResultFiles != null)
                {
                    db.SearchResultsFiles.Remove(dbObjectRemoveResultFiles);
                }

                var dbObjectResultVisualize = db.ResultsVisualizes.Where(x => x.QueryID == QueryID).Select(x => x).FirstOrDefault();

                if (dbObjectResultVisualize != null)
                {
                    db.ResultsVisualizes.Remove(dbObjectResultVisualize);
                }

                db.SaveChanges();

            }


        }

        public void SaveSampleResultsSearchXfmsQuery(string QueryID, string UserID, string Progress, DateTime CreationTime, string isBridgeEnabled, string isFrustratometerEnabled, string EmailID, string Title)
        {
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                db.SearchXfmsQueries.Add(new SearchXfmsQuery()
                {
                    QueryID = QueryID,
                    UserID = UserID,
                    Progress = Progress,
                    CreationTime = CreationTime,
                    isBridgeEnabled = isBridgeEnabled,
                    isFrustratometerEnabled = isFrustratometerEnabled,
                    EmailID = EmailID,
                    Title = Title
                });
                db.SaveChanges();
            }
        }

        public SearchXfmsQueryDto FetchQuery()
        {
            //Fetch "In Queue" Jobs
            //Take first job based on the submission priority, and sent to the MATLAB code for processing + parameters

            var temp = new SearchXfmsQueryDto();
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var dbObject = db.SearchXfmsQueries.Where(x => x.Progress == "In Queue").Select(x => x).OrderBy(x => x.CreationTime).FirstOrDefault();   //  && x.EmailID == "farhan.biomedical.2022@gmail.com"

                if (dbObject == null)
                {
                    return null;
                }
                temp = new SearchXfmsQueryDto()
                {
                    QueryID = dbObject.QueryID,
                    UserID = dbObject.UserID,
                    Progress = dbObject.Progress,
                    CreationTime = dbObject.CreationTime,
                    isBridgeEnabled = dbObject.isBridgeEnabled,
                    isFrustratometerEnabled = dbObject.isFrustratometerEnabled,
                    EmailID = dbObject.EmailID,
                    ID = dbObject.ID,
                    Title = dbObject.Title
                };
            }
            return temp;

        }

        public void UpdateJobStatus(string QueryID, string Status, DateTime ExpectedCompletionTime)
        {
            //Updating the progress status
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var dbObject = db.SearchXfmsQueries.Where(x => x.QueryID == QueryID).Select(x => x).FirstOrDefault();
                dbObject.Progress = Status;
                if (Status == "Running")
                {
                    dbObject.ExpectedCompletionTime = ExpectedCompletionTime;
                }
                else if (Status == "Completed")
                {
                    dbObject.ExpectedCompletionTime = null;
                }
                else if (Status == "Error In Query")
                {
                    dbObject.ExpectedCompletionTime = null;
                }

                dbObject.QueuePosition = "---";
                db.SaveChanges();
            }
        }

        public void SaveZipFullFilePath(string QueryID, string ZippingFileName)
        {
            DateTime JobSubmissionTime = DateTime.Now.AddDays(0);  // Fetching Current Time  //Results will available for 48hrs only                 -2 after publication    #AfterPublication

            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var temp = new SearchResultsFile()
                {
                    QueryID = QueryID,
                    ZipResultFile = ZippingFileName,
                    CreationTime = JobSubmissionTime,
                };
                db.SearchResultsFiles.Add(temp);
                db.SaveChanges();
            }

        }

        public void ResultsSaveIntoDbForVisualize(string QueryID, ResultsVisualizeSaveIntoDB ResultsSaveDbObj)
        {
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var temp = new ResultsVisualize()
                {
                    QueryID = QueryID,
                    FastaFileInfo = ResultsSaveDbObj.FastaFileInfo,
                    PeptideInfo = ResultsSaveDbObj.PeptideInfo,
                    PfSasaTabXlsFile = ResultsSaveDbObj.PfSasaTabXlsFile,
                    BridgeResultsFile = ResultsSaveDbObj.BridgeResultsFile,
                    FrustratometerResultFiles = ResultsSaveDbObj.FrustratometerResultFiles,
                    SasaMainImageFile = ResultsSaveDbObj.SasaMainImageFile,
                    PfModifiedPdb = ResultsSaveDbObj.PfModifiedPdb,
                    CentralityModifiedPdb = ResultsSaveDbObj.CentralityModifiedPdb
                };
                db.ResultsVisualizes.Add(temp);
                db.SaveChanges();
            }
        }

        public void UpdateQueuedInfo(int TypicalCompletionTimeForOneJob, int Tolerance)
        {
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var QueuedData = db.SearchXfmsQueries.Where(x => x.Progress == "In Queue").OrderBy(x => x.CreationTime).ToList<SearchXfmsQuery>();

                if (QueuedData != null)
                {
                    int TotalInQueueJobs = QueuedData.Count;
                    for (int i = 0; i < TotalInQueueJobs; i++)
                    {
                        QueuedData[i].QueuePosition = (i + 1).ToString() +  "/" + TotalInQueueJobs.ToString();
                        QueuedData[i].ExpectedCompletionTime = DateTime.Now.AddHours(((i + 1) * TypicalCompletionTimeForOneJob) + Tolerance);

                    }

                    
                    db.SaveChanges();
                }
            }
        }
    }
}
