using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PerceptronXfmsAPI.Models
{
    public class UniProtDto
    {
        public string PrimaryAccessionNo;
        public string MainHeaderInfo;
        public string ProteinName;
        public string GeneName;
        public string NoOfAminoAcids;
        public string OrganismName;
        public string CheckDataFetched = "False";
    }
}