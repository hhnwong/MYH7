# Programs
CSV2ARFF=csv2arff
DOMCC=./domcc.pl
ENCODE=./encode.pl

# Inputs and options for encoding
FAAFILE=myh7.faa
MUTANTS=myh7_data.csv
MATRIX=BLOSUM80.mat

# Inputs and options for csv2arff
INPUTS=./inputs.txt
DATA=./encodedMutants.csv
OUTPUT=phenotype
CLASSES=HCM,DCM
LIMIT=5
OPTIONS="-norm -ni -auto"

# Location of Weka jar file and Weka classifier
export CLASSPATH="$WEKA/weka.jar"
# CLASSIFIER=weka.classifiers.functions.MultilayerPerceptron
CLASSIFIER="weka.classifiers.trees.RandomForest -I 20 -K 5"
WEKAOPTS="-x 5"  # number of x-validation folds
#WEKAOPTS=""

################################################################################
# Encode the mutant data
echo "Encoding data..."
$ENCODE $FAAFILE $MUTANTS $MATRIX >$DATA

# Run csv2arff
echo "Creating ARFF files..."
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n1.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n2.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n3.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n4.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n5.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n6.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n7.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n8.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n9.arff
$CSV2ARFF -class=$CLASSES -limit=$LIMIT $OPTIONS $INPUTS $OUTPUT $DATA >n10.arff

# Run Weka
# -t = Train
# -i = Give information on performance
echo "Running WEKA..."
java $CLASSIFIER $WEKAOPTS -i -t n1.arff >n1.out
java $CLASSIFIER $WEKAOPTS -i -t n2.arff >n2.out
java $CLASSIFIER $WEKAOPTS -i -t n3.arff >n3.out
java $CLASSIFIER $WEKAOPTS -i -t n4.arff >n4.out
java $CLASSIFIER $WEKAOPTS -i -t n5.arff >n5.out
java $CLASSIFIER $WEKAOPTS -i -t n6.arff >n6.out
java $CLASSIFIER $WEKAOPTS -i -t n7.arff >n7.out
java $CLASSIFIER $WEKAOPTS -i -t n8.arff >n8.out
java $CLASSIFIER $WEKAOPTS -i -t n9.arff >n9.out
java $CLASSIFIER $WEKAOPTS -i -t n10.arff >n10.out

# Print results
echo "Creating results..."
echo "               TP Rate   FP Rate   Precision   Recall  F-Measure   ROC Area  Class"
cat *.out | grep -A 20 Stratified | grep Weighted
for file in n*.out; do $DOMCC $file | tail -1; done
