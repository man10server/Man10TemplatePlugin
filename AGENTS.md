# AGENTS.md

AI開発エージェント向けガイドライン・ルール・ベストプラクティス

## 🤖 AI開発エージェント用ルール

### 📋 基本原則

#### **🎯 目的**
- Man10TemplatePluginを使用したMinecraftプラグイン開発の効率化
- 一貫性のある高品質なコード生成
- 日本語での開発体験最適化

#### **⚡ 開発フロー**
1. **テンプレート取得**: `git clone https://github.com/man10server/Man10TemplatePlugin.git`
2. **環境構築**: `./setup.sh`（初回のみ）
3. **プラグイン作成**: `./new.sh PluginName pluginname`
4. **開発**: `cd ../PluginNamePlugin && ./run.sh`

---

## 🔧 コーディング規約

### **📦 プラグイン命名規則**

| 項目 | 形式 | 例 |
|------|------|-----|
| **プラグイン名** | PascalCase | `ChatFilter`, `Economy`, `PvPManager` |
| **スラッグ** | lowercase | `chatfilter`, `economy`, `pvpmanager` |
| **パッケージ** | `red.man10.{slug}` | `red.man10.chatfilter` |
| **メインクラス** | `{PluginName}Plugin` | `ChatFilterPlugin` |

### **🏗️ ファイル構造**

```
PluginNamePlugin/
├── src/main/kotlin/red/man10/{slug}/
│   ├── {PluginName}Plugin.kt     # メインクラス
│   ├── {PluginName}Command.kt    # コマンド処理
│   ├── {PluginName}Listener.kt   # イベント処理
│   ├── config/                   # 設定関連
│   ├── database/                 # DB関連
│   └── utils/                    # ユーティリティ
├── src/main/resources/
│   ├── plugin.yml               # プラグイン定義
│   └── config.yml               # 設定ファイル
└── README.md                    # プラグイン説明
```

### **💻 Kotlinコーディング標準**

#### **📝 コメント規約**
```kotlin
/**
 * プラグインの主要機能を説明
 * 
 * @param parameter パラメータ説明
 * @return 戻り値説明
 * @author Man10 Development Team
 */
class ExamplePlugin : JavaPlugin() {
    
    /**
     * プラグイン有効化時の処理
     * - 設定ファイル読み込み
     * - コマンド登録
     * - イベントリスナー登録
     */
    override fun onEnable() {
        // 処理内容をコメント
        saveDefaultConfig()
        
        // コマンド登録
        getCommand("example")?.setExecutor(ExampleCommand(this))
    }
}
```

#### **🎨 コード品質基準**
- **関数サイズ**: 30行以内を推奨
- **クラスサイズ**: 200行以内を推奨  
- **ネスト深度**: 3階層以内
- **変数名**: わかりやすい日本語英語併用OK
- **エラーハンドリング**: 必須（try-catch）

---

## 🎮 Man10サーバー固有ルール

### **🔐 権限システム**
```yaml
permissions:
  {pluginname}.use:
    description: "基本使用権限"
    default: true
  {pluginname}.admin:
    description: "管理者権限"
    default: op
  {pluginname}.vip:
    description: "VIP権限"
    default: false
```

### **💬 メッセージ形式**
```kotlin
// ✅ 推奨: Man10標準形式
player.sendMessage("§a[PluginName] §f正常に処理されました")
player.sendMessage("§c[PluginName] §fエラーが発生しました")

// ❌ 非推奨: 色コードなし
player.sendMessage("処理完了")
```

### **📊 設定ファイル標準**
```yaml
# プラグイン基本設定
plugin:
  enabled: true
  debug: false
  language: "ja"

# Man10サーバー連携
man10:
  server_id: "main"
  database_prefix: "{pluginname}_"
  
# 機能別設定
features:
  feature1:
    enabled: true
    settings: {}
```

---

## 🚀 AIエージェント指示

### **📋 必須実行項目**

