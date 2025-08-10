package asrz.Pokemon.controllers.dialogs

import asrz.Pokemon.controllers.controls.HpBar
import asrz.Pokemon.controllers.controls.MoveButtons
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.util.ImageLoader
import java.io.IOException
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.DialogPane
import javafx.scene.control.Label
import javafx.scene.image.ImageView
import xtendfx.beans.FXBindable

@FXBindable
class PokemonViewDialog extends DialogPane implements IController {
	
	@FXML
	ImageView sprite
	
	@FXML
	HpBar hpBar
	
	@FXML
	MoveButtons moveButtons
	
	@FXML
	Label powerLabel
	@FXML
	Label accuracyLabel
	@FXML
	Label detailsLabel
	
	Pokemon pokemon
	
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/dialogs/PokemonViewDialog.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	new(Pokemon pokemon) {
		this()
		
		this.pokemon = pokemon
		initialize()
	}
	
	override initialize() {
		if (pokemon !== null) {
			sprite.image = ImageLoader.loadImage(pokemon.frontSprite)
			moveButtons.activePokemon = pokemon
			moveButtons.moveButtonHandler = [ populateMoveDetailsPanel(move) ]
			moveButtons.initialize()
		}
	}
	
	@FXML
	def onClickDamageButton() {
		pokemon.hp = pokemon.hp - 1
	}
	
	@FXML
	def onClickLevelUpButton() {
		pokemon.levelUp(player, null)
	}
	
	def populateMoveDetailsPanel(Move move) {
		powerLabel.text = String.valueOf(move.power ?: "-")
		accuracyLabel.text = String.valueOf(move.accuracy ?: "-")
		detailsLabel.text = move.description
	}
}
