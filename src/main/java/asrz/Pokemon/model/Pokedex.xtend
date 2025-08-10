package asrz.Pokemon.model

import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.model.enums.Region
import asrz.Pokemon.pokeAPI.model.games.PokedexDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import asrz.Pokemon.util.PokemonUtil
import java.util.ArrayList
import java.util.List
import javafx.collections.FXCollections
import javafx.collections.ObservableMap
import org.bson.codecs.pojo.annotations.BsonIgnore
import xtendfx.beans.FXBindable

@FXBindable
class Pokedex {
	
	int pokedexDaoId
	String pokedexDaoName
	
	String name
	Region region
	Integer generation
	
	@BsonIgnore
	ObservableMap<Integer, PokedexEntry> entries = FXCollections.observableHashMap
	
	PokedexEntryList entriesAsList = new PokedexEntryList
	
	new() {}
	
	def static fromApi(PokedexDAO pokedexDao, String languageName) {
		return new Pokedex() => [
			pokedexDaoId = pokedexDao.id
			pokedexDaoName = pokedexDao.name
			name = pokedexDao.names.findFirst[language.name == languageName].name ?: pokedexDao.name
			region = Region.fromApiString(pokedexDao.region?.name)
			generation = pokedexDao.versionGroups.empty ? null : PokemonUtil.getGenerationFromVersionOrVersionGroup(pokedexDao.versionGroups.first.name)
		]
	}
	
	def getByNumber(int number) {
		return entries.get(number)
	}
	
	def addEntry(PokemonSpeciesDAO pokemonSpeciesDao, int number, PokedexEntryStatus status, String description) {
		val entry = new PokedexEntry(pokemonSpeciesDao, description, status, number)
		entries.put(number, entry)
		
		if (entriesAsList.empty) {
			entriesAsList.add(entry)
		} else {
			val min = entriesAsList.first.number
			val max = entriesAsList.last.number
			val List<PokedexEntry> entriesToAdd = new ArrayList
			
			if (number < min) {
				entriesToAdd.add(entry)
				for (i : number+1..<min) {
					entriesToAdd.add(new PokedexEntry(null, null, PokedexEntryStatus.UNKNOWN, i))
				}
				entriesAsList.addAll(0, entriesToAdd)
			} else if (number > max) {
				for (i : max+1..<number) {
					entriesToAdd.add(new PokedexEntry(null, null, PokedexEntryStatus.UNKNOWN, i))
				}
				entriesToAdd.add(entry)
				entriesAsList.addAll(entriesToAdd)
			} else {
				val index = number - min
				entriesAsList.set(index, entry)
			}
		}
	}
	
	def getEntryByNumber(Integer number) {
		return entries.get(number)
	}
	
}
