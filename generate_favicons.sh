#!/bin/bash

# Function to create SVG favicon
create_favicon() {
    local dir=$1
    local emoji=$2
    local color=$3
    local output="$dir/favicon.svg"

    cat > "$output" << EOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <rect width="100" height="100" fill="$color" rx="10"/>
  <text x="50" y="70" font-size="60" text-anchor="middle" fill="#fff">$emoji</text>
</svg>
EOF
    echo "Created: $output"
}

# Base path
BASE="/Users/hatanakajun/Desktop/products/tools"

# Create favicons for each app
create_favicon "$BASE/aa" "🎨" "#ff2e63"
create_favicon "$BASE/ango" "🔒" "#6c5ce7"
create_favicon "$BASE/ango2" "📝" "#08d9d6"
create_favicon "$BASE/anki-automation" "📚" "#ff9f43"
create_favicon "$BASE/anki-card" "🃏" "#9dff00"
create_favicon "$BASE/atena" "✉️" "#ffde03"
create_favicon "$BASE/base64" "🔢" "#ff2e63"
create_favicon "$BASE/calp" "🧮" "#6c5ce7"
create_favicon "$BASE/calp2" "📊" "#08d9d6"
create_favicon "$BASE/cheat" "📋" "#ff9f43"
create_favicon "$BASE/code-memo" "💻" "#9dff00"
create_favicon "$BASE/color" "🎨" "#ffde03"
create_favicon "$BASE/colorp" "👤" "#ff2e63"
create_favicon "$BASE/curl" "🌐" "#6c5ce7"
create_favicon "$BASE/dollerd" "💲" "#08d9d6"
create_favicon "$BASE/favicon" "⭐" "#ff9f43"
create_favicon "$BASE/favicon2" "📦" "#9dff00"
create_favicon "$BASE/gamed" "🎮" "#ffde03"
create_favicon "$BASE/giron" "💬" "#6c5ce7"
create_favicon "$BASE/gmailq" "📧" "#ff2e63"
create_favicon "$BASE/htmlf" "🔧" "#08d9d6"
create_favicon "$BASE/htmlp" "👁️" "#ff9f43"
create_favicon "$BASE/img2silhouette" "🖼️" "#9dff00"
create_favicon "$BASE/jsonf" "📄" "#ffde03"
create_favicon "$BASE/jwtd" "🔑" "#ff2e63"
create_favicon "$BASE/lgtm" "👍" "#6c5ce7"
create_favicon "$BASE/markdown" "📝" "#08d9d6"
create_favicon "$BASE/merge_link" "🔗" "#ff9f43"
create_favicon "$BASE/mermaid" "🧜" "#9dff00"
create_favicon "$BASE/nippo" "📅" "#ffde03"
create_favicon "$BASE/nippo2" "✅" "#ff2e63"
create_favicon "$BASE/nodev" "🌳" "#6c5ce7"
create_favicon "$BASE/png2svg" "🔄" "#08d9d6"
create_favicon "$BASE/poketype" "⚡" "#ff9f43"
create_favicon "$BASE/poketype2" "🔥" "#9dff00"
create_favicon "$BASE/poketype3" "💧" "#ffde03"
create_favicon "$BASE/poketype4" "🌿" "#ff2e63"
create_favicon "$BASE/progress" "📈" "#6c5ce7"
create_favicon "$BASE/rand" "🔐" "#08d9d6"
create_favicon "$BASE/rand2" "🎲" "#ff9f43"
create_favicon "$BASE/rich-e" "✏️" "#9dff00"
create_favicon "$BASE/rollp" "🧻" "#ffde03"
create_favicon "$BASE/shakyo" "📖" "#ff2e63"
create_favicon "$BASE/shoe-size" "👟" "#6c5ce7"
create_favicon "$BASE/swegi" "🏗️" "#08d9d6"
create_favicon "$BASE/testd" "🧪" "#ff9f43"
create_favicon "$BASE/typing" "⌨️" "#9dff00"

echo "All favicons created!"
