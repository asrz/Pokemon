package asrz.Pokemon.controllers.controls

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.controllers.views.PokedexEntryViewController
import asrz.Pokemon.model.Pokedex
import asrz.Pokemon.model.PokedexEntry
import asrz.Pokemon.model.PokemonSpecies
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.util.ImageLoader
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.io.IOException
import java.util.List
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
		updateTabs()
	}
	
	def void updateTabs() {
		player.pokedexes.forEach[ Pokedex pokedex |
			tabPane.tabs.add(new Tab(pokedex.name, getListView(pokedex)))
		]
		
		player.pokedexes.addListener(new ListChangeListener<Pokedex>() {
			override onChanged(Change<? extends Pokedex> change) {
				while (change.next()) {
					change.addedSubList.forEach[ Pokedex pokedex |
						tabPane.tabs.add(new Tab(pokedex.name, getListView(pokedex)))
					]
				}
			}
		})
	}
	
	def ListView<Pokedex> getListView(Pokedex pokedex) {
		val ObservableList<PokedexEntryButton> list = FXCollections.observableArrayList(
			getButtonsFromPokedexEntries(pokedex, pokedex.entriesAsList)
		)
		
		pokedex.entriesAsList.addListener(new ListChangeListener<PokedexEntry>() {
			override onChanged(Change<? extends PokedexEntry> change) {
				while (change.next()) {
					if (change.wasAdded) {
						list.addAll(change.from, getButtonsFromPokedexEntries(pokedex, change.getAddedSubList()))
					} else if (change.wasRemoved) {
						for (var i = change.to-1; i >= change.from; i--) {
							list.remove(i)
						}
					}
				}
			}
		})
		
		new ListView(list)
	}
	
	def List<PokedexEntryButton> getButtonsFromPokedexEntries(Pokedex pokedex, List<? extends PokedexEntry> entries) {
		if (entries.empty) {
			return Util.list()
		}
		
		val pokedexDao = database.getPokedexes(Filters.eq("id", pokedex.pokedexDaoId)).first
		
		val pokemonSpeciesNameByEntryNumber = pokedexDao.pokemonEntries.toMap([entryNumber], [pokemonSpecies.name])
		
		val min = entries.minBy[number].number
		val max = entries.maxBy[number].number
		
		val range = min..max
		val pokemonSpeciesNames = range.map[pokemonSpeciesNameByEntryNumber.get(it)]
		
		val pokemonSpecies = database.getPokemonSpecies(Filters.in("name", pokemonSpeciesNames))
		val pokemonSpeciesByName = pokemonSpecies.toMap[name]
		
		val pokemonNames = pokemonSpecies.flatMap[varieties].filter[isDefault].map[pokemon.name]
		val pokemonByName = database.getPokemon(Filters.in("name", pokemonNames)).toMap[name]
		
		
		return entries.map[ entry |
			val speciesDao = pokemonSpeciesByName.get(pokemonSpeciesNameByEntryNumber.get(entry.number))
			
			val pokemon = pokemonByName.get(speciesDao.varieties.findFirst[isDefault].pokemon.name)
			val species = c.pokemonService.getPokemonSpecies(pokemon)
			
			if (entry.status != PokedexEntryStatus.UNKNOWN) {
				val image = ImageLoader.loadImage(pokemon.sprites.frontDefault)
				val speciesName = speciesDao.names.findFirst[language.name == player.languageName].name
				return new PokedexEntryButton(species, entry, image, entry.number, speciesName)
			} else {
				val image = ImageLoader.loadSilhouetteImage(pokemon.sprites)
				return new PokedexEntryButton(species, entry, image, entry.number, "???") => [
					disabled = true
				]
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
		disabled = entry.status == PokedexEntryStatus.UNKNOWN
		text = String.format("%03d %s", number, name)
		styleClass.add("pokedexEntry")
		onAction = [
			Application.setScene(SceneHandle.POKEDEX_ENTRY_VIEW, [ new PokedexEntryViewController(species)], [])
		]
	}
}