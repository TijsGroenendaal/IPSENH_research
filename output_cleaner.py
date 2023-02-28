import json
import sys, getopt

class colors:
	# Reset
	Color_Off='\033[0m'       # Text Reset

	# Regular Colors
	Black='\033[0;30m'        # Black
	Red='\033[0;31m'          # Red
	Green='\033[0;32m'        # Green
	Yellow='\033[0;33m'       # Yellow
	Blue='\033[0;34m'         # Blue
	Purple='\033[0;35m'       # Purple
	Cyan='\033[0;36m'         # Cyan
	White='\033[0;37m'        # White

def main (argv):
	file_path = ''

	opts, agrs = getopt.getopt(argv, "f:", ["file="])
	for opt, arg in opts:
		if opt == '-f':
			file_path = arg

	with open(file_path, 'r') as file:
		data = []
		for line in file:
			line = line.lstrip().rstrip("\n+")
			if line:
				data.append(line)

	json_string = ''.join(data)
	json_data = json.loads(json_string)

	with open(file_path, 'w') as file:
	    json.dump(json_data, file, indent=2)

if __name__ == "__main__":
	main(sys.argv[1:])

