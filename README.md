# GenoTools
Hello! In this repo I collect some of the functions, tools, scripts and handy commands that I use when working on genomic data.

### VCFTOOLS related scripts
For now, all this repository contains is a shell script, 0_AddNamesTo012.sh, that takes as input the 3 files produced by vcftools when using the `--012` output format (i.e., filename.012, filename.012.indv and filename.012.pos) and merges them into one file. The three input files contain:

- **filename.012**: genotyping information in the 012 format, where genotypes are coded as either 0 (homozygote reference), 1 (heterozygote) or 2 (homozygote snp). 
- **filename.012.indv**: sample IDs of genotyped individuals
- **filename.012.pos**: locus id and snp position within the locus, divided by a tab
 
The output file, which has the naming format **filename.012.all**, contains information from all three files, with individuals as rows and loci as columns.

Assuming both the script and the 012 files are in the current working directory, the script can be submitted with

```
./0_AddNamesTo012.sh filename
```

The only argument you need to provide is the value of filename, which has to be the same between the three files.
