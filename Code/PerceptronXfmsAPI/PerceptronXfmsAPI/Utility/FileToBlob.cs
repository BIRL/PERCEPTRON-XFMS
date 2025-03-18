using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

namespace PerceptronXfmsAPI.Utility
{
    public class FileToBlob
    {

        public byte[] FileToBlobConverter(string FilePath)
        {
            
            byte[] FileBlob;
            using (FileStream fileStream = File.OpenRead(FilePath))
            {
                FileBlob = new byte[fileStream.Length];
                fileStream.Read(FileBlob, 0, (int) fileStream.Length);
            }
            return FileBlob;
        }
    }
}