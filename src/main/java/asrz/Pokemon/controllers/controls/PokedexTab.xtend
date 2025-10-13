package asrz.Pokemon.controllers.controls

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.controllers.views.PokedexEntryViewController
import asrz.Pokemon.model.Pokedex
import asrz.Pokemon.model.PokedexEntry
import asrz.Pokemon.model.PokemonSpecies
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.pokeAPI.model.games.PokedexDAO
import asrz.Pokemon.util.ImageLoader
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.io.IOException
import java.util.List
import java.util.Map
import javafx.collections.FXCollections
import javafx.collections.ListChangeListener
import javafx.collections.ObservableList
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.geometry.Pos
import javafx.scene.control.Button
import javafx.scene.control.ListView
import javafx.scene.control.Tab
import javafx.scene.control.TabPane
import javafx.scene.image.Image
import javafx.scene.image.ImageView
import javafx.scene.layout.HBox
import javafx.scene.text.TextAlignment
import asrz.Pokemon.util.Timer

class PokedexTab extends HBox implements IController {
	
	@FXML
	TabPane tabPane
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/PokedexTab.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
		val timer = new Timer()
		createTabs()
		timer.endStep("Pokedex tab")
	}
	
	def void createTabs() {
		val pokedexDaoCache = database.getPokedexes(Filters.in("id", player.pokedexes.map[pokedexDaoId])).toMap[id]
		
		val speciesNames = player.pokedexes.flatMap[pokedex |
			val pokedexDao = pokedexDaoCache.get(pokedex.pokedexDaoId)
			val entriesByNumber = pokedexDao.pokemonEntries.toMap[entryNumber]
			return pokedex.entriesAsList.map[entry |
				entriesByNumber.get(entry.number).pokemonSpecies.name
			]
		].toSet.toList
		val speciesCache = c.pokemonService.getPokemonSpeciesByName(speciesNames)
		
		player.pokedexes.forEach[ Pokedex pokedex |
			tabPane.tabs.add(new Tab(pokedex.name, getListView(pokedex, speciesCache, pokedexDaoCache)))
		]
		
		player.pokedexes.addListener(new ListChangeListener<Pokedex>() {
			override onChanged(Change<? extends Pokedex> change) {
				while (change.next()) {
					change.addedSubList.forEach[ Pokedex pokedex |
						tabPane.tabs.add(new Tab(pokedex.name, getListView(pokedex, speciesCache, pokedexDaoCache)))
					]
				}
			}
		})
	}
	
	def ListView<PokedexEntryButton> getListView(Pokedex pokedex, Map<String, PokemonSpecies> speciesCache, Map<Integer, PokedexDAO> pokedexDaoCache) {
		val ObservableList<PokedexEntryButton> list = FXCollections.observableArrayList(
			getButtonsFromPokedexEntries(pokedex, pokedex.entriesAsList, speciesCache, pokedexDaoCache)
		)
		
		pokedex.entriesAsList.addListener(new ListChangeListener<PokedexEntry>() {
			override onChanged(Change<? extends PokedexEntry> change) {
				while (change.next()) {
					println("CHANGE!")
					if (change.wasUpdated) {
						val updatedButtons = getButtonsFromPokedexEntries(pokedex, pokedex.entriesAsList.subList(change.from, change.to), speciesCache, pokedexDaoCache)
						for (var index = change.from; index < change.to; index++) {
							list.set(index, updatedButtons.get(index - change.from))
						}
					} else if (change.wasAdded) {
						val pokedexDao = pokedexDaoCache.get(pokedex.pokedexDaoId)
						val pokedexEntriesByNumber = pokedexDao.pokemonEntries.toMap[entryNumber]
						val addedNames = change.addedSubList.map[number].map[number | pokedexEntriesByNumber.get(number).pokemonSpecies.name]
						val addedSpeciesCache = c.pokemonService.getPokemonSpeciesByName(addedNames)
						list.addAll(change.from, getButtonsFromPokedexEntries(pokedex, change.getAddedSubList(), addedSpeciesCache, pokedexDaoCache))
					} else if (change.wasRemoved) {
						for (var i = change.to-1; i >= change.from; i--) {
							list.remove(i)
						}
					}
				}
			}
		})
		
		new ListView(list) => [
			editable = false
		]
	}
	
	def List<PokedexEntryButton> getButtonsFromPokedexEntries(Pokedex pokedex, List<? extends PokedexEntry> entries, Map<String, PokemonSpecies> speciesCache, Map<Integer, PokedexDAO> pokedexDaoCache) {
		if (entries.empty) {
			return Util.list()
		}
		
		val pokedexDao = pokedexDaoCache.get(pokedex.pokedexDaoId)
		
		val pokemonSpeciesNameByEntryNumber = pokedexDao.pokemonEntries.toMap([entryNumber], [pokemonSpecies.name])
		
		return entries.map[ entry |
			val speciesName = pokemonSpeciesNameByEntryNumber.get(entry.number)
			val species = speciesCache.get(speciesName)
			
			if (entry.status != PokedexEntryStatus.UNKNOWN) {
				val image = ImageLoader.loadImage(species.sprites.frontDefault)
				return new PokedexEntryButton(species, entry, image, entry.number, species.name)
			} else {
				val image = ImageLoader.loadSilhouetteImage(species.sprites)
				return new PokedexEntryButton(species, entry, image, entry.number, "???")
			}
		]
	}
}

class PokedexEntryButton extends Button implements IController {
	PokedexEntry entry
	
	new(PokemonSpecies species, PokedexEntry entry, Image sprite, int number, String name) {
		this.entry = entry
		if (sprite !== null) {
			graphic = new ImageView(sprite) => [
				styleClass.add("pokedexSprite")
			]
		}
		alignment = Pos.CENTER_LEFT
		textAlignment = TextAlignment.RIGHT
		prefWidth = 400
		disable = entry.status == PokedexEntryStatus.UNKNOWN
		text = String.format("%03d %s", number, name)
		styleClass.add("pokedexEntry")
		onAction = [
			Application.setScene(SceneHandle.POKEDEX_ENTRY_VIEW, [ new PokedexEntryViewController(species)], [])
		]
	}
}