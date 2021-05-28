#obtain FAM argument from first argument provided to script
GENO="$1"
INDV=${GENO}.indv
LOCI=${GENO}.pos

# remove first column
cut -d$'\t' -f2- $GENO > temp1

# add row names - sample ids
paste -d$'\t' $INDV temp1 > temp2

# replace tabs with underscores
sed -e 's/\t/_/g' $LOCI > temp3

# add 'sampleID' on top of locus id
echo "sampleID" > temp4
cat temp4 temp3 > temp5

#transpose locus ids by replacing newline with tab, then replace last tab with newline
awk 'BEGIN { ORS = "\t" } { print }' temp5 | sed 's/\t$/\n/' > temp6

# add locus id to 012 file
cat temp6 temp2 > ${GENO}.all
