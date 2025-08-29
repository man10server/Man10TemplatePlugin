#!/usr/bin/env bash
set -euo pipefail

# Man10 プラグインテンプレートから新しいプラグインを作成
# 使用方法: new.sh <プラグイン名> <スラッグ> [作成先]

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "使用方法: $0 <プラグイン名> <スラッグ> [作成先]"
  echo "例: $0 MyAwesome myawesome"
  echo "例: $0 MyAwesome myawesome /path/to/projects"
  echo ""
  echo "作成されるもの: MyAwesomePlugin/ ディレクトリ（完全なプラグイン環境）"
  echo ""
  echo "プラグイン名: PascalCase（例: ChatFilter, Economy）"
  echo "スラッグ: lowercase（例: chatfilter, economy）"
  exit 1
fi

BaseName="$1"
slug="$2"
DEST_BASE="${3:-..}"  # 親ディレクトリがデフォルト

# ソースは現在のディレクトリ（TemplatePlugin）
SRC_DIR="."
DEST_DIR="${DEST_BASE}/${BaseName}Plugin"

# Man10TemplatePluginディレクトリ内で実行されているか確認
if [[ ! -f "src/main/kotlin/red/man10/template/TemplatePlugin.kt" ]]; then
  echo "❌ エラー: このスクリプトはMan10TemplatePluginディレクトリ内で実行してください"
  echo "💡 必要なファイル: src/main/kotlin/red/man10/template/TemplatePlugin.kt"
  exit 1
fi

if [[ -e "$DEST_DIR" ]]; then 
  echo "❌ 作成先が既に存在します: $DEST_DIR" 1>&2
  exit 1
fi

echo "🎯 プラグイン作成中: ${BaseName}Plugin"
echo "📂 ソース: Man10TemplatePlugin (現在のディレクトリ)"
echo "📁 作成先: $DEST_DIR"

# 作成先ディレクトリにコピー
cp -r "$SRC_DIR" "$DEST_DIR"

# ビルド成果物、git、テンプレート固有ファイルをクリーンアップ
echo "🧹 ビルド成果物とテンプレートファイルをクリーンアップ中..."
rm -rf "$DEST_DIR/build"
rm -rf "$DEST_DIR/.gradle"
rm -rf "$DEST_DIR/.kotlin"
rm -rf "$DEST_DIR/.git"
rm -f "$DEST_DIR/new.sh"
rm -f "$DEST_DIR/README-template.md"

# デプロイ設定テンプレートをコピー
echo "📋 デプロイ設定をセットアップ中..."
cp "$SRC_DIR/deploy.conf" "$DEST_DIR/deploy.conf"

# Rename package directory
if [[ -d "$DEST_DIR/src/main/kotlin/red/man10/template" ]]; then
  mkdir -p "$DEST_DIR/src/main/kotlin/red/man10"
  mv "$DEST_DIR/src/main/kotlin/red/man10/template" "$DEST_DIR/src/main/kotlin/red/man10/$slug"
fi

# Rename Kotlin files
if [[ -d "$DEST_DIR/src/main/kotlin/red/man10/$slug" ]]; then
  cd "$DEST_DIR/src/main/kotlin/red/man10/$slug"
  for file in Template*.kt; do
    if [[ -f "$file" ]]; then
      new_name="${file/Template/${BaseName}}"
      mv "$file" "$new_name"
    fi
  done
  cd - > /dev/null
fi

# Replace tokens in all files
tokens=(
  "s/TemplatePlugin/${BaseName}Plugin/g"
  "s/TemplateCommand/${BaseName}Command/g"
  "s/TemplateListener/${BaseName}Listener/g"
  "s/red\\.man10\\.template/red.man10.${slug}/g"
  "s/# TemplatePlugin/# ${BaseName}Plugin/g"
  "s/TemplatePlugin - /# ${BaseName}Plugin - /g"
  "s/Man10サーバー用プラグインテンプレート/${BaseName}Plugin - Man10サーバー用プラグイン/g"
)

while IFS= read -r -d '' f; do
  for t in "${tokens[@]}"; do
    sed -i -e "$t" "$f"
  done
done < <(find "$DEST_DIR" -type f -print0)

# plugin.yml: command name -> slug, usage -> /slug, aliases -> []
pyml="$DEST_DIR/src/main/resources/plugin.yml"
if [[ -f "$pyml" ]]; then
  sed -i -e "s/^\(\s*\)template:/\1${slug}:/" "$pyml"
  sed -i -e "s|usage: /template|usage: /${slug}|" "$pyml"
  sed -i -e "s|aliases: \[ tpl \]|aliases: []|" "$pyml"
  # Fix permission names and description
  sed -i -e "s/template\./${slug}./g" "$pyml"
  sed -i -e "s/テンプレートプラグイン/${BaseName}Plugin/g" "$pyml"
  sed -i -e "s/テンプレートコマンド/${BaseName}コマンド/g" "$pyml"
