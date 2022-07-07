#!/bin/bash -l

bamlist=$1
nInd=$(wc $bamlist | awk '{print $1}')
minInd=88

angsd -GL 1 -out ${bamlist}_admix -nThreads 10 -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-12 -doMaf 1 -bam ${bamlist} -minInd ${minInd} -minMapQ 20 -minQ 20 -minMaf 0.01
