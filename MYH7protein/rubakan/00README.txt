This directory contains a mix of code and examples that illustrate how
you can train a Random Forest or Neural Network with data from the
structural analysis using SAAPdap.

SAAPdap generates a JSON file containing the analysis results. You
need to convert this into a CSV file which contains one row for each
mutant and columns that represent the different structural analysis
parameters. You will also need an output column that indicates whether
the mutant in question is damaging or not (or whatever other
classification you wish to use).

The JSON to CSV conversion is done by the script
json2csv_uniprot_allPDB.pl in the json2csv directory. You simply run
it with

    json2csv_uniprot_allPDB.pl  myfile.json > myfile.csv

You then need to convert the CSV file to the ARFF format used by
Weka. This is done using the csv2arff.pl script. This script has lots
of options to select which columns from the CSV file you want to use
as well as the name of the column which has the output information. It
has lots of options which, amongst other things, can limit the number
of records of each output class. For example if you have 100 damaging
mutants and 10 non-damaging mutants, you can use -limit=10 to select
all the non-damaging mutants and a random selection of 10 of the 100
damaging ones. This then allows you to train several machine learning
models each with a balanced set of data - when you want to make a
prediction, you then use all the models and take a vote on the result.

The mcc.pl script shows you how to calculate the Matthews Correlation
Coefficient - the measure of performance we tend to use. If you have
two possible states (e.g. damaging and neutral) then you can create a
'confusion matrix' comparing the number of predictions and actual
damaging/neutral mutations:

                   PREDICTION
              Damaging    Neutral
            ----------------------
A  Damaging | TP          FN
C           |
T           |
U  Neutral  | FP          TN
A           |
L           |

So you have:
TP (true positives)
FN (false negatives)
FP (false positives)
TN (true negatives)
... where positive means damaging and negative means neutral - but
this is arbitrary - it can be either way round depending on what you
are trying to do.

The mcc.pl script is run as
mcc.pl -tp=xxx -fn=xxx -fp=xxx -tn=xxx


There are then two directories with examples. You need to have
downloaded and installed Weka first and you need to edit the scripts
referred to below to point CLASSPATH to the appropriate directory and
file containing the Weka code.




The experiment1 directory contains examples of how to do the training
using a very simple sequence window-based approach rather than using
all the structural analysis. We did this for the MYH7 HCM/DCM paper to
prove that what we were doing with structural analysis really gave a
benefit. 

It takes a CSV file of the mutants and does all the stages for
training and testing Weka. It uses Weka from the command line rather
than the graphical interface and uses a different script to generate
the MCC which reads the Weka output and calculates the MCC.

Basically the 'doit.sh' script in that directory does all the work. It
assumes you have copied csv2arf.pl to ~/bin/csv2arff

First it runs the encode.pl program to encode the sequence data. Then,
since the dataset is unbalanced (many more HCM than DCM) it uses the
csv2arff program to take 10 approximately equal subsets from the
data. It then trains on each of the 10 sets, extracts the results and
then calculates the MCC.





The humvar500 directory contains another example - this is a real
example training and testing on the HumVar dataset of damaging and
neutral mutations. It uses 500 of each selected at random from a CSV
file generated from the JSON output of the SAAPdap analysis. This is
done by the doit_prepare script (which again assumes you have copied
csv2arf.pl to ~/bin/csv2arff). The doit_learn script then trains and
tests the machine learning.





