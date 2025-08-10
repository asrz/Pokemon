package asrz.Pokemon.util

import asrz.Pokemon.model.Pokemon
import javafx.scene.control.Dialog
import javafx.scene.control.DialogPane
import javafx.scene.control.TextInputDialog
import javafx.scene.control.Alert
import javafx.scene.control.Alert.AlertType
import javafx.scene.control.ButtonType

class DialogUtil {
	
	def static createDialog(DialogPane dialogPane) {
		val dialog = new Dialog()
		dialog.dialogPane = dialogPane
		
		dialogPane.stylesheets.add(DialogUtil.getResource("/css/style.css").toExternalForm)
		
		return dialog
	}
	
	def static void showNicknameDialog(Pokemon pokemon) {
		val dialog = new TextInputDialog()
		dialog.dialogPane.stylesheets.add(DialogUtil.getResource("/css/style.css").toExternalForm)
		dialog.contentText = String.format("Would you like to give your %s a nickname?", pokemon.label)
		dialog.graphic = null
		dialog.headerText = null
		dialog.showAndWait().ifPresent[ text |
			if (text.trim != '') {
				pokemon.nickname = text
			}
		]
	}
	
	def static createYesNoDialog(String text, Object...args) {
		val dialog = new Alert(AlertType.NONE, String.format(text, args), ButtonType.YES, ButtonType.NO)
		dialog.dialogPane.stylesheets.add(DialogUtil.getResource("/css/style.css").toExternalForm)
		
		return dialog
	}
	
	def static createInfoDialog(String text, Object... args) {
		return new Alert(AlertType.NONE, String.format(text, args), ButtonType.OK)
	}
}