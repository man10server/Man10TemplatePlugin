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

# ビルドテスト
./build.sh
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

### **🔧 コミットメッセージ**
```
feat: 新機能追加の説明
fix: バグ修正の説明  
docs: ドキュメント更新
refactor: リファクタリング
test: テスト追加
```

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
