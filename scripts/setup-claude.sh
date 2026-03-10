#!/usr/bin/env bash
set -euo pipefail

# プロジェクトルートを特定（スクリプトの親ディレクトリ）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$PROJECT_ROOT/.claude"
TARGET_DIR="$HOME/.claude"

# ターゲットディレクトリがなければ作成
mkdir -p "$TARGET_DIR"

# .claude/ 内のファイルを走査（ディレクトリは除外）
find "$SOURCE_DIR" -maxdepth 1 -type f | while read -r src_file; do
  filename="$(basename "$src_file")"
  target="$TARGET_DIR/$filename"

  # 既に正しいシンボリックリンクが存在する場合はスキップ
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src_file" ]; then
    echo "[skip] $target -> $src_file (already linked)"
    continue
  fi

  # 既存ファイル（シンボリックリンク含む）がある場合はバックアップ
  if [ -e "$target" ] || [ -L "$target" ]; then
    backup="${target}.bak"
    echo "[backup] $target -> $backup"
    mv "$target" "$backup"
  fi

  # シンボリックリンクを作成
  ln -s "$src_file" "$target"
  echo "[link] $target -> $src_file"
done

# .claude/ 内のサブディレクトリを走査してシンボリックリンクを作成
find "$SOURCE_DIR" -maxdepth 1 -type d | while read -r src_dir; do
  dirname="$(basename "$src_dir")"
  # SOURCE_DIR 自体はスキップ
  [ "$src_dir" = "$SOURCE_DIR" ] && continue
  target="$TARGET_DIR/$dirname"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src_dir" ]; then
    echo "[skip] $target -> $src_dir (already linked)"
    continue
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup="${target}.bak"
    echo "[backup] $target -> $backup"
    mv "$target" "$backup"
  fi

  ln -s "$src_dir" "$target"
  echo "[link] $target -> $src_dir"
done
