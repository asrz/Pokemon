package asrz.Pokemon.controllers.dialogs

import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.enums.BattleSlot
import asrz.Pokemon.util.ImageLoader
import java.io.IOException
import java.util.List
import java.util.Map
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.Button
import javafx.scene.control.ButtonType
import javafx.scene.control.Dialog
import javafx.scene.control.DialogPane
import javafx.scene.image.ImageView

class ChooseTargetDialog extends DialogPane implements IController {
	
	@FXML
	Button playerPrimaryButton
	@FXML
	Button playerSecondaryButton
	@FXML
	Button opponentPrimaryButton
	@FXML
	Button opponentSecondaryButton
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/dialogs/ChooseTargetDialog.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	private def getButton(BattleSlot battleSlot) {
		switch(battleSlot) {
			case OPPONENT_PRIMARY: return opponentPrimaryButton
			case OPPONENT_SECONDARY: return opponentSecondaryButton
			case PLAYER_PRIMARY: return playerPrimaryButton
			case PLAYER_SECONDARY: return playerSecondaryButton
			default: throw new RuntimeException("Unhandled BattleSlot: " + battleSlot)
		}
	}
	
	def void populate(Map<BattleSlot, Pokemon> pokemonBySlot, List<BattleSlot> validChoices, Dialog dialog) {
		for (BattleSlot slot : pokemonBySlot.keySet()) {
			val button = getButton(slot)
			
			button.onAction = [
				dialog.result = slot
				dialog.close()
			]
			
			val pokemon = pokemonBySlot.get(slot)
			
			if (pokemonBySlot.containsKey(slot)) {
				button.visible = true
				button.graphic = new ImageView(ImageLoader.loadImage(pokemon?.frontSprite))
				button.text = pokemon?.label
			} else {
				button.visible = false
			}
			
			button.disable = !validChoices.contains(slot)
		}
	}
	
	override protected createButton(ButtonType buttonType) {
		//do nothing
	}
	
	override protected createButtonBar() {
		//do nothing
	}
	
}
