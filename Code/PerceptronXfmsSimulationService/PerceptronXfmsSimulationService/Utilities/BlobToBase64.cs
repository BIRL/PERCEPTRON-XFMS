using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PerceptronXfmsSimulationService.Utilities
{
    public class BlobToBase64
    {
        public string BlobToStringConverter(byte[] BlobObject)
        {
            if (BlobObject != null)
            {
                return Encoding.UTF8.GetString(BlobObject);
            }
            else
            {
                return string.Empty;
            }
        }
    }
}
