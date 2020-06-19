#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -cwd -V                  
#$ -l h_rt=00:05:00
#$ -l h_vmem=2G
 
#$ -t 1-410
 
# Configure modules
. /etc/profile.d/modules.sh
module load igmm/apps/BEDTools/2.27.1
module load python/3.4.3

# # prepare the input of bedtools
# echo "sort start: $(date)"
# # sort and cut files of Cancer Type-specific PeakCalls
# cd /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls # Cancer_Type_PeakCalls_path in peakOverlap.py
# for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > /exports/eddie/scratch/s1949868/PeakCall_410_c3l400/${file}.sorted; done
# # cut files of recalled peaks in each technical replicate
# cd /exports/eddie/scratch/s1949868/PeakRecall_796_c3l400 # peaks_path in peakOverlap.py
# for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3}}' > /exports/eddie/scratch/s1949868/PeakCall_410_c3l400/${file}.sorted; done
# echo "sort done: $(date)"

# peakOverlap
echo "peakOverlap start: $(date)"
python3 /home/s1949868/peakOverlap.py $SGE_TASK_ID
echo "peakOverlap done: $(date)"