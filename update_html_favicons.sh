#!/bin/bash

# Base path
BASE="/Users/hatanakajun/Desktop/products/tools"

# Find all index.html files
for file in $(find "$BASE" -maxdepth 2 -name "index.html" -type f | grep -v archive | grep -v ".git" | sort); do
    dir=$(dirname "$file")

    # Check if favicon link already exists
    if grep -q 'rel="icon"' "$file"; then
        # Update existing favicon link
        sed -i '' 's|<link rel="icon"[^>]*>|<link rel="icon" href="favicon.svg" type="image/svg+xml">|g' "$file"
        echo "Updated: $file"
    else
        # Add favicon link after <head> tag
        sed -i '' '/<head>/a\
    <link rel="icon" href="favicon.svg" type="image/svg+xml">
' "$file"
        echo "Added: $file"
    fi
done

echo "All HTML files updated with favicon links!"
