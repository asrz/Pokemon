package asrz.Pokemon.controllers.views

import asrz.Pokemon.controllers.controls.TeamTab
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.enums.BattleSlot
import asrz.Pokemon.model.enums.MenuMode
import java.util.function.Consumer
import javafx.fxml.FXML
import javafx.scene.control.Button

class TeamViewController extends BasicController {
	
	@FXML
	TeamTab teamTab
	
	@FXML
	Button cancelButton
	
	
	override initialize() {
		if (teamTab !== null) {
			teamTab.menuMode = MenuMode.BATTLE
		}
	}
	
	def setBattleSlot(BattleSlot slot) {
		teamTab.battleSlot = slot
	}
	
	def setSwitchCallback(Consumer<Pokemon> callback) {
		teamTab.switchCallback = callback
	}
	
	def void setCancelButtonCallback(Runnable callback) {
		cancelButton.onAction = [ callback.run() ]
	}
}
