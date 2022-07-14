#!/bin/bash -l
#SBATCH -D /home/yingxins/Dace
#SBATCH -J iqtree_model_test
#SBATCH -o /home/yingxins/Dace/out-%A.%a.txt
#SBATCH -e /home/yingxins/Dace/error-%A.%a.txt
#SBATCH -t 100:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=syxsu@ucdavis.edu
#SBATCH --mem=100G
#SBATCH --ntasks=14
file=$1
iqtree -s $file -m MFP


