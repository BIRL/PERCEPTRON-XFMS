using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PerceptronXfmsAPI.Models
{
    public class ResultsDownloadDto
    {
        public string ZipFileName;
        public byte[] FileBlob;
        
        //public ResultsDownloadDto(string cZipFileWithPath, List<byte[]> cListOfFileBlobs)
        //{
        //    ZipFileWithPath = cZipFileWithPath;
        //    ListOfFileBlobs = cListOfFileBlobs;
        //}
    }
}