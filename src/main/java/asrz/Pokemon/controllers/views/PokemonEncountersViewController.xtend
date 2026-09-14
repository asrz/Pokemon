package asrz.Pokemon.controllers.views

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.model.GymId
import asrz.Pokemon.model.Gyms
import asrz.Pokemon.model.Locations
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.Trainer
import asrz.Pokemon.model.enums.BattleType
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.model.enums.Region
import asrz.Pokemon.pokeAPI.model.locations.LocationAreaDAO
import asrz.Pokemon.pokeAPI.model.locations.PokemonEncounterDAO
import asrz.Pokemon.pokeAPI.model.locations.RegionDAO
import asrz.Pokemon.util.ImageLoader
import asrz.Pokemon.util.ListMap
import asrz.Pokemon.util.PokemonUtil
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.util.List
import javafx.fxml.FXML
import javafx.geometry.Pos
import javafx.scene.Node
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.control.Tab
import javafx.scene.control.TabPane
import javafx.scene.image.ImageView
import javafx.scene.layout.FlowPane
import javafx.scene.layout.VBox

class PokemonEncountersViewController extends BasicController {
	
	@FXML
	TabPane tabPane
	
	@FXML
	Button backButton
	
	override initialize() {
		
	}
	
	def scoutEncounters(RegionDAO regionDao, String locationName) {
		val locationAreaDaos = database.getLocationAreas(Filters.eq("location.name", locationName))
		val generationEncounters = locationAreaDaos.flatMap[pokemonEncounters]
			.filter[versionDetails.findFirst[
				PokemonUtil.getGenerationFromVersionOrVersionGroup(version.name) <= player.maxGeneration
			] !== null]
		
		val pokemonNames = generationEncounters.map[pokemon.name]
		val pokemonDaos = database.getPokemon(Filters.in("name", pokemonNames))
		val pokemonDaosByName = pokemonDaos.toMap[name]
		
		val pokemonSpecies = database.getPokemonSpecies(Filters.in("name", pokemonDaos.map[species.name]))
		val pokemonSpeciesByName = pokemonSpecies.toMap[name]
		
		val regionalPokedex = player.getPokedexForRegion(Region.fromApiString(regionDao.name))
		
		val location = Locations.locationsByDaoName.get(locationName)
		
		if (location.gyms !== null) {
			val gymTab = new Tab("Gym")
			
			val vBox = new VBox()
			
			for (GymId gymId : location.gyms) {
				val gym = Gyms.gymMap.get(gymId)
				vBox.children.add(new Label(gym.name))
				vBox.children.add(new Button("Challenge") => [
					onAction = [
						player.currentGymId = gymId
						player.currentGymProgress = 0
						Application.setScene(SceneHandle.BATTLE_VIEW, [c.battleViewController], [controller |
							val trainer = gym.trainers.first
							trainer.team = trainer.teamFunction.apply(c)
							(controller as BattleViewController).battleTrainer(trainer, BattleType.SINGLE)
						])
					]
				])
				gymTab.content = vBox
			}
			
			tabPane.tabs.add(gymTab)
		}
		for (locationAreaDao : locationAreaDaos) {
			val vBox = new VBox()
			
			val nodesByEncounterMethod = new ListMap<String, Node>
			val encounters = locationAreaDao.pokemonEncounters.filter[versionDetails.findFirst[
				PokemonUtil.getGenerationFromVersionOrVersionGroup(version.name) <= player.maxGeneration
			] !== null]
			
			for (pokemonEncounterDao : encounters) {
				val pokemonDao = pokemonDaosByName.get(pokemonEncounterDao.pokemon.name)
				val pokemonSpeciesDao = pokemonSpeciesByName.get(pokemonDao.species.name)
				val regionalPokedexEntryNumber = pokemonSpeciesDao.pokedexNumbers.findFirst[pokedex.name == regionalPokedex.pokedexDaoName]
				val pokedexEntry = regionalPokedex.getEntryByNumber(regionalPokedexEntryNumber.entryNumber)
				
				val status = pokedexEntry?.status ?: PokedexEntryStatus.UNKNOWN
				
				val image = if (status == PokedexEntryStatus.UNKNOWN) {
					ImageLoader.loadSilhouetteImage(pokemonDao.sprites)
				} else {
					ImageLoader.loadImage(pokemonDao.sprites.frontDefault)
				}
				
				pokemonEncounterDao.versionDetails
					.filter[PokemonUtil.getGenerationFromVersionOrVersionGroup(version.name) <= player.maxGeneration]
					.flatMap[encounterDetails]
					.groupBy[method.name]
					.forEach[methodName, encounterDetails |
						val imageView = new ImageView(image)
						val minLevel = encounterDetails.minBy[minLevel].minLevel
						val maxLevel = encounterDetails.maxBy[maxLevel].maxLevel
						val levelLabel = minLevel == maxLevel ? String.format("Level %d", minLevel) : String.format("Level %d-%d", minLevel, maxLevel)
						val spriteBox = new VBox(imageView, new Label(levelLabel))
						spriteBox.alignment = Pos.TOP_CENTER
						nodesByEncounterMethod.add(methodName, spriteBox)
					]
			}
			
			for (encounterMethod : nodesByEncounterMethod.keySet()) {
				vBox.children.add(new Button(encounterMethod) => [
					onAction = [ onClickEncounterButton(locationAreaDao, encounterMethod)]
				])
				val flowPane = new FlowPane(nodesByEncounterMethod.get(encounterMethod))
				flowPane.hgap = 10
				vBox.children.add(flowPane)
			}
			
			val tab = new Tab(locationAreaDao.name, vBox)
			tabPane.tabs.add(tab)
		}
	}
	
