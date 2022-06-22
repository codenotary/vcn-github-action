#!/bin/bash

base_url="https://vcn-releases.codenotary.com"

if [[ $# -gt  0 ]]; then
    version_string=$1
fi

if [[ -z "${version_string}" ]]; then
    version_string="latest"
fi

echo "This action will download VCN version $version_string."

linux_file="$base_url/vcn-$version_string-linux-amd64-static"
windows_file="$base_url/vcn-$version_string-windows-amd64.exe"
mac_file="$base_url/vcn-$version_string-darwin-amd64"
os_name=$(uname -s)
out=""

case "${os_name}" in
    Linux*)     target=$linux_file;;
    Darwin*)    target=$mac_file;;
    CYGWIN*)    target="$windows_file" && out=".exe";;
    MINGW*)     target="$windows_file" && out=".exe";;
    *)          echo "Unsupported runner OS. Aborting VCN download." && exit 1;;
esac

curl -s -L "$target" -o vcn"$out" && chmod +x vcn*
echo "Successfully acquired VCN binary."
