using System;
using System.IO;
using System.Net;
//using System.Net.Mail;
using MailKit;
using MailKit.Security;
using MimeKit;
using MimeKit.Text;
using MailKit.Net.Smtp;


namespace PerceptronXfmsAPI.Utility
{
    public static class SendingEmail
    {
        public static void SendingEmailMethod(string UserEmailAddress, string StringInfo, string ExpectedCompletionTime, string CreationTime, string EmailMessage)// Here StringInfo will behave based on EmailMessage either as JobTitle or UniqueUserGuid
        {
            try
            {

                string Path = @"C:\PerceptronXFMSInfo\";
                StreamReader ReadPerceptronXFMSEmailAddress = new StreamReader(Path + "PerceptronXFMSEmailAddress.txt");
                StreamReader ReadPerceptronXFMSEmailPassword = new StreamReader(Path + "PerceptronXFMSData.txt");
                string PerceptronXFMSEmailAddress = ReadPerceptronXFMSEmailAddress.ReadLine();
                string PerceptronXFMSEmailAddressPassword = ReadPerceptronXFMSEmailPassword.ReadLine();

                string BaseUrl = "https://perceptronxfms.lums.edu.pk/";
                var email = new MimeMessage();
                email.From.Add(MailboxAddress.Parse(PerceptronXFMSEmailAddress));
                email.To.Add(MailboxAddress.Parse(UserEmailAddress));


                if (EmailMessage == "Error") // Email Msg for Something Wrong With Entered Query     // StringInfo 
                {
                    email.Subject = "PERCEPTRON-XFMS: XFMS Search Query Not Submitted";

                    email.Body = new TextPart(TextFormat.Html)
                    {
                        Text =
                   "<span style=\"font-size:14px;\">Dear User," +
                    "<br/><br/> Your XFMS search query couldn't be submitted with the \"" + StringInfo + "\" job title. Please check your search parameters and data files." +
                    "</br><br/> For assistance in submitting a search, please visit the <a href=\'" + BaseUrl + "/index.html#/getting \'>Getting Started</a> page" +
                        " and see our <a href=\'https://www.youtube.com/playlist?list=PLaNVq-kFOn0Zu7xi94YiTauT2e5fxYLcz'>Video Tutorials</a>. <br/><br/>If " +
                        "problem still persists, feel free to <a href=\'" + BaseUrl + "index.html#/contact'>contact</a> us.</span>" +


                        EmailFooter()

                    };
                }
                else if (EmailMessage == "QuerySuccessfullySubmitted")
                {
                    email.Subject = "PERCEPTRON-XFMS: XFMS Search Query Submitted";
                    email.Body = new TextPart(TextFormat.Html)
                    {
                        Text =
                    "<span style=\"font-size:14px;\">Dear User," +
                    "<br/><br/>Your XFMS search query was successfully submitted at " + CreationTime + " with the \"" +
                            StringInfo + "\" job title and the expected completion time is " + ExpectedCompletionTime +".<br/><br/>You can check the status of your query at the <a href=\'" + BaseUrl +
                            "index.html#/history \'>User Search History</a> page and once your query will be successfully completed then, we will inform you through an email as well.</span>" +
                    //"</br><br/>For assistance in submitting a search, please visit the <a href=\'" + BaseUrl + "index.html#/getting \'>Getting Started</a> page " +
                    //"and see our <a href=\'https://www.youtube.com/playlist?list=PLaNVq-kFOn0Zu7xi94YiTauT2e5fxYLcz'>Video Tutorials</a>.</span>" +

                    EmailFooter()
                    };
                }



                //email.Subject = "Test Email Subject";
                //email.Body = new TextPart(TextFormat.Html) { Text = "<h1>Example HTML Message Body</h1>" };

                // send email
                using (SmtpClient smtp = new SmtpClient())
                {
                    smtp.Connect("smtp.office365.com", 587, SecureSocketOptions.StartTls);       // https://learn.microsoft.com/es-es/dotnet/api/system.net.mail.smtpclient?redirectedfrom=MSDN&view=netframework-4.7.2 // https://jasonwatmore.com/post/2021/09/02/net-5-send-an-email-via-smtp-with-mailkit
                    smtp.Authenticate(PerceptronXFMSEmailAddress, PerceptronXFMSEmailAddressPassword);
                    smtp.Send(email);
                    smtp.Disconnect(true);
                }
            }
            catch (Exception EmailSentError)
            {

            }


           
        }

        public static string EmailFooter()
        {
            return "<span style=\"font-size:14px;\"></br>Thank you for using PERCEPTRON-XFMS." +
                "</br><br/>Best Wishes," + 
                "<br/><b>The PERCEPTRON-XFMS Team,</b></span>" +
                "<span style=\"font-size:12px;\"></br></br>Biomedical Informatics & Engineering Research Laboratory (BIRL)," +
                "</br>Department of Life Sciences, SBA School of Science and Engineering," +
                "</br>Lahore University of Management Sciences (LUMS), Lahore, Pakistan" +
                "</br>Voice: +92 42 3560 8352" +
                "</br>Email: <a href=\'mailto:perceptronxfms@lums.edu.pk'>perceptronxfms@lums.edu.pk</a>" +
                "</br>Web: <a href='http://biolabs.lums.edu.pk/birl'>biolabs.lums.edu.pk/birl</a> </span>";
        }
    }
}









