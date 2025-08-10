package asrz.Pokemon.controllers.controls

import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.enums.MoveDamageClass
import asrz.Pokemon.model.enums.Type
import java.io.IOException
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.Button
import javafx.scene.control.Label
import xtendfx.beans.FXBindable

@FXBindable
class MoveButton extends Button implements IController {
	
	Move move
	
	@FXML
	Label damageClassLabel
	@FXML
	Label typeLabel
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/MoveButton.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
		moveProperty.addListener([updateTypeStyleClass])
		updateTypeStyleClass()
	}
	
	def updateTypeStyleClass() {
		styleClass.removeAll(Type.values.toList.map[label])
		if (move !== null) {
			styleClass.add(move.type.label)
			damageClassLabel.styleClass.removeAll(MoveDamageClass.values.toList.map[label])
			damageClassLabel.styleClass.add(move.damageClass.label)
			damageClassLabel.styleClass.add("bordered")
		} else {
			damageClassLabel.styleClass.remove("bordered")
		}
	}
}
