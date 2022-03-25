# RL-Seq
## 1. Create environment
```
conda create rlseq
conda activate rlseq
conda install regex samtools bowtie2 bbtools biopython openjdk sra-tools -c bioconda -c conda-forge -c agbiome
```
## 2. Clone dependencies
```
git clone https://github.com/sparks-lab-org/RL-Seq.git
cd RL-Seq
git clone https://github.com/Daniel-Liu-c0deb0t/UMICollapse
cd ../
```
Increase the Java memory allocation in UMICollapse by modifying the umicollapse file to:
```
java -server -Xms110G -Xmx110G -Xss800M -jar umicollapse.jar $@
```
The specific memory allocation may depend on your system resources. 
Note that this is only required for UMI deduplication and is not required to analysis UMI-free data.

## 3. Download data
Data can be downloaded from the SRA [PRJNA803956](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA803956).
SRR17951350: ~56Gb
SRR17926733: ~5Gb

## 4. Run analysis
```
git clone https://github.com/sparks-lab-org/RL-Seq
fastq-dump ./SRR17926733 --split-3 --gzip
bash RL-Seq/scripts/process.sh

fastq-dump ./SRR17951350 --split-3 --gzip
bash RL-Seq/scripts/process-UMI.sh
```