#### **1. プラグイン作成時**
```bash
# 必ず実行する手順
cd Man10TemplatePlugin
./new.sh {PluginName} {pluginname}
cd ../{PluginName}Plugin

# デプロイ設定編集（必須）
vim deploy.conf  # または nano deploy.conf

# ビルドテスト
./build.sh
```

#### **📋 デプロイ設定 (deploy.conf)**

##### **🎯 設定項目**
```bash
# デプロイ先ディレクトリ
DEPLOY_TARGET="/home/man10/mc_net/dev/server/plugins"

# RCON コマンド実行パス
RCON_COMMAND="/home/man10/mc_net/dev/command"

# サーバー名（ログ表示用）
SERVER_NAME="dev"
```

##### **🏷️ 環境別設定例**
```bash
# 開発環境（デフォルト）
DEPLOY_TARGET="/home/man10/mc_net/dev/server/plugins"
RCON_COMMAND="/home/man10/mc_net/dev/command"
SERVER_NAME="dev"

# 本番環境
DEPLOY_TARGET="/home/man10/mc_net/main/server/plugins"
RCON_COMMAND="/home/man10/mc_net/main/command"
SERVER_NAME="main"

# テスト環境
DEPLOY_TARGET="/home/man10/mc_net/test/server/plugins"
RCON_COMMAND="/home/man10/mc_net/test/command" 
SERVER_NAME="test"

# ローカル環境
DEPLOY_TARGET="/home/user/minecraft/plugins"
RCON_COMMAND="/home/user/minecraft/rcon"
SERVER_NAME="local"
```

#### **2. コード生成時**
- ✅ **日本語コメント**: 全クラス・メソッドに説明
- ✅ **エラーハンドリング**: try-catch必須
- ✅ **Man10形式**: 権限・メッセージ・設定
- ✅ **テスト可能**: `./run.sh`で動作確認

#### **3. 品質チェック**
```bash
# ビルドエラーチェック
./build.sh

# デプロイテスト
./deploy.sh

# 動作確認
./reload.sh
```

### **🔍 コードレビュー基準**

#### **✅ チェック項目**
- [ ] **命名規則**: PascalCase/lowercase適用
- [ ] **パッケージ**: `red.man10.{slug}`形式
- [ ] **権限**: plugin.ymlに定義済み
- [ ] **エラーハンドリング**: 例外処理実装
- [ ] **日本語コメント**: 主要メソッドに説明
- [ ] **Man10標準**: 色コード・メッセージ形式
- [ ] **設定ファイル**: config.yml標準構造
- [ ] **ビルド成功**: `./build.sh`でエラーなし

#### **⚠️ 禁止事項**
- ❌ **ハードコーディング**: 設定値の直接埋め込み
- ❌ **英語エラーメッセージ**: プレイヤー向けは日本語
- ❌ **権限チェック省略**: 管理コマンドは必須
- ❌ **例外無視**: catch文で何もしない
- ❌ **巨大メソッド**: 100行超える関数
- ❌ **magic number**: 定数として定義する

---

## 📝 ドキュメント規約

### **📋 README.md構造**
```markdown
# {PluginName}Plugin

{プラグインの簡潔な説明}

## 機能
- 機能1の説明
- 機能2の説明

## コマンド
| コマンド | 権限 | 説明 |
|----------|------|------|

## 権限
| 権限 | デフォルト | 説明 |
|------|------------|------|

## 設定
config.ymlの主要設定項目

## インストール
./run.sh による自動デプロイ手順
```

### **🔧 Git運用ルール**

#### **📋 開発ワークフロー（必須）**
```bash
# 1. 機能開発・修正
# コード実装

# 2. 【必須】ビルド前コミット
git add .
git commit -m "feat: 新機能実装（ビルド前）"

# 3. ビルドテスト
./build.sh

# 4. 【ビルド成功時】テスト実行
./run.sh
# または
./deploy.sh && ./reload.sh

# 5. 【テスト完了時】本番コミット&プッシュ
git add .
git commit -m "feat: 新機能完成・テスト完了

✅ ビルド成功
✅ 動作確認完了
✅ プラグイン正常稼働"
git push origin main
```

