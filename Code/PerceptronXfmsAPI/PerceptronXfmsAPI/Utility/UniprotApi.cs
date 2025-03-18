using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using Newtonsoft.Json;
//using System.Security.Cryptography.Xml;
using PerceptronXfmsAPI.Models;

namespace PerceptronXfmsAPI.Utility
{
    public class UniprotApi
    {
        public string ExtractProteinHeader(string FastaFileInfo)
        {
            string ProteinHeader = JsonConvert.DeserializeObject<ProteinDto>(FastaFileInfo).ProteinHeader;

            int FirstVerticalBar = ProteinHeader.IndexOf("|");              //Updated 20201215 
            int SecondVerticalBar = ProteinHeader.IndexOf("|", FirstVerticalBar + 1);              //Updated 20201215 

            ProteinHeader = ProteinHeader.Substring(FirstVerticalBar + 1, SecondVerticalBar - FirstVerticalBar - 1);

            return ProteinHeader;
        }




        public UniProtDto GetAndPrepareUniprotData(string ProteinHeader)
        {

            string DataObject = GetUniprotData(ProteinHeader);

            var UniProtObj = new UniProtDto();
            UniProtObj.PrimaryAccessionNo = ProteinHeader;

            if (DataObject != null)
            {
                UniProtObj = PrepareUniprotInfo(DataObject, UniProtObj);
                UniProtObj.CheckDataFetched = "True";
            }
            return UniProtObj;
        }



        public UniProtDto PrepareUniprotInfo(string DataObject, UniProtDto UniProtObj)
        {
            string LineStart = "ID   ";
            int MainHeaderStartIndex = DataObject.IndexOf(LineStart);
            int MainHeaderEndIndex = DataObject.IndexOf("              Reviewed;");

            int length = MainHeaderEndIndex - LineStart.Length;
            UniProtObj.MainHeaderInfo = DataObject.Substring(MainHeaderStartIndex + LineStart.Length, length);



            string ProtNameStart = "DE   RecName: Full=";
            int ProtStartIndex = DataObject.IndexOf(ProtNameStart);
            int ProtEndIndex = DataObject.IndexOf(";\nGN   Name=");

            length = ProtEndIndex - (ProtStartIndex + ProtNameStart.Length);
            UniProtObj.ProteinName = DataObject.Substring(ProtStartIndex + ProtNameStart.Length, length);


            string GeneStart = "GN   Name=";
            int GeneStartIndex = DataObject.IndexOf(GeneStart);
            int GeneEndIndex = DataObject.IndexOf("; OrderedLocusNames=");

            length = GeneEndIndex - (GeneStartIndex + GeneStart.Length);
            UniProtObj.GeneName = DataObject.Substring(GeneStartIndex + GeneStart.Length, length);



            string AminoAcidsStart = "SQ   SEQUENCE   ";
            int AminoAcidsStartIndex = DataObject.IndexOf(AminoAcidsStart);
            int AminoAcidsEndIndex = DataObject.IndexOf(" AA;  ");

            length = AminoAcidsEndIndex - (AminoAcidsStartIndex + AminoAcidsStart.Length);
            UniProtObj.NoOfAminoAcids = DataObject.Substring(AminoAcidsStartIndex + AminoAcidsStart.Length, length);




            string OrganismNameStart = "OS   ";
            int OrganismNameStartIndex = DataObject.IndexOf(OrganismNameStart);
            int OrganismNameEndIndex = DataObject.IndexOf(".\nOC   ");

            length = OrganismNameEndIndex - (OrganismNameStartIndex + OrganismNameStart.Length);
            UniProtObj.OrganismName = DataObject.Substring(OrganismNameStartIndex + OrganismNameStart.Length, length);
            
            return UniProtObj;
        }


        public string GetUniprotData(string ProteinHeader)
        {
            string UniProtBaseApiURL = "https://rest.uniprot.org/uniprotkb/" + ProteinHeader + ".txt";
            string UrlParameters = "";
            string DataObject = "";

            using (HttpClient client = new HttpClient())
            {
                client.BaseAddress = new Uri(UniProtBaseApiURL);
                // Add an Accept header for JSON format.
                client.DefaultRequestHeaders.Accept.Add(
                   new MediaTypeWithQualityHeaderValue("application/json"));
                ServicePointManager.Expect100Continue = true;
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                // Get data response
                var response = client.GetAsync(UrlParameters).Result;
                if (response.IsSuccessStatusCode)
                {
                    // Parse the response body
                    DataObject = response.Content.ReadAsStringAsync().Result;
                }
                else
                {
                    DataObject = null;
                    //Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
                }
            }
            return DataObject;
        }

    }
}