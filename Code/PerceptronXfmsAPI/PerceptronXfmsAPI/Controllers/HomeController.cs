using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Mvc;
using System;

using PerceptronXfmsAPI.Utility;

namespace PerceptronXfmsAPI.Controllers
{
    public class HomeController : ApiController
    {

        [System.Web.Http.HttpGet]
        [System.Web.Http.Route("")]
        public HttpResponseMessage Index()
        {
            //SendingEmail.SendingEmailMethod("farhan.biomedical.2022@gmail.com", "TestingEmail", "2023", "2022", "Error");

            return new HttpResponseMessage()
            {
                Content = new StringContent(
                    "<strong>PerceptronXfmsAPI is working fine.</strong>",
                    Encoding.UTF8,
                    "text/html"
                )
            };
        }
    }
}