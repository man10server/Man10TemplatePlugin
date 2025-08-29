#!/usr/bin/env bash
set -euo pipefail

# Create new plugin from TemplatePlugin
# Usage: new.sh <PluginName> <slug> [destination]

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <PluginName> <slug> [destination]"
  echo "Example: $0 MyAwesome myawesome"
  echo "Example: $0 MyAwesome myawesome /path/to/projects"
  echo ""
  echo "Creates: MyAwesomePlugin/ directory with complete plugin setup"
  exit 1
fi

BaseName="$1"
slug="$2"
DEST_BASE="${3:-..}"  # Default to parent directory

# Source is current directory (TemplatePlugin)
SRC_DIR="."
DEST_DIR="${DEST_BASE}/${BaseName}Plugin"

# Verify we're in Man10TemplatePlugin directory
if [[ ! -f "src/main/kotlin/red/man10/template/TemplatePlugin.kt" ]]; then
  echo "❌ Error: This script must be run from within the Man10TemplatePlugin directory"
  echo "💡 Expected to find: src/main/kotlin/red/man10/template/TemplatePlugin.kt"
  exit 1
fi

if [[ -e "$DEST_DIR" ]]; then 
  echo "❌ destination exists: $DEST_DIR" 1>&2
  exit 1
fi

echo "🎯 Creating plugin: ${BaseName}Plugin"
echo "📂 Source: Man10TemplatePlugin (current directory)"
echo "📁 Destination: $DEST_DIR"

# Create destination directory
cp -r "$SRC_DIR" "$DEST_DIR"

# Clean up build artifacts, git, and template-specific files
echo "🧹 Cleaning up build artifacts and template files..."
rm -rf "$DEST_DIR/build"
rm -rf "$DEST_DIR/.gradle"
rm -rf "$DEST_DIR/.kotlin"
rm -rf "$DEST_DIR/.git"
rm -f "$DEST_DIR/new.sh"
rm -f "$DEST_DIR/README-template.md"

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

# Deploy JAR to server
shopt -s nullglob
jars=(build/libs/*Plugin-*.jar)
if [[ ${#jars[@]} -eq 0 ]]; then
  echo "❌ JAR file not found. Run ./build.sh first" 1>&2
  exit 1
fi

JAR_FILE=$(ls -1t "${jars[@]}" | head -n1)
cp "$JAR_FILE" "/home/man10/mc_net/dev/server/plugins/$(basename "$JAR_FILE")"
echo "✅ Deployed: $JAR_FILE -> /home/man10/mc_net/dev/server/plugins/$(basename "$JAR_FILE")"
EOF

cat > "$DEST_DIR/reload.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

# Reload plugin via PlugManX
PLUGIN_NAME=$(basename build/libs/*Plugin-*.jar .jar | sed 's/-[0-9].*//')
echo "🔄 Reloading plugin: $PLUGIN_NAME"
/home/man10/mc_net/dev/command "plugman reload $PLUGIN_NAME" || {
  echo "⚠️  Reload failed, trying load instead..."
  /home/man10/mc_net/dev/command "plugman load $PLUGIN_NAME"
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

echo "✨ Plugin ready!"
echo ""
echo "🎯 Created: $(basename "$DEST_DIR")"
echo "📁 Location: $DEST_DIR"
echo ""
echo "🚀 Quick start:"
echo "  cd $DEST_DIR"
echo "  ./run.sh     # ビルド→デプロイ→リロード"
echo ""
echo "📝 Individual commands:"
echo "  ./build.sh   # ビルドのみ"
echo "  ./deploy.sh  # デプロイのみ"
echo "  ./reload.sh  # リロードのみ"
echo ""
echo "💡 Now run: cd $DEST_DIR"