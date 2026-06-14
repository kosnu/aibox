#!/usr/bin/env bash
set -euo pipefail

# プロジェクトルートを特定（スクリプトの親ディレクトリ）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$PROJECT_ROOT/.codex"
TARGET_DIR="$HOME/.codex"
SKILLS_SOURCE_DIR="$PROJECT_ROOT/.agents/skills"
SKILLS_TARGET_DIR="$HOME/.agents/skills"

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

restore_home_config() {
  local source_config="$SOURCE_DIR/config.toml"
  local target_config="$TARGET_DIR/config.toml"
  local backup_config="${target_config}.bak"

  if [ ! -e "$target_config" ] && [ ! -L "$target_config" ] && [ -f "$source_config" ]; then
    echo "[copy] $source_config -> $target_config"
    cp -p "$source_config" "$target_config"
    return
  fi

  if [ ! -L "$target_config" ] || [ "$(readlink "$target_config")" != "$source_config" ]; then
    return
  fi

  echo "[unlink] $target_config (repo config is not linked)"
  rm "$target_config"

  if [ -e "$backup_config" ] || [ -L "$backup_config" ]; then
    echo "[restore] $backup_config -> $target_config"
    mv "$backup_config" "$target_config"
  elif [ -f "$source_config" ]; then
    echo "[copy] $source_config -> $target_config"
    cp -p "$source_config" "$target_config"
  fi
}

restore_home_config

# .codex/ の直下を走査
find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' src_entry; do
  name="$(basename "$src_entry")"
  [ "$name" = "skills" ] && continue
  [ "$name" = "config.toml" ] && continue
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

    # 子要素（例: .codex/hooks/hoge）をリンク
    find "$src_entry" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' src_child; do
      child_name="$(basename "$src_child")"
      target_child="$target_entry/$child_name"
      link_entry "$src_child" "$target_child"
    done
  fi
done

if [ -d "$SKILLS_SOURCE_DIR" ]; then
  ensure_real_dir "$SKILLS_TARGET_DIR"
  remove_stale_child_links "$SKILLS_SOURCE_DIR" "$SKILLS_TARGET_DIR"

  find "$SKILLS_SOURCE_DIR" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' src_skill; do
    skill_name="$(basename "$src_skill")"
    target_skill="$SKILLS_TARGET_DIR/$skill_name"
    link_entry "$src_skill" "$target_skill"
  done
fi
