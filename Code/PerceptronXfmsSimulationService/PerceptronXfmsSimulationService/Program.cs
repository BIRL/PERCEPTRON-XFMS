using System;
using System.IO;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Threading;
using PerceptronXfmsSimulationService.Repository;
using PerceptronXfmsSimulationService.EngineCalling;
using PerceptronXfmsSimulationService.Utilities;
using PerceptronXfmsSimulationService.DTO;
using System.Data.Entity.Validation;
using PerceptronXfmsSimulationService.Constants;

namespace PerceptronXfmsSimulationService
{
    class Program
    {
        //public static string RootPath = @"F:\PERCEPTRONXFMS";   //D:\GitHub\02_WebTool\WebTool //"D:\FARHAN\00_LocalGitHub\WebTool";
        //public static string MatlabMainFileFullPath = RootPath + "\\ToolBox";   // Path will be updated based on dev or prod side folder structs
        //public static string MatlabScriptsFullPath = RootPath + "\\PerceptronXfmsSimulationService\\PerceptronXfmsSimulationService\\Utilities";

        //public static string ResultFolderPath = @"F:\ResultFolder";
        //public static string InputFolder = @"F:\Input";//"D:\PerceptronXfmsInputFolder";

        public static string subInputFolder = "MiscInputFiles";
        public static string subName = "Result_";


        public static string PeptideInfo = "PeptideInfo.xls";
        public static string PfSasaTabXlsFile = "PF_SASA_tab.xls";
        public static string BridgeResultsFile = "ResultsBridge.xlsx";
        public static string SasaMainImageFile = "SASAmain.png";
        public static string FastaFile = "Fasta.fasta";

        public static string FrustratometerFolder = "frustratometeR_Results";

        public static string FrustratometerImageResultsFolder = "Images";
        public static DateTime ExpectedCompletionTime = DateTime.Now.AddHours(3);  // in hrs

        public static int TypicalCompletionTimeForOneJob = 3;    // in hrs
        public static int Tolerance = 3;    // in hrs





        public static void UpdateSampleResultsOnDB()
        {
            try
            {
                string QueryID = "00000000-0000-0000-0000-000000000000";
                string UserID = "Sample";
                string Progress = "Sample Results";
                DateTime CreationTime = DateTime.Now.AddDays(0);
                string isBridgeEnabled = "True";    // "False"
                string isFrustratometerEnabled = "True";    // "False"
                string EmailID = "";
                string Title = "XFMS - Sample Results";

                string QueryResultFullPath = StringConstants.ResultFolderPath + "\\" + subName + QueryID;

                if (!Directory.Exists(QueryResultFullPath))
                {
                    throw new Exception("Sample Result folder does not exist at specified location.");
                }

                //var _FastaReader = new FastaReader();
                //var ProteinInfo = _FastaReader.FetchFastaInfo(QueryResultFullPath + "\\" + FastaFile);


                string ZippingFileName = "";
                var ResultsSaveDbObj = new ResultsVisualizeSaveIntoDB();

                //ResultsSaveDbObj.FastaFileInfo = JsonConvert.SerializeObject(ProteinInfo);

                //var ProteinInfo = new List<ProteinDto>(){ new ProteinDto()    //Creating List Just to avoid Front end parsing errors
                //{
                //    ProteinHeader = "P0AE67",
                //    ProteinSequence = "MADKELKFLVVDDFSTMRRIVRNLLKELGFNNVEEAEDGVDALNKLQAGGYGFVISDWNMPNMDGLELLKTIRADGAMSALPVLMVTAEAKKENIIAAAQAGASGYVVKPFTAATLEEKLNKIFEKLGM"
                //} };


                //var ProteinInfo = new ProteinDto()    //Creating List Just to avoid Front end parsing errors
                //{ 
                //    ProteinHeader = "P0AE67",
                //    ProteinSequence = "ADKELKFLVVDDFSTMRRIVRNLLKELGFNNVEEAEDGVDALNKLQAGGYGFVISDWNMPNMDGLELLKTIRADGAMSALPVLMVTAEAKKENIIAAAQAGASGYVVKPFTAATLEEKLNKIFEKLGM"
                //};

                //////////////////////////
                //var test = new FetchPathsForFrustratometerResults().FetchFilePathsOfFrustratometerResults(QueryResultFullPath, FrustratometerFolder, FrustratometerImageResultsFolder);
                //instanceSqlDatabase.ResultsSaveIntoDbForVisualize(QueryID, ResultsSaveDbObj);
                //////////////////////////////////




                CompileResultsforDownAndVisualize(QueryResultFullPath, Title, QueryID, ref ZippingFileName, ResultsSaveDbObj, isBridgeEnabled, isFrustratometerEnabled);

                var instanceSqlDatabase = new SqlDatabase();


                // Delete All Sample Results Before Adding new Sample Results
                instanceSqlDatabase.RemovePreviousSampleResults(QueryID);



                ///// SAVING INFORMATION FOR SAMPLE SEARCH RESULTS
                ///
                instanceSqlDatabase.SaveSampleResultsSearchXfmsQuery(QueryID, UserID, Progress, CreationTime, isBridgeEnabled, isFrustratometerEnabled, EmailID, Title);

                // Save ZippingFileName  into the DB
                instanceSqlDatabase.SaveZipFullFilePath(QueryID, ZippingFileName);

                // Save Results into DB for Visualization
                instanceSqlDatabase.ResultsSaveIntoDbForVisualize(QueryID, ResultsSaveDbObj);

            }
            catch(DbEntityValidationException e)      // Exception 
            {
                
                DBErrorException.DbEntitiyError(e);
                // ERROR- Unable to update the Sample Results
            }

        }




