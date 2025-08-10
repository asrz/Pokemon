package asrz.Pokemon.controllers.dialogs

import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Pokemon
import java.io.IOException
import java.util.function.Consumer
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.DialogPane
import javafx.scene.control.Label

class LevelUpDialog extends DialogPane implements IController {
	
	@FXML
	Label pokemonLabel
	@FXML
	Label oldLevelLabel
	@FXML
	Label newLevelLabel
	
	@FXML
	Label oldHp
	@FXML
	Label hpChange
	@FXML
	Label newHp
	
	@FXML
	Label oldAttack
	@FXML
	Label attackChange
	@FXML
	Label newAttack
	
	@FXML
	Label oldDefense
	@FXML
	Label defenseChange
	@FXML
	Label newDefense
	
	@FXML
	Label oldSpecialAttack
	@FXML
	Label specialAttackChange
	@FXML
	Label newSpecialAttack
	
	@FXML
	Label oldSpecialDefense
	@FXML
	Label specialDefenseChange
	@FXML
	Label newSpecialDefense
	
	@FXML
	Label oldSpeed
	@FXML
	Label speedChange
	@FXML
	Label newSpeed
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/dialogs/LevelUpDialog.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	def populateAndLevelUp(Pokemon pokemon, Consumer<Move> moveCallback) {
		pokemonLabel.text = pokemon.label
		oldLevelLabel.text = pokemon.levelLabel
		
		oldHp.text = String.valueOf(pokemon.hp)
		oldAttack.text = String.valueOf(pokemon.attack)
		oldDefense.text = String.valueOf(pokemon.defense)
		oldSpecialAttack.text = String.valueOf(pokemon.specialAttack)
		oldSpecialDefense.text = String.valueOf(pokemon.specialDefense)
		oldSpeed.text = String.valueOf(pokemon.speed)
		
		pokemon.levelUp(player, moveCallback)
		
		newLevelLabel.text = pokemon.levelLabel
		
		newHp.text = String.valueOf(pokemon.hp)
		newAttack.text = String.valueOf(pokemon.attack)
		newDefense.text = String.valueOf(pokemon.defense)
		newSpecialAttack.text = String.valueOf(pokemon.specialAttack)
		newSpecialDefense.text = String.valueOf(pokemon.specialDefense)
		newSpeed.text = String.valueOf(pokemon.speed)
		
		hpChange.text = String.format("%+d", Integer.valueOf(newHp.text) - Integer.valueOf(oldHp.text))
		attackChange.text = String.format("%+d", Integer.valueOf(newAttack.text) - Integer.valueOf(oldAttack.text))
		defenseChange.text = String.format("%+d", Integer.valueOf(newDefense.text) - Integer.valueOf(oldDefense.text))
		specialAttackChange.text = String.format("%+d", Integer.valueOf(newSpecialAttack.text) - Integer.valueOf(oldSpecialAttack.text))
		specialDefenseChange.text = String.format("%+d", Integer.valueOf(newSpecialDefense.text) - Integer.valueOf(oldSpecialDefense.text))
		speedChange.text = String.format("%+d", Integer.valueOf(newSpeed.text) - Integer.valueOf(oldSpeed.text))
	}
	
}
