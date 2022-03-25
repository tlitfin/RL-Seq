#!/bin/bash

xdir=$(dirname $0)
datadir=$xdir/../data/
logdir=$xdir/../logs/

prefix=SRR17951350

#### STAGE 1
raw1=${prefix}_1.fastq.gz
raw2=${prefix}_2.fastq.gz
python $xdir/filter-UMI.py $raw1 $raw2 > $logdir/filter-UMI.log

#### STAGE 2
bbduk.sh -in=HRP2-filterRM13-1.fastq \
    -in2=HRP2-filterRM13-2.fastq -out=HRP2-trimadapt-1.fastq -out2=HRP2-trimadapt-2.fastq \
    -ktrim=r -k=17 -mink=15 -hdist=2 -ref=$datadir/adapters-UMI.fa \
    -minlen=15 -tbo -maq=10 -tpe &> $logdir/duk-UMI.log

#### STAGE 3
bowtie2 --very-sensitive --no-unal -p 32 -x $datadir/reference/trinity_ribosome -1 HRP2-trimadapt-1.fastq -2 HRP2-trimadapt-2.fastq | samtools view -bS - | samtools sort - -o HRP2-sorted.bam  &> $logdir/bowtie2-UMI.log

#### STAGE 4
wd=$PWD
cd $xdir/../UMICollapse
./umicollapse bam -i $wd/HRP2-sorted.bam -o $wd/HRP2-dedupe.sam --umi-sep \# --pairs --two-pass
cd $wd

#### STAGE 5
mkdir data-UMI
python $xdir/count.py HRP2-dedupe.sam $datadir/reference/trinity_ribosome.fasta data-UMI/