fi

# Gradle settings rename
sed -i -e "s/rootProject.name = \"TemplatePlugin\"/rootProject.name = \"${BaseName}Plugin\"/" "$DEST_DIR/settings.gradle.kts"
sed -i -e "s/archiveBaseName.set(\"TemplatePlugin\")/archiveBaseName.set(\"${BaseName}Plugin\")/" "$DEST_DIR/build.gradle.kts"

# Update README.md with new plugin information
if [[ -f "$DEST_DIR/README.md" ]]; then
  # Replace plugin name in README
  sed -i -e "s/# TemplatePlugin/# ${BaseName}Plugin/" "$DEST_DIR/README.md"
  sed -i -e "s/TemplatePlugin/${BaseName}Plugin/g" "$DEST_DIR/README.md"
  sed -i -e "s/template/${slug}/g" "$DEST_DIR/README.md"
  sed -i -e "s|/template|/${slug}|g" "$DEST_DIR/README.md"
  sed -i -e "s|/tpl|/${slug:0:3}|g" "$DEST_DIR/README.md"
  
  # Update package references in README
  sed -i -e "s/red\\.man10\\.template/red.man10.${slug}/g" "$DEST_DIR/README.md"
  
  # Update creation example in README
  sed -i -e "s/create\\.sh MyAwesome myawesome/create.sh ${BaseName} ${slug}/" "$DEST_DIR/README.md"
  sed -i -e "s/MyAwesomePlugin/${BaseName}Plugin/g" "$DEST_DIR/README.md"
fi

# Create convenient scripts in plugin directory
cat > "$DEST_DIR/build.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"
echo "🔨 Building plugin..."
./gradlew build
echo "✅ Build completed: $(ls build/libs/*.jar)"
EOF

cat > "$DEST_DIR/deploy.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

# Load deploy configuration
if [[ -f "deploy.conf" ]]; then
  source deploy.conf
else
  echo "⚠️  deploy.conf not found, using default settings"
  DEPLOY_TARGET="/home/man10/mc_net/dev/server/plugins"
  SERVER_NAME="dev"
fi

# Deploy JAR to server
shopt -s nullglob
jars=(build/libs/*Plugin-*.jar)
if [[ ${#jars[@]} -eq 0 ]]; then
  echo "❌ JAR file not found. Run ./build.sh first" 1>&2
  exit 1
fi

JAR_FILE=$(ls -1t "${jars[@]}" | head -n1)
cp "$JAR_FILE" "${DEPLOY_TARGET}/$(basename "$JAR_FILE")"
echo "✅ Deployed: $JAR_FILE -> ${DEPLOY_TARGET}/$(basename "$JAR_FILE")"
echo "🎯 Server: ${SERVER_NAME}"
EOF

cat > "$DEST_DIR/reload.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

# Load deploy configuration
if [[ -f "deploy.conf" ]]; then
  source deploy.conf
else
  echo "⚠️  deploy.conf not found, using default settings"
  RCON_COMMAND="/home/man10/mc_net/dev/command"
  SERVER_NAME="dev"
fi

# Reload plugin via PlugManX
PLUGIN_NAME=$(basename build/libs/*Plugin-*.jar .jar | sed 's/-[0-9].*//')
echo "🔄 Reloading plugin: $PLUGIN_NAME on ${SERVER_NAME}"
"${RCON_COMMAND}" "plugman reload $PLUGIN_NAME" || {
  echo "⚠️  Reload failed, trying load instead..."
  "${RCON_COMMAND}" "plugman load $PLUGIN_NAME"
}
EOF

cat > "$DEST_DIR/run.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"
echo "🚀 Running full development cycle..."
./build.sh
./deploy.sh
./reload.sh
echo "✅ Development cycle completed!"
EOF

# Make scripts executable
chmod +x "$DEST_DIR"/*.sh

echo "✨ プラグイン作成完了！"
echo ""
echo "🎯 作成されたプラグイン: $(basename "$DEST_DIR")"
echo "📁 場所: $DEST_DIR"
echo ""
echo "🚀 クイックスタート:"
echo "  ./run.sh     # ビルド→デプロイ→リロード"
echo ""
echo "📝 個別コマンド:"
echo "  ./build.sh   # ビルドのみ"
echo "  ./deploy.sh  # デプロイのみ"
echo "  ./reload.sh  # リロードのみ"
echo ""
echo "🎉 プラグインディレクトリに移動します..."

# 作成したプラグインディレクトリに自動移動
cd "$DEST_DIR"

echo "📂 現在のディレクトリ: $(pwd)"
echo "💡 今すぐ開発を始められます！"
echo ""
echo "🎯 次のステップ:"
echo "  1. vim deploy.conf     # デプロイ設定を確認・編集"
echo "  2. ./run.sh           # ビルド→デプロイ→テスト"

# 新しいシェルを起動して、ユーザーが作成したディレクトリで作業を続けられるようにする
exec $SHELL