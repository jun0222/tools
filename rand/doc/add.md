# 乱数生成ツールのドキュメント

## 概要

この乱数生成ツールは、特定の条件に基づいて乱数を生成する機能を提供します。以下の条件をユーザーが指定できます。

- 乱数の長さ
- 乱数に含める要素（数字のみ、英数字、英数字と記号）

## 新機能の追加方法

新機能を追加するには、次のステップに従ってください。

### 1. 条件の追加

乱数生成に関する新たな条件を追加する場合は、まず新たな選択肢を HTML 部分に追加します。

```html
<label for="newCondition">新しい条件:</label>
<select id="newCondition">
  <option value="option1">オプション1</option>
  <option value="option2">オプション2</option>
  <!-- 追加したい選択肢をここに書く -->
</select>
```

### 2. 乱数生成処理の追加

次に、JavaScript 部分に新たな条件に基づく乱数生成処理を追加します。`generateRandom`関数内の条件分岐に新たな case を追加し、その中で新たな条件に基づいて乱数を生成する処理を書きます。

```javascript
function generateRandom() {
  // 省略...

  switch (condition) {
    // 省略...
    case "newCondition":
      // 新しい条件に基づく乱数生成処理
      break;
  }

  // 省略...
}
```

### 3. 動作確認

最後に、新たに追加した機能が正しく動作するか確認します。選択肢を変更したときやボタンをクリックしたときなど、各種操作で期待通りの結果が得られるかを確認してください。

以上が新機能の追加方法です。人名の生成など、特定のパターンに基づいた乱数生成機能を追加する場合も、この手順に従って追加することができます。