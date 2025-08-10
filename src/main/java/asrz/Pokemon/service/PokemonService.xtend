package asrz.Pokemon.service

import asrz.Pokemon.application.Context
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.PokemonSpecies
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.util.PokemonUtil
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.util.List

class PokemonService extends BaseService {
	
	new(Context context) {
		super(context)
	}
	
	def PokemonSpecies getPokemonSpecies(PokemonDAO pokemonDAO) {
		val pokemonSpeciesDAO = database.getPokemonSpecies(Filters.eq("name", pokemonDAO.species.name)).first
		val pokemonFormDAO = database.getPokemonForms(Filters.eq("name", pokemonDAO.forms.head.name)).first
		
		val moveNames = pokemonDAO.moves.map[move.name]
		val moveDAOs = database.getMoves(Filters.in("name", moveNames))
		
		val abilityDAOs = database.getAbilities(Filters.in("name", pokemonDAO.abilities.map[ability.name]))
		val hiddenAbilityDAO = abilityDAOs.findFirst[name == pokemonDAO.abilities.findFirst[hidden]?.ability?.name]
		abilityDAOs.remove(hiddenAbilityDAO)
		
		return new PokemonSpecies(
			pokemonSpeciesDAO, 
			pokemonFormDAO, 
			pokemonDAO, 
			moveDAOs,
			abilityDAOs,
			hiddenAbilityDAO,
			player.languageName
		)
	}
	
	def buildPokemon(String pokemonName, int level) {
		val pokemonDao = database.getPokemon(Filters.eq("name", pokemonName)).first
		val pokemonSpecies = getPokemonSpecies(pokemonDao)
		
		val pokemon = Pokemon.fromSpeciesWithNoIVsAndRandomNeutralNature(pokemonSpecies)
		if (level > 1) {
			for (i : 2..level) {
				pokemon.levelUp(null, null)
			}
		}
		
		return pokemon
	}
	
	def void updatePokedexes(Pokemon pokemon, PokedexEntryStatus status) {
		updatePokedexes(Util.list(pokemon), status)
	}
	
	def void updatePokedexes(List<Pokemon> pokemons, PokedexEntryStatus status) {
		val allSpecies = database.getPokemonSpecies(Filters.in("id", pokemons.map[species.pokemonSpeciesDaoId]))
		
		for (pokedex : player.pokedexes) {
			for (species : allSpecies) {
				val Integer number = species.pokedexNumbers.findFirst[it.pokedex.name == pokedex.pokedexDaoName]?.entryNumber
				if (number !== null && pokedex.getByNumber(number) === null) {
					if (pokedex.generation !== null) {
						println(pokedex.name + " " + species.name)
						println(species.flavorTextEntries.filter[language.name == player.languageName].map[version.name].sortBy[PokemonUtil.getGenerationFromVersionOrVersionGroup(it)].join('\n'))
						val description = species.flavorTextEntries.findLast[PokemonUtil.getGenerationFromVersionOrVersionGroup(version.name) == pokedex.generation && language.name == player.languageName]?.flavorText
						pokedex.addEntry(species, number, status, description)
					} else {
						val description = species.flavorTextEntries.findLast[language.name == player.languageName].flavorText
						pokedex.addEntry(species, number, status, description)
					}
				}
			}
		}
	}
	
}