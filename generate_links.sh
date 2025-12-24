#!/bin/bash

# TODO: cheatはcheat/へのリンクにしたい
# TODO: generate_linksでignoreディレクトリはファイル管理にしたい、
# TODO: 生成したhtmlのリンクテキストはtitleタグとかからとってきたい。ないものはそのままで良いが

# 実行例: ./generate_links.sh -i ignore_dir1 -i ignore_dir2 -b https://tools.juns-app.com/
# 権限なかったら: chmod +x generate_links.sh
# スクリプトの使い方を表示する関数
usage() {
  echo "使い方: $0 [-i 無視するディレクトリ] [-b ベースURL] [-h]"
  echo "指定されたディレクトリ内の全HTMLファイルへのリンクを含むHTMLファイルを生成します。"
  echo "  -i    無視するディレクトリ。複数指定可能です。"
  echo "  -b    リンクに追加するベースURL。"
  exit 1
}
# 引数のパース
ignore_dirs=()
base_url=""
while getopts "i:b:h" opt; do
  case $opt in
    i) ignore_dirs+=("$OPTARG") ;;
    b) base_url="$OPTARG" ;;
    h|\?) usage ;;
  esac
done

# イグノアディレクトリオプションを find コマンド用にフォーマット
find_ignore_opts=""
for dir in "${ignore_dirs[@]}"; do
  find_ignore_opts+=" -path ./$dir -prune -o"
done

# ./archiveディレクトリを手動で追加して無視する
find_ignore_opts+=" -path ./archive -prune -o"

# ./gamedディレクトリを手動で追加して無視する
find_ignore_opts+=" -path ./gamed -prune -o"
find_ignore_opts+=" -path ./cheat -prune -o"

# ディレクトリ内の全HTMLファイルを再帰的に検索
html_files=$(eval "find . $find_ignore_opts -name '*.html' -print")
html_files=$(echo -e "$html_files\n./cheat/index.html")

# HTMLファイルの取得に失敗した場合のエラーハンドリング
if [ -z "$html_files" ]; then
  echo "No HTML files found, or an error occurred while generating the list."
  exit 1
fi

