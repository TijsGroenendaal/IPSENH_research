import getopt
import json
import csv
import os
import sys


class Colors:
    # Reset
    Color_Off = '\033[0m'  # Text Reset

    # Regular Colors
    Black = '\033[0;30m'  # Black
    Red = '\033[0;31m'  # Red
    Green = '\033[0;32m'  # Green
    Yellow = '\033[0;33m'  # Yellow
    Blue = '\033[0;34m'  # Blue
    Purple = '\033[0;35m'  # Purple
    Cyan = '\033[0;36m'  # Cyan
    White = '\033[0;37m'  # White


def main(argv):
    output_path = ''
    sample_dir = ''

    opts, args = getopt.getopt(argv, "s:o:", ["file="])
    for opt, arg in opts:
        if opt == '-o':
            output_path = arg
        if opt == '-s':
            sample_dir = arg

    file_names = sorted([f for f in os.listdir(sample_dir) if f.endswith('.json')], key=lambda x: int(x.split('_')[1].split('.')[0]))

    print("Merging result of samples", Colors.Green, sample_dir, Colors.Color_Off)

    # Open the CSV file for writing
    with open(output_path, 'w+') as csv_file:
        # Create a CSV writer
        writer = csv.DictWriter(csv_file, fieldnames=[], lineterminator='\n')

        iteration = 1
        # Iterate over the list of file names
        for file_name in file_names:
            # Check if the file is a JSON file
            if file_name.endswith('.json'):
                # Open the JSON file
                with open(os.path.join(sample_dir, file_name)) as json_file:
                    # Load the data from the file
                    data = json.load(json_file)[0]

                data.update({"sample": file_name.split("_")[1].split(".")[0]})

                # If this is the first file, write the headers
                if not writer.fieldnames:
                    writer.fieldnames = data.keys()
                    writer.writeheader()

                writer.writerow(data)

            iteration += 1


if __name__ == "__main__":
    main(sys.argv[1:])
