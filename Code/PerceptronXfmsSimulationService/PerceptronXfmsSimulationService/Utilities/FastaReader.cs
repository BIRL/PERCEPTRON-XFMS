using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PerceptronXfmsSimulationService.DTO;

namespace PerceptronXfmsSimulationService.Utilities
{
    public class FastaReader
    {
        
        public ProteinDto FetchFastaInfo(string FastaFullFileName)
        {
            var _ProteinDto = new ProteinDto();
            try
            {
                //Stopwatch Time = Stopwatch.StartNew();
                //Time.Start();


                //var tempD = new List<FastaProteinDataDto>();

                var FastaFile = new StreamReader(FastaFullFileName);
                var ReadPeripheralFastaFile = new StreamReader(FastaFullFileName); // Reading same file but for using ReadLine() method separately...!

                //var FastaProteinInfo = new List<ProteinDto>();
                int FastaFileLineCount = File.ReadLines(FastaFullFileName).Count();  //ReadLines is more computationally efficient than ReadAllLines  &  ReadLines() creates an enumerator on the file, reading it line-by-line (actually using StreamReader. ReadLine() ).

                string NextLine = ReadPeripheralFastaFile.ReadLine();

                string tempHeader;
                string tempFastaHeader = "";
                string tempSequence = "";

                int FileReadingIteration = 0;

                /* FROM HERE; START READING FILE  */
                while (FileReadingIteration < FastaFileLineCount)// For Reading Full fasta file till end...
                {
                    tempHeader = "";
                    tempFastaHeader = "";
                    tempSequence = "";
                    string FastaFileLine;
                    //string NextLine;

                    while (true)
                    {
                        FileReadingIteration += 1;
                        FastaFileLine = FastaFile.ReadLine();

                        switch (FastaFileLine.Contains(">")) //Updated 20201215    --- Replaced this ">sp|" to ">"   ---- //ReadLine for Reading Lines Line By Line
                        {
                            case true:

                                /*Uniprot Accession Number have 6 to 10 alphanumrical characters...*/
                                /* https://www.uniprot.org/help/accession_numbers  */
                                //FastaFileLine = ">sp|ABCDEFGHIJKL123|NUD|||||4B"; //I am Just for testing

                                int FirstVerticalBar = FastaFileLine.IndexOf("|");              //Updated 20201215 
                                int SecondVerticalBar = FastaFileLine.IndexOf("|", FirstVerticalBar + 1);              //Updated 20201215 

                                tempHeader = FastaFileLine.Substring(FirstVerticalBar + 1, SecondVerticalBar - FirstVerticalBar - 1); //4: is starting Position(BUT NOT INCLUDED) & 6 is number of characters should be extracted
                                tempFastaHeader = FastaFileLine.Replace("'", " ");
                                tempFastaHeader = tempFastaHeader.Replace(",", " ");
                                ////if (FastaFileLine[10] != '|') //If Accession Number Length is >6    // ITS HEALTHY...
                                ////{
                                ////    int LengthofAccessionNumber = FastaFileLine.IndexOf('|', 9) - 4; //4 is due to {>sp|}
                                ////    tempHeader = FastaFileLine.Substring(4, LengthofAccessionNumber);
                                ////}
                                break;

                            case false:
                                tempSequence = tempSequence + FastaFileLine;//FastaFullFileName
                                break;
                        }
                        try
                        {
                            NextLine = ReadPeripheralFastaFile.ReadLine();
                            if (NextLine.Contains(">") || NextLine == null)  //Updated 20201215    --- Replaced this ">sp|" to ">"   ----
                            { break; }
                        }
                        catch (Exception) //Last Line will be empty. So, NextLine will be null & Exception will break the loop
                        {
                            break;
                        }
                    }
                    //GetSequenceInfoData(tempHeader, tempFastaHeader, tempSequence, FastaProteinInfo);

                }
                //FastaProteinInfo = FastaProteinInfo.OrderByDescending(n => n.MolecularWeight).ToList();  //Sort By Descending Order         //ITS HEALTHY

                //GetConnectionString(FastaProteinInfo, DatabaseToBeUpdated);   //ITS HEALTHY

                FastaFile.Close();

                _ProteinDto.ProteinHeader = tempFastaHeader;
                _ProteinDto.ProteinSequence = tempSequence;

                return _ProteinDto;// FastaProteinInfo;
            }
            catch (Exception e)
            {
                throw;
            }
        }
    }
}
