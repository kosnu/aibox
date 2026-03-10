---
name: creating-issue
description: Creates a GitHub issue using the repository's issue templates. Use when the user asks to create an issue or says "Issueを作って".
disable-model-invocation: true
model: sonnet
argument-hint: "[issue description]"
---

# Create Issue

## Step 1: Issue テンプレートの確認

- `ls .github/ISSUE_TEMPLATE/` でテンプレート一覧を取得する
- テンプレートが存在する場合:
  - 各ファイルを読み込み、`name:` フィールドや内容からテンプレートの用途を把握する
  - `$ARGUMENTS` の内容から最適なテンプレートを推測する
  - AskUserQuestion でテンプレート選択を確認する（選択肢として全テンプレートを提示）
- テンプレートが存在しない場合: テンプレートなしで次のステップへ進む

## Step 2: プロジェクトの選択

- `gh project list --limit 20` でプロジェクト一覧を取得する
- プロジェクトが1件のみ → 自動選択（ユーザーに選択したプロジェクト名を通知）
- プロジェクトが複数 → AskUserQuestion でユーザーに選択させる
- プロジェクトがない → プロジェクト紐づけなしで次のステップへ進む

## Step 3: Issue の作成

- 選択されたテンプレートを読み込み、`$ARGUMENTS` の内容に基づいてタイトルと本文を埋める
  - テンプレートの YAML frontmatter（`---` で囲まれた部分）は除いて本文のみ使用する
  - テンプレートのセクション見出しをすべて維持し、空欄や placeholder を残さない
- テンプレートなしの場合は `$ARGUMENTS` から適切な本文を作成する
- `gh issue create --title "..." --body "..." [--project "プロジェクト名"]` で作成する
- 作成後に Issue の URL を表示する

## Next Action

Issue 作成後に `/creating-branch {issue-number}` を提案する。

## Rules

- テンプレート推測結果は必ず AskUserQuestion でユーザーに確認してから使用すること
- プロジェクトが1件のみなら自動選択してよい（確認不要）
- テンプレートの frontmatter は本文に含めない
- `gh issue create` はインタラクティブモードを使わず、`--title` と `--body` を明示的に渡すこと
