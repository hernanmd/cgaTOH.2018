#!/bin/sh

#################################################
#
# PARAMETER SAFETY CHECKING
#
#################################################

set -e

globalInputFile="../SNPs_Het_Mis2.txt"
globalInputDir="pedmaps/"
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

listChr=$(seq -s " " 1 $maxChr)
echo "Lista CHR = "$listChr
for chr in $listChr; do
	echo "Processing Chromosome $chr"
	inputFile=$globalInputDir"GT0016_ArBos1_1_ordenado2-ord_f6_paste.chr"$chr
	echo "Expected input file "$inputFile
	echo "TABLE NAMES "$paramInputTableNames
	for inputParamFile in $paramInputTableNames; do
		echo "Processing $inputParamFile"
		# Read parameter record
		echo "${chr}q;d" > tmpFile
		field=$(sed -f tmpFile $inputParamFile)
		# Parse parameters
		chr=$(echo $field | cut -d" " -f1)
		echo "chr from table "$chr
		snp=$(echo $field | cut -d" " -f2)
		echo "snp from table"$snp
		max_hetero=$(echo $field | cut -d" " -f3)
		echo "max hetero "$max_hetero
		max_missing=$(echo $field | cut -d" " -f4)
		outputFile=$chr"_"$snp"_"${minLengthRange[$i]}"_"$max_missing"_"$max_hetero
		echo "output file = "$outputFile
		./TOH_ClusteringSuite_v1_0.exe -force_proceed -map $inputFile -p $inputFile -l $snp -n 3 -min_length ${minLengthRange[$i]} -max_gap 1000000 -max_missing $max_missing -max_hetero $max_hetero -k $k -o $outputFile | tee -a log_all1.txt
		echo "Finished run "$i 
		# Increment min length index to match current inputParamFile
		((i++))
	done
	i=0
done
