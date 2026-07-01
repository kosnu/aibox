#!/usr/bin/env bash
set -euo pipefail

# プロジェクトルートを特定（スクリプトの親ディレクトリ）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$PROJECT_ROOT/.claude"
TARGET_DIR="$HOME/.claude"

# ターゲットディレクトリがなければ作成
mkdir -p "$TARGET_DIR"

next_backup_path() {
  local target="$1"
  local backup="${target}.bak"
  local index=1

  while [ -e "$backup" ] || [ -L "$backup" ]; do
    backup="${target}.bak.${index}"
    index=$((index + 1))
  done

  echo "$backup"
}

backup_target() {
  local target="$1"
  local backup

  backup="$(next_backup_path "$target")"
  echo "[backup] $target -> $backup"
  mv "$target" "$backup"
}

link_entry() {
  local src="$1"
  local target="$2"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
    echo "[skip] $target -> $src (already linked)"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup_target "$target"
  fi

  ln -s "$src" "$target"
  echo "[link] $target -> $src"
}

ensure_real_dir() {
  local dir="$1"

  if [ -L "$dir" ]; then
    backup_target "$dir"
  elif [ -e "$dir" ] && [ ! -d "$dir" ]; then
    backup_target "$dir"
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

    local link_dest
    link_dest="$(readlink "$target_child")"

    if [[ "$link_dest" == "$src_dir/"* ]] && [ ! -e "$src_child" ] && [ ! -L "$src_child" ]; then
      echo "[unlink] $target_child (source removed)"
      rm "$target_child"
    fi
  done
}

remove_stale_child_links "$SOURCE_DIR" "$TARGET_DIR"

# .claude/ 内のファイルを走査（ディレクトリは除外）
find "$SOURCE_DIR" -maxdepth 1 -type f | while read -r src_file; do
  filename="$(basename "$src_file")"
  target="$TARGET_DIR/$filename"
  link_entry "$src_file" "$target"
done

# .claude/ 内のサブディレクトリは実ディレクトリとして用意し、その直下の子要素をリンクする
find "$SOURCE_DIR" -maxdepth 1 -type d | while read -r src_dir; do
  dirname="$(basename "$src_dir")"
  # SOURCE_DIR 自体はスキップ
  [ "$src_dir" = "$SOURCE_DIR" ] && continue
  target="$TARGET_DIR/$dirname"

  ensure_real_dir "$target"
  remove_stale_child_links "$src_dir" "$target"

  find "$src_dir" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' src_child; do
    child_name="$(basename "$src_child")"
    target_child="$target/$child_name"
    link_entry "$src_child" "$target_child"
  done
done
