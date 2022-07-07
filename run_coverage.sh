#!/bin/bash -l
#SBATCH -D /home/yingxins/Dace
#SBATCH -J coverage
#SBATCH -o /home/yingxins/Dace/out-%A.%a.txt
#SBATCH -e /home/yingxins/Dace/error-%A.%a.txt
#SBATCH -t 24:00:00
#SBATCH --array=1-19
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=syxsu@ucdavis.edu
#SBATCH --mem=60G
list=spk_469
ref=spk_bam_contig2
file=$(sed  -n ${SLURM_ARRAY_TASK_ID}p ${list})
name=$(ls ${file} | sed 's/.sort.flt.bam//g')
wc=$(wc -l ${ref} | awk '{print $1}')

x=1
while [ $x -le $wc ]
do
	contig=$(sed -n ${x}p ${ref})
	samtools depth -r ${contig}:50-50 $file  > ${name}_${contig}_${SLURM_ARRAY_TASK_ID}
	cat  ${name}_${contig}_${SLURM_ARRAY_TASK_ID} >> ${name}.contig
	rm ${name}_${contig}_${SLURM_ARRAY_TASK_ID}
	x=$(($x+1))
done



