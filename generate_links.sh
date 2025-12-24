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
  echo "  <title>HTML File Links</title>"
  echo "  <style>"
  echo "    body { font-family: Arial, sans-serif; padding: 20px; }"
  echo "    ul { list-style-type: none; padding-left: 0; }"
  echo "    li { margin: 5px 0; }"
  echo "    a { text-decoration: none; color: #0366d6; }"
  echo "    a:hover { text-decoration: underline; }"
  echo "  </style>"
  echo "  <link href=\"path/styles.css\" rel=\"stylesheet\" />"
  echo "  <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">"
  echo "  <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>"
  echo "  <link href=\"https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;700&family=Fira+Code:wght@400;500;600&display=swap\" rel=\"stylesheet\">"
  echo "</head>"
  echo "<body>"
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
