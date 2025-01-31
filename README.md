# RNAseq alingment using a nextflow pipeline configuresd for bluebear

## Overview of running this pipeline

1. Download or clone this repo into a dir

2. Put all the fastq files in to a single dir, they need to be named like this:

```bash

CTRL_1_XXXXXX_LX_1.fq.gz
CTRL_1_XXXXXX_LX_2.fq.gz

```

3. Fastqs can come from different lanes, e.g. :

```bash

CTRL_1_XXXXXX_L1_1.fq.gz
CTRL_1_XXXXXX_L1_2.fq.gz
CTRL_1_XXXXXX_L2_1.fq.gz
CTRL_1_XXXXXX_L2_2.fq.gz

```

The script will group fatsqs from all samples after the second '_'


4. The modify the run.txt script to the dir with your data and ref genomes

5. Next submit your job and check outputs

6. (optional) Create STAR reference genenome

```bash
#!/bin/bash
#SBATCH -n 40
#SBATCH -N 1
#SBATCH --mem 180000
#SBATCH --time 10:0:0
#SBATCH --mail-type ALL
#SBATCH --account=croftap-stia-atac


set -e
module purge; module load bluebear
module load bear-apps/2022b
module load STAR/2.7.11a-GCC-12.2.0


STAR --runThreadN 40 \
--runMode genomeGenerate \
--genomeDir ./mm10 \
--genomeFastaFiles ./GRCh38.primary_assembly.genome.fa \
--sjdbGTFfile ./gencode.v29.annotation.gtf

```

