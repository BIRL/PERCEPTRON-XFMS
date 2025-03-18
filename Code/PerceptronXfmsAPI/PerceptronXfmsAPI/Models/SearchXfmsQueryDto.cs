using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PerceptronXfmsAPI.Models
{
    public class SearchXfmsQueryDto
    {
        public SearchXfmsQuery SearchXfmsQuery;

        public SearchXfmsQueryDto()
        {
            SearchXfmsQuery = new SearchXfmsQuery();
        }
    }
}