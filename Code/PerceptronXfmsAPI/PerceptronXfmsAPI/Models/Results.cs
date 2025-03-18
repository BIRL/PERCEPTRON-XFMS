using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PerceptronXfmsAPI.Models
{
    public class Results
    {
        public string QueryId;
        public List<ProteinDtoOld> FinalProt;
        public ExecutionTime Times;

        public Results(string qId, List<ProteinDtoOld> prt, ExecutionTime t)
        {
            QueryId = qId;
            FinalProt = prt;
            Times = t;
        }
        public Results()
        {
            FinalProt = new List<ProteinDtoOld>();
            Times = new ExecutionTime();
        }
    }
}