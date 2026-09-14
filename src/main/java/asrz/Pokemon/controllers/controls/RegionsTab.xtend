package asrz.Pokemon.controllers.controls

import asrz.Pokemon.controllers.views.IController
import java.io.IOException
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.control.TabPane
import javafx.scene.layout.VBox
import xtendfx.beans.FXBindable
import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.model.enums.BattleType

@FXBindable
class RegionsTab extends VBox implements IController  {
	
	@FXML
	TabPane tabPane
	
	@FXML
	KantoTab kantoTab
	
	@FXML
	VBox gymPane
	
	@FXML
	Label gymLabel
	
	@FXML
	Button continueGymButton
	
	@FXML
	Button retreatGymButton
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/RegionsTab.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
	}
	
	def updateGymView() {
		if (player.currentGym !== null) {
			tabPane.visible = false
			gymPane.visible = true
			
			gymLabel.text = String.format("You have beaten %d out of %d trainers in the %s", player.currentGymProgress, player.currentGym.trainers.size(), player.currentGym.name)
		} else {
			tabPane.visible = true
			gymPane.visible = false
		}
	}
	
	@FXML
	def continueGym() {
		Application.setScene(SceneHandle.BATTLE_VIEW, [c.battleViewController], [controller |
			(controller as BattleViewController).battleTrainer(player.currentGym.trainers.get(player.currentGymProgress), BattleType.SINGLE)
		])
	}
	
	@FXML
	def retreatGym() {
		player.currentGymId = null
		player.currentGymProgress = null
		updateGymView()
	}
}
