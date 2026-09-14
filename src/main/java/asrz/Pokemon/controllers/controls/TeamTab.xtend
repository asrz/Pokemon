package asrz.Pokemon.controllers.controls

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Player
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.enums.BattleSlot
import asrz.Pokemon.model.enums.MenuMode
import asrz.Pokemon.util.Util
import java.io.IOException
import java.util.function.Consumer
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.layout.GridPane
import xtendfx.beans.FXBindable

@FXBindable
class TeamTab extends GridPane implements IController {
	
	@FXML
	TeamButton pokemonButton_1
	@FXML
	TeamButton pokemonButton_2
	@FXML
	TeamButton pokemonButton_3
	@FXML
	TeamButton pokemonButton_4
	@FXML
	TeamButton pokemonButton_5
	@FXML
	TeamButton pokemonButton_6

	Player player
	
	MenuMode menuMode
	
	BattleSlot battleSlot
	
	Consumer<Pokemon> switchCallback
	
	new() {
		this.player = IController.super.getPlayer()
		
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/PokemonTeamView.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
		for (teamButton : Util.list(pokemonButton_1, pokemonButton_2, pokemonButton_3, pokemonButton_4, pokemonButton_5, pokemonButton_6)) {
			teamButton.switchHandler = [handleSwitchButton(teamButton)]
			teamButton.initialize()
		}
	}
	
	
	def void handleSwitchButton(TeamButton teamButton) {
		if (menuMode == MenuMode.BATTLE) {
			Application.setScene(SceneHandle.BATTLE_VIEW, [], [ switchCallback.accept(teamButton.pokemon) ])
		}
	}
}
