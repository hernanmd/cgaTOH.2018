#!/bin/sh

$full_cgaTOH_log=run_log.txt
$final_report=Final_Report.txt
$found_TOHs=TOHFounds.txt
$found_cTOHs=TOHcFounds.txt
$found_runLengths=TOHRunLengths.txt
$found_SNPoverlaps=TOHSNPOveraps.txt
$found_minPhysicalGaps=TOHMinPhysicalLengths.txt
$found_maxPhysicalGaps=TOHMaxPhysicalGaps.txt
$found_maxMissingSNPs=TOHMaxMissingSNPs.txt
$found_maxHetSNPs=TOHMaxHetSNPs.txt
$found_Clusterings=TOHClusterings.txt
$found_Similarity=TOHSimilaritys.txt
$found_Threshold=TOHThreshold.txt
$found_minClusteringElems=TOHMinClusteringElems.txt
$found_regionAtts=TOHRegionAtts.txt
$found_allelicMatchSimOver=TOHAllelicMatchingSimilarityOverride.txt
$found_minAllelicMatch=TOHMinimumAllelicMatch.txt
$found_minAllelicOver=TOHMinimumAllelicOverlaps.txt

echo "TOH Regions Found" > $found_TOHs
grep ' TOH Regions Found.$'  | cut -d ' ' -f 1 >> $found_TOHs

echo "cTOH Regions Found" > $found_cTOHs
grep 'cTOH Regions Found.$' $full_cgaTOH_log | cut -d ' ' -f 1 >> $found_cTOHs

echo "TOH Run Length" > $found_runLengths
grep ' <> TOH Run Length:' $full_cgaTOH_log | cut -d ' ' -f 6 >> $found_runLengths

echo "SNP Overlap" > $found_SNPoverlaps
grep ' <> SNP Overlap:' $full_cgaTOH_log | cut -d ' ' -f 5 >> $found_SNPoverlaps

echo "Minimum Physical Length" > $found_minPhysicalGaps
grep ' <> Minimum Physical Length:' $full_cgaTOH_log | cut -d ' ' -f 6 >> $found_minPhysicalGaps

echo "Maximum Physical Gap" > $found_minPhysicalGaps
grep ' <> Maximum Physical Gap:' $full_cgaTOH_log | cut -d ' ' -f 6 >> $found_maxPhysicalGaps

echo "Maximum Missing SNPs" >  $found_maxMissingSNPs
grep ' <> Maximum Missing SNPs:' $full_cgaTOH_log | cut -d ' ' -f 6 >> $found_maxMissingSNPs

echo "Maximum Heterozygous SNPs" > $found_maxHetSNPs
grep ' <> Maximum Heterozygous SNPs:' $full_cgaTOH_log | cut -d ' ' -f 6 >> $found_maxHetSNPs

echo "Clustering Iterations" > $found_Clusterings
grep ' <> Clustering Iterations:' $full_cgaTOH_log | cut -d ' ' -f 5 >> $found_Clusterings

echo "Similarity Threshold" >  $found_Similarity
grep ' <> Similarity Threshold:' $full_cgaTOH_log | cut -d ' ' -f 5 >> $found_Similarity

echo "Threshold Type" > $found_Threshold
grep ' <> Threshold Type:' $full_cgaTOH_log | cut -d ' ' -f 5 >> $found_Threshold

echo "Minimum Clustering Elements" > $found_minClusteringElems
grep ' <> Minimum Clustering Elements:' $full_cgaTOH_log | cut -d ' ' -f 6 >> $found_minClusteringElems

echo "Region Attenuation" > $found_regionAtts
grep ' <> Region Attenuation:' $full_cgaTOH_log | cut -d ' ' -f 5 >> $found_regionAtts

echo "Allelic Matching Similarity Override" > $found_allelicMatchSimOver
grep ' <> Allelic Matching Similarity Override:' $full_cgaTOH_log | cut -d ' ' -f 7 >> $found_allelicMatchSimOver

echo "Minimum Allelic Match" > $found_minAllelicMatch
grep ' <> Minimum Allelic Match:' $full_cgaTOH_log | cut -d ' ' -f 6 >> $found_minAllelicMatch

echo "Minimum Allele Overlap" > $found_minAllelicOver
grep ' <> Minimum Allele Overlap:' $full_cgaTOH_log | cut -d ' ' -f 6 >> $found_minAllelicOver


paste -d'\t' \
	$found_minPhysicalGaps \
	$found_runLengths \
	$found_TOHs \
	$found_cTOHs \
	$found_maxPhysicalGaps \
	$found_maxMissingSNPs \ 
	$found_maxHetSNPs \
	$found_SNPoverlaps \
	$found_Clusterings \
	$found_Similarity \
	$found_Threshold \
	$found_minClusteringElems \
	$found_regionAtts \
	$found_allelicMatchSimOver \ 
	$found_minAllelicMatch \
	$found_minAllelicOver > $final_report
