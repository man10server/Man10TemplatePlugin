# TemplatePlugin

Man10サーバー用プラグインテンプレート

## 概要

新しいプラグインを作成する際のベースとなるテンプレートプラグインです。
基本的な機能（コマンド、イベントリスナー、設定ファイル）が含まれており、
これをベースに独自のプラグインを開発できます。

## 機能

### ✅ 含まれている機能
- **基本コマンド**: `/template` (`/tpl`) - テンプレートコマンド
- **プレイヤーイベント**: プレイヤー参加時の挨拶メッセージ
- **設定ファイル**: `config.yml` による設定管理
- **ログ出力**: プラグイン有効化/無効化時のログ

### 🛠️ 技術仕様
- **言語**: Kotlin
- **ビルドツール**: Gradle 8.5
- **Java**: 21
- **Paper API**: 1.21-R0.1-SNAPSHOT
- **パッケージ**: `red.man10.template`

## 使用方法

### プラグイン作成
```bash
# 新しいプラグインを作成（TemplatePluginをベースに）
create.sh MyAwesome myawesome

# 作成されたプラグインディレクトリに移動
cd plugins-src/MyAwesomePlugin
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

## 参考リンク

- [Paper API ドキュメント](https://docs.papermc.io/)
- [Bukkit API リファレンス](https://hub.spigotmc.org/javadocs/bukkit/)
- [Kotlin 公式ドキュメント](https://kotlinlang.org/docs/)
- [Gradle ドキュメント](https://docs.gradle.org/)

---

**Man10 Plugin Development Template v1.0**  
🔧 作成者: Man10 Development Team  
📅 最終更新: 2024年8月
