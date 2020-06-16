#!/usr/bin/python3

import os, sys
import subprocess as sp

# number of cancer type
num = int(sys.argv[1])
print(num)

# some paths
Cancer_Type_PeakCalls_path = "/exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls"
peaks001_path = "/exports/eddie/scratch/s1949868/PeakRecall_peaks001"
Sample_PeakCalls_path = "/exports/eddie/scratch/s1949868/Sample_PeakCalls"

# get abbreviations of 23 cancer types
Cancer_types = [i.split("_")[0] for i in os.listdir(Cancer_Type_PeakCalls_path)]
print(Cancer_types)

# function
def peakOverlap(Cancer_type, path):
	'''
	Obtain PeakCalls of 404 biological samples by using `bedtools intersect`:
	for each technical replicate(796), choose recalled peaks overlapping with corresponding cancer type-specific peakCalls
	only report peaks that are overlapped 100%
	peakCalls in two replicates from the same sample will be merged
	Args:
		Cancer_type: the abbreviation of a cancer type
		path: the path of input files (sorted Cancer type-specific peakCalls and all samples recalled peaks) and output files
	'''
	# use the same ID to identify technical replicates from the same biological sample
	l1 = ["_".join(i.split("_")[0:8]) for i in os.listdir(path) if i.startswith(Cancer_type) and i.endswith(".bed.sorted")]
	# count technical replicates for each ID and store them in a dict
	bioSample_dict={}
	for item in l1:
		if item in bioSample_dict:
			bioSample_dict[item]+=1
		else:
			bioSample_dict[item]=1
	print(bioSample_dict)
	for sample in bioSample_dict.keys():
		if bioSample_dict[sample] == 1:
			os.system("bedtools intersect -a " + path + "/" + Cancer_type + "*txt.sorted -b " + path + "/" + sample + "* -f 1.0 -wa -sorted > " + path + "/" + sample+"_peakCalls.bed")
			print("bedtools intersect -a " + path + "/" + Cancer_type + "*txt.sorted -b " + path + "/" + sample + "* -f 1.0 -wa -sorted > " + path + "/" + sample+"_peakCalls.bed")
		elif bioSample_dict[sample] == 2:
			os.system("bedtools intersect -a " + path + "/" + Cancer_type + "*txt.sorted -b " + path + "/" + sample + "* -f 1.0 -c -wa -sorted " + " | awk '{FS=OFS=" + r'"\t"' + ";if($5==2){print $1,$2,$3,$4}}'" + " > " + path + "/" + sample+"_peakCalls.bed")
			print("bedtools intersect -a " + path + "/" + Cancer_type + "*txt.sorted -b " + path + "/" + sample + "* -f 1.0 -c -wa -sorted " + " | awk '{FS=OFS=" + r'"\t"' + ";if($5==2){print $1,$2,$3,$4}}'" + " > " + path + "/" + sample+"_peakCalls.bed")

# ======================================= Main =======================================

# call peakOverlap() function
print Cancer_types[num]
peakOverlap(Cancer_type=Cancer_types[num], path=Sample_PeakCalls_path)