package red.man10.template

import org.bukkit.ChatColor
import org.bukkit.event.EventHandler
import org.bukkit.event.Listener
import org.bukkit.event.player.PlayerJoinEvent

/**
 * TemplateListener - イベントリスナークラス
 * 
 * サーバー内で発生するイベント（プレイヤー参加、ブロック破壊等）を監視し、
 * 対応する処理を実行します。
 * このクラスをベースに、独自のイベント処理を実装してください。
 * 
 * @param plugin プラグインのメインインスタンス
 * @author Man10 Development Team
 */
class TemplateListener(private val plugin: TemplatePlugin) : Listener {
    
    /**
     * プレイヤー参加時の処理
     * 
     * プレイヤーがサーバーに参加した際に実行されます。
     * 
     * @param e プレイヤー参加イベント
     */
    @EventHandler
    fun onJoin(e: PlayerJoinEvent) {
        // 水色のプレフィックスと白色のメッセージでウェルカムメッセージを送信
        e.player.sendMessage("${ChatColor.AQUA}[Template] ${ChatColor.WHITE}Welcome, ${e.player.name}!")
    }
}
