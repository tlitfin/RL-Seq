#!/bin/env python

from sys import argv
from Bio import SeqIO
import numpy as np
import re
import os

id_dict = {
        'BB': '5S',
        'AA': '16S',
        'DA': '23S'
        }

seq_dict = {}
sequences = {}
for record in SeqIO.parse(argv[2], 'fasta'):
    seq_dict[id_dict[record.id]] = np.zeros((len(record.seq)))
    sequences[id_dict[record.id]] = record.seq._data.replace('T', 'U')

with open(argv[1]) as f:
    for i, line in enumerate(f):
        if i%1000000==0: print("%d reads complete..."%i)
        ss = line.split('\t')
        if ss[1] != '83' and ss[1]!='89': continue
            
        matches = sum(map(int, re.findall(r"(\d+)M", ss[5])))
        deletes = sum(map(int, re.findall(r"(\d+)D", ss[5])))
        inserts = sum(map(int, re.findall(r"(\d+)I", ss[5])))

        try:
            seq_dict[id_dict[ss[2]]][int(ss[3])+matches+deletes-2]+=1
        except:
            print(ss)
            from sys import exit
            exit(1)
        

bdir=argv[3]
for id, data in seq_dict.items():
    with open('%s/%s.txt'%(bdir,id),'w') as f:
        for i in range(len(data)):
            f.write('%d %s %d\n'%(i+1, sequences[id][i], data[i]))

    
