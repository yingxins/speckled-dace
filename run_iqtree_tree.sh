#!/bin/bash -l
#SBATCH -D /home/yingxins/Dace
#SBATCH -J iqtree_phylogeny
#SBATCH -o /home/yingxins/Dace/out-%A.%a.txt
#SBATCH -e /home/yingxins/Dace/error-%A.%a.txt
#SBATCH -t 200:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=syxsu@ucdavis.edu
#SBATCH --mem=100G
file=$1
iqtree -s $file -m  TVM+F+R4 -cmax 15 -nt AUTO


