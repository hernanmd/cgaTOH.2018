" Script to run AFTER run_cgaTOH_adjusted.sh "
" Requires NeoCSV installed in a Pharo >= 5.0 image "

| filePath homozygousruns currentIndiv totalForCurrentIndiv totalSum globalDict sumTotalFile groupH groupL highLow |

" List all individuals in both groups Low and High to set 0 to missing individuals when iterating "
groupH := #('11135' '11141' '11147' '11161' '11128' '11136' '11142' '11148' '11151' '11129' '11137' '11143' '11196' '11149' '11152' '11130' '11138' '11144' '11150' '11153' '11131' '11160' '11139' '11145' '11157' '11154' '11132' '11140' '11146' '11155' '11133' '11162' '11158' '11159' '11156' '11134').
groupL := #('11163' '11173' '11181' '11164' '11174' '11179' '11182' '11175' '11169' '11187' '11165' '11176' '11180' '11166' '11170' '11185' '11177' '11167' '11184' '11171' '11183' '11186' '11172' '11178' '11168').

" Set the current group "
currentGroup := groupL.
highLow := 'L'.

" Set path with all cgaTOH output files "
filePath := 'RttPEDMAP\cgaTOH_IGEVET\cgaTOH-run1-' , highLow , '\'.

" Iterate through different window sizes "
#(500000 1000000 2000000 4000000 8000000 16000000) do: [ : minLength | 
	" Select and parse cgaTOH output homozygousruns files "
	homozygousruns := filePath asFileReference entries select: [ : e | (e name endsWith: 'homozygousruns') and: [ (e name substrings: '_') includes: minLength asString ] ].
	globalDict := Dictionary new.
	totalForCurrentIndiv := OrderedCollection new. 
	" Iterate through all runs (one run per chromosome) in the current window (minLength) "
	homozygousruns do: [ : fh | 
		(NeoCSVReader on: fh asFileReference readStream )
			skipHeader;
			do: [ : rec | 
				rec first = currentIndiv
					ifTrue: [ totalForCurrentIndiv add: (rec at: 11) asNumber  ]
					ifFalse: [
						" New individual in current row (rec) "
						totalForCurrentIndiv notEmpty 
							ifTrue: [ 
								totalSum := totalForCurrentIndiv sum.
								globalDict 
									at: currentIndiv 
									ifPresent: [ : sums |  sums add: totalSum ] 
									ifAbsent: [ globalDict at: currentIndiv put: (OrderedCollection with: totalSum) ] ].
						totalForCurrentIndiv := OrderedCollection new. 				
						totalForCurrentIndiv add: (rec at: 11) asNumber.
						currentIndiv := rec first. ] ] ].
	" Write sum of total ROH's of individuals in all chromosomes for the current window (minLength) "
	sumTotalFile := FileStream newFileNamed: minLength asString , highLow , '.csv'.
	globalDict associationsDo: [ : assoc | 
		sumTotalFile 
			nextPutAll: assoc key asString; 
			tab; 
			nextPutAll: assoc value sum asString; 
			crlf ].
	" Write missing individuals with 0 ROH's "
	(currentGroup difference: globalDict keys) do: [ : mi | 
		sumTotalFile 
			nextPutAll: mi; 
			tab; 
			nextPut: $0; 
			crlf;
			flush ].
	 ].
sumTotalFile close.
