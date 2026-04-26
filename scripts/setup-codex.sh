#!/usr/bin/env bash
set -euo pipefail

# プロジェクトルートを特定（スクリプトの親ディレクトリ）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$PROJECT_ROOT/.codex"
TARGET_DIR="$HOME/.codex"

# ソースディレクトリがなければ終了
if [ ! -d "$SOURCE_DIR" ]; then
  echo "[error] source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

# ターゲットディレクトリがなければ作成
mkdir -p "$TARGET_DIR"

link_entry() {
  local src="$1"
  local target="$2"

  # 既に正しいシンボリックリンクが存在する場合はスキップ
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
    echo "[skip] $target -> $src (already linked)"
    return
  fi

  # 既存ファイル（シンボリックリンク含む）がある場合はバックアップ
  if [ -e "$target" ] || [ -L "$target" ]; then
    local backup="${target}.bak"
    echo "[backup] $target -> $backup"
    mv "$target" "$backup"
  fi

  # シンボリックリンクを作成
  ln -s "$src" "$target"
  echo "[link] $target -> $src"
}

ensure_real_dir() {
  local dir="$1"

  if [ -L "$dir" ]; then
    local backup="${dir}.bak"
    echo "[backup] $dir -> $backup"
    mv "$dir" "$backup"
  elif [ -e "$dir" ] && [ ! -d "$dir" ]; then
    local backup="${dir}.bak"
    echo "[backup] $dir -> $backup"
    mv "$dir" "$backup"
  fi

  mkdir -p "$dir"
}

remove_stale_child_links() {
  local src_dir="$1"
  local target_dir="$2"

  find "$target_dir" -mindepth 1 -maxdepth 1 -type l -print0 | while IFS= read -r -d '' target_child; do
    local child_name
    local src_child

    child_name="$(basename "$target_child")"
    src_child="$src_dir/$child_name"

    if [ ! -e "$src_child" ] && [ ! -L "$src_child" ]; then
      echo "[unlink] $target_child (source removed)"
      rm "$target_child"
    fi
  done
}

# .codex/ の直下を走査
find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' src_entry; do
  name="$(basename "$src_entry")"
  target_entry="$TARGET_DIR/$name"

  if [ -f "$src_entry" ]; then
    # ルート直下のファイルはそのままリンク
    link_entry "$src_entry" "$target_entry"
    continue
  fi

  if [ -d "$src_entry" ]; then
    # ルート直下のディレクトリ自体はリンクせず、実ディレクトリとして用意
    ensure_real_dir "$target_entry"
    remove_stale_child_links "$src_entry" "$target_entry"

    # 子要素（例: .codex/skills/hoge）をリンク
    find "$src_entry" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' src_child; do
      child_name="$(basename "$src_child")"
      target_child="$target_entry/$child_name"
      link_entry "$src_child" "$target_child"
    done
  fi
done
