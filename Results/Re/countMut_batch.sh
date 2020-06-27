#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -cwd -V                  
#$ -l h_rt=00:05:00
#$ -l h_vmem=8G

#$ -t 1-404

# Configure modules
. /etc/profile.d/modules.sh
module load igmm/apps/R/3.6.3

# echo -e "sampleID\tcancerType\tMutNumber\tOverlapNumber" > MutNumber.txt

# 
for file in $(ls /exports/eddie/scratch/s1949868/PRDM9BoundPeaks_410_Case_ID/* | head -n $SGE_TASK_ID | tail -n1); do
	echo $file

	Rscript ~/countMut.R $file

done