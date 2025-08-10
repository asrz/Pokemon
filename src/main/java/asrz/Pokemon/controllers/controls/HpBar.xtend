package asrz.Pokemon.controllers.controls

import asrz.Pokemon.animation.RectangleWidthTransition
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Pokemon
import java.io.IOException
import javafx.event.ActionEvent
import javafx.event.EventHandler
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.layout.StackPane
import javafx.scene.layout.VBox
import javafx.scene.shape.Rectangle
import javafx.util.Duration
import xtendfx.beans.FXBindable

@FXBindable
class HpBar extends VBox implements IController {

	Pokemon pokemon
	
	@FXML
	Rectangle innerBar
	
	@FXML
	StackPane stackPane
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/HpBar.fxml"))
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
			innerBar.width = pokemon.hpPercentage * 2
		}
		stackPane.visible = pokemon !== null
	}
	
	def applyDamage(int damage, EventHandler<ActionEvent> onFinished) {
		val fromWidth = pokemon.hpPercentage * 2
		pokemon.applyDamage(damage)
		val toWidth = pokemon.hpPercentage * 2
		val transition = new RectangleWidthTransition (Duration.millis(Math.abs(damage) * 200)) => [
			it.rectangle = innerBar
			it.fromWidth = fromWidth
			it.toWidth = toWidth
			it.onFinished = onFinished
		]
		transition.play()
	}
}
