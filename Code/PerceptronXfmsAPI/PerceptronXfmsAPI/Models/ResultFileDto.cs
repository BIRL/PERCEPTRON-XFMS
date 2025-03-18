using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PerceptronXfmsAPI.Models
{
    public class ResultFileDto
    {
        public List<ProteinDtoOld> TopProteinOfResultFile = new List<ProteinDtoOld>();
        public string ResultFileName;

        public ResultFileDto(List<ProteinDtoOld> cTopProteinOfResultFile, string cResultFileName)
        {
            TopProteinOfResultFile = cTopProteinOfResultFile;
            ResultFileName = cResultFileName;
        }
   }
}