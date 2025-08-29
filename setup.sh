#!/usr/bin/env bash
set -euo pipefail

# TemplatePlugin Environment Setup Script
# 開発環境の自動セットアップ（必要なパッケージのインストール）

echo "🚀 TemplatePlugin開発環境セットアップ"
echo ""

# Root権限チェック
check_sudo() {
  if ! sudo -n true 2>/dev/null; then
    echo "🔐 このスクリプトはsudo権限が必要です"
    echo "💡 パスワードの入力が求められる場合があります"
  fi
}

# Java 21のインストール確認とインストール
setup_java() {
  echo "☕ Java 21のセットアップ..."
  
  if command -v java >/dev/null 2>&1; then
    java_version=$(java -version 2>&1 | head -n1)
    echo "  現在のJava: $java_version"
    
    # Java 21かチェック
    if java -version 2>&1 | grep -q "openjdk version \"21"; then
      echo "  ✅ Java 21 が既にインストールされています"
      return 0
    fi
  fi
  
  echo "  📦 OpenJDK 21をインストール中..."
  sudo apt update
  sudo apt install -y openjdk-21-jdk-headless
  
  # JAVA_HOMEの設定確認
  if ! grep -q "JAVA_HOME.*java-21" ~/.bashrc 2>/dev/null; then
    echo "  🔧 JAVA_HOME環境変数を設定中..."
    echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
  fi
  
  echo "  ✅ Java 21のセットアップ完了"
}

# Git設定確認
setup_git() {
  echo "📝 Git設定の確認..."
  
  if ! command -v git >/dev/null 2>&1; then
    echo "  📦 Gitをインストール中..."
    sudo apt install -y git
  fi
  
  # Git設定の確認
  if ! git config --global user.name >/dev/null 2>&1; then
    echo "  ⚠️  Git user.nameが設定されていません"
    echo "  💡 手動で設定してください: git config --global user.name 'Your Name'"
  fi
  
  if ! git config --global user.email >/dev/null 2>&1; then
    echo "  ⚠️  Git user.emailが設定されていません"
    echo "  💡 手動で設定してください: git config --global user.email 'your@email.com'"
  fi
  
  echo "  ✅ Git設定確認完了"
}

# 開発ツールのインストール
setup_dev_tools() {
  echo "🛠️  開発ツールのセットアップ..."
  
  # 必要なパッケージのリスト
  packages=(
    "curl"       # ダウンロード用
    "wget"       # ダウンロード用
    "unzip"      # アーカイブ展開用
    "tree"       # ディレクトリ構造表示用
    "vim"        # テキストエディタ
    "nano"       # テキストエディタ
  )
  
  echo "  📦 必要なパッケージをインストール中..."
  for pkg in "${packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
      echo "    インストール中: $pkg"
      sudo apt install -y "$pkg"
    else
      echo "    ✅ $pkg は既にインストール済み"
    fi
  done
  
  echo "  ✅ 開発ツールのセットアップ完了"
}

# PATH設定の確認・追加
setup_path() {
  echo "🛤️  PATH設定の確認..."
  
  # TemplatePluginディレクトリをPATHに追加
  template_dir="$(pwd)"
  
  if ! grep -q "$template_dir" ~/.bashrc 2>/dev/null; then
    echo "  🔧 TemplatePluginディレクトリをPATHに追加中..."
    echo "# TemplatePlugin PATH" >> ~/.bashrc
    echo "export PATH=\"$template_dir:\$PATH\"" >> ~/.bashrc
    echo "  ✅ PATH設定完了"
    echo "  💡 新しいターミナルで有効になります"
  else
    echo "  ✅ PATH設定は既に完了しています"
  fi
}

# Gradleテスト
test_gradle() {
  echo "🧪 Gradle動作テスト..."
  
  if [[ -f "gradlew" ]]; then
    echo "  🔨 Gradle Wrapperのテスト中..."
    if ./gradlew tasks --quiet >/dev/null 2>&1; then
      echo "  ✅ Gradle Wrapper正常動作"
    else
      echo "  ⚠️  Gradle Wrapperでエラーが発生しました"
      echo "  💡 手動でテストしてください: ./gradlew tasks"
    fi
  else
    echo "  ⚠️  gradlewが見つかりません"
  fi
}

# メイン実行
main() {
  echo "開始時刻: $(date)"
  echo ""
  
  check_sudo
  setup_java
  setup_git
  setup_dev_tools
  setup_path
  test_gradle
  
  echo ""
  echo "🎉 セットアップ完了！"
  echo ""
  echo "📋 次のステップ:"
  echo "  1. 新しいターミナルを開く（PATH設定を反映）"
  echo "  2. プラグイン作成: ./new.sh MyPlugin myplugin"
  echo "  3. 開発開始: cd ../MyPluginPlugin && ./run.sh"
  echo ""
  echo "🔧 追加設定（必要に応じて）:"
  echo "  - Git設定: git config --global user.name 'Your Name'"
  echo "  - Git設定: git config --global user.email 'your@email.com'"
  echo ""
  echo "完了時刻: $(date)"
}

# スクリプト実行
main "$@"