	protected def void onClickEncounterButton(LocationAreaDAO locationAreaDao, String encounterMethod) {
		val location = Locations.locationsByDaoName.get(locationAreaDao.location.name)
		println(locationAreaDao.location.name)
		
		val allEncounters = locationAreaDao.pokemonEncounters
		allEncounters.forEach[ encounter |
			encounter.versionDetails = encounter.versionDetails.filter[encounterDetails.map[method.name].contains(encounterMethod) && PokemonUtil.getGenerationFromVersionOrVersionGroup(version.name) == 1].toList
		]
		
		
		if (!Util.isEmpty(location.trainerClasses) && Util.randomPercentage() <= 50) {
			val minLevel = allEncounters.flatMap[versionDetails].flatMap[encounterDetails].map[minLevel].min
			val maxLevel = allEncounters.flatMap[versionDetails].flatMap[encounterDetails].map[maxLevel].max
			val pokemonNames = allEncounters.filter[!Util.isEmpty(it.versionDetails)].map[pokemon.name]
			
			val maxBst = database.getPokemon(Filters.in("name", pokemonNames)).maxBy[it.baseStatTotal].baseStatTotal
			
			val trainerClass = Util.randomChoice(location.trainerClasses)
			val trainer = c.pokemonService.getTrainer(trainerClass, player.maxGeneration, minLevel, maxLevel, maxBst)
			
			Application.setScene(SceneHandle.BATTLE_VIEW, [
				return c.battleViewController
			], [ controller |
				(controller as BattleViewController).battleTrainer(trainer, BattleType.DOUBLE)
			])
		} else {
			val pokemon1 = getPokemonEncounter(allEncounters)
	//		val pokemon2 = getPokemonEncounter(allEncounters)
			val wildTrainer = new Trainer() => [
				team.pokemon_1 = pokemon1
	//			team.pokemon_2 = pokemon2
				wild = true
			]
			
			Application.setScene(SceneHandle.BATTLE_VIEW, [
				return new BattleViewController()
			], [ controller |
				(controller as BattleViewController).battleTrainer(wildTrainer, BattleType.SINGLE)
			])
		}
	}
	
	protected def Pokemon getPokemonEncounter(List<PokemonEncounterDAO> encounterTable) {
		val totalChance = encounterTable
			.flatMap[versionDetails]
			.flatMap[encounterDetails]
			.map[chance]
			.reduce[p1, p2| p1 + p2]
			
		var roll = Util.randomInt(1, totalChance)
		
		for (pokemonEncounter : encounterTable) {
			var pokemon = pokemonEncounter.pokemon
			for (versionDetail : pokemonEncounter.versionDetails) {
				for (encounter : versionDetail.encounterDetails) {
					roll -= encounter.chance
					if (roll <= 0) {
						return c.pokemonService.buildPokemon(pokemon.name, Util.randomInt(encounter.minLevel, encounter.maxLevel))
					}
				}
			}
		}
	}
	
	@FXML
	def onBackButton() {
		Application.setScene(SceneHandle.MAIN_VIEW, [c.mainViewController], [])
	}
}
