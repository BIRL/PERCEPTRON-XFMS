using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PerceptronXfmsAPI.Models
{
    public class UserHistory
    {
        public string title { get; set; }
        public string time { get; set; }
        public string qid { get; set; }
        public string progress { get; set; }
        public string ExpectedCompletionTime { get; set; }
        public string QueuePosition { get; set; }
    }
}