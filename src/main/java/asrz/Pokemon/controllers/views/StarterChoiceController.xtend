package asrz.Pokemon.controllers.views

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.Trainer
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.util.DialogUtil
import asrz.Pokemon.util.ImageLoader
import javafx.fxml.FXML
import javafx.scene.control.Button
import javafx.scene.image.ImageView

class StarterChoiceController extends BasicController {
	
	@FXML
	Button spriteButton1
	
	@FXML
	Button spriteButton2
	
	@FXML
	Button spriteButton3
	
	Pokemon pokemon1
	Pokemon pokemon2
	Pokemon pokemon3
	
	new(PokemonDAO pokemon1, PokemonDAO pokemon2, PokemonDAO pokemon3) {
		this.pokemon1 = Pokemon.fromSpeciesWithNoIVsAndRandomNeutralNature(c.pokemonService.getPokemonSpecies(pokemon1))
		this.pokemon2 = Pokemon.fromSpeciesWithNoIVsAndRandomNeutralNature(c.pokemonService.getPokemonSpecies(pokemon2))
		this.pokemon3 = Pokemon.fromSpeciesWithNoIVsAndRandomNeutralNature(c.pokemonService.getPokemonSpecies(pokemon3))
	}
	
	override initialize() {
		spriteButton1.graphic = new ImageView(ImageLoader.loadImage(pokemon1.frontSprite))
		spriteButton1.text = pokemon1.label
		spriteButton1.onAction = [choosePokemon(pokemon1)]
		
		spriteButton2.graphic = new ImageView(ImageLoader.loadImage(pokemon2.frontSprite))
		spriteButton2.text = pokemon2.label
		spriteButton2.onAction = [choosePokemon(pokemon2)]
		
		spriteButton3.graphic = new ImageView(ImageLoader.loadImage(pokemon3.frontSprite))
		spriteButton3.text = pokemon3.label
		spriteButton3.onAction = [choosePokemon(pokemon3)]
	}
	
	
	def choosePokemon(Pokemon starter) {
		val rival = new Trainer("Rival", "Gary")
		
		val rivalStarter = 
		if (starter == pokemon1) {
			pokemon2
		} else if (starter == pokemon2) {
			pokemon3
		} else {
			pokemon1
		}
		
		for (i : 2..5) {
			starter.levelUp(null, null)
			rivalStarter.levelUp(rival, null)
		}
		
		rival.addPokemon(rivalStarter)
		player.addPokemon(starter)
		c.pokemonService.updatePokedexes(starter, PokedexEntryStatus.CAUGHT)
		
		DialogUtil.showNicknameDialog(starter)
		
//		loadTeamView()
//		loadPokemonView()
		loadBattleView(rival)
//		loadMainView()
	}
	
//	def loadTeamView() {
//		Application.setScene(SceneHandle.POKEMON_TEAM_VIEW, [new PokemonTeamViewController])
//	}
	
//	def loadPokemonView() {
//		Application.setScene(SceneHandle.POKEMON_VIEW, [new PokemonViewController(player.team.pokemon_1)])
//	}
	
	def loadMainView() {
		Application.setScene(SceneHandle.MAIN_VIEW, [
			new MainViewController()
		], [])
	}
	
	def loadBattleView(Trainer trainer) {
		Application.setScene(SceneHandle.BATTLE_VIEW, [], [ controller |
			(controller as BattleViewController).battleTrainer(trainer)
		])
	}
}
