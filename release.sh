#!/usr/bin/env bash
set -euo pipefail

# Man10TemplatePlugin リリーススクリプト
# 使用方法: ./release.sh [バージョン] [リリースタイプ]

# 現在のバージョンを取得
get_current_version() {
  if [[ -f "VERSION" ]]; then
    cat VERSION
  else
    echo "1.0.0"
  fi
}

# 次のバージョンを計算
calculate_next_version() {
  local current="$1"
  local type="$2"
  
  IFS='.' read -r major minor patch <<< "$current"
  
  case "$type" in
    "major")
      echo "$((major + 1)).0.0"
      ;;
    "minor")
      echo "$major.$((minor + 1)).0"
      ;;
    "patch")
      echo "$major.$minor.$((patch + 1))"
      ;;
    *)
      echo "$major.$((minor + 1)).0"  # デフォルトはminor
      ;;
  esac
}

# バージョンとリリースタイプの自動判定
if [[ $# -eq 0 ]]; then
  # 引数なし：対話的にリリースタイプを選択
  CURRENT_VERSION=$(get_current_version)
  echo "🔍 現在のバージョン: v$CURRENT_VERSION"
  echo ""
  echo "📋 リリースタイプを選択してください:"
  echo "  1) patch  - バグ修正 (v$(calculate_next_version "$CURRENT_VERSION" "patch"))"
  echo "  2) minor  - 新機能追加 (v$(calculate_next_version "$CURRENT_VERSION" "minor"))"
  echo "  3) major  - 大幅変更 (v$(calculate_next_version "$CURRENT_VERSION" "major"))"
  echo "  4) カスタム - 手動入力"
  echo ""
  read -p "選択 (1-4): " -n 1 -r
  echo
  echo
  
  case "$REPLY" in
    1)
      RELEASE_TYPE="patch"
      VERSION=$(calculate_next_version "$CURRENT_VERSION" "patch")
      ;;
    2)
      RELEASE_TYPE="minor"
      VERSION=$(calculate_next_version "$CURRENT_VERSION" "minor")
      ;;
    3)
      RELEASE_TYPE="major"
      VERSION=$(calculate_next_version "$CURRENT_VERSION" "major")
      ;;
    4)
      read -p "新しいバージョン番号を入力: " VERSION
      RELEASE_TYPE="custom"
      ;;
    *)
      echo "❌ 無効な選択です"
      exit 1
      ;;
  esac
elif [[ $# -eq 1 ]]; then
  if [[ "$1" =~ ^(patch|minor|major)$ ]]; then
    # 第一引数がリリースタイプの場合
    CURRENT_VERSION=$(get_current_version)
    RELEASE_TYPE="$1"
    VERSION=$(calculate_next_version "$CURRENT_VERSION" "$RELEASE_TYPE")
  else
    # 第一引数がバージョン番号の場合
    VERSION="$1"
    RELEASE_TYPE="minor"
  fi
else
  # 両方指定
  VERSION="$1"
  RELEASE_TYPE="$2"
fi

if [[ -z "${VERSION:-}" ]]; then
  echo "使用方法: $0 [バージョン] [リリースタイプ]"
  echo ""
  echo "🎯 簡単な使い方:"
  echo "  $0           # 対話的にリリースタイプを選択"
  echo "  $0 patch     # パッチリリース（バグ修正）"
  echo "  $0 minor     # マイナーリリース（新機能）"
  echo "  $0 major     # メジャーリリース（大幅変更）"
  echo ""
  echo "📋 従来の使い方:"
  echo "  $0 1.1.0     # バージョン指定"
  echo "  $0 1.1.0 minor"
  echo ""
  echo "🎯 実行内容:"
  echo "  1. VERSIONファイル更新"
  echo "  2. 変更をコミット"
  echo "  3. タグ作成・プッシュ"
  echo "  4. GitHubアクション自動実行"
  exit 1
fi

VERSION="$1"
RELEASE_TYPE="${2:-minor}"

# バージョンフォーマット確認
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "❌ エラー: バージョン形式が正しくありません"
  echo "💡 正しい形式: 1.2.3 (セマンティックバージョニング)"
  exit 1
fi

# Gitリポジトリ確認
if [[ ! -d ".git" ]]; then
  echo "❌ エラー: Gitリポジトリではありません"
  exit 1
fi

# 作業ディレクトリの確認
if [[ ! -f "src/main/kotlin/red/man10/template/TemplatePlugin.kt" ]]; then
  echo "❌ エラー: Man10TemplatePluginディレクトリで実行してください"
  exit 1
fi

echo "🚀 Man10TemplatePlugin リリース v$VERSION"
echo "📋 リリースタイプ: $RELEASE_TYPE"
echo ""

# 未コミットの変更確認
if [[ -n "$(git status --porcelain)" ]]; then
  echo "⚠️  未コミットの変更があります:"
  git status --short
  echo ""
  read -p "続行しますか？ (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ リリースをキャンセルしました"
    exit 1
  fi
fi

# 現在のブランチ確認
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "⚠️  現在のブランチ: $CURRENT_BRANCH"
  read -p "mainブランチ以外からリリースしますか？ (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ リリースをキャンセルしました"
    echo "💡 mainブランチに切り替えてから実行してください: git checkout main"
    exit 1
  fi
fi

# リリース内容確認
echo "🎯 実行する操作:"
echo "  1. VERSION を $VERSION に更新"
echo "  2. build.gradle.kts の version を更新"
echo "  3. 変更をコミット"
echo "  4. タグ v$VERSION を作成"
echo "  5. GitHubにプッシュ（GitHubアクション自動実行）"
echo ""
read -p "リリースを実行しますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "❌ リリースをキャンセルしました"
  exit 1
fi

echo ""
echo "🔧 リリース処理開始..."

# 1. VERSIONファイル更新
echo "📝 VERSIONファイルを更新中..."
echo "$VERSION" > VERSION

# 2. build.gradle.kts のバージョン更新
echo "📝 build.gradle.kts のバージョンを更新中..."
sed -i "s/version = \".*\"/version = \"$VERSION\"/" build.gradle.kts

# 3. リリースタイプ別のコミットメッセージ生成
case "$RELEASE_TYPE" in
  "major")
    COMMIT_MSG="release: v$VERSION - メジャーリリース

🎉 メジャーバージョンアップ v$VERSION
- 大幅な機能追加・改善
- 破壊的変更を含む可能性
- 詳細はCHANGELOG.mdを参照"
    ;;
  "minor")
    COMMIT_MSG="release: v$VERSION - マイナーリリース

