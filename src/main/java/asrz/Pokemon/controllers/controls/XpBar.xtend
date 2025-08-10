package asrz.Pokemon.controllers.controls

import asrz.Pokemon.animation.RectangleWidthTransition
import asrz.Pokemon.controllers.dialogs.LevelUpDialog
import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.util.DialogUtil
import asrz.Pokemon.util.PokemonUtil
import java.io.IOException
import javafx.event.ActionEvent
import javafx.event.EventHandler
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.layout.StackPane
import javafx.scene.shape.Rectangle
import javafx.util.Duration
import xtendfx.beans.FXBindable

@FXBindable
class XpBar extends StackPane implements IController {

	BattleViewController battleViewController
	
	Pokemon pokemon
	
	@FXML
	Rectangle innerBar
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/XpBar.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
		if (pokemon !== null) {
			innerBar.width = pokemon.xpPercentage
		}
	}
	
	def void addXp(Pokemon pokemon, int xp, boolean showAnimations, EventHandler<ActionEvent> onFinished) {
		val animation = 
		if (xp >= pokemon.xpToNextLevel) {
			getAnimation(showAnimations, pokemon.xpPercentage, 100, [
				levelUp(pokemon).addListener[
					val newXp = pokemon.species.growthRate.getXpRequired(pokemon.level)
					val remainingXp = xp - (newXp - pokemon.xp)
					pokemon.xp = newXp
					addXp(pokemon, remainingXp, showAnimations, onFinished)
				]
			])
		} else {
			getAnimation(showAnimations, pokemon.xpPercentage, pokemon.calculateXpPercentage(pokemon.level, pokemon.xp + xp), [pokemon.xp = pokemon.xp + xp].andThen(onFinished))
		}
		animation.play
	}
	
	def levelUp(Pokemon pokemon) {
		val dialogPane = new LevelUpDialog()
		dialogPane.populateAndLevelUp(pokemon, [move | addText("%s learned the move %s", pokemon.label, move.label)])
		
		addText(PokemonUtil.getLevelUpText(pokemon))
		
		val dialog = DialogUtil.createDialog(dialogPane)
		dialog.show()
		return dialog.resultProperty
	}
	
	private def RectangleWidthTransition getAnimation(boolean showAnimations, double initialPercentage, double finalPercentage, EventHandler<ActionEvent> onFinished) {
		val millis = showAnimations ? (finalPercentage - initialPercentage) * 20 : 0
		new RectangleWidthTransition(Duration.millis(millis)) => [
			rectangle = innerBar
			fromWidth = initialPercentage * 2
			toWidth = finalPercentage * 2
			it.onFinished = onFinished
		]
	}
	
	def addText(String text, Object...args) {
		battleViewController.addText(text, args)
	}
}
