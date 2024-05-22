#!/usr/bin/awk -f

BEGIN {
    # Set the output file name
    output_file = FILENAME "_results.tsv"
    # Remove the input file name from ARGV to prevent it from being processed
    ARGV[1] = ""
    # Open the output file for writing
    print "filename\tmean\tstandard_deviation\tnon_zero_mean\tmedian\tnon_zero_count\tproportion_non_zero" > output_file
}

# Initialize variables
{
    total_sum += $1
    all_values[NR] = $1
    if ($1 != 0) {
        non_zero_sum += $1
        non_zero_count++
    }
}

# Calculate mean, standard deviation, median
END {
    mean = total_sum / NR
    for (i = 1; i <= NR; i++) {
        sum_sq_diff += (all_values[i] - mean) ^ 2
    }
    std_dev = sqrt(sum_sq_diff / NR)
    asort(all_values)  # Sort the array
    median_index = int((NR + 1) / 2)
    median = (NR % 2 == 0) ? (all_values[median_index] + all_values[median_index + 1]) / 2 : all_values[median_index]
    non_zero_mean = non_zero_sum / non_zero_count
    proportion_non_zero = non_zero_count / NR

    # Write results to output file
    print FILENAME "\t" mean "\t" std_dev "\t" non_zero_mean "\t" median "\t" non_zero_count "\t" proportion_non_zero > output_file
}