using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Linq;
using System.Web;
using System.Diagnostics;

namespace PerceptronXfmsAPI.Utility
{
    public class ExcelFileReader
    {
        //public voi
        // How data is reading in C# then do work around of un necessary data trimming along with 
        // if missing data then show 0 or missing etc.

            


        public void ExcelFileReading(string Path)
        {




            //this is the connection string which has OLDB 4.0 Connection and Source URL of file
            //use HDR=YES if first excel row contains headers, HDR=NO means your excel's first row is not headers and it's data.


            //string connString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source= " + Path + "; Extended Properties='Excel 8.0;HDR=YES;IMEX=1;'";

            //string connString = "Provider = Microsoft.ACE.OLEDB.12.0; Data Source = " + Path + "; Persist Security Info = False;";


            string connString = "Provider = Microsoft.ACE.OLEDB.12.0; Data Source = " + Path + "; Extended Properties = 'Excel 12.0 Xml;HDR=YES'";

            // Create the connection object
            OleDbConnection oledbConn = new OleDbConnection(connString);
            try
            {
                // Open connection
                oledbConn.Open();

                // Create OleDbCommand object and select data from worksheet Sample-spreadsheet-file
                //here sheet name is Sample-spreadsheet-file, usually it is Sheet1, Sheet2 etc..
                //OleDbCommand cmd = new OleDbCommand("SELECT * FROM [Sample-spreadsheet-file$]", oledbConn);

                OleDbCommand cmd = new OleDbCommand("SELECT * FROM [Sheet1$]", oledbConn);

                // Create new OleDbDataAdapter
                OleDbDataAdapter oleda = new OleDbDataAdapter();

                oleda.SelectCommand = cmd;

                // Create a DataSet which will hold the data extracted from the worksheet.
                DataSet ds = new DataSet();

                // Fill the DataSet from the data extracted from the worksheet.
                //oleda.Fill(ds, "Employees");


                DataSet dsRetrievedData = new DataSet();


                oleda.Fill(dsRetrievedData);
                
                Debug.WriteLine(dsRetrievedData);
                Debug.WriteLine(dsRetrievedData.Tables[0].DefaultView);

                List<string> tempResiduePos = new List<string>();
                List<string> tempResidue = new List<string>();
                List<string> tempSasaValues = new List<string>();
                List<string> tempLogPfValues = new List<string>();


                //loop through each row
                foreach (var m in ds.Tables[0].DefaultView)
                {
                    //tempResiduePos.Add((m.Row.ItemArray[0]).To);
                    Debug.WriteLine(((System.Data.DataRowView)m).Row.ItemArray[0] + " " + ((System.Data.DataRowView)m).Row.ItemArray[1] + " " + ((System.Data.DataRowView)m).Row.ItemArray[2]);

                }

            }
            catch (Exception e)
            {
                Console.WriteLine("Error :" + e.Message);
            }
            finally
            {
                // Close connection%
                oledbConn.Close();
            }
        }
    }


}
