#!/bin/bash

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

if [[ $(sudo systemctl is-active postgresql) -ne active ]]; then
	echo -e "${Red} postgresql not running: Exiting now \n ${Color_Off}"
	exit
fi

while getopts d:p:q:o:s:c: flag
do
	# shellcheck disable=SC2220
	case ${flag} in
		d) conf_dir=${OPTARG};;
		p) psql_config=${OPTARG};;
		q) query_dir=${OPTARG};;
		o) output_dir=${OPTARG};;
		s) sample_count=${OPTARG};;
	esac
done

if [[ -z ${conf_dir} ]]; then conf_dir="$(pwd)/config"; fi
if [[ -z ${psql_config} ]]; then psql_config="/etc/postgresql/15/main"; fi
if [[ -z ${query_dir} ]]; then query_dir="$(pwd)/query"; fi
if [[ -z ${output_dir} ]]; then output_dir="$(pwd)/output"; fi
if [[ -z ${sample_count} ]]; then sample_count=30; fi

echo -e "using postgresql config directory ${Green}${psql_config}${Color_Off}"
echo -e "using research config directory ${Green}${conf_dir}${Color_Off}"
echo -e "using query directory ${Green}${query_dir}${Color_Off}"
echo -e "using output directory ${Green}${output_dir}${Color_Off}"

for config in "${conf_dir}"/*.conf; do

	echo -e "\nStopping postgresql Service"
	sudo systemctl stop postgresql

	echo -e "${White}Switching config file to${Yellow}$config${Color_Off}"
	sudo cp -r "$config" "${psql_config}/postgresql.conf"

	conf_output_dir="${output_dir}/$(basename "$config" .conf)"

	mkdir "$conf_output_dir"

	for query in "$query_dir"/*.sql; do
		sudo systemctl restart postgresql
		echo -e "Executing Query ${Purple}${query}${Color_Off}"
		sample_output_dir="${conf_output_dir}/$(basename "${query}" .sql)"
		mkdir "$sample_output_dir"
		for sample in $(seq 1 $sample_count); do
			file_output="${sample_output_dir}/sample_${sample}.json"
			psql -U postgres -f "$query" -t -o "$file_output"
			python3 output_cleaner.py -f "${file_output}"
		done
		python3 measurement_result_merger.py -s "$sample_output_dir" -o "$sample_output_dir/results.csv"
	done
done
