#!/bin/bash

version_string=$(curl -s https://api.github.com/repos/codenotary/vcn/releases/latest | awk '/tag_name/ {gsub(/"/,""); gsub(/,/,""); print $2}')
base_url=https://github.com/codenotary/vcn/releases/latest/download
linux_file="$base_url/vcn-$version_string-linux-amd64-static"
windows_file="$base_url/vcn-$version_string-windows-amd64.exe"
os_name=$(uname -a)
out=""

if [[ "$os_name" == *"Linux"* ]]; then
    target=$linux_file
elif [[ "$os_name" == *"Win"* ]]; then
    target="$windows_file"
    out=".exe"
else
    echo "Unsupported runner OS, aborting VCN Action"
fi

curl "$target" -o vcn"$out"