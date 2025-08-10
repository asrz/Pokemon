package asrz.Pokemon.controllers.views

import asrz.Pokemon.controllers.controls.BagTab
import asrz.Pokemon.model.enums.MenuMode
import javafx.fxml.FXML

class BagViewController extends BasicController {
	
	@FXML
	BagTab bagTab
	
	override initialize() {
		bagTab.menuMode = MenuMode.BATTLE
	}
	
}