✨ 新機能追加 v$VERSION
- 新機能・改善の追加
- 後方互換性を維持
- 詳細はCHANGELOG.mdを参照"
    ;;
  "patch")
    COMMIT_MSG="release: v$VERSION - パッチリリース

🐛 バグ修正 v$VERSION
- バグ修正・安定性向上
- 後方互換性を維持
- 詳細はCHANGELOG.mdを参照"
    ;;
  *)
    COMMIT_MSG="release: v$VERSION

🚀 リリース v$VERSION
- 詳細はCHANGELOG.mdを参照"
    ;;
esac

# 4. コミット実行
echo "📦 変更をコミット中..."
git add VERSION build.gradle.kts
git commit -m "$COMMIT_MSG"

# 5. タグ作成・重複チェック
echo "🏷️  タグ v$VERSION を作成中..."

# 既存タグチェック
if git tag -l | grep -q "^v$VERSION$"; then
  echo "⚠️  タグ v$VERSION は既に存在します"
  echo ""
  echo "📋 選択してください:"
  echo "  1) タグを上書き（既存リリースを更新）"
  echo "  2) キャンセル"
  echo ""
  read -p "選択 (1-2): " -n 1 -r
  echo
  echo
  
  case "$REPLY" in
    1)
      echo "🔄 既存タグ v$VERSION を削除・再作成中..."
      git tag -d "v$VERSION"
      # リモートタグも削除（エラーは無視）
      git push origin ":refs/tags/v$VERSION" 2>/dev/null || true
      git tag -a "v$VERSION" -m "v$VERSION: $(echo "$RELEASE_TYPE" | tr '[:lower:]' '[:upper:]')リリース（更新）"
      echo "✅ タグを上書きしました"
      ;;
    2)
      echo "❌ リリースをキャンセルしました"
      exit 1
      ;;
    *)
      echo "❌ 無効な選択です"
      exit 1
      ;;
  esac
else
  git tag -a "v$VERSION" -m "v$VERSION: $(echo "$RELEASE_TYPE" | tr '[:lower:]' '[:upper:]')リリース"
fi

# 6. プッシュ実行
echo "🚀 GitHubにプッシュ中..."
git push origin "$CURRENT_BRANCH"

# タグが上書きされた場合はforce pushが必要
if git tag -l | grep -q "^v$VERSION$"; then
  git push origin "v$VERSION" --force
else
  git push origin "v$VERSION"
fi

echo ""
echo "🎉 リリース v$VERSION 完了！"
echo ""
echo "🔗 次のステップ:"
echo "  1. GitHub Actionsの実行状況を確認"
echo "     https://github.com/man10server/Man10TemplatePlugin/actions"
echo "  2. リリースページを確認"
echo "     https://github.com/man10server/Man10TemplatePlugin/releases"
echo "  3. 自動生成されたリリースノートを編集（必要に応じて）"
echo ""
echo "⚡ GitHubアクションにより以下が自動実行されます:"
echo "  - プラグインのビルド"
echo "  - GitHubリリースの作成"
echo "  - JARファイルの添付"
echo "  - リリースノートの自動生成"
echo ""
echo "💡 リリース完了まで数分お待ちください。"
