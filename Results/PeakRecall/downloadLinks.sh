#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -cwd -V                  
#$ -l h_rt=01:00:00
#$ -l h_vmem=8G
 
#$ -t 1-23

for link in $(cat /home/s1949868/BedGraph/bigWigLinks.txt | head -n $SGE_TASK_ID | tail -n1); do 
	wget $link
done
