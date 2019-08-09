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
#
#********************************************************************************************************************
#
#   Description:
#   ============
#
#********************************************************************************************************************
#
#   Usage:
#   ======
#   Extract a Excel file to Python Script.
#
#********************************************************************************************************************
#
#   Revision History:
#   =================
#   V1.0   25.06.19  Original
#   V1.1   27.06.19  Output format   Changed uniprot accession to be at 
#                                    the start of each line rather than a counter 
#                                        
#                    file            Changed filename from "MYH7protein.py to
#                                    ExtractExcelMutations.py.
#                    
#   V1.2   28.06.19  Import          added the add_argument() method, which is what we use to specify which 
#                    Argparse        command-line options the program is willing to accept. 
#                                    
#                    
#
#
#********************************************************************************************************************
import pandas as pd
import re


def extract_mutants(df, column_name):
    """
    Here I am trying to extract mutant from the excel document.
    We import the pandas module, including ExcelFile. 
    The df reads the data into a Pandas Data Frame.
    """
    
    result=list() #List of native residue
    pattern=re.compile("(\w)(\d+)(\w)")
      
    for i, line in enumerate(df[column_name]): #paramether
        if not pd.isnull(line):
            matches = re.findall(pattern, line)
            if len(matches) == 1:
                match = matches[0]
                if (len(match)) == 3:
                    result.append(match[0] + ' ' + match[1] + ' '+ match[2]) #one line
                    
    
    return result
    
def main(file,sheet_name, column_name, accession_code): #mangler her 
     
    #accession_code = "P12883"
    df = pd.ExcelFile(file).parse(sheet_name) #Read ExcelFile #Exchelsheet
    results = extract_mutants(df,column_name)
    for result in results:
        print(accession_code, ' ', result)

if __name__ == "__main__":
    """
    
    """
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="file to analyze", type=str)
    parser.add_argument("sheet_name", help ="sheet name", type=str)
    parser.add_argument("column_name", help="column name", type=str)
    parser.add_argument("accession_code", help="accession code", type=str)
    args = parser.parse_args()
    main(args.file,args.sheet_name,args.column_name,args.accession_code)
    

   
    
 

