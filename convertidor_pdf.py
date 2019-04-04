# -*- coding: utf-8 -*-
"""
Created on Wed Apr  3 22:43:36 2019

@author: jmhc
"""

import PyPDF2 

#%%
archivo = 'C:/Users/jmhc/Documents/clasificador.pdf'

# leer archivo pdf

pdfFileObj = open(archivo, 'rb')

# Procesa archivo pdf
pdfReader = PyPDF2.PdfFileReader(pdfFileObj)

num_pages = pdfReader.numPages
count = 0
text = ""

#The while loop will read each page
while count < num_pages:
    pageObj = pdfReader.getPage(count)
    count +=1
    text += pageObj.extractText()
    
print(text)
