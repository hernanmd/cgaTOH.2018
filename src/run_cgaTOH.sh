#!/bin/sh

#################################################
#
# PARAMETER CHECKING
#
#################################################

echo -n "Checking command parameter is present..."
if [ $# -eq 0 ]; then
    echo "ERROR"
    echo "Usage: $(basename $0) ped_input (without .PED extension)"
fi
echo "ok"

echo -n "Check input file are actually files..."
inputFile=$1
if [ ! -f "$inputFile.ped" ]; then
    echo "ERROR"
    echo "$inputFile not a file"
fi
echo "ok"

#################################################
#
# PARAMETER SAFETY CHECKING
#
#################################################

#echo -n "Converting to DOS file"
#unix2dos $inputFile".ped"
#unix2dos $inputFile".map"
#echo "done"

# Get timestamp
echo "Getting timestamp"
timestamp=$(date -d "today" +"%Y%m%d%H%M%S")
# Setup output file name
outputFile="$timestamp" 

#################################################
#
# cgaTOH parameters
#
#################################################

echo "Setting parameters"

# From 10 to 20 in steps of 5
tohRange=$(seq 10 5 20)

minimumSNPOverlapRange=$(seq 1 3)

# minimum physical length of a TOH run, if not given phycal length won't be considered 
# Input range from 1000 to 1000000 in steps of 10000
# Window Size
inputRange=$(seq 1000 1000 30000)

# inputRange=1000000
# maximum physical gap between adjacent SNPs, if not given ysical gaps won't be considered  
# maxGap=1000000
maxGapRange=$(seq 1000 1000 100000)

# maximum missing SNPs allowed in a TOH run, if none gi n then any number will be allowed
# maxMissing=2
maxMissingRange=$(seq 1 5)

# maximum heterozygous SNPs allowed in a TOH run, if non given then none will be allowed
maxHetero=1

# iterations (maximum tree depth) for binary clustering, default 100c
k=100000

echo "Entering loops"
for maxMissing in $maxMissingRange; do
	for tohSize in $tohRange; do
		for maxGap in $maxGapRange; do
			for windowSize in $inputRange; do
				for minimumSNPOverlap in $minimumSNPOverlapRange; do
					TOH_ClusteringSuite_v1_0.exe -force_proceed -map $inputFile -p $inputFile -l $tohSize -n $minimumSNPOverlap -min_length $windowSize -max_gap $maxGap -max_missing $maxMissing -max_hetero $maxHetero -k $k -o $outputFile | tee -a log_all1.txt
				done
			done
		done
	done
done