#### **🎯 コミットタイミング**
| タイミング | 必須度 | 目的 |
|------------|--------|------|
| **実装完了時** | 必須 | 作業進捗保存・ロールバック準備 |
| **ビルド成功時** | 推奨 | 動作する状態の確保 |
| **テスト完了時** | 必須 | リリース可能状態・プッシュOK |
| **機能完成時** | 必須 | 完全な機能単位での区切り |

#### **🔧 コミットメッセージ規約**

##### **📝 基本フォーマット**
```
<type>: <subject>（50文字以内）

<body>（詳細説明・72文字で改行）
- 実装内容
- テスト結果
- 注意事項
```

##### **🏷️ Type一覧**
| Type | 用途 | 例 |
|------|------|-----|
| `feat` | 新機能追加 | `feat: チャットフィルター機能追加` |
| `fix` | バグ修正 | `fix: プレイヤーデータ保存エラー修正` |
| `docs` | ドキュメント | `docs: README.md更新` |
| `style` | コード整形 | `style: インデント修正` |
| `refactor` | リファクタリング | `refactor: CommandHandler分離` |
| `test` | テスト追加 | `test: データベーステスト追加` |
| `chore` | 設定変更 | `chore: Gradle設定更新` |
| `build` | ビルド関連 | `build: shadowJar設定修正` |
| `wip` | 作業中 | `wip: 経済システム実装中（ビルド前）` |

##### **⚡ 特別なコミット**
```bash
# ビルド前コミット（作業保存）
git commit -m "wip: ログイン機能実装中（ビルド前）

🚧 実装状況:
- LoginHandler基本実装
- データベーススキーマ定義
- 次回: パスワードハッシュ化実装"

# テスト完了コミット（リリース準備）
git commit -m "feat: ログイン機能完成・テスト完了

✅ 実装完了:
- セキュアなパスワード認証
- セッション管理
- ログイン履歴記録

✅ テスト完了:
- 正常ログイン確認
- 不正ログイン防止確認
- パフォーマンス問題なし

🚀 リリース準備完了"
```

#### **🔄 ブランチ戦略**

##### **📊 推奨ブランチ構成**
```
main          ← 本番・安定版（常にリリース可能）
├── develop   ← 開発統合ブランチ
├── feature/  ← 機能開発ブランチ
├── hotfix/   ← 緊急修正ブランチ
└── release/  ← リリース準備ブランチ
```

##### **🚀 機能開発フロー**
```bash
# 1. 機能ブランチ作成
git checkout -b feature/chat-filter
git push -u origin feature/chat-filter

# 2. 開発・ビルド前コミット
git commit -m "wip: チャットフィルター実装中"

# 3. ビルド成功・テスト完了
git commit -m "feat: チャットフィルター完成・テスト完了"

# 4. developにマージ
git checkout develop
git merge feature/chat-filter
git push origin develop

# 5. mainにマージ（リリース）
git checkout main
git merge develop
git push origin main
git tag -a v1.1.0 -m "チャットフィルター機能追加"
git push origin v1.1.0
```

#### **🔍 プルリクエスト規約**

##### **📋 PR作成基準**
- ✅ **ビルド成功**: `./build.sh`エラーなし
- ✅ **テスト完了**: `./run.sh`で動作確認
- ✅ **コード品質**: AGENTS.md準拠
- ✅ **ドキュメント**: README.md更新

##### **📝 PRテンプレート**
```markdown
## 📋 変更内容
- 機能概要
- 実装内容

## ✅ テスト状況
- [ ] ビルド成功（./build.sh）
- [ ] 動作確認（./run.sh）
- [ ] 機能テスト完了
- [ ] エラーハンドリング確認

## 📊 影響範囲
- 影響するクラス・機能
- 設定ファイル変更
- 権限変更

## 🔗 関連Issue
Closes #123
```

#### **🚨 緊急時対応・ロールバック**

