document.getElementById("copyButton").addEventListener("click", function () {
  const textArea = document.getElementById("textArea");
  textArea.select();
  textArea.setSelectionRange(0, 99999); // モバイル対応

  // クリップボードにコピー
  navigator.clipboard
    .writeText(textArea.value)
    .then(() => {
      // コピー成功メッセージを表示
      document.getElementById("statusMessage").textContent =
        "コピーされました！";
    })
    .catch((err) => {
      document.getElementById("statusMessage").textContent =
        "コピーに失敗しました。";
      console.error("クリップボードへのコピーが失敗しました: ", err);
    });
});
