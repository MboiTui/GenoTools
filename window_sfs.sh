#! /bin/bash

#PBS -N jobName
#PBS -l walltime=60:00:00
#PBS -l select=1:ncpus=3:mem=2gb
#PBS -J 1-31

# Change to project directory
cd /project/directory/containing/required/inputs

# Required input files
### reference.fa = the reference genome in fasta format
### ancestral.fa.gz = the ancestral genome in fasta format (gzipped)
### a.bamlist = list of bamfiles for population a, aligned to the reference
### b.bamlist = list of bamfiles for population b, aligned to the reference
### Windows_scaffold${i}.bed = scaffold/chromosome specific bed files with window size of your choice

# Load angsd module
### Required if you are working within a computing cluster (e.g., the JCU HPC), otherwise remove
module load angsd

########################################
# Set required environmental variables #
########################################
# Set reference and ancestral sequence
REF="path/to/reference.fa"
ANC="path/to/ancestral.fa.gz"

# Get indexnumber for chromosomes
### In my case bed files for scaffolds/chromosome contain the scaffold name as `scaffoldN`
### where N is an integer between 1 and 31
### Change accordingly for your system and naming scheme
i=${PBS_ARRAY_INDEX}

# Population names
### I pass population names with the -v argument to qsub
### e.g., qsub -v a=North,b=South windows_sfs.sh
a=${a}; b=${b}

# Make directory for temporary/intermediate files
mkdir -p temp_${a}_${b}

# Clean environment to avoid appending to old files
### I included this to ensure i remove previous outputs from non completed runs
rm ${a}.${b}.scaffold${i}.50kwin.sfs

#############################################
# Loop through the bed file with while read #
#############################################
cat Windows_scaffold${i}.bed | while read CHROM START END
do
# Make rf file with info on window to analyze
echo ${CHROM}:${START}-${END} > temp_${a}_${b}/${i}.rf
# Make saf file for each pop with angsd
### adjust filtering options (-minQ, -minMapQ) and number of threads (-P) to use according to your needs
angsd -b ${a}.bamlist -out temp_${a}_${b}/tmp.${a}.${i} -doSaf 1 -GL 2 -rf temp_${a}_${b}/${i}.rf -minQ 20 -minMapQ 20 -ref ${REF} -anc ${ANC} -P 2
angsd -b ${b}.bamlist -out temp_${a}_${b}/tmp.${b}.${i} -doSaf 1 -GL 2 -rf temp_${a}_${b}/${i}.rf -minQ 20 -minMapQ 20 -ref ${REF} -anc ${ANC} -P 2
# Estimate sfs from saf files
realSFS temp_${a}_${b}/tmp.${a}.${i}.saf.idx temp_${a}_${b}/tmp.${b}.${i}.saf.idx | awk '{if(NF>4){print $N}}' > temp_${a}_${b}/tmp.${a}.${b}.scaffold${i}.50kwin.sfs
# Make a bed file with one line
echo ${CHROM} ${START} ${END} > temp_${a}_${b}/${i}.bed
# Append to sfs file
paste --delimiters=" " temp_${a}_${b}/${i}.bed temp_${a}_${b}/tmp.${a}.${b}.scaffold${i}.50kwin.sfs >> ${a}.${b}.scaffold${i}.50kwin.sfs
done

# Remove intermediate superfluos files
rm temp_${a}_${b}/${i}.rf temp_${a}_${b}/tmp.*.${i}.* temp_${a}_${b}/${i}.bed temp_${a}_${b}/tmp.${a}.${b}.scaffold${i}.50kwin.sfs

# Use the file `${a}.${b}.scaffold${i}.50kwin.sfs` as input for David Marques `dxy_wsfs.py` script
