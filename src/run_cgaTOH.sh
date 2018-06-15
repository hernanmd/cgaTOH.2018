#!/bin/sh

#################################################
#
# Input settings
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

# iterations (maximum tree depth) for binary clustering, default 100
k=100000

# Complete output log file
log=run_log.txt


#################################################
#
# PARAMETER CHECKING
#
#################################################

echo -n "Checking command parameter is present..."
if [ $# -eq 0 ]; then
	echo "ERROR"
	echo "Usage: $(basename $0) ped_input (without .PED extension)"
	exit 1
fi
echo "ok"

echo -n "Check input file are actually files..."
inputFile=$1
if [ ! -f "$inputFile.ped" ]; then
	echo "ERROR"
	echo "$inputFile not a file"
	exit 1
fi
echo "ok"

#################################################
#
# Download cgaTOH
#
#################################################

programUrl="http://www.cs.kent.edu/%7Ezhao/TOH"
tohExeName="TOH_ClusteringSuite_v1_0"
case "$OSTYPE" in
	solaris*)
		echo_line "Solaris seems not supported by cgaTOH"
                exit 1
		;;
	darwin*)
		timestamp=$(date +%Y%m%d%H%M%S)
                tohContainer="OS_X.zip"
                tohExe=$tohExeName
                [[ -f $tohContainer ]] || curl $programUrl/$tohContainer -o $tohContainer; unzip $tohContainer; mv OS_X/$tohExe . ; chmod 755 $tohExe
		;;
	linux*)
                tohContainer="Linux.zip"
                tohExe=$tohExeName
                [[ -f $tohContainer ]] || curl $programUrl/$tohContainer -o $tohContainer; unzip $tohContainer; mv Linux/$tohExe . ; chmod 755 $tohExe
		;;
	bsd*)
		echo_line "BSD seems not supported by cgaTOH"
                exit 1
		;;
	msys*)
		timestamp=$(date -d "today" +"%Y%m%d%H%M%S")
                tohContainer="Windows_32_bit.zip"
                tohExe=$tohExeName".exe"
                [[ -f $tohContainer ]] || curl $programUrl/$tohContainer -o $tohContainer; unzip $tohContainer; mv Win/$tohExe .
		;;
	*)
		echo "unknown: $OSTYPE"
                exit 1
		;;
esac

#################################################
#
# PARAMETER SAFETY CHECKING
#
#################################################

# Setup output file name
outputFile="$timestamp"

for maxMissing in $maxMissingRange; do
	echo "Iterating Max Missing Range: "$maxMissing
	for tohSize in $tohRange; do
	echo "Iterating TOH Size Range: "$tohSize
		for maxGap in $maxGapRange; do
			echo "Iterating Max Gap Range: "$maxGap
			for winSize in $inputRange; do
				echo "Iterating Window Size: "$winSize
				for minSNPOverlap in $minimumSNPOverlapRange; do
					echo "Iterating Minimum SNP OVerlap Range: "$min
					./$tohExe -force_proceed -map $inputFile -p $inputFile -l $tohSize -n $minSNPOverlap -min_length $winSize -max_gap $maxGap -max_missing $maxMissing -max_hetero $maxHetero -k $k -o $outputFile | tee -a run_log.txt
				done
			done
		done
	done
done
