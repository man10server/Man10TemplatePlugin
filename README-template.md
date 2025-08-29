# TemplatePlugin

Man10サーバー用プラグインテンプレート - 新しいプラグイン開発のベース

## 🚀 使用方法

### 新しいプラグインの作成
```bash
# TemplatePluginディレクトリで実行
./new.sh MyAwesome myawesome

# 作成されたプラグインに移動  
cd ../MyAwesomePlugin

# 開発開始
./run.sh    # ビルド→デプロイ→リロード
```

### 作成例
```bash
# チャットフィルタープラグインを作成
./new.sh ChatFilter chatfilter

# 経済システムプラグインを作成  
./new.sh Economy economy

# 特定のディレクトリに作成
./new.sh MyPlugin myplugin /path/to/projects
```

## 📦 テンプレートの内容

### ✅ 含まれているもの
- **基本プラグイン構造**: Paper 1.21対応
- **コマンドシステム**: 権限管理付き
- **イベントリスナー**: プレイヤー参加時の処理例
- **設定ファイル**: `config.yml`によるカスタマイズ
- **ビルドシステム**: Gradle 8.5 + Kotlin 1.9.24
- **開発スクリプト**: `build.sh`, `deploy.sh`, `reload.sh`, `run.sh`

### 🛠️ 技術仕様
- **言語**: Kotlin
- **Java**: 21 (OpenJDK)
- **Gradle**: 8.5 (Wrapper付き)
- **Paper API**: 1.21-R0.1-SNAPSHOT
- **アーキテクチャ**: Plugin + Command + Listener

## 🔧 カスタマイズガイド

### 新しいコマンドの追加
1. `plugin.yml`にコマンドを定義
2. `CommandExecutor`クラスを作成
3. `onEnable()`でコマンドを登録

### 新しいイベントの処理
1. `Listener`クラスを作成
2. `@EventHandler`でメソッドを定義
3. `onEnable()`でリスナーを登録

### 設定項目の追加
1. `config.yml`に設定を追加
2. プラグインコードで`config.getString()`等で読み込み

## 📁 生成されるファイル構造

```
MyAwesomePlugin/
├── src/main/
│   ├── kotlin/red/man10/myawesome/
│   │   ├── MyAwesomePlugin.kt     # メインプラグイン
│   │   ├── MyAwesomeCommand.kt    # コマンド処理
│   │   └── MyAwesomeListener.kt   # イベント処理
│   └── resources/
│       ├── plugin.yml             # プラグイン定義
│       └── config.yml             # 設定ファイル
├── build.gradle.kts               # ビルド設定
├── settings.gradle.kts            # プロジェクト設定
├── README.md                      # プラグイン固有のREADME
├── build.sh                       # ビルドスクリプト
├── deploy.sh                      # デプロイスクリプト
├── reload.sh                      # リロードスクリプト
└── run.sh                         # 全工程実行スクリプト
```

## 🎯 開発フロー

```bash
# 1. プラグイン作成
./new.sh MyPlugin myplugin

# 2. 開発環境に移動
cd ../MyPluginPlugin

# 3. 開発サイクル
vim src/main/kotlin/red/man10/myplugin/MyPluginPlugin.kt
./run.sh    # 変更をビルド→デプロイ→テスト

# 4. 個別操作（必要に応じて）
./build.sh   # ビルドのみ
./deploy.sh  # デプロイのみ
./reload.sh  # リロードのみ
```

## 📚 参考リンク

- [Paper API ドキュメント](https://docs.papermc.io/)
- [Bukkit API リファレンス](https://hub.spigotmc.org/javadocs/bukkit/)
- [Kotlin 公式ドキュメント](https://kotlinlang.org/docs/)

---

**TemplatePlugin v1.0** - Man10 Development Team
