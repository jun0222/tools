## ルール

Conventional Commits 規約に従ってコミットメッセージを記述

```
<type>(<scope>): <subject>
```

### 参考

- [conventionalcommits.org](https://www.conventionalcommits.org/en/v1.0.0/)
- [GitHub](https://github.com/conventional-changelog/commitlint)

### 例

- feat(transactions): 収支入力画面にカテゴリ選択ドロップダウンを追加
- fix(balance): 月間残高計算で端数が切り捨てられる不具合を修正
- docs(readme): インストール手順と環境変数設定方法を追記
- style(ui): ホーム画面のカード間マージンとフォントサイズを調整
- refactor(db-schema): 支出テーブルのカラム構成を整理
- perf(report): 月次レポート生成クエリを最適化して処理時間を短縮
- test(api): 取引取得エンドポイントのユニットテストを追加
- build(docker): Dockerfile に Node.js バージョン固定を導入
- ci(github-actions): テストキャッシュを有効化してビルド時間を改善
- chore(deps): 家計簿 SDK を v2.1.0 にアップデート
- revert(ui): Revert “style(ui): ホーム画面のカード間マージンとフォントサイズを調整”

## ブランチ名

- 機能開発: feature/DEV-1234-add-login-ui
- バグ修正: bugfix/DEV-5678-fix-login-error
- 緊急ホットフィックス: hotfix/DEV-9999-patch-critical-crash
- リリース準備: release/1.3.0
- ドキュメント: docs/update-readme
- その他雑多: chore/update-deps

> `DEV-1234` の部分は JIRA 等の課題キーを付けることで「どのチケット（Issue）に紐づく変更か」がひと目でわかるようにするとさらに運用が楽になります。
> ブランチ名は 小文字＋ハイフン区切り かつ 説明的 な短い英語（または英数字＋ハイフン）でまとめます。
> 不要になったブランチはマージ後すみやかに削除しましょう。

[参考](https://engineering.mercari.com/blog/entry/20211213-8f5f5a5aee/)
