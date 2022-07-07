#!/bin/bash -l
#SBATCH -D /home/yingxins/Dace
#SBATCH -J genotype_calling
#SBATCH -o /home/yingxins/Dace/out-%A.%a.txt
#SBATCH -e /home/yingxins/Dace/error-%A.%a.txt
#SBATCH -t 24:00:00
list=$1
nInd=88

angsd -bam ${list}  -GL 1 -out ${list}_glf2  -doMaf 1 -doMajorMinor 1 -SNP_pval 0.00000001 -doGeno 4 -doPost 2  -minQ 20 -minMapQ 20 -minInd $nInd  -minMaf 0.01 -doPlink 2 -doGlf 3
