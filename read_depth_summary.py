import sys
import numpy as np
import gzip

# Check if the correct number of arguments are provided
if len(sys.argv) != 2:
    print("Usage: python read_depth_summary.py <file_path>")
    sys.exit(1)

# Extract file path from command-line arguments
file_path = sys.argv[1]

try:
    # Initialize variables for calculations
    total_sum = 0
    non_zero_sum = 0
    non_zero_count = 0

    # Open input and output files
    with gzip.open(file_path, 'rt') as input_file, open(file_path.replace('.gz', '_results.tsv'), 'w') as output_file:
        output_file.write("filename\tn_positions\tmean\tstandard_deviation\tnon_zero_mean\tmedian\tnon_zero_count\tnon_zero_sum\tproportion_reference_covered\n")
        
        # Process the file line by line
        for line in input_file:
            try:
                value = float(line.strip())  # Convert the line to a float
            except ValueError:
                print("Error: Non-numerical value found in {}".format(file_path))
                sys.exit(1)
            total_sum += value  # Accumulate sum of all values
            if value != 0:
                non_zero_sum += value  # Accumulate sum of non-zero values
                non_zero_count += 1  # Count non-zero values

        # Calculate mean, standard deviation, median
        input_file.seek(0)  # Reset file pointer to the beginning
        all_values = [float(line.strip()) for line in input_file]
        mean = total_sum / len(all_values)
        std_dev = np.std(all_values)
        median = np.median(all_values)
        non_zero_mean = non_zero_sum / non_zero_count
        proportion_non_zero = float(non_zero_count) / len(all_values)

        # Write results to output file
        output_file.write("{}\t{}\t{:.2f}\t{:.2f}\t{:.2f}\t{}\t{}\t{}\t{:.2f}\n".format(file_path, len(all_values), mean, std_dev, non_zero_mean, median, non_zero_count, non_zero_sum, proportion_non_zero))

    print("Results written to: {}".format(output_file.name))

except FileNotFoundError:
    print("Error: File {} not found.".format(file_path))
    sys.exit(1)
