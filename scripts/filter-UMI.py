#!/bin/env python

from sys import argv, stdout
import gzip
import regex
#import re

def data_generator(fn):
    with gzip.open(fn) as f:
        while True:
            lines = [f.readline() for i in range(4)]
            if not lines[0]:
                break
            yield lines
    return

rm13 = regex.compile(r"(TGTAAAACGACGGCCAGT){s<=2}")

def myfilter(fn1, fn2):
    count = 0 
    count_pass = 0
    for data1, data2 in zip(data_generator(fn1), data_generator(fn2)):
        count += 1
        
        end = data1[1].decode()[:36]
        end1 = end[18:36]

        if count%1000000==0:
            print(count, count_pass)
            stdout.flush()
        
        if rm13.match(end1):
            count_pass += 1
            yield ((data1[0].decode().split()[0]+'#%s_%s\n'%(key, end[:18]), data1[1].decode()[36:], data1[2].decode(), data1[3].decode()[36:]),\
                   (data2[0].decode().split()[0]+'#%s_%s\n'%(key, end[:18]), data2[1].decode()[3:], data2[2].decode(), data2[3].decode()[3:]))

    print("FINISH", count, count_pass)


with open('HRP2-filterRM13-1.fastq','w') as f, open('HRP2-filterRM13-2.fastq','w') as g:
    for i, (fastq1, fastq2) in enumerate(myfilter(argv[1], argv[2])):
        f.write("".join(fastq1))
        g.write("".join(fastq2))
