# Changelog

All notable changes to Man10TemplatePlugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-08-30

### Added
- 🚀 **初回リリース**: Man10TemplatePlugin v1.0.0
- ⚡ **自動プラグイン作成**: `new.sh` による3秒プラグイン生成
- 🔧 **環境自動セットアップ**: `setup.sh` による開発環境構築
- 📦 **完全日本語対応**: コメント・ドキュメント・エラーメッセージ
- 🏗️ **モダン技術スタック**: Kotlin 1.9.24 + Gradle 8.5 + Java 21
- 🎯 **Paper 1.21対応**: 最新Minecraft API対応
- 🔄 **自動ビルド・デプロイ**: `run.sh` による開発サイクル自動化
- 📝 **完全ドキュメント**: README、CHANGELOG、LICENSE完備
- 🎨 **プロフェッショナル構成**: Git管理、バージョン管理対応

### Features
- **コマンドシステム**: 権限管理付きコマンド実装例
- **イベントリスナー**: プレイヤー参加イベント処理例
- **設定ファイル**: `config.yml` による設定管理
- **自動置換システム**: パッケージ名・クラス名・設定の自動変換
- **開発スクリプト**: ビルド・デプロイ・リロード・全工程スクリプト
- **PATH統合**: どこからでも実行可能なコマンド設定

### Technical Details
- Java: OpenJDK 21 (LTS)
- Kotlin: 1.9.24 (stable)
- Gradle: 8.5 with Wrapper
- Paper API: 1.21-R0.1-SNAPSHOT
- Package: `red.man10.template` (auto-replaceable)
- Build Target: Paper Server 1.21

### Documentation
- 📖 **README.md**: 完全使用ガイド
- 📋 **CHANGELOG.md**: 変更履歴（このファイル）
- 📄 **LICENSE**: MIT License
- 🔧 **README-template.md**: テンプレート説明

### Developer Experience
- **3秒プラグイン作成**: `./new.sh MyPlugin myplugin`
- **ワンクリックビルド**: `./run.sh` で開発完結
- **自動環境構築**: `./setup.sh` で依存関係解決
- **Git統合**: バージョン管理・チーム開発対応
- **エラーハンドリング**: わかりやすい日本語エラーメッセージ

---

## [Unreleased]

### Planned Features
- 🔌 **プラグイン拡張**: データベース接続テンプレート
- 🌐 **API統合**: REST API・WebSocket対応
- 🔒 **セキュリティ**: 認証・認可システムテンプレート
- 📊 **メトリクス**: パフォーマンス監視テンプレート
- 🧪 **テスト**: 自動テストテンプレート
- 📦 **CI/CD**: GitHub Actions統合

---

**フォーマット説明:**
- `Added`: 新機能
- `Changed`: 既存機能の変更
- `Deprecated`: 非推奨になった機能
- `Removed`: 削除された機能
- `Fixed`: バグ修正
- `Security`: セキュリティ関連の修正

---

## 📦 リリース手順

### 🎯 自動リリース（推奨）

#### **1. タグ作成・プッシュ**
```bash
# バージョン更新
echo "1.1.0" > VERSION

# コミット
git add VERSION CHANGELOG.md
git commit -m "release: v1.1.0

✨ 新機能:
- 機能1追加
- 機能2改善

🐛 バグ修正:
- 問題1修正
- 問題2解決"

# タグ作成（GitHubアクション自動実行）
git tag -a v1.1.0 -m "v1.1.0: 新機能追加・バグ修正"
git push origin main
git push origin v1.1.0
```

#### **2. GitHubアクション自動実行**
- ✅ **ビルド**: Gradle自動実行
- ✅ **リリース作成**: GitHub Release自動作成
- ✅ **JAR添付**: プラグインファイル自動添付
- ✅ **リリースノート**: 自動生成

#### **3. リリース完了** 🎉
- GitHub Releasesページで確認
- JARファイルのダウンロード可能
- 変更履歴・インストール手順を自動表示
