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
  echo '<!DOCTYPE html>'
  echo '<html lang="ja">'
  echo '<head>'
  echo '  <meta charset="UTF-8">'
  echo '  <meta name="viewport" content="width=device-width, initial-scale=1.0">'
  echo '  <title>tools</title>'
  echo '  <link rel="icon" href="img/favicon.svg" type="image/svg+xml">'
  echo '  <link rel="preconnect" href="https://fonts.googleapis.com">'
  echo '  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'
  echo '  <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;700&family=Fira+Code:wght@400;500;600&display=swap" rel="stylesheet">'
  echo '  <link href="path/styles.css" rel="stylesheet" />'
  echo '</head>'
  echo '<body>'
  echo '  <!-- 起動アニメーション -->'
  echo '  <div class="boot-screen">'
  echo '    <div class="boot-command">'
  echo '      <span class="boot-prompt">$</span>'
  echo '      <span class="boot-text">'
  echo '        <span>t</span><span>o</span><span>o</span><span>l</span><span>s</span>'
  echo '      </span>'
  echo '      <span class="boot-cursor"></span>'
  echo '    </div>'
  echo '    <div class="boot-execute">⏎ Executing...</div>'
  echo '  </div>'
  echo ''
  echo '  <div class="terminal-container">'
  echo '    <div class="terminal-header">'
  echo '      <div class="terminal-buttons">'
  echo '        <span class="terminal-btn btn-close"></span>'
  echo '        <span class="terminal-btn btn-minimize"></span>'
  echo '        <span class="terminal-btn btn-maximize"></span>'
  echo '      </div>'
  echo '      <div class="terminal-title">tools ~ search</div>'
  echo '    </div>'
  echo ''
  echo '    <div class="terminal-body">'
  echo '      <div class="input-line">'
  echo '        <span class="prompt">$</span>'
  echo '        <span class="command-prefix">open</span>'
  echo '        <input type="text" id="searchInput" placeholder="tool name..." autocomplete="off" autofocus />'
  echo '      </div>'
  echo ''
  echo '      <div class="help-hint">'
  echo '        <span class="hint-key">Enter</span> open'
  echo '        <span class="hint-key">↑↓</span> navigate'
  echo '        <span class="hint-key">*</span> all'
  echo '      </div>'
  echo ''
  echo '      <div class="results-container" id="resultsContainer">'
  echo '        <div class="results-list" id="resultsList"></div>'
  echo '      </div>'
  echo ''
  echo '      <div class="status-bar">'
  echo '        <span class="status-left" id="statusLeft">Ready</span>'
  echo '        <span class="status-right" id="statusRight">0 tools</span>'
  echo '      </div>'
  echo '    </div>'
  echo '  </div>'
  echo ''
  echo '  <script>'
  echo '    const tools = ['

  # 各HTMLファイルからツールデータを生成
  while IFS= read -r file; do
    # "index.html" をパスから除去
    clean_file=$(echo "$file" | sed 's|/index\.html$||')
    # 先頭の./ を除去
    path_only=$(echo "$clean_file" | sed 's|^\./||')
    # ツール名（最後のパス要素）
    name=$(basename "$path_only" .html)

    echo "      { name: \"$name\", path: \"$path_only\" },"
  done <<< "$html_files"

  # 外部リンク
  echo '      { name: "dev-blog", path: "Dev Blog", url: "https://www.juns-app.com" },'

  echo '    ];'
  echo ''
  cat << 'SCRIPT_END'
    const BASE_URL = "https://tools.juns-app.com/";
    let selectedIndex = 0;
    let filteredTools = [];

    const searchInput = document.getElementById("searchInput");
    const resultsList = document.getElementById("resultsList");
    const statusLeft = document.getElementById("statusLeft");
    const statusRight = document.getElementById("statusRight");

    function renderResults(items, highlight = "") {
      resultsList.innerHTML = "";

      if (items.length === 0 && highlight !== "") {
        resultsList.innerHTML = '<div class="no-results">No matching tools found</div>';
        statusRight.textContent = "0 tools";
        return;
      }

      if (items.length === 0) {
        statusRight.textContent = `${tools.length} tools available`;
        return;
      }

      items.forEach((tool, index) => {
        const item = document.createElement("div");
        item.className = `result-item ${index === selectedIndex ? "selected" : ""}`;
        item.dataset.index = index;

        let nameHtml = tool.name;
        if (highlight && highlight !== "*") {
          const regex = new RegExp(`(${highlight.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, "gi");
          nameHtml = tool.name.replace(regex, "<mark>$1</mark>");
        }

        item.innerHTML = `
          <span class="result-arrow">${index === selectedIndex ? ">" : " "}</span>
          <span class="result-name">${nameHtml}</span>
          <span class="result-path">${tool.path}</span>
        `;

        item.addEventListener("click", () => openTool(index));
        item.addEventListener("mouseenter", () => {
          selectedIndex = index;
          updateSelection();
        });

        resultsList.appendChild(item);
      });

      statusRight.textContent = `${items.length} tool${items.length !== 1 ? "s" : ""}`;
    }

    function updateSelection() {
      const items = resultsList.querySelectorAll(".result-item");
      items.forEach((item, index) => {
        if (index === selectedIndex) {
          item.classList.add("selected");
          item.querySelector(".result-arrow").textContent = ">";
          item.scrollIntoView({ block: "nearest" });
        } else {
          item.classList.remove("selected");
          item.querySelector(".result-arrow").textContent = " ";
        }
      });
    }

    function filterTools(query) {
      if (query === "") {
        return [];
      }
      if (query === "*") {
        statusLeft.textContent = "Showing all tools";
        return [...tools].sort((a, b) => a.name.localeCompare(b.name));
      }
      statusLeft.textContent = "Searching...";

      const q = query.toLowerCase();
      return tools
        .filter(t => t.name.toLowerCase().includes(q) || t.path.toLowerCase().includes(q))
        .sort((a, b) => {
          const aStarts = a.name.toLowerCase().startsWith(q);
          const bStarts = b.name.toLowerCase().startsWith(q);
          if (aStarts && !bStarts) return -1;
          if (!aStarts && bStarts) return 1;
          return a.name.localeCompare(b.name);
        });
    }

    function openTool(index) {
      if (filteredTools[index]) {
        const tool = filteredTools[index];
        const url = tool.url || (BASE_URL + tool.path);
        statusLeft.textContent = `Opening ${tool.name}...`;
        window.open(url, "_blank");
      }
    }

    searchInput.addEventListener("input", (e) => {
      const query = e.target.value.trim();
      selectedIndex = 0;
      filteredTools = filterTools(query);
      renderResults(filteredTools, query);

      if (query === "") {
        statusLeft.textContent = "Ready";
      }
    });

    searchInput.addEventListener("keydown", (e) => {
      if (e.key === "ArrowDown") {
        e.preventDefault();
        if (filteredTools.length > 0) {
          selectedIndex = (selectedIndex + 1) % filteredTools.length;
          updateSelection();
        }
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        if (filteredTools.length > 0) {
          selectedIndex = (selectedIndex - 1 + filteredTools.length) % filteredTools.length;
          updateSelection();
        }
      } else if (e.key === "Enter") {
        e.preventDefault();
        if (filteredTools.length > 0) {
          openTool(selectedIndex);
        }
      } else if (e.key === "Escape") {
        searchInput.value = "";
        filteredTools = [];
        renderResults([]);
        statusLeft.textContent = "Ready";
      }
    });

    // 初期状態
    renderResults([]);
    statusLeft.textContent = "Ready";

    // ページロード時にフォーカス
    setTimeout(() => {
      searchInput.focus();
    }, 2000);
SCRIPT_END

  echo '  </script>'
  echo '</body>'
  echo '</html>'
} > $output_html

# ファイルの生成が成功した場合のメッセージ
if [ $? -eq 0 ]; then
  echo "HTML file '$output_html' has been generated successfully."
else
  echo "An error occurred while generating the HTML file."
  exit 1
fi
