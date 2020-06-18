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

# find the DSB hotspots that any PRDM9 motif falls into for each biological sample
for file in $(ls /exports/eddie/scratch/s1949868/Fimo_sample/*_fimo_out/fimo.gff | head -n $SGE_TASK_ID | tail -n1); do
	echo $file

	# obtain the sample name to name the output file
	fileName=`echo ${file:44:50}`
	echo $fileName

	# find the DSB hotspots that any PRDM9 motif falls into by `bedtools intersect`
	bedtools intersect -a /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt -b $file -u -F 1.0 > "${fileName}.hotspots.bed"
	# count hotspots that overlap PRDM9 motif
	overlapNumber=`wc -l "${fileName}.hotspots.bed" | awk '{print $1}'`
	# total hotspots number
	totalHotspots=`wc -l /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt | awk '{print $1}'`
	# output the sample name and counts
	echo -e "${fileName}\t${overlapNumber}\t${totalHotspots}" >> hotspotsOverlap.txt

done