        public static void RunMeOnly()
        {
            byte[] blob;
            // Read Zip file 
            using (FileStream fileStream = File.OpenRead(@"F:\PerceptronXfmsResultFolder\Result_8ecbd72f-5188-4a4f-b1b7-4d27f9bd7136\Modifiedchey.pdb"))
            {
                blob = new byte[fileStream.Length];
                fileStream.Read(blob, 0, (int)fileStream.Length);
            }
        }


        static void Main(string[] args)
        {
            //RunMeOnly();
            var instanceSqlDatabase = new SqlDatabase();
            bool RunLoop = true;
            string format = "yyyy/MM/dd HH:mm:ss";

            //Checking the path of MATLAB code based on my cube or server
            StringConstants.MatlabMainFileFullPath = CheckMatlabToolboxPathInsideDev(StringConstants.MatlabMainFileFullPath, "ToolBox");
            StringConstants.MatlabScriptsFullPath = CheckMatlabToolboxPathInsideDev(StringConstants.MatlabScriptsFullPath, "Utilities");


            /// Updating Sample Results On DB
            //UpdateSampleResultsOnDB();



            Console.WriteLine("WARNING!!!");
            Console.WriteLine("Using the path " + StringConstants.MatlabMainFileFullPath + " for ToolBox");
            Console.WriteLine("Using the path " + StringConstants.MatlabScriptsFullPath + " for Utilities");

            Console.WriteLine("**********************************************");
            Console.WriteLine("*****PERCEPTRON-XFMS INITIALIZING CONSOLE*****");
            Console.WriteLine("**********************************************");

            
            //string EmailID = "";
            while (RunLoop)
            {
                

                
                var SearchQuery = instanceSqlDatabase.FetchQuery();
                try
                {


                    //SearchQuery.QueryID = "8ecbd72f-5188-4a4f-b1b7-4d27f9bd7136";                  //////Only for testing

                    if (SearchQuery != null)  // for safety
                    {
                        string JobStatus = "Running";


                        //Updating the Queued status and Expected Completion time 
                        instanceSqlDatabase.UpdateJobStatus(SearchQuery.QueryID, JobStatus, ExpectedCompletionTime);

                        if (SearchQuery.EmailID != "")
                        {
                            SendingEmail.SendingEmailMethod(SearchQuery.EmailID, SearchQuery.Title, ExpectedCompletionTime.ToString(format), SearchQuery.CreationTime.ToString(format), "QueryIsJustStartedForRunning");
                        }

                        //Update the status of other queued position jobs
                        instanceSqlDatabase.UpdateQueuedInfo(TypicalCompletionTimeForOneJob, Tolerance);


                        Console.WriteLine("Running Job: " + SearchQuery.QueryID + "-----" + "Progress: " + JobStatus);


                        var Call2MatlabDataObj = new Calling2Engine().Call2MATLAB(StringConstants.MatlabMainFileFullPath, SearchQuery);

                        //////// Read MATLAB output files for (i) creating zip file that will be used for Results Downloading &
                        //////// for (ii) Results Visualization
                        //////// end results of both (i) & (ii) will be saved into the database

                        string ZippingFileName = "";
                        var ResultsSaveDbObj = new ResultsVisualizeSaveIntoDB();

                        CompileResultsforDownAndVisualize(Call2MatlabDataObj.QueryResultFullPath, SearchQuery.Title, SearchQuery.QueryID, ref ZippingFileName, ResultsSaveDbObj, SearchQuery.isBridgeEnabled, SearchQuery.isFrustratometerEnabled);

                        ////Zipping the Resutls
                        //var ZippingFileName = new Zipping().ZippingOutputFiles(ResultFolderPath, Call2MatlabDataObj.QueryResultFullPath, SearchQuery.Title, SearchQuery.QueryID);


                        // Reading Files & Save Into DB
                        //var ResultsSaveDbObj = new ResultsVisualizeSaveIntoDB();

                        //DoseResponseInformation


                        //Reading FASTA File
                        //string FastaFile = InputFolder + "\\" + QueryID + "\\" + subInputFolder + "\\" + "FASTA.fasta";
                        //ResultsSaveDbObj.ProteinSequence = new ReadFastaFile().FastaFileReader(FastaFile);


                        //PeptideInfo.xls
                        //string PeptideInfo = "PeptideInfo.xls";
                        //ResultsSaveDbObj.PeptideInfo = new Call2ExcelFileReader().Call2ExcelFileReaderMatlab(MatlabScriptsFullPath, ResultFolderPath, subName, SearchQuery.QueryID, PeptideInfo);



                        ///PF_SASA_tab.xls
                        //string PfSasaTabXlsFile = "PF_SASA_tab.xls";
                        //ResultsSaveDbObj.PfSasaTabXlsFile = new Call2ExcelFileReader().Call2ExcelFileReaderMatlab(MatlabScriptsFullPath, ResultFolderPath, subName, SearchQuery.QueryID, PfSasaTabXlsFile);



                        ///Bridge2 - Centrality Table [ResultsBridge.xlsx]
                        //if (SearchQuery.isBridgeEnabled == "True")
                        //{
                        //    //string BridgeResultsFile = "ResultsBridge.xlsx";
                        //    // Read file and save into DB
                        //    ResultsSaveDbObj.BridgeResultsFile = new Call2ExcelFileReader().Call2ExcelFileReaderMatlab(MatlabScriptsFullPath, ResultFolderPath, subName, SearchQuery.QueryID, BridgeResultsFile);
                        //}



                        /// SASAmain.png
                        //string SasaMainImageFile = "SASAmain.png";
                        //ResultsSaveDbObj.SasaMainImageFile = ResultFolderPath + "\\" + subName + SearchQuery.QueryID + "\\" + SasaMainImageFile;

                        //var SasaFileBlob = new FileToBlob().FileToBlobConverter(ResultFolderPath + "\\" + subName + SearchQuery.QueryID + "\\" + SasaMainImageFile);
                        //ResultsSaveDbObj.SasaMainImageFile = new BlobToBase64().BlobToStringConverter(SasaFileBlob);


                        /////////////////////////  BELOW IS FOR UPCOMING IMPLEMENTATION
                        /////////////////////////  BELOW IS FOR UPCOMING IMPLEMENTATION
                        /////////////////////////  BELOW IS FOR UPCOMING IMPLEMENTATION

                        ///Modified (Protection Factor) PDB [Modifiedchey.pdb]
                        //string PfModifiedPdb = "Modifiedchey.pdb";


                        ///Modified Centrality (Centrality.m) PDB [XYZ]


                        // Save ZippingFileName  into the DB
                        instanceSqlDatabase.SaveZipFullFilePath(SearchQuery.QueryID, ZippingFileName);

                        // Save Results into DB for Visualization
                        instanceSqlDatabase.ResultsSaveIntoDbForVisualize(SearchQuery.QueryID, ResultsSaveDbObj);


                        instanceSqlDatabase.UpdateJobStatus(SearchQuery.QueryID, "Completed", ExpectedCompletionTime);
                        Console.WriteLine("Running Job: " + SearchQuery.QueryID + "-----" + "Progress: " + "Completed");
                        int waithere = 1;

                        if (SearchQuery.EmailID != "")
                        {
                            SendingEmail.SendingEmailMethod(SearchQuery.EmailID, SearchQuery.Title, ExpectedCompletionTime.ToString(format), SearchQuery.CreationTime.ToString(format), "QuerySuccessfullyCompleted");
                        }

                    }
                    else
                    {
                        Thread.Sleep(10000);
                    }
                }
                catch(Exception Error)
                {
                    if (SearchQuery != null)
                    {
                        // Here error will come 

                        // Save Status into the DB
                        instanceSqlDatabase.UpdateJobStatus(SearchQuery.QueryID, "Error In Query", ExpectedCompletionTime);

                        if (SearchQuery.EmailID != "")
                        {
                            SendingEmail.SendingEmailMethod(SearchQuery.EmailID, SearchQuery.Title, ExpectedCompletionTime.ToString(format), SearchQuery.CreationTime.ToString(format), "Error");
                        }

                        Console.WriteLine("Running Job: " + SearchQuery.QueryID + "-----" + "Progress: " + "Error In Query");
                    }
                }
                
            }
            Console.ReadLine();
        }


