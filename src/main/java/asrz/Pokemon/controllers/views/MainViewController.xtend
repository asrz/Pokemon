package asrz.Pokemon.controllers.views

import asrz.Pokemon.controllers.controls.BagTab
import asrz.Pokemon.controllers.controls.RegionsTab
import asrz.Pokemon.controllers.controls.TeamTab
import asrz.Pokemon.model.enums.MenuMode
import javafx.fxml.FXML
import javafx.scene.control.TabPane

class MainViewController extends BasicController {
	
	@FXML
	TabPane mainTabPane
	
	@FXML
	TeamTab teamTab
	
	@FXML
	RegionsTab regionsTab
	
	@FXML
	BagTab bagTab
	
	override initialize() {
		if (teamTab !== null) {
			teamTab.menuMode = MenuMode.OVERWORLD
		}
		if (bagTab !== null) {
			bagTab.menuMode = MenuMode.OVERWORLD
		}
	}
	
}
