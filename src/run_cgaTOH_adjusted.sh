#!/bin/sh

#################################################
#
# PARAMETER SAFETY CHECKING
#
#################################################

set -e

globalInputFile="../SNPs_Het_Mis.txt"
globalInputDir="../PEDMAPs-by-Chr/RttPEDMAP-v6-H-by-Chr/RttPEDMAP-v6-H-c"
# globalInputDir="PEDMAPs-by-Chr\RttPEDMAP-v6-L-by-Chr\RttPEDMAP-v6-L-c"

# Get timestamp
echo "Getting timestamp"
timestamp=$(date -d "today" +"%Y%m%d%H%M%S")
# Setup output file name
outputFile="$timestamp"
# Maximum chromosome number
maxChr=29

#################################################
#
# Split global parameter table
#
#################################################

cut -f 1-4 $globalInputFile | tail -n +2 > SNPs_Het_Mis_MinL01M.csv
cut -f 1-2,5-6 $globalInputFile | tail -n +2 > SNPs_Het_Mis_MinL02M.csv
cut -f 1-2,7-8 $globalInputFile | tail -n +2 > SNPs_Het_Mis_MinL04M.csv
cut -f 1-2,9-10 $globalInputFile | tail -n +2 > SNPs_Het_Mis_MinL08M.csv
cut -f 1-2,11-12 $globalInputFile | tail -n +2 > SNPs_Het_Mis_MinL16M.csv

#################################################
#
# cgaTOH parameters
#
#################################################

echo "Setting ROH parameters"

paramInputTableNames=$(ls SNPs_Het_Mis_MinL*)

# iterations (maximum tree depth) for binary clustering, default 100c
k=100000

# minimum physical length of a TOH run, if not given phycal length won't be considered. A.k.a: Window Size
minLengthRange=(1000000 2000000 4000000 8000000 16000000)

i=0
echo "Entering loops"
for chr in $(seq 1 $maxChrNumber); do
	echo "Processing Chromosome $chr"
	inputFile=$globalInputDir$chr
	for inputParamFile in $paramInputTableNames; do
		echo "Processing $inputParamFile"
		# Read parameter record
		echo "${chr}q;d" > tmpFile
		field=$(sed -f tmpFile $inputParamFile)
		# Parse parameters
		chr=$(echo $field | cut -d" " -f1)
		snp=$(echo $field | cut -d" " -f2)
		max_hetero=$(echo $field | cut -d" " -f3)
		max_missing=$(echo $field | cut -d" " -f4)
		outputFile=$chr"_"$snp"_"${minLengthRange[$i]}"_"$max_missing"_"$max_hetero
		TOH_ClusteringSuite_v1_0.exe -force_proceed -map $inputFile -p $inputFile -l $snp -n 3 -min_length ${minLengthRange[$i]} -max_gap 1000000 -max_missing $max_missing -max_hetero $max_hetero -k $k -o $outputFile | tee -a log_all1.txt
		# Increment min length index to match current inputParamFile
		((i++))
	done
	i=0
done
