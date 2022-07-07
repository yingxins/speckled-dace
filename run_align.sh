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
ref=$2

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p ${list}" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2, $3}')   
	set -- $var
	c1=$1
	c2=$2
	c3=$3

	echo "#!/bin/bash -l

bwa mem -t 4 $ref ${c1} ${c2} | samtools view -Sb - | samtools sort - > ${c3}.sort.bam
samtools view -f 0x2 -b ${c3}.sort.bam | samtools rmdup - ${c3}.sort.flt.bam
bwa -a is $ref ${c3}.sort.flt.bam" > ${c3}.sh

	sbatch -t 1:00:00 -c 4 --mem=2G ${c3}.sh

	x=$(( $x + 1 ))

done