##### **⚡ ビルドエラー時**
```bash
# 1. ビルドエラー発生
./build.sh
# ❌ ビルド失敗

# 2. 【すぐに】エラー状態をコミット
git add .
git commit -m "fix: ビルドエラー発生・調査中

❌ エラー内容:
- Gradle依存関係エラー
- Kotlin構文エラー

🔍 次回対応:
- 依存関係確認
- 構文修正"

# 3. 前回の動作版に戻る
git log --oneline -5
git checkout <前回の動作版コミット>

# 4. 新ブランチで修正
git checkout -b hotfix/build-error
# 修正作業
```

##### **🔄 テスト失敗時**
```bash
# 1. テスト失敗（ビルドは成功）
./build.sh  # ✅ 成功
./run.sh    # ❌ 実行時エラー

# 2. 【重要】テスト失敗状態を記録
git add .
git commit -m "fix: テスト失敗・動作不良確認

✅ ビルド成功
❌ 実行時エラー:
- プラグイン読み込み失敗
- NullPointerException

🚫 【プッシュ禁止】
🔍 原因調査・修正必要"

# 3. すぐに修正 or ロールバック
# 修正可能な場合
# 修正作業 → ビルド → テスト → プッシュ

# 修正困難な場合（ロールバック）
git reset --hard <前回のテスト成功版>
```

##### **💥 本番エラー時（緊急）**
```bash
# 1. 【最優先】サーバーからプラグイン無効化
# /plugman disable PluginName

# 2. 緊急ホットフィックス作成
git checkout main
git checkout -b hotfix/critical-fix
# 最小限修正
git commit -m "hotfix: 緊急修正・本番復旧

🚨 緊急対応:
- 致命的バグ修正
- 最小限修正のみ

✅ テスト完了:
- 本番環境で動作確認済み"

# 3. 即座にリリース
git checkout main
git merge hotfix/critical-fix
git push origin main
git tag -a v1.0.1 -m "緊急修正版"
git push origin v1.0.1
```

#### **📊 Git運用メトリクス**

##### **🎯 品質指標**
| 指標 | 目標値 | 測定方法 |
|------|--------|----------|
| **ビルド成功率** | 95%以上 | ビルド前コミット数 / 総コミット数 |
| **テスト完了率** | 90%以上 | テスト完了コミット数 / ビルド成功数 |
| **ロールバック率** | 5%以下 | ロールバック回数 / リリース回数 |
| **ホットフィックス率** | 10%以下 | 緊急修正回数 / リリース回数 |

##### **📈 推奨コミット頻度**
- **開発中**: 30分〜1時間おき（作業保存）
- **機能完成**: 1日1回以上（進捗明確化）
- **テスト完了**: 即座（リリース準備）
- **本番プッシュ**: 週1〜2回（安定リリース）

---

## 🎯 AIエージェント推奨フロー

### **🤖 標準対話例**

#### **1. プラグイン作成要求時**
```
ユーザー: "チャットフィルタープラグインを作って"

AI応答:
1. Man10TemplatePluginでChatFilterプラグインを作成します
2. 基本的なチャットフィルタリング機能を実装
3. 設定ファイルでNGワード管理
4. 管理者用コマンドでリアルタイム設定
```

#### **2. 機能実装要求時**
```
ユーザー: "経済システムに銀行機能を追加"

AI応答:
1. BankManagerクラス作成
2. 預金・引き出し・利息システム
3. 権限設定（economy.bank.use）
4. コマンド（/economy bank deposit 1000）
5. 設定ファイル更新（利率・手数料）
```

#### **3. バグ修正要求時**
```
ユーザー: "プレイヤーデータが保存されない"

AI応答:
1. データベース接続確認
2. 保存タイミングのログ追加
3. 例外処理強化
4. 非同期処理でデータ整合性確保
5. テストデータでの動作確認
```

---

## 🔄 バージョン管理

### **📊 このファイルについて**
- **バージョン**: 1.0.0
- **最終更新**: 2024年8月30日
- **作成者**: Man10 Development Team
- **用途**: AI開発エージェント向けガイドライン

### **🔄 更新履歴**
- **v1.0.0** (2024-08-30): 初版作成・基本ルール確立

---

**このガイドラインに従って、一貫性のある高品質なMinecraftプラグイン開発を実現してください。** 🚀
