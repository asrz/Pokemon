package asrz.Pokemon.controllers.controls

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Trainer
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.model.enums.Region
import asrz.Pokemon.pokeAPI.model.locations.PokemonEncounterDAO
import asrz.Pokemon.pokeAPI.model.locations.RegionDAO
import asrz.Pokemon.util.DialogUtil
import asrz.Pokemon.util.ImageLoader
import asrz.Pokemon.util.ListMap
import asrz.Pokemon.util.PokemonUtil
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.io.IOException
import java.util.List
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.geometry.Pos
import javafx.scene.Node
import javafx.scene.control.Button
import javafx.scene.control.ButtonType
import javafx.scene.control.DialogPane
import javafx.scene.control.Label
import javafx.scene.control.Tab
import javafx.scene.control.TabPane
import javafx.scene.image.ImageView
import javafx.scene.layout.FlowPane
import javafx.scene.layout.VBox
import xtendfx.beans.FXBindable

@FXBindable
class RegionsTab extends VBox implements IController  {
	
	@FXML
	TabPane tabPane
	
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
		val regions = database.getRegions(Filters.empty)
		val locations = database.getLocations(Filters.ne("region", null))
		val locationsByRegionName = locations.groupBy[region.name]
		
		for (RegionDAO region : regions) {
			val generation = Region.fromApiString(region.name).generation
			if (generation !== null && generation <=player.maxGeneration) {
				tabPane.tabs += new Tab(region.label) => [
					closable = false
					content = new FlowPane(locationsByRegionName.get(region.name).map[ locationDao |
						new VBox(
							new Label(locationDao.getLabel(player.languageName)),
							new Button("Scout") => [
								onAction = [onClickScoutButton(region, locationDao.name)]
							],
							new Button("Encounter") => [
								onAction = [onClickEncounterButton(locationDao.name)]
							]
						)
					])
				]
			}
		}
	}
	
	def onClickEncounterButton(String locationName) {
		val locationAreaDaos = database.getLocationAreas(Filters.eq("location.name", locationName))
		
		val allEncounters = locationAreaDaos.flatMap[pokemonEncounters].toList
		allEncounters.forEach[ encounter |
			encounter.versionDetails = encounter.versionDetails.filter[PokemonUtil.getGenerationFromVersionOrVersionGroup(version.name) == 1].toList
		]
		
		val pokemon = getPokemonEncounter(allEncounters)
		val wildTrainer = new Trainer() => [
			team.pokemon_1 = pokemon
			wild = true
		]
		
		Application.setScene(SceneHandle.BATTLE_VIEW, [
			return new BattleViewController()
		], [ controller |
			(controller as BattleViewController).battleTrainer(wildTrainer)
		])
	}
	
	def getPokemonEncounter(List<PokemonEncounterDAO> encounterTable) {
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
	
	def onClickScoutButton(RegionDAO regionDao, String locationName) {
		val dialogPane = new DialogPane()
		dialogPane.buttonTypes.add(ButtonType.CLOSE)
		val tabPane = new TabPane()
		dialogPane.content = tabPane
		
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
		
		for (locationAreaDao : locationAreaDaos) {
			val vBox = new VBox()
			val nodesByEncounterMethod = new ListMap<String, Node>
			val encounters = locationAreaDao.pokemonEncounters.filter[versionDetails.findFirst[
				PokemonUtil.getGenerationFromVersionOrVersionGroup(version.name) <= player.maxGeneration
			] !== null]
			
			for (pokemonEncounterDao : encounters) {
				val pokemonDao = pokemonDaosByName.get(pokemonEncounterDao.pokemon.name)
				println(pokemonDao.name)
				val pokemonSpeciesDao = pokemonSpeciesByName.get(pokemonDao.species.name)
				println(pokemonSpeciesDao.name)
				val regionalPokedexEntryNumber = pokemonSpeciesDao.pokedexNumbers.findFirst[pokedex.name == regionalPokedex.pokedexDaoName]
				println(regionalPokedexEntryNumber)
				val pokedexEntry = regionalPokedex.getEntryByNumber(regionalPokedexEntryNumber.entryNumber)
				println(pokedexEntry)
				
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
				vBox.children.add(new Label(encounterMethod))
				val flowPane = new FlowPane(nodesByEncounterMethod.get(encounterMethod))
				flowPane.hgap = 10
				vBox.children.add(flowPane)
			}
			
			val tab = new Tab(locationAreaDao.name, vBox)
			tabPane.tabs.add(tab)
		}
		
		DialogUtil.createDialog(dialogPane).show()
	}
	
}
