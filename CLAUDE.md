# MVP プロジェクト

このリポジトリは pain-collector → mvp-factory パイプラインで自動生成された MVP です。

## セッション開始時の動作

1. `docs/spec.md` を読み込む（必須。存在しなければ何もしない）
2. `docs/deep-dive.md` が存在すれば参照する（競合分析、ペルソナ、GTM 戦略）
3. `docs/origin.md` から生成元の情報を確認する

## 実装フロー

compound-engineering プラグインが利用可能な場合:
1. `/ce:brainstorm` — Spec を入力として要件確認。不明確な箇所は Spec から推測して判断する（対話的な質問はしない）
2. `/ce:plan` — Spec の技術スタック推奨に従って設計。Implementation Units に分割
3. `/ce:work` — Plan に従って実装。テストを書く
4. `/ce:review` — コードレビュー。指摘があれば修正

compound-engineering が利用できない場合:
1. Spec を読んで要件を理解する
2. 技術スタックを選定する（Spec に推奨があればそれに従う）
3. 実装する
4. テストを書く

## 技術スタック選定ルール

Spec に推奨スタックの記載がある場合はそれに従う。ない場合のデフォルト:

| レイヤー | デフォルト | 理由 |
|---|---|---|
| フロントエンド | Next.js 14+ (App Router) + Tailwind CSS | 個人開発で最速、Vercel デプロイ容易 |
| バックエンド | Next.js API Routes or Route Handlers | フロントと同一リポジトリで管理 |
| DB | SQLite (better-sqlite3) or Supabase | MVP ではシンプルに。スケール必要時に移行 |
| 認証 | NextAuth.js or Supabase Auth | Spec に認証要件があれば |
| デプロイ | Vercel | ゼロ config デプロイ |
| スタイリング | Tailwind CSS + shadcn/ui | コンポーネント再利用性 |

## コーディング規約

- TypeScript 必須（JavaScript 不可）
- ESLint + Prettier を設定する
- テストフレームワーク: Vitest（フロントエンド）or pytest（Python）
- README.md にセットアップ手順を必ず記載する
- 環境変数は `.env.example` にテンプレートを用意する

## MVP スコープの原則

- Spec の Week 1（必須機能）のみを実装する
- Week 2（追加機能）は TODO コメントとして残す
- 1 つの画面で 1 つのコア機能を提供する
- 認証は Spec に明記されている場合のみ実装する
- 決済機能は MVP では実装しない（Stripe 連携等は後から追加）

## コミットメッセージ

- 日本語で記述する
- Conventional Commits 形式: `feat:`, `fix:`, `docs:`, `test:`
