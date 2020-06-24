#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -cwd -V                  
#$ -l h_rt=00:05:00 # 4G 1s
#$ -l h_vmem=4G

#$ -t 1-410

# Configure modules
. /etc/profile.d/modules.sh
module load igmm/apps/BEDTools/2.27.1

# echo -e "sampleName\toverlapNumber\ttotalHotspots" > hotspotsOverlap.txt

# find the DSB hotspots that overlap any PRDM9 bound peaks
for file in $(ls /exports/eddie/scratch/s1949868/PRDM9BoundPeaks_410/*_PRDM9_bound_peaks.bed | head -n $SGE_TASK_ID | tail -n1); do
	echo $file

	# obtain the sample name to name the output file
	fileName=`echo ${file#*PRDM9BoundPeaks_410/}`
	fileName=`echo ${fileName%_PRDM9_bound_peaks*}`
	echo $fileName

	# find the DSB hotspots that overlap any PRDM9 bound peaks by `bedtools intersect`
	bedtools intersect -a /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt -b $file -u > "${fileName}_PRDM9BoundPeaks_overlap_hotspots.bed"
	# count hotspots that overlap PRDM9 motif
	overlapNumber=`wc -l "${fileName}_PRDM9BoundPeaks_overlap_hotspots.bed" | awk '{print $1}'`
	# total hotspots number
	totalHotspots=`wc -l /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt | awk '{print $1}'`
	# output the sample name and counts
	echo -e "${fileName}\t${overlapNumber}\t${totalHotspots}" >> hotspotsOverlap.txt

done