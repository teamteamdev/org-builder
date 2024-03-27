#!/usr/bin/env bash 

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 source-directory destination-directory"
    exit 1
fi

package_dir=$(dirname "$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")")
source_dir=$(realpath "$1")
temp_dir=$(mktemp -d)
chmod 755 "$temp_dir"
trap 'rm -rf $temp_dir' EXIT 
destination_dir=$(realpath "$2")

cd "$source_dir"

find . -type f -print0 | while IFS= read -r -d '' filename; do
    mkdir -p "$temp_dir/$(dirname "$filename")"

    if [[ "$filename" == */_* ]]; then
        echo "$filename: skipping"
    elif [[ "$filename" == *.org ]]; then
        echo "$filename: orgfile, compiling"

        emacs -Q --script "$package_dir/lib/org-compile.el" "$filename"

        mv "${filename%.org}.html" "$temp_dir/${filename%.org}.html"
    else
        echo "$filename: not an orgfile, copying"
        cp "$filename" "$temp_dir/$filename"
    fi
done

rsync -rav --delete "$temp_dir/" "$destination_dir"

cd -
