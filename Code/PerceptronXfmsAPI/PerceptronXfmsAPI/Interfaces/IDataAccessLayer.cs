using System;
using System.Collections.Generic;
using PerceptronXfmsAPI.Models;
using PerceptronXfmsAPI.Engine;

namespace PerceptronXfmsAPI
{
    internal interface IDataAccessLayer
    {
        Statistics stat();
        string StoreXfmsSearchParameters(SearchXfmsQueryDto parameters);
        List<UserHistory> GetUserHistory(string Uid, string UserIDforSampleResults, DateTime JobSubmissionTime);
        List<ScanResults> SearchResultsContent(string QueryID, DateTime JobSubmissionTime);
        string ZipFullFilePath(string QueryID);
        DetailProtectionFactorDto FetchResultsProtectionFactor(string QueryID);
        DetailedCentralityDto FetchResultsCentrality(string QueryID);
        FrustratometerDto FetchResultsFrustratometer(string QueryID);
        SearchXfmsQueryDto FetchSearchParameters(string QueryID);

        //ZipResultsDownloadInfo ScanResultFile(string QueryId);
        //List<ScanResults> Scan_Results(string qid, DateTime JobSubmissionTime);
        //List<SummaryResults> Summary_results(string qid, string fid, DateTime JobSubmissionTime);
        //DetailedResults Detailed_Results(string qid, string rid, DateTime JobSubmissionTime);
        //DetailedProteinHitView DetailedProteinHitView_Results(string qid, string rid, string rank, DateTime JobSubmissionTime);
        //void StoringCompiledResults(List<ResultsDownloadDataCompile> CompiledResults);
        //SearchParameter GetSearchParmeters(string qid);
        //ScanResultsDownloadDataDto ScanResultsDownloadData(string qid, string FileUniqueId);
        //string StoreSearchParameters(SearchParametersDto parameters);
        //string UpdatingDatabase(string DatabaseName, List<FastaReaderProteinDataDto> FastaProteinInfo);

        //ScanInputDataDto ScanInputData(string qid);
        //string StorePerceptronSdkInfo(DateTime JobSubmission, string QueryId, string Title, string UserName);

        //List<string> ScanResultsAgainstFileUniqueId(string qid, string FileId);
        //MassSpectrumImagedetail GetImagePathMassSpectrum(string qid);
    }
}
