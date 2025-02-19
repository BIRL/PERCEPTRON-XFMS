import pandas as pd
import numpy
import openpyxl

def CentralityFormattingAndSave(centralities, MyResultsFile):

   betweenes=(centralities['betweenness'])
   bet_true=betweenes[0]
   bet_true
   v = pd.DataFrame(bet_true).stack()
   Bet_normalized=(pd.concat({k: pd.DataFrame.from_dict(v, orient='index') for k,v in bet_true.items()})
      .stack()
      .unstack(1)
      .reset_index(level=1, drop=True)
      .rename_axis('Code')
      .reset_index())
   Bet_normalized
   numpy.transpose(Bet_normalized)
   bet_false=betweenes[1]
   bet_false
   v = pd.DataFrame(bet_false).stack()
   Bet_not_normalized=(pd.concat({k: pd.DataFrame.from_dict(v, orient='index') for k,v in bet_false.items()})
      .stack()
      .unstack(1)
      .reset_index(level=1, drop=True)
      .rename_axis('Code')
      .reset_index())
   Bet_not_normalized
   numpy.transpose(Bet_not_normalized)
   Degree=(centralities['degree'])

   degree_true=Degree[0]
   degree_true
   v = pd.DataFrame(degree_true).stack()
   deg_normalized=(pd.concat({k: pd.DataFrame.from_dict(v, orient='index') for k,v in degree_true.items()})
      .stack()
      .unstack(1)
      .reset_index(level=1, drop=True)
      .rename_axis('Code')
      .reset_index())
   deg_normalized
   numpy.transpose(deg_normalized)
   degree_false=Degree[1]
   degree_false
   v = pd.DataFrame(degree_false).stack()
   deg_not_normalized=(pd.concat({k: pd.DataFrame.from_dict(v, orient='index') for k,v in degree_false.items()})
      .stack()
      .unstack(1)
      .reset_index(level=1, drop=True)
      .rename_axis('Code')
      .reset_index())
   deg_not_normalized
   numpy.transpose(deg_not_normalized)
   bet= pd.concat([deg_normalized,deg_not_normalized,Bet_normalized,Bet_not_normalized])
   table=numpy.transpose(bet)
   table.columns=['degree_normalized_averaged', 'degree_not-normalized_averaged', 'degree_normalized_not-averaged', 'degree_not-normalized_not-averaged',
               'betweenness_normalized_averaged', 'betweenness_not-normalized_averaged', 'betweenness_normalized_not-averaged', 'betweenness_not-normalized_not-averaged']
   table = table.iloc[1: , :]
   table

   table.to_excel(MyResultsFile)