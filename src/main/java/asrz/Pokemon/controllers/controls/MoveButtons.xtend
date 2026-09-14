package asrz.Pokemon.controllers.controls

import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Pokemon
import java.io.IOException
import java.util.function.Consumer
import javafx.beans.binding.Bindings
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.layout.GridPane
import xtendfx.beans.FXBindable
import xtendfx.beans.Immutable

@FXBindable
class MoveButtons extends GridPane implements IController {
	
	@Immutable
	BattleViewController battleViewController
	
	@FXML
	MoveButton moveButton_1
	@FXML
	MoveButton moveButton_2
	@FXML
	MoveButton moveButton_3
	@FXML
	MoveButton moveButton_4
	
	Pokemon activePokemon
	
	Consumer<MoveButton> moveButtonHandler
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/MoveButtons.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
		if (activePokemon !== null && moveButtonHandler !== null) {
			moveButton_1.moveProperty.bind(getActivePokemon.move_1Property)
			moveButton_1.onAction = [moveButtonHandler.accept(moveButton_1)]
			moveButton_1.initialize
			
			moveButton_2.moveProperty.bind(getActivePokemon.move_2Property)
			moveButton_2.onAction = [moveButtonHandler.accept(moveButton_2)]
			moveButton_2.initialize
			
			moveButton_3.moveProperty.bind(getActivePokemon.move_3Property)
			moveButton_3.onAction = [moveButtonHandler.accept(moveButton_3)]
			moveButton_3.initialize
			
			moveButton_4.moveProperty.bind(getActivePokemon.move_4Property)
			moveButton_4.onAction = [moveButtonHandler.accept(moveButton_4)]
			moveButton_4.initialize
			
			moveButton_1.disableProperty.bind(Bindings.createBooleanBinding([return moveButton_1.move === null], moveButton_1.moveProperty))
			moveButton_2.disableProperty.bind(Bindings.createBooleanBinding([return moveButton_2.move === null], moveButton_2.moveProperty))
			moveButton_3.disableProperty.bind(Bindings.createBooleanBinding([return moveButton_3.move === null], moveButton_3.moveProperty))
			moveButton_4.disableProperty.bind(Bindings.createBooleanBinding([return moveButton_4.move === null], moveButton_4.moveProperty))
		}
	}
	
}
