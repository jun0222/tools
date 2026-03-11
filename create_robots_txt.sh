#!/bin/bash

# Base path
BASE="/Users/hatanakajun/Desktop/products/tools"

# Find all directories with index.html
for file in $(find "$BASE" -maxdepth 2 -name "index.html" -type f | grep -v archive | grep -v ".git" | sort); do
    dir=$(dirname "$file")
    robots_file="$dir/robots.txt"

    # Create robots.txt
    cat > "$robots_file" << EOF
User-agent: *
Disallow: /
EOF
    echo "Created: $robots_file"
done

echo "All robots.txt files created!"
