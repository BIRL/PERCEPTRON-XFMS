using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PerceptronXfmsAPI.Repository;
using PerceptronXfmsAPI.Models;

namespace PerceptronXfmsAPI.Utility
{
    public class QueueStatusAndTime
    {
        public void ExtractQueueStatusAndTimeInfo(SearchXfmsQueryDto parametersDto)
        {
            int AlreadyPresentJobs = new SqlDatabase().FetchQueuedInfo();

            parametersDto.SearchXfmsQuery.ExpectedCompletionTime = CalculateTime(AlreadyPresentJobs);  //CalculateTime(AlreadyPresentJobs);  //In hours

            parametersDto.SearchXfmsQuery.QueuePosition = (AlreadyPresentJobs + 1).ToString() + "/" + (AlreadyPresentJobs + 1).ToString();
        }

        public DateTime CalculateTime(int AlreadyPresentJobs)
        {
            int Tolerance = 3; // in hrs
            int TypicalCompletionTimeForOneJob = 3; // in hrs

            int hours = (AlreadyPresentJobs * TypicalCompletionTimeForOneJob) + Tolerance;

            var ExpectedCompletionTime = DateTime.Now.AddHours(hours);

            return ExpectedCompletionTime;
        }   
    }
}