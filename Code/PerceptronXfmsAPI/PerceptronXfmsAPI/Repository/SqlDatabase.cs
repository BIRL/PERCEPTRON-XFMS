using System;
using System.IO;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using PerceptronXfmsAPI.Models;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity.Validation;  //Added on 12Sep2019.. WHy its not needed before...???
using PerceptronXfmsAPI.Utility;
using System.Security;
using Newtonsoft.Json;

namespace PerceptronXfmsAPI.Repository
{
    public class SqlDatabase : IDataAccessLayer
    {
        public string StoreXfmsSearchParameters(SearchXfmsQueryDto parameters)
        {
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                db.SearchXfmsQueries.Add(parameters.SearchXfmsQuery);

                db.SaveChanges();
            }
            return "Ok";
        }

        public Statistics stat()
        {
            var StatsInfo = new Statistics();
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var SearchQueries = db.SearchXfmsQueries.ToList(); // .Add(parameters.SearchXfmsQuery);     //    .Where(x => x.Progress == "In Queue" || x.Progress == "In Queue").Select(x => x.Progress).
                var UsersSubmittedQueries = db.SearchXfmsQueries.Select(x => x.UserID).ToList().Distinct();

                StatsInfo.search = (SearchQueries.Count() + 16).ToString();   // 15 for local users // Before import & export numbers
                StatsInfo.user = (UsersSubmittedQueries.Count() + 10).ToString();   // 10 for local users // Before import & export numbers

            }
            return StatsInfo;
        }
        public List<UserHistory> GetUserHistory(string Uid, string UserIDforSampleResults, DateTime JobSubmissionTime)
        {
            var UserJobHistory = new List<UserHistory>();
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                //Some additionaly preparation of sample results - #JustForTheSafetySeparatelyFetched
                var SampleResultsInfo = db.SearchXfmsQueries.Where(x => x.UserID == UserIDforSampleResults).Select(x => x).FirstOrDefault(); // .Add(parameters.SearchXfmsQuery);
                var tempSampleResultsInfo = new UserHistory
                {
                    title = SampleResultsInfo.Title,
                    time = "---",
                    qid = SampleResultsInfo.QueryID,
                    progress = SampleResultsInfo.Progress,
                    ExpectedCompletionTime = "---",
                    QueuePosition = "---"
                };
                UserJobHistory.Add(tempSampleResultsInfo);

                //Fetching user specified history
                var UserHistory = db.SearchXfmsQueries.Where(x => x.UserID == Uid  && x.CreationTime >= JobSubmissionTime).Select(x => x).OrderByDescending(x => x.CreationTime).ToList(); // .Add(parameters.SearchXfmsQuery);

                //#Future - if want to subtract Resultscompletion - DateTimeNow < 2 then show results
                //var ResultsDataObj = db.SearchResultsFiles.Where(x => x.UserID == Uid & x=>x.QueryID).Select(x => x).ToList();
                //var UpdatedUserHistoryBasedOnResults = UserHistory

                for (int index = 0; index < UserHistory.Count; index++)
                {
                    var temp = new UserHistory
                    {
                        title = UserHistory[index].Title,
                        time = UserHistory[index].CreationTime.ToString(),
                        qid = UserHistory[index].QueryID,
                        progress = UserHistory[index].Progress,
                        ExpectedCompletionTime = UserHistory[index].ExpectedCompletionTime != null ? UserHistory[index].ExpectedCompletionTime.ToString() : "---",
                        QueuePosition = UserHistory[index].QueuePosition != null ? UserHistory[index].QueuePosition : "---"
                    };
                    UserJobHistory.Add(temp);
                }
            }
            return UserJobHistory;
        }


        public SearchXfmsQueryDto FetchSearchParameters(string QueryID)
        {
            var SearchXfmsQueryDto = new SearchXfmsQueryDto(); ;
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var SearchXfmsQuery = db.SearchXfmsQueries.Where(x => x.QueryID == QueryID).FirstOrDefault();


                SearchXfmsQueryDto.SearchXfmsQuery = SearchXfmsQuery;
            }
            return SearchXfmsQueryDto;
        }



        public string ZipFullFilePath(string QueryID)
        {
            string ZipResultFullFilePath = "";
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                ZipResultFullFilePath = db.SearchResultsFiles.Where(x => x.QueryID == QueryID).Select(x => x.ZipResultFile).FirstOrDefault();
                if(ZipResultFullFilePath == null)
                {
                    throw(new Exception("No results found."));
                }
            }
            return ZipResultFullFilePath;
        }


        public List<ScanResults> SearchResultsContent(string QueryID, DateTime JobSubmissionTime)
        {
            var _Null = new List<ScanResults>() { };
            return _Null;
        }

        public DetailProtectionFactorDto FetchResultsProtectionFactor(string QueryID)
        {
            var DetailProtectionFactor = new DetailProtectionFactorDto();
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var Data = db.ResultsVisualizes.Where(x => x.QueryID == QueryID).Select(x => x).FirstOrDefault();
                DetailProtectionFactor.PfSasaTabXlsFile = Data.PfSasaTabXlsFile;
                DetailProtectionFactor.SasaMainImageFile = Data.SasaMainImageFile;
                DetailProtectionFactor.FastaFileInfo = Data.FastaFileInfo;
            }
            return DetailProtectionFactor;
        }

        public DetailedCentralityDto FetchResultsCentrality(string QueryID)
        {
            var DetailedCentrality = new DetailedCentralityDto();
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var Check = db.SearchXfmsQueries.Where(x => x.QueryID == QueryID).Select(x => x).FirstOrDefault();

                var Data = db.ResultsVisualizes.Where(x => x.QueryID == QueryID).Select(x => x).FirstOrDefault();
                DetailedCentrality.BridgeResultsFile = Data.BridgeResultsFile;
                DetailedCentrality.FastaFileInfo = Data.FastaFileInfo;
                return DetailedCentrality;

            }
        }


        public FrustratometerDto FetchResultsFrustratometer(string QueryID)
        {
            var FrustratometerResults = new FrustratometerDto();
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                //var Check = db.SearchXfmsQueries.Where(x => x.QueryID == QueryID).Select(x => x).FirstOrDefault();

                var Data = db.ResultsVisualizes.Where(x => x.QueryID == QueryID).Select(x => x).FirstOrDefault();
                FrustratometerResults.ImageFilesPathInfo = Data.FrustratometerResultFiles;
                FrustratometerResults.FastaFileInfo = Data.FastaFileInfo;

                return FrustratometerResults;
            }
        }


        public int FetchQueuedInfo()
        {
            int AlreadyPresentJobs = 0;
            using (var db = new PerceptronXfmsDatabaseEntities())
            {
                var ExtractInfo = db.SearchXfmsQueries.Where(x => x.Progress == "Running" || x.Progress == "In Queue");

                AlreadyPresentJobs = ExtractInfo.Count();
            }
            return AlreadyPresentJobs;
        }



        //////DBErrorException _DBErrorException = new DBErrorException();
        //////private string ServerName = "BIRL-109004DT\SQLEXPRESS02";    //    Integrated Security=SSPI;         //       CHIRAGH-II
        //////private SqlCredential Credentials;
        //////StreamReader ReadSqlUsername = new StreamReader(@"C:\01_DoNotEnterPerceptronRelaventInfo\SQLRemoteUserName.txt");
        //////StreamReader ReadSqlPwd = new StreamReader(@"C:\01_DoNotEnterPerceptronRelaventInfo\SQLRemotePWD.txt");

        //////public SqlDatabase()
        //////{
        //////    SecureString securePwd = new SecureString();
        //////    string strPWD = ReadSqlPwd.ReadLine();
        //////    for (int i = 0; i < strPWD.Length; i++)
        //////    {
        //////        securePwd.AppendChar(strPWD[i]);
        //////    }
        //////    securePwd.MakeReadOnly();
        //////    Credentials = new SqlCredential(ReadSqlUsername.ReadLine(), securePwd);
        //////}


        ////////Store Query Parameters
        //////public string StoreSearchParameters(SearchParametersDto parameters)
        //////{
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        db.SearchQueries.Add(parameters.SearchQuerry);
        //////        db.SearchParameters.Add(parameters.SearchParameters);
        //////        db.SearchFiles.AddRange(parameters.SearchFiles);
        //////        db.PtmFixedModifications.Add(parameters.FixedMods);
        //////        db.PtmVariableModifications.Add(parameters.VarMods);

        //////        db.SaveChanges();

        //////    }
        //////    return "Ok";
        //////}

        //////public string StorePerceptronSdkInfo(DateTime JobSubmission, string QueryId, string Title, string UserName)
        //////{
        //////    string Message = "Query successfully submitted!";
        //////    var PerceptronSdkInfo = new PerceptronSdk
        //////    {
        //////        JobSubmission = JobSubmission,
        //////        QueryId = QueryId,
        //////        Title = Title,
        //////        UserName = UserName,
        //////        ResultsAvailable = "False"
        //////    };

        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        db.PerceptronSdks.Add(PerceptronSdkInfo);

        //////        db.SaveChanges();

        //////    }
        //////    return Message;
        //////}


        //////public void StoreSearchFiles(SearchParametersDto param)
        //////{
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        db.SaveChanges();
        //////    }
        //////}

        ////////Stores Server Status
        //////public List<SearchQuery> RetrieveSearchQueries()
        //////{
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        return db.SearchQueries.ToList();
        //////    }
        //////}

        ////////Returns Progress
        //////public int RetrieveQueryProgress(string qid)
        //////{
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        return Convert.ToInt32(db.SearchQueries.Where(x => x.QueryId == qid).Select(x => x.Progress));
        //////    }
        //////}

        //////public List<SearchQuery> RetrieveUsersSearchQueries(string userid)
        //////{
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        return db.SearchQueries.Where(x => x.UserId == userid).ToList();
        //////    }
        //////}

        //////public ResultsDto RetrieveResultByRid(string rid)
        //////{
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        return new ResultsDto
        //////        {
        //////            //InsilicioLeft = db.ResultInsilicoMatchLefts.Where(x => x.ResultId == rid).ToList(),
        //////            //InsilicoRight = db.ResultInsilicoMatchRights.Where(x => x.ResultId == rid).ToList(),
        //////            //PtmSites = db.ResultPtmSites.Where(x => x.ResultId == rid).ToList(),
        //////            Results = db.SearchResults.First(x => x.ResultId == rid)
        //////        };
        //////    }
        //////}

        //////public ResultViewDto retrieve_searchview_db(string qid)
        //////{
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        return new ResultViewDto
        //////        {
        //////            Paramters = new SearchParametersDto
        //////            {
        //////                SearchParameters = db.SearchParameters.First(x => x.QueryId == qid),
        //////                FixedMods = db.PtmFixedModifications.First(x => x.QueryId == qid),
        //////                SearchFiles = db.SearchFiles.Where(x => x.QueryId == qid).ToList(),
        //////                SearchQuerry = db.SearchQueries.First(x => x.QueryId == qid),
        //////                VarMods = db.PtmVariableModifications.First(x => x.QueryId == qid)
        //////            },
        //////            ExecutionTime = db.ExecutionTimes.First(x => x.QueryId == qid),
        //////            Results =
        //////                db.SearchResults.Where(x => x.QueryId == qid)
        //////                    .Select(x => RetrieveResultByRid(x.ResultId))
        //////                    .ToList()
        //////        };
        //////    }
        //////}


        //////public List<ScanResults> Scan_Results(string qid, DateTime JobSubmissionTime)
        //////{

        //////    qid = qid.Trim('"');
        //////    var scanResults = new List<ScanResults>();
        //////    try
        //////    {
        //////        using (var db = new PerceptronDatabaseEntities())
        //////        {
        //////            var sqlConnection1 =
        //////                new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////                    //@"Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////            var cmd = new SqlCommand
        //////            {
        //////                CommandText =
        //////                //"SELECT *\nFROM SearchResults E\nWHERE E.QueryId = '" + qid + "' FROM SearchFiles E2 Where E2.QueryId=E.QueryId AND E2.FileUniqueId = E.FileUniqueId))",  // E.ProteinRank = '1',

        //////                //          " ' AND P.JobSubmission >= ' " + JobSubmissionTime +

        //////                /// ITS HEALTHY BELOW
        //////                //"SELECT P.FileId, P.Mw, P.Header, P.Score, P.FileUniqueId, P.ProteinRank, R.FileName \nFROM SearchFiles as R, SearchResults as P \nWHERE P.Queryid = '" + qid + 
        //////                //    "' AND P.ProteinRank = '" + 1 + "' AND P.FileUniqueId=R.FileUniqueId ORDER BY P.Queryid Desc ",
        //////                ////// ITS HEALTHY ABOVE
        //////                ///
        //////                "SELECT P.FileId, P.Mw, P.Header, P.Score, P.FileUniqueId, P.ProteinRank, P.Queryid, R.Queryid, R.FileName \nFROM SearchFiles as R, SearchResults as P \nWHERE P.Queryid = '" + qid +
        //////                "' AND P.Queryid = R.Queryid AND P.JobSubmission >= ' " + JobSubmissionTime +
        //////                "' AND P.ProteinRank = '" + 1 + "' AND P.FileUniqueId=R.FileUniqueId AND P.JobSubmission = R.JobSubmission ORDER BY P.JobSubmission Desc ",  //Updated 20210118
        //////                CommandType = CommandType.Text,
        //////                Connection = sqlConnection1
        //////            };
        //////            sqlConnection1.Open();
        //////            var SearchFileList = db.SearchFiles.Where(x => x.QueryId == qid).ToList();

        //////            //var parameters = db.SearchParameters.Where(x => x.QueryId == qid).ToList().First();

        //////            int j = 0;
        //////            var dataReader = cmd.ExecuteReader();


        //////            if (SearchFileList.Count == 1)   //Checking if no of files more than one then, it will be considered as batch mode and PERCEPTRON will not fetch the data from database.
        //////            {
        //////                var FileSpecificData = db.SearchResults.Where(x => x.QueryId == qid).ToList();

        //////                while (dataReader.Read())
        //////                {
        //////                    var temp = new ScanResults
        //////                    {
        //////                        FileId = dataReader["FileId"].ToString(),
        //////                        FileName = Path.GetFileName(dataReader["FileName"].ToString()),
        //////                        ProteinId = dataReader["Header"].ToString(),
        //////                        Score = (double)dataReader["Score"],
        //////                        MolW = (double)dataReader["Mw"],
        //////                        FileUniqueId = dataReader["FileUniqueId"].ToString(),
        //////                        //SearchModeMessage = "SingleMode"       // Just for showing whether its Single ode or Batch Mode

        //////                        //Truncation = "No",
        //////                        //Frags = 1,
        //////                        //Mods = 1,

        //////                    };
        //////                    scanResults.Add(temp);
        //////                }
        //////            }
        //////            dataReader.Close();
        //////            cmd.Dispose();
        //////            sqlConnection1.Close();
        //////        }
        //////    }

        //////    catch (DbEntityValidationException e)
        //////    {
        //////        int asd = 1;

        //////    }


        //////    return scanResults;
        //////}

        //////public ZipResultsDownloadInfo ScanResultFile(string QueryId)
        //////{
        //////    var ZipResultFileInfo = new ZipResultsDownloadInfo();
        //////    using (new PerceptronDatabaseEntities())
        //////    {
        //////        var sqlConnection1 =
        //////            new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        //@"Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////        var cmd = new SqlCommand
        //////        {
        //////            CommandText =
        //////                "SELECT QueryId, ZipFileWithQueryId, ZipFileName \nFROM ZipResultsDownloadInfo\nWHERE QueryId = '" + QueryId + "'",
        //////            CommandType = CommandType.Text,
        //////            Connection = sqlConnection1
        //////        };
        //////        sqlConnection1.Open();

        //////        var dataReader = cmd.ExecuteReader();
        //////        while (dataReader.Read())
        //////        {
        //////            ZipResultFileInfo.QueryId = QueryId;
        //////            ZipResultFileInfo.ZipFileWithQueryId = dataReader["ZipFileWithQueryId"].ToString();
        //////            ZipResultFileInfo.ZipFileName = dataReader["ZipFileName"].ToString();
        //////        }

        //////        dataReader.Close();
        //////        cmd.Dispose();
        //////        sqlConnection1.Close();
        //////    }
        //////    return ZipResultFileInfo;
        //////}

        //////public ScanInputDataDto ScanInputData(string qid)   // ITS HEALTHY WAS IN USED WHEN API COMPILE THE RESUTLS
        //////{
        //////    var FileUniqueIdsList = new List<string>();
        //////    var FileNamesList = new List<string>();
        //////    var UniqueFileNameList = new List<string>();
        //////    var searchParameters = new SearchParameter();

        //////    using (new PerceptronDatabaseEntities())
        //////    {
        //////        var sqlConnection1 =
        //////            new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        //@Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////        var cmd = new SqlCommand
        //////        {
        //////            CommandText =
        //////                "SELECT FileUniqueId, FileName, UniqueFileName \nFROM SearchFiles\nWHERE QueryId = '" + qid + "'",
        //////            CommandType = CommandType.Text,
        //////            Connection = sqlConnection1
        //////        };
        //////        sqlConnection1.Open();

        //////        var dataReader = cmd.ExecuteReader();
        //////        while (dataReader.Read())
        //////        {
        //////            FileUniqueIdsList.Add(dataReader["FileUniqueId"].ToString());
        //////            FileNamesList.Add(dataReader["FileName"].ToString());
        //////            UniqueFileNameList.Add(dataReader["UniqueFileName"].ToString());
        //////        }

        //////        dataReader.Close();
        //////        cmd.Dispose();
        //////        sqlConnection1.Close();
        //////    }
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        searchParameters = db.SearchParameters.Where(x => x.QueryId == qid).ToList().First();
        //////    }

        //////    var ScanInputDataInfo = new ScanInputDataDto(FileUniqueIdsList, FileNamesList, UniqueFileNameList, searchParameters);
        //////    return ScanInputDataInfo;
        //////}



        //////public ScanResultsDownloadDataDto ScanResultsDownloadData(string qid, string FileUniqueId)
        //////{
        //////    //var tempScanResultsDownloadDataDto = new ScanResultsDownloadDataDto();

        //////    //var ListOfPeakData = new List<PeakListData>();
        //////    var ListOfSearchResults = new List<SearchResult>();
        //////    var PtmSites = new List<ResultPtmSite>();
        //////    //var ResultIds = new List<string>();

        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        try
        //////        {
        //////            ListOfSearchResults.AddRange(db.SearchResults.Where(x => x.FileUniqueId == FileUniqueId)); //Fetching Results from PerceptronDatabase based on the Peaklist files using FileUniqueId
        //////            var NoOfResultIds = ListOfSearchResults.Select(x => x.ResultId).Distinct().ToList();


        //////            for (int i = 0; i < ListOfSearchResults.Count; i++)
        //////            {
        //////                var ResultId = ListOfSearchResults[i].ResultId;
        //////                PtmSites.AddRange(db.ResultPtmSites.Where(x => x.ResultId == ResultId));
        //////            }
        //////            var PtmVarMod = new List<PtmVariableModification>();
        //////            var PtmFixedMod = new List<PtmFixedModification>();
        //////        }
        //////        catch (Exception e)
        //////        {
        //////            ListOfSearchResults = new List<SearchResult>();
        //////            PtmSites = new List<ResultPtmSite>();
        //////        }

        //////    }
        //////    var tempScanResultsDownloadDataDto = new ScanResultsDownloadDataDto(ListOfSearchResults, PtmSites);
        //////    return tempScanResultsDownloadDataDto;

        //////}

        //////public List<SummaryResults> Summary_results(string qid, string fid, DateTime JobSubmissionTime)
        //////{
        //////    qid = qid.Trim('"');
        //////    var summaryResults = new List<SummaryResults>();
        //////    var db = new PerceptronDatabaseEntities();
        //////    using (new PerceptronDatabaseEntities())
        //////    {
        //////        var sqlConnection1 =
        //////            new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        //@"Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////        var cmd = new SqlCommand
        //////        {
        //////            CommandText =
        //////                "SELECT *\nFROM SearchResults E\nWHERE E.QueryId = '" + qid + "' AND E.JobSubmission >= '" + JobSubmissionTime + "' AND E.fileid = '" + fid + "' ORDER BY E.Score DESC ",  //Updated 20210118
        //////            CommandType = CommandType.Text,
        //////            Connection = sqlConnection1
        //////        };
        //////        sqlConnection1.Open();
        //////        int j = 0;
        //////        var dataReader = cmd.ExecuteReader();
        //////        while (dataReader.Read())
        //////        {
        //////            var temp = new SummaryResults
        //////            {
        //////                ProteinId = dataReader["Header"].ToString(),
        //////                Mods = 2, /// Mods is a Number of Ptm Sites and "2" is not actual value so, actual one 
        //////                          /// cannot be updated here so, here "2" will be considered as a placeholder only
        //////                MolW = (double)dataReader["Mw"],
        //////                ProteinName = "Protein " + j,
        //////                ProteinRank = (int)dataReader["ProteinRank"], //1,
        //////                ResultId = dataReader["ResultId"].ToString(),
        //////                Score = (double)dataReader["Score"],
        //////                TerminalMods = dataReader["TerminalModification"].ToString()
        //////            };
        //////            ++j;
        //////            summaryResults.Add(temp);
        //////        }
        //////        dataReader.Close();
        //////        cmd.Dispose();
        //////        sqlConnection1.Close();
        //////    }
        //////    using (var dbInfo = new PerceptronDatabaseEntities())
        //////    {
        //////        for (int i = 0; i < summaryResults.Count; i++)
        //////        {
        //////            string ResultId = summaryResults[i].ResultId;
        //////            //int NoOfPtmSites = 0; 
        //////            //if (dbInfo.ResultPtmSites.Where(x => x.ResultId == ResultId).Count() != 0)
        //////            //    NoOfPtmSites = dbInfo.ResultPtmSites.Where(x => x.ResultId == ResultId).First().Index.Split(',').Select(int.Parse).ToList().Count;  // Just wanted to get Number of Ptm Sites


        //////            summaryResults[i].Mods = NoOfPTMMods(ResultId, dbInfo); //Updated 20200821 //NoOfPtmSites;  // Updating the actual value of "Mods" here...
        //////        }
        //////        summaryResults = summaryResults.OrderBy(x => x.ProteinRank).ToList();
        //////    }
        //////    return summaryResults;
        //////}

        //////private int NoOfPTMMods(string ResultId, PerceptronDatabaseEntities dbInfo) //Added 20200821
        //////{
        //////    int NoOfPtmSites = 0;
        //////    if (dbInfo.ResultPtmSites.Where(x => x.ResultId == ResultId).Count() != 0)
        //////        NoOfPtmSites = dbInfo.ResultPtmSites.Where(x => x.ResultId == ResultId).First().Index.Split(',').Select(int.Parse).ToList().Count;  // Just wanted to get Number of Ptm Sites
        //////    return NoOfPtmSites;
        //////}

        //////private int NoOfMatchedFrags(SearchResult searchResult)
        //////{
        //////    int LeftMatches = 0; int RightMathces = 0;
        //////    if (searchResult.LeftMatchedIndex != "")
        //////    {
        //////        var LeftMatchedIndex = searchResult.LeftMatchedIndex.Split(',').Select(int.Parse).ToList();
        //////        LeftMatches = LeftMatchedIndex.Count;
        //////    }

        //////    if (searchResult.RightMatchedIndex != "")
        //////    {
        //////        var RightMatchedIndex = searchResult.RightMatchedIndex.Split(',').Select(int.Parse).ToList();
        //////        RightMathces = RightMatchedIndex.Count;
        //////    }

        //////    int NoOfMatches = LeftMatches + RightMathces;
        //////    return NoOfMatches;
        //////}

        //////public List<UserHistory> GetUserHistory(string Uid, DateTime JobSubmissionTime)
        //////{
        //////    var summaryResults = new List<UserHistory>();

        //////    try
        //////    {
        //////        using (new PerceptronDatabaseEntities())
        //////        {
        //////            var sqlConnection1 =
        //////                new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////            //@"Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////            var cmd = new SqlCommand
        //////            {
        //////                CommandText =
        //////                //"SELECT P.Queryid, P.Title, R.CreationTime, R.Progress \nFROM SearchQueries as R, SearchParameters as P \nWHERE P.UserId = '" + Uid + "'AND P.Queryid=R.QueryId ",
        //////                "SELECT P.Queryid, P.Title, R.CreationTime, R.Progress \nFROM SearchQueries as R, SearchParameters as P \nWHERE P.UserId = '" + Uid + " ' AND P.JobSubmission >= ' " + JobSubmissionTime + " 'AND P.Queryid=R.QueryId AND P.JobSubmission=R.JobSubmission ",  //Updated 20210118
        //////                CommandType = CommandType.Text,
        //////                Connection = sqlConnection1
        //////            };
        //////            sqlConnection1.Open();

        //////            var dataReader = cmd.ExecuteReader();
        //////            while (dataReader.Read())
        //////            {
        //////                var temp = new UserHistory
        //////                {
        //////                    title = dataReader["Title"].ToString(),
        //////                    qid = dataReader["Queryid"].ToString(),
        //////                    time = dataReader["CreationTime"].ToString(),
        //////                    progress = dataReader["Progress"].ToString()
        //////                };
        //////                summaryResults.Add(temp);
        //////            }
        //////            dataReader.Close();
        //////            cmd.Dispose();
        //////            sqlConnection1.Close();
        //////        }
        //////    }
        //////    catch (DbEntityValidationException e)
        //////    {
        //////        _DBErrorException.DbEntitiyError(e);
        //////    }

        //////    for (int index = 0; index < summaryResults.Count; index++)
        //////    {
        //////        if (summaryResults[index].progress == "0")
        //////        {
        //////            summaryResults[index].progress = "In Queue";
        //////        }


        //////        else if (summaryResults[index].progress == "10")
        //////        {
        //////            summaryResults[index].progress = "Running";
        //////        }


        //////        else if (summaryResults[index].progress == "100")
        //////        {
        //////            summaryResults[index].progress = "Completed";
        //////        }

        //////        else if (summaryResults[index].progress == "-100")
        //////        {
        //////            summaryResults[index].progress = "Result Expired";
        //////        }

        //////        else  // WHEN (summaryResults[index].progress == "-1")
        //////        {
        //////            summaryResults[index].progress = "Error in Query";
        //////        }
        //////    }
        //////    return summaryResults.OrderByDescending(x => x.time).ToList();
        //////}

        //////public stat stat()
        //////{

        //////    var temp = new stat();
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        var sqlConnection1 =
        //////            new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        //@"Server=BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////        var cmd = new SqlCommand
        //////        {
        //////            CommandText =
        //////                "SELECT count( distinct UserId) as one  FROM SearchQueries",
        //////            CommandType = CommandType.Text,
        //////            Connection = sqlConnection1
        //////        };
        //////        sqlConnection1.Open();
        //////        int j = 0;
        //////        var dataReader = cmd.ExecuteReader();
        //////        while (dataReader.Read())
        //////        {

        //////            temp.user = dataReader["one"].ToString();
        //////        }
        //////        dataReader.Close();
        //////        cmd.Dispose();
        //////        sqlConnection1.Close();
        //////    }
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        var sqlConnection1 =
        //////            new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        //@"Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");

        //////        var cmd = new SqlCommand
        //////        {
        //////            CommandText = "Select count( QueryId) as two FROM SearchQueries WHERE Progress = 100",

        //////            //"Select count( QueryId) as two FROM SearchResults",

        //////            CommandType = CommandType.Text,
        //////            Connection = sqlConnection1
        //////        };


        //////        sqlConnection1.Open();
        //////        int j = 0;
        //////        var dataReader = cmd.ExecuteReader();
        //////        while (dataReader.Read())
        //////        {

        //////            temp.search = dataReader["two"].ToString();
        //////        }
        //////        dataReader.Close();
        //////        cmd.Dispose();
        //////        sqlConnection1.Close();
        //////    }
        //////    return temp;
        //////}


        //////public DetailedResults Detailed_Results(string qid, string rid, DateTime JobSubmissionTime)
        //////{
        //////    var detiledResults = new DetailedResults();
        //////    var searchResult = new SearchResult();

        //////    using (new PerceptronDatabaseEntities())            /// ITS HEALTHY
        //////    {
        //////        var sqlConnection1 =
        //////            new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        //"@Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////        var cmd = new SqlCommand
        //////        {
        //////            CommandText =
        //////                //"SELECT QueryId \nFROM SearchResults \nWHERE ResultId = '" + rid + "'",
        //////                "SELECT * \nFROM SearchResults as R  \nWHERE R.ResultId = '" + rid + "' AND R.QueryId = '" + qid + "' AND R.JobSubmission >= ' " + JobSubmissionTime + "'ORDER BY R.JobSubmission Desc",  //Updated
        //////            CommandType = CommandType.Text,
        //////            Connection = sqlConnection1
        //////        };
        //////        sqlConnection1.Open();

        //////        var dataReader = cmd.ExecuteReader();
        //////        while (dataReader.Read())
        //////        {
        //////            searchResult = new SearchResult  // Updated 20210118
        //////            {
        //////                QueryId = dataReader["QueryId"].ToString(),
        //////                ResultId = dataReader["ResultId"].ToString(),
        //////                Header = dataReader["Header"].ToString(),
        //////                Sequence = dataReader["Sequence"].ToString(),
        //////                PstScore = Convert.ToDouble(dataReader["PstScore"]),//.ToString(),
        //////                InsilicoScore = Convert.ToDouble(dataReader["InsilicoScore"]),
        //////                PtmScore = Convert.ToDouble(dataReader["PtmScore"]),
        //////                Score = Convert.ToDouble(dataReader["Score"]),


        //////                MwScore = Convert.ToDouble(dataReader["MwScore"]),
        //////                Mw = Convert.ToDouble(dataReader["Mw"]),
        //////                FileId = dataReader["FileId"].ToString(),

        //////                OriginalSequence = dataReader["OriginalSequence"].ToString(),
        //////                PSTTags = dataReader["PSTTags"].ToString(),
        //////                RightMatchedIndex = dataReader["RightMatchedIndex"].ToString(),
        //////                RightPeakIndex = dataReader["RightPeakIndex"].ToString(),
        //////                RightType = dataReader["RightType"].ToString(),
        //////                LeftMatchedIndex = dataReader["LeftMatchedIndex"].ToString(),
        //////                LeftPeakIndex = dataReader["LeftPeakIndex"].ToString(),
        //////                LeftType = dataReader["LeftType"].ToString(),
        //////                InsilicoMassLeft = dataReader["InsilicoMassLeft"].ToString(),
        //////                InsilicoMassRight = dataReader["InsilicoMassRight"].ToString(),
        //////                InsilicoMassLeftAo = dataReader["InsilicoMassLeftAo"].ToString(),
        //////                InsilicoMassLeftBo = dataReader["InsilicoMassLeftBo"].ToString(),
        //////                InsilicoMassLeftAstar = dataReader["InsilicoMassLeftAstar"].ToString(),
        //////                InsilicoMassLeftBstar = dataReader["InsilicoMassLeftBstar"].ToString(),
        //////                InsilicoMassRightYo = dataReader["InsilicoMassRightYo"].ToString(),
        //////                InsilicoMassRightYstar = dataReader["InsilicoMassRightYstar"].ToString(),
        //////                InsilicoMassRightZo = dataReader["InsilicoMassRightZo"].ToString(),
        //////                InsilicoMassRightZoo = dataReader["InsilicoMassRightZoo"].ToString(),
        //////                TerminalModification = dataReader["TerminalModification"].ToString(),
        //////                TruncationSite = dataReader["TruncationSite"].ToString(),
        //////                TruncationIndex = Convert.ToInt16(dataReader["TruncationIndex"]),
        //////                FileUniqueId = dataReader["FileUniqueId"].ToString(),
        //////                Evalue = Convert.ToInt16(dataReader["Evalue"]),
        //////                BlindPtmLocalization = dataReader["BlindPtmLocalization"].ToString(),
        //////                ProteinRank = Convert.ToInt16(dataReader["ProteinRank"]),

        //////            };
        //////            //searchResults.Add(temp);
        //////        }

        //////        dataReader.Close();
        //////        cmd.Dispose();
        //////        sqlConnection1.Close();
        //////    }


        //////    try
        //////    {
        //////        using (var db = new PerceptronDatabaseEntities())
        //////        {
        //////            var searchParameters = db.SearchParameters.Where(x => x.QueryId == qid).ToList();
        //////            //var searchResult = db.SearchResults.Where(x => x.ResultId == rid).ToList();


        //////            //var resultInsilicoLeft = db.ResultInsilicoMatchLefts.Where(x => x.ResultId == rid).ToList();
        //////            //var resultInsilicoRight = db.ResultInsilicoMatchRights.Where(x => x.ResultId == rid).ToList();

        //////            //var ptmVarmod = db.PtmVariableModifications.First(x => x.QueryId == qid);
        //////            //var ptmFixedmod = db.PtmFixedModifications.First(x => x.QueryId == qid);

        //////            var ptmSite = db.ResultPtmSites.Where(x => x.ResultId == rid).ToList();
        //////            var execTime = db.ExecutionTimes.Where(x => x.QueryId == qid).ToList();
        //////            var searchQuery = db.SearchQueries.Where(x => x.QueryId == qid).ToList();


        //////            //if (db.ResultPtmSites.Where(x => x.ResultId == rid).Count() != 0)
        //////            //    NoOfPtmSites = db.ResultPtmSites.Where(x => x.ResultId == rid).First().Index.Split(',').Select(int.Parse).ToList().Count;  // Just wanted to get Number of Ptm 


        //////            if (searchParameters.Count != 0)
        //////                detiledResults.Paramters.SearchParameters = searchParameters.Any() ? GetSearchParametersDtoModel(searchParameters.First()) : new SearchParameter();

        //////            //detiledResults.Paramters.FixedMods = ptmFixedmod;
        //////            //detiledResults.Paramters.VarMods = ptmVarmod;

        //////            if (searchQuery.Count != 0)
        //////                detiledResults.Paramters.SearchQuerry = searchQuery.First();

        //////            //detiledResults.Results.InsilicioLeft = resultInsilicoLeft;
        //////            //detiledResults.Results.InsilicoRight = resultInsilicoRight;


        //////            detiledResults.Results.NoOfPtmSites = NoOfPTMMods(rid, db);    //Updated 20200821
        //////            detiledResults.Results.NoOfMatchedFragments = NoOfMatchedFrags(searchResult);   //Updated 20210118

        //////            if (searchResult != new SearchResult())    //Why if for Safe...?   //Updated 20210118
        //////                detiledResults.Results.Results = searchResult;
        //////            if (execTime.Count != 0)
        //////                detiledResults.ExecutionTime = execTime.First();



        //////        }

        //////    }
        //////    catch(Exception e)
        //////    {
        //////        int fsdfs = 1;
        //////    }
        //////    return detiledResults;

        //////}
        ////////DownloadAllResults



        /////////////Extracting File Unique Ids and FileNames against File Unique Ids
        ////////FileUniqueIdsList = ListOfSearchResults.Select(x => x.FileUniqueId).Distinct().ToList();
        ////////var tempFiles = db.SearchFiles.Where(x => x.QueryId == qid).ToList();
        ////////for (int indexFileUniqueId = 0; indexFileUniqueId < FileUniqueIdsList.Count; indexFileUniqueId++)
        ////////{
        ////////    for (int index = 0; index < tempFiles.Count; index++)
        ////////    {
        ////////        if (tempFiles[index].FileUniqueId == FileUniqueIdsList[indexFileUniqueId])
        ////////        {
        ////////            FileNamesList.Add(tempFiles[index].FileName);
        ////////            break;
        ////////        }
        ////////    }

        ////////}



        //////public DetailedProteinHitView DetailedProteinHitView_Results(string qid, string rid, string rank, DateTime JobSubmissionTime)
        //////{
        //////    string FileId = ""; var GetPeakListData = new PeakListData();
        //////    var DetailedProteinHitViewResults = new DetailedProteinHitView();
        //////    var searchResult = new SearchResult();
        //////    using (new PerceptronDatabaseEntities())
        //////    {
        //////        var sqlConnection1 =
        //////            new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        //@"Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////        var cmd = new SqlCommand
        //////        {
        //////            CommandText =
        //////            //  "SELECT SR.Queryid, SR.FileUniqueId \nFROM SearchResults \nWHERE ResultId = '" + rid + "' as R, AND SELECT PeakListData as P \nWHERE P.FileUniqueId = SR.FileUniqueId ",
        //////            //"SELECT QueryId, FileUniqueId \nFROM SearchResults \nWHERE ResultId = '" + rid + "'",   // Its HEALTHY

        //////            "SELECT * \nFROM SearchResults \nWHERE QueryId = '" + qid + "'AND ResultId = '" + rid + "' AND ProteinRank = '" + rank + "' AND JobSubmission >= ' " + JobSubmissionTime + "'ORDER BY JobSubmission Desc" ,  ////   "' AND QueryId = '" + qid +

        //////            CommandType = CommandType.Text,
        //////            Connection = sqlConnection1
        //////        };
        //////        sqlConnection1.Open();

        //////        var dataReader = cmd.ExecuteReader();
        //////        while (dataReader.Read())
        //////        {
        //////            ////qid = dataReader["QueryId"].ToString();
        //////            ////FileId = dataReader["FileUniqueId"].ToString();
        //////            searchResult = new SearchResult  // Updated 20210118
        //////            {
        //////                QueryId = dataReader["QueryId"].ToString(),
        //////                ResultId = dataReader["ResultId"].ToString(),
        //////                Header = dataReader["Header"].ToString(),
        //////                Sequence = dataReader["Sequence"].ToString(),
        //////                PstScore = Convert.ToDouble(dataReader["PstScore"]),//.ToString(),
        //////                InsilicoScore = Convert.ToDouble(dataReader["InsilicoScore"]),
        //////                PtmScore = Convert.ToDouble(dataReader["PtmScore"]),
        //////                Score = Convert.ToDouble(dataReader["Score"]),


        //////                MwScore = Convert.ToDouble(dataReader["MwScore"]),
        //////                Mw = Convert.ToDouble(dataReader["Mw"]),
        //////                FileId = dataReader["FileId"].ToString(),

        //////                OriginalSequence = dataReader["OriginalSequence"].ToString(),
        //////                PSTTags = dataReader["PSTTags"].ToString(),
        //////                RightMatchedIndex = dataReader["RightMatchedIndex"].ToString(),
        //////                RightPeakIndex = dataReader["RightPeakIndex"].ToString(),
        //////                RightType = dataReader["RightType"].ToString(),
        //////                LeftMatchedIndex = dataReader["LeftMatchedIndex"].ToString(),
        //////                LeftPeakIndex = dataReader["LeftPeakIndex"].ToString(),
        //////                LeftType = dataReader["LeftType"].ToString(),
        //////                InsilicoMassLeft = dataReader["InsilicoMassLeft"].ToString(),
        //////                InsilicoMassRight = dataReader["InsilicoMassRight"].ToString(),
        //////                InsilicoMassLeftAo = dataReader["InsilicoMassLeftAo"].ToString(),
        //////                InsilicoMassLeftBo = dataReader["InsilicoMassLeftBo"].ToString(),
        //////                InsilicoMassLeftAstar = dataReader["InsilicoMassLeftAstar"].ToString(),
        //////                InsilicoMassLeftBstar = dataReader["InsilicoMassLeftBstar"].ToString(),
        //////                InsilicoMassRightYo = dataReader["InsilicoMassRightYo"].ToString(),
        //////                InsilicoMassRightYstar = dataReader["InsilicoMassRightYstar"].ToString(),
        //////                InsilicoMassRightZo = dataReader["InsilicoMassRightZo"].ToString(),
        //////                InsilicoMassRightZoo = dataReader["InsilicoMassRightZoo"].ToString(),
        //////                TerminalModification = dataReader["TerminalModification"].ToString(),
        //////                TruncationSite = dataReader["TruncationSite"].ToString(),
        //////                TruncationIndex = Convert.ToInt16(dataReader["TruncationIndex"]),
        //////                FileUniqueId = dataReader["FileUniqueId"].ToString(),
        //////                Evalue = Convert.ToInt16(dataReader["Evalue"]),
        //////                BlindPtmLocalization = dataReader["BlindPtmLocalization"].ToString(),
        //////                ProteinRank = Convert.ToInt16(dataReader["ProteinRank"]),

        //////            };
        //////        }
        //////        dataReader.Close();
        //////        cmd.Dispose();
        //////        sqlConnection1.Close();
        //////    }
        //////    qid = searchResult.QueryId;
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        var searchParameters = db.SearchParameters.Where(x => x.QueryId == qid).ToList();
        //////        ////var searchResult = db.SearchResults.Where(x => x.ResultId == rid).ToList();
        //////        var peakListData = db.PeakListDatas.Where(x => x.FileUniqueId == searchResult.FileUniqueId).ToList();

        //////        // var FileInfo = db.SearchFiles.Where(x => x.FileUniqueId == FileName).ToList();
        //////        //NO NEED 
        //////        //var resultInsilicoLeft = db.ResultInsilicoMatchLefts.Where(x => x.ResultId == rid).ToList();
        //////        //var resultInsilicoRight = db.ResultInsilicoMatchRights.Where(x => x.ResultId == rid).ToList();

        //////        /*  WILL USE IT LATER  */
        //////        var ptmVarmod = db.PtmVariableModifications.Where(x => x.QueryId == qid).ToList();
        //////        var ptmFixedmod = db.PtmFixedModifications.Where(x => x.QueryId == qid).ToList();
        //////        var ptmSite = db.ResultPtmSites.Where(x => x.ResultId == rid).ToList();

        //////        if (ptmSite.Count != 0)
        //////        {
        //////            DetailedProteinHitViewResults.Results.PtmSitesInfo = ptmSite.First();
        //////        }


        //////        /*  WILL USE IT LATER  */

        //////        DetailedProteinHitViewResults.Results.Results = searchResult;//.First();
        //////        DetailedProteinHitViewResults.searchParameters = searchParameters.First();
        //////        DetailedProteinHitViewResults.PeakListData = peakListData.First();

        //////        //#4TTB


        //////        //NO NEED 
        //////        //var execTime = db.ExecutionTimes.Where(x => x.QueryId == qid).ToList();
        //////        //var searchQuery = db.SearchQueries.Where(x => x.QueryId == qid).ToList();


        //////        //if (searchParameters.Count != 0)
        //////        //    DetailedProteinHitViewResults.Paramters.SearchParameters = searchParameters.Any() ? GetSearchParametersDtoModel(searchParameters.First()) : new SearchParameter();

        //////        //DetailedProteinHitViewResults.Paramters.FixedMods = ptmFixedmod;
        //////        //DetailedProteinHitViewResults.Paramters.VarMods = ptmVarmod;

        //////        //if (searchQuery.Count != 0)
        //////        //    DetailedProteinHitViewResults.Paramters.SearchQuerry = searchQuery.First();


        //////        //DetailedProteinHitViewResults.Results.PtmSites = ptmSite;
        //////        //if (searchResult.Count != 0)
        //////        //    DetailedProteinHitViewResults.Results.Results = searchResult.First();


        //////        //if (execTime.Count != 0)
        //////        //    DetailedProteinHitViewResults.ExecutionTime = execTime.First();



        //////    }
        //////    return DetailedProteinHitViewResults;
        //////}

        //////private SearchParameter GetSearchParametersDtoModel(SearchParameter searchParameters)
        //////{
        //////    var searchParameter = new SearchParameter
        //////    {
        //////        QueryId = searchParameters.QueryId,
        //////        Autotune = searchParameters.Autotune,
        //////        DenovoAllow = searchParameters.DenovoAllow,
        //////        MassMode = searchParameters.MassMode,
        //////        FilterDb = searchParameters.FilterDb,
        //////        HandleIons = searchParameters.HandleIons,
        //////        HopThreshhold = searchParameters.HopThreshhold,
        //////        HopTolUnit = searchParameters.HopTolUnit,
        //////        InsilicoFragType = searchParameters.InsilicoFragType,
        //////        UserId = searchParameters.UserId,
        //////        Title = searchParameters.Title,
        //////        ProteinDatabase = searchParameters.ProteinDatabase,
        //////        PtmTolerance = searchParameters.PtmTolerance,
        //////        MinimumPstLength = searchParameters.MinimumPstLength,
        //////        MaximumPstLength = searchParameters.MaximumPstLength,
        //////        MwTolerance = searchParameters.MwTolerance,
        //////        MwSweight = searchParameters.MwSweight,
        //////        PstSweight = searchParameters.PstSweight,
        //////        InsilicoSweight = searchParameters.InsilicoSweight,
        //////        NumberOfOutputs = searchParameters.NumberOfOutputs,
        //////        PtmAllow = searchParameters.PtmAllow,
        //////        NeutralLoss = searchParameters.NeutralLoss,
        //////        PSTTolerance = searchParameters.PSTTolerance,


        //////        PeptideTolerance = searchParameters.PeptideTolerance,
        //////        PeptideToleranceUnit = searchParameters.PeptideToleranceUnit,
        //////        TerminalModification = searchParameters.TerminalModification,
        //////        SliderValue = searchParameters.SliderValue,
        //////        CysteineChemicalModification = searchParameters.CysteineChemicalModification,
        //////        MethionineChemicalModification = searchParameters.MethionineChemicalModification,
        //////        EmailId = searchParameters.EmailId,
        //////        Truncation = searchParameters.Truncation,
        //////        FDRCutOff = searchParameters.FDRCutOff,
        //////        JobSubmission = searchParameters.JobSubmission

        //////    };
        //////    return searchParameter;
        //////}

        //////public void StoringCompiledResults(List<ResultsDownloadDataCompile> CompiledResults)
        //////{

        //////}
        //////public SearchParameter GetSearchParmeters(string qid)
        //////{
        //////    var SearchParameter = new SearchParameter();
        //////    using (new PerceptronDatabaseEntities())
        //////    {
        //////        var sqlConnection1 =
        //////            new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        //@"Server= BIRL-109004DT\SQLEXPRESS02; Database= PerceptronDatabase; Integrated Security=SSPI;");
        //////        var cmd = new SqlCommand
        //////        {
        //////            CommandText =
        //////                "SELECT QueryId \nFROM SearchResults \nWHERE QueryId = '" + qid + "'",
        //////            CommandType = CommandType.Text,
        //////            Connection = sqlConnection1
        //////        };
        //////        sqlConnection1.Open();

        //////        var dataReader = cmd.ExecuteReader();
        //////        while (dataReader.Read())
        //////            qid = dataReader["QueryId"].ToString();

        //////        dataReader.Close();
        //////        cmd.Dispose();
        //////        sqlConnection1.Close();
        //////    }
        //////    using (var db = new PerceptronDatabaseEntities())
        //////    {
        //////        var searchParameters = db.SearchParameters.Where(x => x.QueryId == qid).ToList();

        //////        if (searchParameters.Count != 0)
        //////            SearchParameter = searchParameters.Any() ? GetSearchParametersDtoModel(searchParameters.First()) : new SearchParameter();

        //////    }
        //////    return SearchParameter;
        //////}

        //////public string UpdatingDatabase(string DatabaseName, List<FastaReaderProteinDataDto> FastaReaderProteinInfo)  //For Updating Database Enteries by FastaReader (.fasta to SQL query)
        //////{
        //////    string Message = "Database Successfully Updated";

        //////    try
        //////    {
        //////        // string ConnetionString = "Data Source=BIRL-109004DT\SQLEXPRESS02;Initial Catalog=" + DatabaseName + ";Integrated Security=True";
        //////        string ConnetionString = "Data Source= "+ ServerName + "; Initial Catalog=" + DatabaseName + ";Integrated Security=false";

        //////        //new SqlConnection("Server=" + ServerName + "; Database= PerceptronDatabase; Integrated Security=false;", Credentials);
        //////        SqlConnection Connection = new SqlConnection(ConnetionString, Credentials);
        //////        Connection.Open();

        //////        var Query0 = "DELETE FROM " + DatabaseName + ".dbo.ProteinInfoes";      //Deleting previous data from the Database to avoid error like "Duplicating Primary Key Rule"
        //////        var Command0 = new SqlCommand(Query0, Connection);
        //////        Command0.ExecuteNonQuery();

        //////        var QueryInfo = "";


        //////        for (int index = 0; index < FastaReaderProteinInfo.Count; index++)
        //////        {
        //////            QueryInfo = "Insert INTO " + DatabaseName + ".dbo.ProteinInfoes (ID, ProteinDescription, MW, Seq, Insilico, InsilicoR) Values ('"
        //////             + FastaReaderProteinInfo[index].ID + "','" + FastaReaderProteinInfo[index].ProteinDescription + "','" + FastaReaderProteinInfo[index].MolecularWeight + "','" + FastaReaderProteinInfo[index].Sequence + "','" + FastaReaderProteinInfo[index].InsilicoLeft + "','" + FastaReaderProteinInfo[index].InsilicoRight + "')";

        //////            var Command = new SqlCommand(QueryInfo, Connection);
        //////            Command.ExecuteNonQuery();
        //////        }

        //////        Connection.Close();
        //////    }

        //////    catch (Exception e)
        //////    {
        //////        Message = "Error";
        //////    }
        //////    return Message;
        //////}

        //////public List<FastaWriterProteinDataDto> ReadingDataBase(string DatabaseName)  //For Downloading Database Enteries by FastaWriter (SQL Database to .fasta)
        //////{
        //////    var FastaWriterProteinInfo = new List<FastaWriterProteinDataDto>();
        //////    try
        //////    {
        //////        using (new PerceptronDatabaseEntities())
        //////        {
        //////            var sqlConnection1 =
        //////                new SqlConnection("Server= " + ServerName + "; Database= " + DatabaseName + "; Integrated Security=false;");
        //////            //new SqlConnection(@"Server= BIRL-109004DT\SQLEXPRESS02; Database= " + DatabaseName + "; Integrated Security=SSPI;");
        //////            var cmd = new SqlCommand
        //////            {
        //////                CommandText =
        //////                    "SELECT ProteinDescription, Seq \nFROM ProteinInfoes",
        //////                CommandType = CommandType.Text,
        //////                Connection = sqlConnection1
        //////            };
        //////            sqlConnection1.Open();

        //////            var dataReader = cmd.ExecuteReader();
        //////            while (dataReader.Read())
        //////            {
        //////                var tempFastaWriterProteinInfo = new FastaWriterProteinDataDto()
        //////                {
        //////                    ProteinDescription = dataReader["ProteinDescription"].ToString(),
        //////                    Sequence = dataReader["Seq"].ToString(),
        //////                };
        //////                FastaWriterProteinInfo.Add(tempFastaWriterProteinInfo);
        //////            }

        //////            dataReader.Close();
        //////            cmd.Dispose();
        //////            sqlConnection1.Close();
        //////        }
        //////    }
        //////    catch (Exception e)
        //////    {
        //////        throw;
        //////    }
        //////    return FastaWriterProteinInfo;
        //////}


    }
}
