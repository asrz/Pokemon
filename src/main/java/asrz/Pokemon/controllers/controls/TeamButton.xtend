package asrz.Pokemon.controllers.controls

import asrz.Pokemon.controllers.dialogs.PokemonViewDialog
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.util.DialogUtil
import asrz.Pokemon.util.ImageLoader
import java.io.IOException
import java.util.function.Consumer
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.Label
import javafx.scene.control.MenuButton
import javafx.scene.image.ImageView
import xtendfx.beans.FXBindable
import javafx.beans.binding.Bindings

@FXBindable
class TeamButton extends MenuButton implements IController {

	Pokemon pokemon
	
	@FXML
	ImageView imageView
	
	@FXML
	HpBar hpBar
	
	@FXML
	Label label
	
	Consumer<Pokemon> switchHandler
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/TeamButton.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
		if (pokemon !== null) {
			imageView.image = ImageLoader.loadImage(pokemon.frontSprite)
			hpBar.pokemon = pokemon
			hpBar.initialize()
			disableProperty.bind(Bindings.createBooleanBinding([ return pokemon.hp <= 0 ], pokemonProperty, pokemon.hpProperty))
		} else {
			disable = true
			disableProperty.unbind
		}
	}
	
	@FXML
	def void onClickSummary() {
		DialogUtil.createDialog(new PokemonViewDialog(pokemon)).showAndWait
	}
	
	@FXML
	def void onClickSwitch() {
		if (switchHandler !== null) {
			switchHandler.accept(pokemon)
		}
	}
}
