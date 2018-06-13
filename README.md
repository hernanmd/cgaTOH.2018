[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# cgaTOH.2018

ROH Analysis and Post-Analysis using cgaTOH and R. This repository provides a set of scripts to use as template for running [cgaTOH](https://digitalcommons.kent.edu/cgi/viewcontent.cgi?referer=https://duckduckgo.com/&httpsredir=1&article=1013&context=cspubs) software.

# Requirements

  - Download and install:
    - [GitBash](http://www.techoism.com/how-to-install-git-bash-on-windows/)
    - (Optional) [PLINK](https://www.youtube.com/watch?v=I62fp9HB0kg&feature=youtu.be)

# cgaTOH Script: (run_cgaTOH.sh) Input Files Preparation

## Description

This script executes cgaTOH looping through a different set of variables doing 5 global iterations. The final count of iterations depend on the maximums assigned to the iteration array in the following variables:

  - First iteration variable (outermost) iterates a range between a minimum and the maximum of missing SNPs allowed in a TOH run. If none is given then any number will be allowed.
  - Second iteration defines a range of TOH lengths between a minimum value and a maximum value in defined steps, for example to define a range from 10 TOH length to 20 TOHs length in steps of 5 ```tohRange=$(seq 10 5 20)``` 
  - The maximum physical gap between adjacent SNPs, if not given physical gaps won't be considered ```maxGap=1000000```. The maximum gap range is defined as a range of maximum gaps for each iteration, example: ```maxGapRange=$(seq 1000 1000 100000)```
  - The minimum physical length of a TOH run, if not given physical length won't be considered . For example to define a range from 1000 to 1000000 in steps of 10000 ```inputRange=$(seq 1000 1000 30000)```
  - Additional settings
    - Maximum heterozygous SNPs allowed in a TOH run, if non given then none will be allowed.

## Usage

  - Open a GitBash console.
  - cd to your working directory (example: my_working_dir): ``` cd /c/Users/MyUsername/Documents/my_working_dir ```
  - ``` git clone https://github.com/hernanmd/cgaTOH.2018.git; cd cgaTOH.2018/src ```
  - Put your .PED/.MAP or multiple .PED/.MAP files into the new directory
    - (Optional) If your PED/MAP has many chromosomes: PLINK can split using the --chr parameter: ``` for c in $(seq 1 29); do plink --file my_input --out my_input_chr$c --chr $c --recode tab --cow; done```
	
# cgaTOH Adjusted Script: (run_cgaTOH_adjusted.sh) Input Files Preparation

## Description

The adjusted script uses an input parameter table (example: SNP_Het_Mis.txt) which divides ROHs into five different categories of ranges:

  - 1-2 Mb
  - 2-4 Mb
  - 4-8 Mb
  - 8-16 Mb
  - More than 16 Mb

Each category consist of two columns: Missing and Heterozygous SNPs allowed per length category respectively. Each number of heterozygous (nH) and missing (nM) genotypes allowed in each ROH category for each chromosome was calculated as

nH = (mL / dS) .eG
nM = (mL / dS) .mG

where 

  - mL is ROH minimum length, 
  - dS is the average distance between SNPs in the chromosome,
  - eG is the genotyping error rate (0.25% according to Affymetrix standard procedures), 
  - mG is the average missing genotype rate in the chromosome

## Usage
  - Open a GitBash console.
  - cd to your working directory (example: my_working_dir): ``` cd /c/Users/MyUsername/Documents/my_working_dir ```
  - ``` git clone https://github.com/hernanmd/cgaTOH.2018.git; cd cgaTOH.2018/src ```
  - Put your .PED/.MAP or multiple .PED/.MAP files into the new directory
    - (Optional) If your PED/MAP has many chromosomes: PLINK can split using the --chr parameter: ``` for c in $(seq 1 29); do plink --file my_input --out my_input_chr$c --chr $c --recode tab --cow; done```
  - You must have a CSV file with run parameters. See SNP_Het_Mis.txt for a sample table. This table will be splitted during execution using always the two first columns and incrementing by two the following ones: First run take columns 1,2,3,4. Second run take columns 1,2,5,6. Third run: 1,2,7,8...etc.

## Script parameters
  
  - You should check and adjust the following parameters in the script:
    - k = Number of iterations (script defaults to 1000000) = Maximum tree depth for binary clustering.
    - maxChr = Number of chromosomes in your organism.
    - globalInputFile = Name of the CSV file with run parameters (SNP_Het_Mis.txt)
    - n = Minimum SNP overlap, default is 10.
    - max_gap = Maximum physical gap between adjacent SNPs, if not given physical gaps won't be considered
    - min_length = Minimum physical length of a TOH run, if not given physical length won't be considered
  - You should check and adjust the following parameters in the CSV file (SNP_Het_Mis.txt)
    - max_missing = "Third" column in each generated table from each run = Maximum missing SNPs allowed in a TOH run, if none give n then any number will be allowed
    - max_hetero = "Fourth" column in each generated table from each run = Maximum heterozygous SNPs allowed in a TOH run, if none given then none will be allowed
    - l = Second column = TOH length, default is 100

# Usage 

```bash
bash
. ./run_cgaTOH_adjusted.sh
```

## Output

  - Depending on your parameters in the CSV file (SNP_Het_Mis.txt), the output could generate hundreds of files.
    - Output files are timestamped, so different runs will never overwrite existing output files.
  - The output files should be used as input files to extract the ROH valuable information such as how many ROHs were found.
  
# parse_cgaTOH_output script

Once the Run cgaTOH (adjusted) script has completed, you can extract results using a script to parse the complete cgaTOH output log. The script generates 16 files:

  - TOHFounds.txt
  - TOHcFounds.txt
  - TOHRunLengths.txt
  - TOHSNPOveraps.txt
  - TOHMinPhysicalLengths.txt
  - TOHMaxPhysicalGaps.txt
  - TOHMaxMissingSNPs.txt
  - TOHMaxHetSNPs.txt
  - TOHClusterings.txt
  - TOHSimilaritys.txt
  - TOHThreshold.txt
  - TOHMinClusteringElems.txt
  - TOHRegionAtts.txt
  - TOHAllelicMatchingSimilarityOverride.txt
  - TOHMinimumAllelicMatch.txt
  - TOHMinimumAllelicOverlaps.txt

## Usage

```bash
./parse_cgaTOH_output.sh
```

# Contribute

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

If you have discovered a bug or have a feature suggestion, feel free to create an issue on Github.
If you'd like to make some changes yourself, see the following:    
  - Fork this repository to your own GitHub account and then clone it to your local device
  - Do some modifications
  - Test.
  - Add <your GitHub username> to add yourself as author below.
  - Finally, submit a pull request with your changes!
  - This project follows the [all-contributors specification](https://github.com/kentcdodds/all-contributors). Contributions of any kind are welcome!

# License

This software is licensed under the MIT License.

Copyright Hernán Morales Durand, Daniel E. Goszczynski, 2018.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Authors

Hernán Morales Durand, Daniel E. Goszczynski
