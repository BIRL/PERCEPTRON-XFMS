using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PerceptronXfmsAPI.Models
{
    public class FrustratometerDto
    {
        public string ImageFilesPathInfo;
        public List<byte[]> ImageFilesInListOfBlobs = new List<byte[]>();
        public string FastaFileInfo;
        public UniProtDto UniProtObj;
    }
}