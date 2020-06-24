#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -cwd -V                  
#$ -l h_rt=00:05:00 # 4G 1s
#$ -l h_vmem=4G

#$ -t 1-23
 
# Configure modules
. /etc/profile.d/modules.sh
module load igmm/apps/BEDTools/2.27.1

# find the DSB hotspots that any PRDM9 motif falls into for each biological sample
for file in $(ls /exports/eddie/scratch/s1949868/Fimo_23_cancerType/*_fimo_out/fimo.gff | head -n $SGE_TASK_ID | tail -n1); do
	echo $file

	# obtain the sample name to name the output file
#	fileName=`echo ${file:44:50}`
	fileName=`echo ${file#*Fimo_23_cancerType/}`
	fileName=`echo ${fileName%_fimo_out*}`
	echo $fileName

	# find the DSB hotspots that any PRDM9 motif falls into by `bedtools intersect`
	bedtools intersect -a /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls/bed/"${fileName}.bed" -b $file -u -F 1.0 > "${fileName}_PRDM9_bound_peaks.bed"

done