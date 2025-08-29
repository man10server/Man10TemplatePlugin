package red.man10.template

import org.bukkit.plugin.java.JavaPlugin

/**
 * TemplatePlugin - Man10サーバー用プラグインテンプレート
 * 
 * 新しいプラグインを作成する際のベースとなるテンプレートです。
 * 基本的な機能（コマンド、イベントリスナー、設定ファイル）が含まれています。
 * 
 * @author Man10 Development Team
 * @version 1.0
 */
class TemplatePlugin : JavaPlugin() {
    
    /**
     * プラグイン有効化時の処理
     * - 設定ファイルの作成
     * - コマンドの登録
     * - イベントリスナーの登録
     */
    override fun onEnable() {
        // デフォルト設定ファイル（config.yml）を保存
        saveDefaultConfig()
        
        // プラグイン有効化ログを出力
        logger.info("TemplatePlugin enabled (v${description.version})")
        
        // /template コマンドを登録
        getCommand("template")?.setExecutor(TemplateCommand(this))
        
        // プレイヤー参加イベントリスナーを登録
        server.pluginManager.registerEvents(TemplateListener(this), this)
    }

    /**
     * プラグイン無効化時の処理
     */
    override fun onDisable() {
        // プラグイン無効化ログを出力
        logger.info("TemplatePlugin disabled")
    }
}
