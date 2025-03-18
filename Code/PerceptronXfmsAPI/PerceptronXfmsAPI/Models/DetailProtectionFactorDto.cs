using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PerceptronXfmsAPI.Models
{
    public class DetailProtectionFactorDto
    {
        public string PfSasaTabXlsFile;
        public string SasaMainImageFile;
        public byte[] SasaFileBlob;
        public string FastaFileInfo;
        public UniProtDto UniProtObj;
    }
}