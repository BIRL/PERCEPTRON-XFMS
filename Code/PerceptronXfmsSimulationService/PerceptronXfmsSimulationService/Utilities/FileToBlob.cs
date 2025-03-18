using System.IO;

namespace PerceptronXfmsSimulationService.Utilities
{
    public class FileToBlob
    {

        public byte[] FileToBlobConverter(string ImageFile)
        {

            byte[] SasaFileBlob;
            using (FileStream fileStream = File.OpenRead(ImageFile))
            {
                SasaFileBlob = new byte[fileStream.Length];
                fileStream.Read(SasaFileBlob, 0, (int)fileStream.Length);
            }
            return SasaFileBlob;
        }
    }
}