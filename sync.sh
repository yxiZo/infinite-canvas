#!/bin/bash
# 同步上游：先丢弃 app 启动时自动写入的 ?v= 缓存戳（纯生成物、无业务价值），
# 再 fast-forward 拉取上游更新，最后重启容器。
# Sync with upstream: discard auto-generated cache-busting stamps, fast-forward pull, restart.
set -e
cd "$(dirname "$0")"

echo "==> 丢弃 static/*.html 的自动版本戳（app 会在下次启动重新生成）"
git checkout -- static/*.html 2>/dev/null || true

echo "==> 拉取上游（仅允许 fast-forward，保证无冲突）"
git pull --ff-only

echo "==> 重启容器"
docker compose restart

echo "==> 完成。当前版本：$(cat VERSION 2>/dev/null)"
