# GenoTools
Hello! In this repo I collect some of the functions, tools, scripts and handy commands that I use when working on genomic data.

### Calculate SFS across windows in the genome
This script estimates the sfs for pre-defined windows along the genome. Required inputs are a bed file for each chromosome stating listing the windows of interest in the format `chromosome\tstart\tend`, the reference fasta file, the ancestral fasta file (can be replaced with the refence file for folded sfs), and a list of bamfiles for individuals to use. 
- [window_sfs.sh](https://github.com/MboiTui/GenoTools/blob/main/window_sfs.sh)

The output of this script can then be used as input into David Marques' python [script](https://github.com/marqueda/PopGenCode/blob/master/dxy_wsfs.py) to calculate Dxy from the sfs.

### SAM/BAM scripts
The only scripts in here now are an awk and python script to calculate the mean, stdev, non-zero mean, median, non-zero count, and genome coverage proportions from the output of `samtools depth`. I produced them to be used as part of the [lcWGS tutorial](https://github.com/nt246/lcwgs-guide-tutorial/blob/main/tutorial1_data_processing/markdowns/data_processing.md#estimate-read-depth-in-your-bam-files) by the Therdilksen lab, to assess read depth per sample before estimating genotype likelihoods.
The input file contains one column, with one integer per base pair, stating the read depth for that base pair from a bam/sam alignment file.
The output is a table with the filename, followed by the metrics mentioned above. Test it on a small file (< 10.000.000 rows).
DISCLAIMER: These scripts have only been tested on a handful of my own data, so please test them thoroughly on a small dataset first.
- [read_depth_sumamry.awk](https://github.com/MboiTui/GenoTools/blob/main/read_depth_summary.awk)
- [read_depth_summary.py](https://github.com/MboiTui/GenoTools/blob/main/read_depth_summary.py)

### VCF processing scripts
The script [0_AddNamesTo012.sh](https://github.com/MboiTui/GenoTools/blob/40933ef5cfdd61b8c44a3672ced2806a68528570/0_AddNamesTo012.sh) takes as input the 3 files produced by vcftools when using the `--012` output format (i.e., filename.012, filename.012.indv and filename.012.pos) and merges them into one file. The three input files contain:

- **filename.012**: genotyping information in the 012 format, where genotypes are coded as either 0 (homozygote reference), 1 (heterozygote) or 2 (homozygote snp). 
- **filename.012.indv**: sample IDs of genotyped individuals
- **filename.012.pos**: locus id and snp position within the locus, divided by a tab
 
The output file, which has the naming format **filename.012.all**, contains information from all three files, with individuals as rows and loci as columns.

Assuming both the script and the 012 files are in the current working directory, the script can be submitted with

```
./0_AddNamesTo012.sh filename
```

The only argument you need to provide is the value of filename, which has to be the same between the three files.
