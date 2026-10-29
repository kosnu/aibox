# aibox

AI エージェント向けの共通スキルと、個人用の Codex 設定を管理するリポジトリ。

## スキル

スキルのソースは `skills/` にある。[APM](https://microsoft.github.io/apm/getting-started/installation/) を使ってホームに導入する。

```sh
apm install -g 'kosnu/aibox#main' --target agent-skills
```

更新するときは次を実行し、変更内容を確認して適用する。

```sh
apm update -g kosnu/aibox
```

共有スキルは `~/.agents/skills/` に配置され、このディレクトリに対応するツールで利用できる。旧リンクからの移行は[移行手順](docs/migrate-skill-links.md)を参照。

## Codex の設定

`scripts/setup-codex.sh` は、このリポジトリの `.codex/` にある設定をホームにリンクする。既存の `config.toml` はホーム内のファイルとして保持する。セットアップまたは再リンクするときに実行する。

```sh
bash scripts/setup-codex.sh
```

セットアップの回帰テストは、一時ホームを使って実行する。

```sh
bash scripts/test-setup-codex.sh
```
