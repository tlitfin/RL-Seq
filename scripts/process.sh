#!/bin/bash

xdir=$(dirname $0)
datadir=$xdir/../data/
logdir=$xdir/../logs/

prefix=SRR17926733

#### STAGE 1
raw1=${prefix}_1.fastq.gz
raw2=${prefix}_2.fastq.gz
python $xdir/filter.py $raw1 $raw2 > $logdir/filter.log


#### STAGE 2
bbduk.sh -in=HRP1-filterRM13-1.fastq \
    -in2=HRP1-filterRM13-2.fastq -out=HRP1-trimadapt-1.fastq -out2=HRP1-trimadapt-2.fastq \
    -ktrim=r -k=17 -mink=15 -hdist=2 -ref=$datadir/adapters.fa \
    -minlen=15 -tbo -maq=10 -tpe &> $logdir/duk.log

#### STAGE 3
bowtie2 --very-sensitive --no-unal -p 32 -x $datadir/reference/trinity_ribosome -1 HRP1-trimadapt-1.fastq -2 HRP1-trimadapt-2.fastq -S HRP1-mapped.sam &> $logdir/bowtie2.log

#### STAGE 4
mkdir data
python $xdir/count.py HRP1-mapped.sam $datadir/reference/trinity_ribosome.fasta data/
