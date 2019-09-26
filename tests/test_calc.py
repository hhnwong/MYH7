#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 27 14:12:59 2019

@author: Rubakan
"""

import unittest
import pandas as pd
from myh7_analysis.ExtractExcelMutations import extract_mutants

class TestCalc(unittest.TestCase):
    
   def test_mutant_name_extraction(self):
       df = pd.DataFrame({"MYH7protein": ["R453C"]})
       native_residue, residue_number, mutant_residue=extract_mutants(df)
       self.assertEqual(native_residue[0], "R")
       self.assertEqual(residue_number[0], "453")
       self.assertEqual(mutant_residue[0], "C")

if __name__ == '__main__':
    unittest.main()