# HTML生成
output_html="path.html"
{
  echo "<!DOCTYPE html>"
  echo "<html lang=\"ja\">"
  echo "<head>"
  echo "  <meta charset=\"UTF-8\">"
  echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
  echo "  <title>tools</title>"
  echo "  <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">"
  echo "  <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>"
  echo "  <link href=\"https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;700&family=Fira+Code:wght@400;500;600&display=swap\" rel=\"stylesheet\">"
  echo "  <link href=\"path/styles.css\" rel=\"stylesheet\" />"
  echo "</head>"
  echo "<body>"
  echo "  <!-- 起動アニメーション -->"
  echo "  <div class=\"boot-screen\">"
  echo "    <div class=\"boot-command\">"
  echo "      <span class=\"boot-prompt\">$</span>"
  echo "      <span class=\"boot-text\">"
  echo "        <span>t</span><span>o</span><span>o</span><span>l</span><span>s</span>"
  echo "      </span>"
  echo "      <span class=\"boot-cursor\"></span>"
  echo "    </div>"
  echo "    <div class=\"boot-execute\">⏎ Executing...</div>"
  echo "  </div>"
  echo ""
  echo "  <h1>ツール一覧</h1>"
  echo "  <ul>"

  # 各HTMLファイルのリンクを生成
  while IFS= read -r file; do
    # "index.html" をパスから除去
    clean_file=$(echo "$file" | sed 's|/index\.html$||')
    
    # エスケープ処理を追加してHTMLの安全性を確保
    escaped_file=$(echo "$clean_file" | sed 's/&/\&amp;/g; s/"/\&quot;/g; s/'\''/\&#39;/g; s/</\&lt;/g; s/>/\&gt;/g')
    full_url="${base_url}${escaped_file#./}"
    
    echo "    <li><a href=\"$full_url\">$escaped_file</a></li>"
  done <<< "$html_files"

  echo "  </ul>"
  echo ""
  echo "  <script>"
  echo "    // ページロード時にリンクを再構築"
  echo "    document.addEventListener('DOMContentLoaded', function() {"
  echo "      const ul = document.querySelector('ul');"
  echo "      const links = Array.from(ul.querySelectorAll('li'));"
  echo "      "
  echo "      // URLからパス部分を抽出してソート用のデータを作成"
  echo "      const linkData = links.map(li => {"
  echo "        const a = li.querySelector('a');"
  echo "        const hrefText = a.textContent;"
  echo "        const cleanPath = hrefText.replace(/^\.\//, '');"
  echo "        const firstChar = cleanPath.charAt(0).toLowerCase();"
  echo "        "
  echo "        return {"
  echo "          element: li,"
  echo "          href: a.href,"
  echo "          path: cleanPath,"
  echo "          firstChar: firstChar,"
  echo "          sortKey: cleanPath.toLowerCase()"
  echo "        };"
  echo "      });"
  echo "      "
  echo "      // アルファベット順にソート"
  echo "      linkData.sort((a, b) => a.sortKey.localeCompare(b.sortKey));"
  echo "      "
  echo "      // カテゴリごとにグループ化"
  echo "      const categories = {};"
  echo "      linkData.forEach(item => {"
  echo "        const category = item.firstChar;"
  echo "        if (!categories[category]) {"
  echo "          categories[category] = [];"
  echo "        }"
  echo "        categories[category].push(item);"
  echo "      });"
  echo "      "
  echo "      // 既存のulを空にする"
  echo "      ul.innerHTML = '';"
  echo "      "
  echo "      // カテゴリごとに再構築"
  echo "      Object.keys(categories).sort().forEach((category, categoryIndex) => {"
  echo "        const items = categories[category];"
  echo "        "
  echo "        // カテゴリセクションを作成"
  echo "        const section = document.createElement('div');"
  echo "        section.className = \`category-section category-\${category}\`;"
  echo "        section.style.animationDelay = \`\${categoryIndex * 0.1}s\`;"
  echo "        "
  echo "        // カテゴリヘッダーを作成"
  echo "        const header = document.createElement('div');"
  echo "        header.className = 'category-header';"
  echo "        header.textContent = \`[\${category.toUpperCase()}]\`;"
  echo "        header.setAttribute('data-count', \`\${items.length} tools\`);"
  echo "        section.appendChild(header);"
  echo "        "
  echo "        // カテゴリ内のリストを作成"
  echo "        const categoryUl = document.createElement('ul');"
  echo "        "
  echo "        items.forEach((item, index) => {"
  echo "          const li = document.createElement('li');"
  echo "          li.style.animationDelay = \`\${(categoryIndex * 0.1) + (index * 0.02)}s\`;"
  echo "          "
  echo "          const a = document.createElement('a');"
  echo "          a.href = item.href;"
  echo "          "
  echo "          // URLのベース部分"
  echo "          const baseSpan = document.createElement('span');"
  echo "          baseSpan.className = 'url-base';"
  echo "          baseSpan.textContent = 'https://tools.juns-app.com';"
  echo "          "
  echo "          // パス部分"
  echo "          const pathSpan = document.createElement('span');"
  echo "          pathSpan.className = 'url-path';"
  echo "          pathSpan.textContent = \`/\${item.path}\`;"
  echo "          "
  echo "          a.appendChild(baseSpan);"
  echo "          a.appendChild(pathSpan);"
  echo "          li.appendChild(a);"
  echo "          categoryUl.appendChild(li);"
  echo "        });"
  echo "        "
  echo "        section.appendChild(categoryUl);"
  echo "        ul.parentElement.insertBefore(section, ul);"
  echo "      });"
  echo "      "
  echo "      // 元のulを削除"
  echo "      ul.remove();"
  echo "    });"
  echo "  </script>"
  echo "</body>"
  echo "</html>"
} > $output_html

# ファイルの生成が成功した場合のメッセージ
if [ $? -eq 0 ]; then
  echo "HTML file '$output_html' has been generated successfully."
else
  echo "An error occurred while generating the HTML file."
  exit 1
fi
