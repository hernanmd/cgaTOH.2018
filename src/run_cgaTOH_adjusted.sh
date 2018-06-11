#!/bin/sh

# Description: Run cgaTOH Software script.
# Author : <hernan.morales@gmail.com>
# Input:
#   .ped/.map directory
#	Ranges of minimum physical length of a TOH run
#	Number of chromosomes
#	Number of iterations
#	CSV file with cgaTOH parameters
#	Minimum SNP overlap
# 	Maximum physical gap between adjacent SNPs
# Output:
#   Text file with complete cgaTOH output log

#################################################
#
# Input settings
#
#################################################

set -e

# Name of the software executable
tohExe=TOH_ClusteringSuite_v1_0.exe
# CSV file with cgaTOH parameters
globalInputFile="../SNPs_Het_Mis.txt"
# Directory with .PED/.MAP files
globalInputDir="pedmaps/"
# Maximum chromosome number
maxChr=29
# iterations (maximum tree depth) for binary clustering, default 100
k=100000
# Minimum SNP overlap, default is 10
min_snp_overlap=3
# Maximum physical gap between adjacent SNPs, if not given physical gaps won't be considered
max_gap=1000000
# minimum physical length of a TOH run, if not given phycal length won't be considered. A.k.a: Window Size
minLengthRange=(1000000 2000000 4000000 8000000 16000000)
# Complete output log file
log=run_log.txt

# Get timestamp
echo "Getting timestamp"
timestamp=$(date -d "today" +"%Y%m%d%H%M%S")
# Setup output file name
outputFile="$timestamp"

#################################################
#
# Download cgaTOH
#
#################################################

tohWin="Windows_32_bit.zip"
[[ -f $tohWin ]] || wget http://www.cs.kent.edu/%7Ezhao/TOH/Windows_32_bit.zip; unzip $tohWin

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

#################################################
#
# Begin code
#
#################################################

i=0
echo "Entering loops"
for chr in $(seq -s " " 1 $maxChr); do
	echo "Processing Chromosome $chr"
	inputFile=$globalInputDir$chr
	for inputParamFile in $paramInputTableNames; do
		echo "Input file: "$inputFile
		
		echo "Processing $inputParamFile"
		# Read parameter record
		echo "${chr}q;d" > tmpFile
		field=$(sed -f tmpFile $inputParamFile)
		# Parse parameters
		chrs=$(echo $field | cut -d" " -f1)
		echo "Processing chromosome: "$chrs
		
		snp=$(echo $field | cut -d" " -f2)
		echo "Processing SNPs: "$snp
		
		max_hetero=$(echo $field | cut -d" " -f3)
		max_missing=$(echo $field | cut -d" " -f4)
		
		outputFile=$chrs"_"$snp"_"${minLengthRange[$i]}"_"$max_missing"_"$max_hetero
		echo "Current output file: "$outputFile
		./$tohExe -force_proceed -map $inputFile -p $inputFile -l $snp -n $min_snp_overlap -min_length ${minLengthRange[$i]} -max_gap $max_gap -max_missing $max_missing -max_hetero $max_hetero -k $k -o $outputFile | tee -a $log
		
		# Increment min length index to match current inputParamFile
		((i++))
	done
	i=0
done