        public static string CheckMatlabToolboxPathInsideDev(string Folder, string CheckPathOf)
        {
            string FolderInfo = Folder;
            if (!(Directory.Exists(Folder)) && CheckPathOf == "ToolBox")
            {
                Folder = StringConstants.MatlabMainFileFullPath;
            }
            else if (!(Directory.Exists(Folder)) && CheckPathOf == "Utilities")
            {
                Folder = StringConstants.MatlabScriptsFullPath;
            }
            return Folder;
        }

        public static void CompileResultsforDownAndVisualize(string QueryResultFullPath, string Title, string QueryID, ref string ZippingFileName, ResultsVisualizeSaveIntoDB ResultsSaveDbObj, string isBridgeEnabled, string isFrustratometerEnabled)
        {
            var _FastaReader = new FastaReader();
            var ProteinInfo = _FastaReader.FetchFastaInfo(QueryResultFullPath + "\\" + FastaFile);
            ResultsSaveDbObj.FastaFileInfo = JsonConvert.SerializeObject(ProteinInfo);


            ////Zipping the Resutls
            ZippingFileName = new Zipping().ZippingOutputFiles(StringConstants.ResultFolderPath, QueryResultFullPath, Title, QueryID);

            ResultsSaveDbObj.PeptideInfo = new Call2ExcelFileReader().Call2ExcelFileReaderMatlab(StringConstants.MatlabScriptsFullPath, StringConstants.ResultFolderPath, subName, QueryID, PeptideInfo);

            ResultsSaveDbObj.PfSasaTabXlsFile = new Call2ExcelFileReader().Call2ExcelFileReaderMatlab(StringConstants.MatlabScriptsFullPath, StringConstants.ResultFolderPath, subName, QueryID, PfSasaTabXlsFile);

            if (isBridgeEnabled == "True")
            {
                ResultsSaveDbObj.BridgeResultsFile = new Call2ExcelFileReader().Call2ExcelFileReaderMatlab(StringConstants.MatlabScriptsFullPath, StringConstants.ResultFolderPath, subName, QueryID, BridgeResultsFile);
            }

            if(isFrustratometerEnabled == "True")
            {
                ResultsSaveDbObj.FrustratometerResultFiles = new FetchPathsForFrustratometerResults().FetchFilePathsOfFrustratometerResults(QueryResultFullPath, FrustratometerFolder, FrustratometerImageResultsFolder);
                
                //ResultsSaveDbObj.FrustratometerResultFiles
            }

            ResultsSaveDbObj.SasaMainImageFile = StringConstants.ResultFolderPath + "\\" + subName + QueryID + "\\" + SasaMainImageFile;

        }

    }
}






//Outputs from MATLAB code  ->
//  -> (i) Sucessfully Run 
//  -> (ii) Error in Simulation
// Update the status into the database
// (if) success then create a zipped folder as well and SAVE INTO THE RESULTSLOG TABLE
//
//Send email to the user (if email provided)
//
//
// If DB is not attached then service should not crash but go to the sleep..!!

