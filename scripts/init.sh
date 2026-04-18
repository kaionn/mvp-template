#!/usr/bin/env bash
# scripts/init.sh
# テンプレートの {{PRODUCT_NAME}} placeholder を実際のプロダクト名に置換する.
# mvp-factory build.yml から呼び出される前提で冪等に動作する.
#
# Usage:
#   PRODUCT_NAME=my-app scripts/init.sh
#   scripts/init.sh my-app

set -euo pipefail

PRODUCT_NAME="${1:-${PRODUCT_NAME:-}}"

if [ -z "$PRODUCT_NAME" ]; then
  echo "❌ PRODUCT_NAME が指定されていません" >&2
  echo "   Usage: PRODUCT_NAME=my-app scripts/init.sh" >&2
  exit 1
fi

# ケバブケース検証
if ! [[ "$PRODUCT_NAME" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
  echo "❌ PRODUCT_NAME がケバブケースではありません: $PRODUCT_NAME" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# 置換対象ファイル. README.md は {Product Name} (空白付き) も置換するためここでは個別処理
TARGETS=(
  "package.json"
  "src/app/layout.tsx"
  "src/app/page.tsx"
)

for target in "${TARGETS[@]}"; do
  if [ ! -f "$target" ]; then
    echo "⚠️ $target が存在しないためスキップ" >&2
    continue
  fi
  # macOS / GNU sed 両対応のため一時ファイル経由
  TMP=$(mktemp)
  sed "s|{{PRODUCT_NAME}}|${PRODUCT_NAME}|g" "$target" > "$TMP"
  mv "$TMP" "$target"
  echo "✅ $target を更新"
done

# README.md は {Product Name} (古い placeholder) も置換
if [ -f "README.md" ]; then
  TMP=$(mktemp)
  sed -e "s|{{PRODUCT_NAME}}|${PRODUCT_NAME}|g" \
      -e "s|{Product Name}|${PRODUCT_NAME}|g" \
      "README.md" > "$TMP"
  mv "$TMP" README.md
  echo "✅ README.md を更新"
fi

echo "🎉 init.sh 完了 (PRODUCT_NAME=${PRODUCT_NAME})"
