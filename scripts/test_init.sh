#!/usr/bin/env bash
# scripts/test_init.sh
# init.sh の冪等性と置換完全性を検証する.
#
# 1. テンプレートを tmp dir にコピー
# 2. init.sh を実行
# 3. {{PRODUCT_NAME}} と {Product Name} が残っていないことを確認
# 4. 2 回目の実行でエラーにならないこと（冪等）

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_NAME="my-test-product"

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

echo "📦 テンプレートを $WORK_DIR にコピー"
# init.sh が触る対象ファイルだけコピー
cp -r "$REPO_ROOT/scripts" "$WORK_DIR/scripts"
cp "$REPO_ROOT/package.json" "$WORK_DIR/"
cp "$REPO_ROOT/README.md" "$WORK_DIR/"
mkdir -p "$WORK_DIR/src/app"
cp "$REPO_ROOT/src/app/layout.tsx" "$WORK_DIR/src/app/"
cp "$REPO_ROOT/src/app/page.tsx" "$WORK_DIR/src/app/"

cd "$WORK_DIR"

echo "🚀 init.sh 1回目実行"
PRODUCT_NAME="$TEST_NAME" bash scripts/init.sh

echo "🔍 placeholder が残っていないか確認"
if grep -rE '\{\{PRODUCT_NAME\}\}' package.json src README.md 2>/dev/null; then
  echo "❌ {{PRODUCT_NAME}} が残っています" >&2
  exit 1
fi
if grep -rE '\{Product Name\}' README.md 2>/dev/null; then
  echo "❌ {Product Name} が残っています" >&2
  exit 1
fi

echo "🔍 置換結果を確認"
grep -q "\"name\": \"$TEST_NAME\"" package.json || {
  echo "❌ package.json の name が更新されていません" >&2
  exit 1
}
grep -q "$TEST_NAME" src/app/layout.tsx || {
  echo "❌ layout.tsx が更新されていません" >&2
  exit 1
}

echo "🔁 init.sh 2回目実行（冪等性確認）"
PRODUCT_NAME="$TEST_NAME" bash scripts/init.sh

echo "🚫 不正な PRODUCT_NAME を拒否することを確認"
if PRODUCT_NAME="Invalid_Name" bash scripts/init.sh 2>/dev/null; then
  echo "❌ 不正な PRODUCT_NAME を受理してしまいました" >&2
  exit 1
fi

if bash scripts/init.sh 2>/dev/null; then
  echo "❌ PRODUCT_NAME 未指定で成功してしまいました" >&2
  exit 1
fi

echo "✅ test_init.sh 全テストパス"
