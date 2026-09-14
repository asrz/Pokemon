package asrz.Pokemon.controllers.views

import asrz.Pokemon.controllers.controls.BagTab
import asrz.Pokemon.model.enums.MenuMode
import javafx.fxml.FXML
import javafx.scene.control.Button
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class BagViewController extends BasicController {
	
	@FXML
	BagTab bagTab
	
	@FXML
	Button cancelButton
	
	override initialize() {
		bagTab.menuMode = MenuMode.BATTLE
		
		if (bagTab.menuMode == MenuMode.BATTLE) {
			cancelButton.visible = true
		} else {
			cancelButton.visible = false
		}
	}
	
	def void setCancelButtonCallback(Runnable callback) {
		cancelButton.onAction = [ callback.run() ]
	}
}
