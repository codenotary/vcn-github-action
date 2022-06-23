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

echo "Downloading vcn from $target"
curl -s -L "$target" -o vcn"$out" && chmod +x vcn*

if [[ $? != 0 ]]
then
  echo "File download failed."
  echo "Exit code $?"
else
  echo "Successfully downloaded file."
  file -i vcn"$out" | grep -E 'executable|mach-binary|dosexec'
  if [[ $? == 0 ]]
  then
    echo "File $target is executable."
  else
    echo "File $target is not executable."
  fi
fi
