#!/bin/bash
for file in *.json
do 
  $PBIN/saapJSONPred.pl -v $file >$file.pred
done
