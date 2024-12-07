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

