package red.man10.template

import org.bukkit.ChatColor
import org.bukkit.command.Command
import org.bukkit.command.CommandExecutor
import org.bukkit.command.CommandSender

/**
 * TemplateCommand - テンプレートコマンドの処理
 * 
 * /template コマンドが実行された際の処理を行います。
 * このクラスをベースに、独自のコマンド処理を実装してください。
 * 
 * @param plugin プラグインのメインインスタンス
 * @author Man10 Development Team
 */
class TemplateCommand(private val plugin: TemplatePlugin) : CommandExecutor {
    
    /**
     * コマンド実行時の処理
     * 
     * @param sender コマンドを実行したプレイヤーまたはコンソール
     * @param command 実行されたコマンド
     * @param label 使用されたコマンドラベル
     * @param args コマンド引数の配列
     * @return 処理成功時はtrue、失敗時はfalse
     */
    override fun onCommand(sender: CommandSender, command: Command, label: String, args: Array<out String>): Boolean {
        // 緑色のプレフィックスと白色のメッセージでプラグインからの挨拶を送信
        sender.sendMessage("${ChatColor.GREEN}[Template] ${ChatColor.WHITE}Hello from TemplatePlugin!")
        return true
    }
}
