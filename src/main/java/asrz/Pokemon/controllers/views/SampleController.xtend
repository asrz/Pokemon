package asrz.Pokemon.controllers.views

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.util.DialogUtil
import com.mongodb.client.model.Filters
import javafx.fxml.FXML
import javafx.scene.control.Button
import javafx.scene.control.ButtonBar.ButtonData
import javafx.scene.control.Label
import javafx.scene.control.TextField
import javafx.scene.layout.HBox
import javafx.scene.layout.VBox

import static com.mongodb.client.model.Filters.eq

class SampleController extends BasicController {
	
	@FXML
	VBox root
	
	@FXML
	TextField nameField
	
	@FXML
	Label loadGameLabel
	
	override initialize() {
		val players = database.getPlayers(Filters.empty)
		if (players.empty) {
			loadGameLabel.visible = false
		}
		
		for (player : players) {
			root.children.add(new HBox(
				new Button(player.name) => [
					onAction = [
						startGame(player.name)
					]
				],
				new Button("Delete") => [ button |
					button.onAction = [
						DialogUtil.createYesNoDialog("Are you sure? This cannot be undone").showAndWait.ifPresent[
							if (it.buttonData == ButtonData.YES) {
								c.playerService.deleteGame(player)
								button.visible = false
							}
						]
					]
				]
			))
		}
	}
	
	@FXML
	def buttonClicked() {
		startGame(nameField.text)
	}
	
	def startGame(String playerName) {
		val databasePlayer = database.getPlayer(Filters.eq("name", playerName))
		if (databasePlayer !== null) {
			c.playerService.loadGame(databasePlayer)
			Application.setScene(SceneHandle.MAIN_VIEW, [new MainViewController()], [])
		} else {
			player.name = nameField.text
			
			val bulbasaur = database.getPokemon(eq("id", 1)).first
			val charmander = database.getPokemon(eq("id", 4)).first
			val squirtle = database.getPokemon(eq("id", 7)).first
			
			Application.setScene(SceneHandle.STARTER_CHOICE, [new StarterChoiceController(bulbasaur, charmander, squirtle)], [])
		}
	}
}
