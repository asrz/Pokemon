package asrz.Pokemon.controllers.views

import asrz.Pokemon.controllers.controls.TeamTab
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.enums.BattleSlot
import asrz.Pokemon.model.enums.MenuMode
import java.util.function.BiConsumer
import javafx.fxml.FXML

class TeamViewController extends BasicController {
	
	@FXML
	TeamTab teamTab
	
	
	override initialize() {
		if (teamTab !== null) {
			teamTab.menuMode = MenuMode.BATTLE
		}
	}
	
	def setBattleSlot(BattleSlot slot) {
		teamTab.battleSlot = slot
	}
	
	def setSwitchCallback(BiConsumer<BattleSlot, Pokemon> callback) {
		teamTab.switchCallback = callback
	} 
}
