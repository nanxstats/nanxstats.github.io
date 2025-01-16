#!/bin/bash

repo_url="https://github.com/nanxstats/tinytopics.git"
repo_name="tinytopics"
output_file="output.txt"
unpack_dir="output/"

echo "Cloning repository..."
git clone "$repo_url"

echo "Syncing environment in $repo_name..."
(cd "$repo_name" && rye sync)

declare -a files_to_remove=(
  "$repo_name/.venv/lib/python3.12/site-packages/IPython/core/tests/nonascii.py"
  "$repo_name/.venv/lib/python3.12/site-packages/IPython/core/tests/nonascii2.py"
  "$repo_name/.venv/lib/python3.12/site-packages/beautifulsoup4-4.12.3.dist-info/licenses/AUTHORS"
  "$repo_name/.venv/lib/python3.12/site-packages/bs4/tests/fuzz/"
)

echo "Removing non UTF-8 files..."
for file in "${files_to_remove[@]}"; do
  rm -rf "$file" && echo "Removed: $file"
done

start_time_pack=$(date +%s)
echo "Packing..."
pkglite pack "$repo_name" -o "$output_file" -q
end_time_pack=$(date +%s)

elapsed_time_pack=$((end_time_pack - start_time_pack))
file_size_bytes=$(stat --format="%s" "$output_file" 2>/dev/null || stat -f"%z" "$output_file")
file_size_mb=$(echo "scale=2; $file_size_bytes / (1024^2)" | bc)
file_size_gb=$(echo "scale=2; $file_size_bytes / (1024^3)" | bc)
mb_per_second_pack=$(echo "scale=2; $file_size_mb / $elapsed_time_pack" | bc)

echo "Packing complete."
echo "Output file size: $file_size_gb GB"
echo "Packing time: $elapsed_time_pack seconds"
echo "Packing write speed: $mb_per_second_pack MB/s"

start_time_unpack=$(date +%s)
echo "Unpacking..."
pkglite unpack "$output_file" -o "$unpack_dir" -q
end_time_unpack=$(date +%s)

elapsed_time_unpack=$((end_time_unpack - start_time_unpack))
mb_per_second_unpack=$(echo "scale=2; $file_size_mb / $elapsed_time_unpack" | bc)

echo "Unpacking complete."
echo "Unpacking time: $elapsed_time_unpack seconds"
echo "Unpacking read speed: $mb_per_second_unpack MB/s"
