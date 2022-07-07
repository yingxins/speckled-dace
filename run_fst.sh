#!/bin/bash -l
#SBATCH -D /home/yingxins/Dace
#SBATCH -J fst
#SBATCH -o /home/yingxins/Dace/out-%A.%a.txt
#SBATCH -e /home/yingxins/Dace/error-%A.%a.txt
#SBATCH -t 24:00:00
#SBATCH --array=0-7

list1=("spk_bam_CCA" "spk_bam_CCA" "spk_bam_CCA" "spk_bam_CCA" "spk_bam_CCA" "spk_bam_CCA" "spk_bam_CCA" "spk_bam_CCA")   #no comma
list2=("spk_bam_LongValley" "spk_bam_Amargosa" "spk_bam_Owens" "spk_bam_Lahontan" "spk_bam_Butte" "spk_bam_Klamath" "spk_bam_WarnerB" "spk_bam_SantaAna")
ref=final_contigs.fasta
c1=${list1[$SLURM_ARRAY_TASK_ID]}
c2=${list2[$SLURM_ARRAY_TASK_ID]}

angsd -b ${c1}   -anc $ref  -out ${c1} -dosaf 1 -gl 1
angsd -b ${c2}   -anc $ref  -out ${c2} -dosaf 1 -gl 1
realSFS ${c1}.saf.idx ${c2}.saf.idx > ${c1}_${c2}.ml
realSFS fst index ${c1}.saf.idx ${c2}.saf.idx -sfs ${c1}_${c2}.ml  -fstout ${c1}_${c2}
realSFS fst stats ${c1}_${c2}.fst.idx | cat >  ${c1}_${c2}.txt 

