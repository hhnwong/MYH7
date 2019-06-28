#!/usr/bin/env python3

#*************************************************************************
#
#   Program:    Extract Excel Mutation
#   File:       ExtractExcelMutations.py
#   
#   Version:    Python 3
#   Date:       27.06.2019
#   
#   
#   Copyright:  (c) UCL / Rubakan Thurupan
#   Author:     Rubakan Thurupan
#   Address:    Biomolecular Structure & Modelling Unit,
#               Department of Biochemistry & Molecular Biology,
#               University College,
#               Gower Street,
#               London.
#               WC1E 6BT.
#   EMail:      rubakan.thurupan@nmbu.no

#*************************************************************************************************************************

#
#In this script I have extracted from the Excel document that we received 
#from cardiologist Dr.Lopes Luis from St Bartholomew's Hospital. 
#The goal is to use this script on Dr. Andrew Martin's bioinformatic tool to analyze.(?)
#*********************************************************************************************************

import pandas as pd
import re


def extract_mutants(df):
    """
    Here I am trying to extract mutant from the excel document
    """
    
    native_residue=list() #List of native residue
    residue_number=list() #List of reisdue number
    mutant_residue =list() # List of mutant residue
    pattern=re.compile("(\w)(\d+)(\w)")
      
    for i, line in enumerate(df['MYH7protein']):
        if not pd.isnull(line):
            matches = re.findall(pattern, line)
            if len(matches) == 1:
                match = matches[0]
                if (len(match)) == 3:
                    native_residue.append(match[0])
                    residue_number.append(match[1])
                    mutant_residue.append(match[2])
    
    return native_residue, residue_number, mutant_residue
    
def main(file, accession_code):
     
    #accession_code = "P12883"
    df = pd.ExcelFile(file).parse('Majid MYH7') #Read ExcelFile
    native_residue, residue_number, mutant_residue = extract_mutants(df)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="file to analyze", type=str)
    parser.add_argument("accession_code", help="accession code", type=str)
    args = parser.parse_args()
    main(args.file, args.accession_code)
    

   
    
 

