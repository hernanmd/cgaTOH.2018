#!/bin/sh

grep ' TOH Regions Found.$' log_all1.txt | cut -d ' ' -f 1 > TOHFounds.txt
grep 'cTOH Regions Found.$' log_all1.txt | cut -d ' ' -f 1 > TOHcFounds.txt
grep ' <> TOH Run Length:' log_all1.txt | cut -d ' ' -f 6 > TOHRunLengths.txt
grep ' <> SNP Overlap:' log_all1.txt | cut -d ' ' -f 5 > TOHSNPOveraps.txt
grep ' <> Minimum Physical Length:' log_all1.txt | cut -d ' ' -f 6 > TOHMinPhysicalLengths.txt
grep ' <> Maximum Physical Gap:' log_all1.txt | cut -d ' ' -f 6 > TOHMaxPhysicalGaps.txt
grep ' <> Maximum Missing SNPs:' log_all1.txt | cut -d ' ' -f 6 > TOHMaxMissingSNPs.txt
grep ' <> Maximum Heterozygous SNPs:' log_all1.txt | cut -d ' ' -f 6 > TOHMaxHeterozygousSNPs.txt
grep ' <> Clustering Iterations:' log_all1.txt | cut -d ' ' -f 5 > TOHClusterings.txt
grep ' <> Similarity Threshold:' log_all1.txt | cut -d ' ' -f 5 > TOHSimilaritys.txt
grep ' <> Threshold Type:' log_all1.txt | cut -d ' ' -f 5 > TOHThreshold.txt
grep ' <> Minimum Clustering Elements:' log_all1.txt | cut -d ' ' -f 6 > TOHMinimumClusteringElements.txt
grep ' <> Region Attenuation:' log_all1.txt | cut -d ' ' -f 5 > TOHRegionAtts.txt
grep ' <> Allelic Matching Similarity Override:' log_all1.txt | cut -d ' ' -f 7 > TOHAllelicMatchingSimilarityOverride.txt
grep ' <> Minimum Allelic Match:' log_all1.txt | cut -d ' ' -f 6 > TOHMinimumAllelicMatchs.txt
grep ' <> Minimum Allele Overlap:' log_all1.txt | cut -d ' ' -f 6 > TOHMinimumAllelicOverlaps.txt


paste -d'\t' TOHMinPhysicalLengths.txt TOHRunLengths.txt TOHFounds.txt TOHcFounds.txt TOHMaxPhysicalGaps.txt TOHMaxMissingSNPs.txt TOHMaxHeterozygousSNPs.txt TOHSNPOveraps.txt TOHClusterings.txt TOHSimilaritys.txt TOHThreshold.txt TOHMinimumClusteringElements.txt TOHRegionAtts.txt TOHAllelicMatchingSimilarityOverride.txt TOHMinimumAllelicMatchs.txt TOHMinimumAllelicOverlaps.txt > Report.txt
