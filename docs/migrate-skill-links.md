# 旧リンクからの移行

APM 導入前に `~/.agents/skills/` と `~/.codex/skills/` を確認する。旧セットアップやそれ以前の構成で作られたリンクが両方に残っていることがあり、同名スキルの重複や APM の衝突を引き起こす。

```sh
ls -la ~/.agents/skills ~/.codex/skills
```

各リンクの参照先を `readlink` で確認し、aibox の `.agents/skills/` または旧 `.codex/skills/` を指すリンクだけを、ホーム内の別のバックアップディレクトリへ移動する。リンク切れの古いスキルも対象に含める。実ディレクトリや他のリポジトリへのリンクは移動しない。同名の実ディレクトリがある場合は内容と所有者を確認してから手動で退避する。ディレクトリ全体を削除したり、`--force` で上書きしたりしない。

```sh
readlink ~/.agents/skills/repo
mkdir -p ~/aibox-skill-links-backup/agents ~/aibox-skill-links-backup/codex
# 以下は参照先を確認したリンクについてのみ実行する例
mv ~/.agents/skills/repo ~/aibox-skill-links-backup/agents/
```

同じ要領で対象リンクを退避したら[導入コマンド](../README.md#スキル)を実行し、`~/.agents/skills/` の各スキルがリンクではなくディレクトリであること、`~/.codex/skills/` に同名の旧リンクが残っていないことを確認する。必要ならバックアップしたリンクを元の場所に戻せるが、先に APM 管理の同名ディレクトリを退避する。

