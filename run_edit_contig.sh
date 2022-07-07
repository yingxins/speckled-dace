#!/bin/bash -l
#SBATCH -D /home/yingxins/Dace
#SBATCH -J alignment
#SBATCH -o /home/yingxins/Dace/out-%A.%a.txt
#SBATCH -e /home/yingxins/Dace/error-%A.%a.txt
#SBATCH -t 24:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=syxsu@ucdavis.edu
#SBATCH --mem=60G


list=$1

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ]
do
	file=$(sed -n ${x}p $list)
	name=$(ls $file | sed 's/._contig//g')
	cat $file | cut -f3 >  ${name}_contig_depth.txt
	x=$(( $x + 1 ))

done

