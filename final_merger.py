import os
import sys
import pandas as pd
import getopt


def main(argv):
    # Set the path for the directory containing the CSV files
    opts, args = getopt.getopt(argv, "o:")
    for opt, arg in opts:
        if opt == '-o':
            csv_dir = arg

    # Create a dictionary to hold the data frames for each query type
    query_type_data = {}

    # Loop through each environment directory
    for env_dir in os.listdir(csv_dir):
        if not os.path.isdir(os.path.join(csv_dir, env_dir)):
            continue

        # Loop through each query type directory for the current environment
        for query_type_dir in os.listdir(os.path.join(csv_dir, env_dir)):
            if not os.path.isdir(os.path.join(csv_dir, env_dir, query_type_dir)):
                continue

            # Read in the CSV file for the current query type
            csv_file_path = os.path.join(csv_dir, env_dir, query_type_dir, "results.csv")
            df = pd.read_csv(csv_file_path, delimiter=",")

            # Transpose the data and filter for the desired columns
            # Select the desired columns and set the index to the "sample" column
            df = df[["Planning Time", "Execution Time", "sample"]].set_index("sample")

            # Transpose the DataFrame and reset the index to the default integer index
            df = df.T.reset_index(drop=True)
            df.index.name = "Timing Type"
            df.columns.name = "Sample"
            df.insert(loc=0, column="Environemnt", value=env_dir)

            # Add the data frame to the dictionary for the current query type
            if query_type_dir not in query_type_data:
                query_type_data[query_type_dir] = []
            query_type_data[query_type_dir].append(df)

    # Merge the data frames for each query type into a single data frame
    for query_type, df_list in query_type_data.items():
        merged_data = pd.concat(df_list, keys=[f"{query_type}_{i}" for i in range(len(df_list))],
                                names=["Sample"], sort=False)

        # Write the merged data frame to a CSV file for each query type
        output_file = f"{query_type}.csv"
        merged_data.to_csv(os.path.join(csv_dir, output_file))


if __name__ == "__main__":
    main(sys.argv[1:])
