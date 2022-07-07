#!/bin/bash -l

bamlist=$1
nInd=$(wc $bamlist | awk '{print $1}')
minInd=$[$nInd*5/10]

angsd -bam ${bamlist} -out ${bamlist}_pca -doMajorMinor 1 -minMapQ 20 -minQ 20 -SNP_pval 1e-12 -GL 1 -doMaf 1 -minMaf 0.01 -minInd ${minInd} -doCov 1 -doIBS 1 -doCounts 1

