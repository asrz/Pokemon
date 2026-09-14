package asrz.Pokemon.util

import asrz.Pokemon.controllers.dialogs.ChooseTargetDialog
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.enums.BattleSlot
import java.util.List
import java.util.Map
import javafx.scene.control.Alert
import javafx.scene.control.Alert.AlertType
import javafx.scene.control.ButtonType
import javafx.scene.control.Dialog
import javafx.scene.control.DialogPane
import javafx.scene.control.TextInputDialog

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
	
	def static BattleSlot chooseTarget(Map<BattleSlot, Pokemon> pokemonBySlot, List<BattleSlot> validChoices) {
		val nonNullChoices = validChoices.filter[pokemonBySlot.get(it) !== null].toList
		if (nonNullChoices.size() == 1) {
			//if there's only one choice just use it - e.g. SELECTED_POKEMON in single battle
			return nonNullChoices.get(0)
		}
		
		val Dialog<BattleSlot> dialog = new Dialog()
		val dialogPane = new ChooseTargetDialog()
		dialog.dialogPane = dialogPane
		
		for (BattleSlot slot : validChoices) {
			dialogPane.buttonTypes.add(new ButtonType(slot.name()))
		}
		
		dialogPane.populate(pokemonBySlot, validChoices, dialog)
		
		val result = dialog.showAndWait()
		println(result)
		if (result !== null && result.isPresent()) {
			val Object realResult = result.get()
			if (realResult instanceof BattleSlot) {
				return realResult
			}
		}
		
		return null
	}
}