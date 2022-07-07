#!/bin/bash -l
#SBATCH -D /home/yingxins/Dace
#SBATCH -J prune
#SBATCH -o /home/yingxins/Dace/out-%A.%a.txt
#SBATCH -e /home/yingxins/Dace/error-%A.%a.txt
#SBATCH -t 24:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=syxsu@ucdavis.edu
#SBATCH --mem=60G
vcf=$1
bcftools +prune -m 0.9 -w 10000 ${vcf}.vcf  -Ov -o ${vcf}_prune.vcf

