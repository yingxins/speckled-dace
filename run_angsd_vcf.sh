#!/bin/bash -l
#!/bin/bash -l
#SBATCH -D /home/yingxins/Dace
#SBATCH -J alignment
#SBATCH -o /home/yingxins/Dace/out-%A.%a.txt
#SBATCH -e /home/yingxins/Dace/error-%A.%a.txt
#SBATCH -t 24:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=syxsu@ucdavis.edu
#SBATCH --mem=60G
#SBATCH -p high
list=$1
nInd=$(wc $bamlist | awk ‘{print $1}’)
minInd=$[$nInd*5/10]

angsd -bam ${list}  -GL 1 -out ${list}_phylogeny  -doMaf 1 -doMajorMinor 1 -SNP_pval 1e-12 -doGeno 4 -doPost 1  -minQ 20 -minMapQ 20 -minInd $minInd -minMaf 0.01 -doPlink 2 -dovcf 1
