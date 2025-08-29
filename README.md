# Man10TemplatePlugin v1.0.0

[![Java](https://img.shields.io/badge/Java-21-orange)](https://adoptium.net/)
[![Kotlin](https://img.shields.io/badge/Kotlin-1.9.24-blue)](https://kotlinlang.org/)
[![Gradle](https://img.shields.io/badge/Gradle-8.5-green)](https://gradle.org/)
[![Paper](https://img.shields.io/badge/Paper-1.21-yellow)](https://papermc.io/)

Man10サーバー用Minecraftプラグインテンプレート - プロフェッショナル開発環境

## 🎯 概要

新しいMinecraftプラグインを**3秒で作成**できる、完全自動化されたテンプレートシステムです。  
初心者から上級者まで、効率的なプラグイン開発をサポートします。

### ✨ 特徴
- **🚀 超高速セットアップ**: `./setup.sh` で環境構築完了
- **⚡ 3秒プラグイン作成**: `./new.sh MyPlugin myplugin` 
- **🔄 自動ビルド・デプロイ**: `./run.sh` で開発サイクル完結
- **📦 完全自己完結**: 必要なものが全て含まれる
- **🌐 日本語完全対応**: コメント・ドキュメント・エラーメッセージ

## 機能

### ✅ 含まれている機能
- **基本コマンド**: `/template` (`/tpl`) - テンプレートコマンド
- **プレイヤーイベント**: プレイヤー参加時の挨拶メッセージ
- **設定ファイル**: `config.yml` による設定管理
- **ログ出力**: プラグイン有効化/無効化時のログ

### 🛠️ 技術仕様

| 項目 | バージョン | 説明 |
|------|------------|------|
| **Java** | OpenJDK 21 | 最新LTS版、自動インストール対応 |
| **Kotlin** | 1.9.24 | 安定版、Java相互運用性 |
| **Gradle** | 8.5 | Wrapper付き、オフライン対応 |
| **Paper API** | 1.21-R0.1-SNAPSHOT | 最新Minecraft対応 |
| **アーキテクチャ** | Plugin + Command + Listener | 標準的なプラグイン構成 |
| **パッケージ** | `red.man10.template` | 自動置換対応 |

## 使用方法

### 📦 初回セットアップ
```bash
# GitHubからテンプレートを取得
git clone https://github.com/man10server/Man10TemplatePlugin.git
cd Man10TemplatePlugin

# 開発環境のセットアップ（初回のみ）
./setup.sh
```

### ⚡ プラグイン作成（3秒）
```bash
# Man10TemplatePluginディレクトリで実行
./new.sh MyAwesome myawesome

# 作成されたプラグインディレクトリに移動
cd ../MyAwesomePlugin
```

### 開発フロー
```bash
# ビルド
./build.sh

# サーバーにデプロイ
./deploy.sh

# プラグインをリロード
./reload.sh

# 全工程を一度に実行
./run.sh
```

### サーバー内コマンド
```
/template      # 基本的な挨拶メッセージを表示
/tpl          # 上記のエイリアス
```

## ファイル構成

```
TemplatePlugin/
├── README.md                    # このファイル
├── build.gradle.kts            # ビルド設定
├── settings.gradle.kts         # プロジェクト設定
├── src/main/
│   ├── kotlin/red/man10/template/
│   │   ├── TemplatePlugin.kt   # メインプラグインクラス
│   │   ├── TemplateCommand.kt  # コマンド処理
│   │   └── TemplateListener.kt # イベントリスナー
│   └── resources/
│       ├── plugin.yml          # プラグイン定義
│       └── config.yml          # 設定ファイル
├── build.sh                   # ビルドスクリプト
├── deploy.sh                  # デプロイスクリプト
├── reload.sh                  # リロードスクリプト
└── run.sh                     # 全工程実行スクリプト
```

## カスタマイズ方法

### 1. プラグイン名の変更
- `plugin.yml` の `name` を変更
- パッケージ名を変更 (`red.man10.template` → `red.man10.yourname`)
- クラス名を変更 (`TemplatePlugin` → `YourPlugin`)

### 2. コマンドの追加
- `plugin.yml` にコマンドを追加
- 新しいCommandExecutorクラスを作成
- `onEnable()` でコマンドを登録

### 3. イベントの追加
- 新しいListenerクラスを作成
- `@EventHandler` でイベント処理メソッドを定義
- `onEnable()` でイベントリスナーを登録

### 4. 設定項目の追加
- `config.yml` に新しい設定項目を追加
- プラグインコード内で `config.getString()` 等で読み込み

## トラブルシューティング

### ビルドエラー
```bash
# Gradleキャッシュをクリア
./gradlew clean

# 依存関係を再解決
./gradlew build --refresh-dependencies
```

### デプロイ失敗
```bash
# サーバーが起動しているか確認
# JARファイルが正しく生成されているか確認
ls -la build/libs/
```

### リロード失敗
```bash
# PlugManXが有効になっているか確認
# プラグイン名が正しいか確認
```

## 🤖 AI開発エージェント向け

**重要**: AI開発エージェント（Claude、ChatGPT等）を使用してプラグイン開発を行う場合は、必ず **[AGENTS.md](AGENTS.md)** を参照してください。

### 📋 AI開発者向けガイド
- **[AGENTS.md](AGENTS.md)**: 包括的ルール・コーディング規約・品質基準
- **命名規則**: PascalCase/lowercase統一  
- **Man10標準**: 権限・メッセージ・設定形式
- **品質チェック**: 必須実行項目・禁止事項
- **標準フロー**: テンプレート→./new.sh→開発→./run.sh

## 📚 参考リンク

- **[AGENTS.md](AGENTS.md)** - AI開発エージェント向けガイドライン
- [Paper API ドキュメント](https://docs.papermc.io/)
- [Bukkit API リファレンス](https://hub.spigotmc.org/javadocs/bukkit/)
- [Kotlin 公式ドキュメント](https://kotlinlang.org/docs/)
- [Gradle ドキュメント](https://docs.gradle.org/)

## 📊 バージョン履歴

### v1.0.0 (2024-08-30)
- ✨ 初回リリース
- 🚀 自動環境セットアップ機能
- ⚡ 3秒プラグイン作成システム
- 📦 完全日本語対応
- 🔧 Gradle 8.5 + Kotlin 1.9.24 + Java 21構成
- 🎯 Paper 1.21 API対応

## 🤝 サポート・コントリビューション

### 📞 サポート
- **Issues**: [GitHub Issues](https://github.com/man10server/TemplatePlugin/issues)
- **Discord**: Man10 Development Server
- **Wiki**: [開発者Wiki](https://wiki.man10.red/development)

### 🔧 コントリビューション
1. Fork このリポジトリ
2. Feature ブランチ作成 (`git checkout -b feature/AmazingFeature`)
3. 変更をコミット (`git commit -m 'feat: Add AmazingFeature'`)
4. ブランチにプッシュ (`git push origin feature/AmazingFeature`)
5. Pull Request を作成

### 📄 ライセンス
MIT License - 詳細は [LICENSE](LICENSE) ファイルを参照

---

<div align="center">

**🎮 Man10TemplatePlugin v1.0.0**  
*Professional Minecraft Plugin Development Template*

[![Man10 Server](https://img.shields.io/badge/Man10-Server-red)](https://man10.red)
[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red)]()

**🔧 作成者**: Man10 Development Team  
**📅 最終更新**: 2024年8月30日  
**🌟 Star**: [GitHub Repository](https://github.com/man10server/TemplatePlugin)

</div>
