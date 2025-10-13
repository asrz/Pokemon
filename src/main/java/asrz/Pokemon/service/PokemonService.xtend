package asrz.Pokemon.service

import asrz.Pokemon.application.Context
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.PokemonSpecies
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.util.PokemonUtil
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.util.HashMap
import java.util.List
import java.util.Map

class PokemonService extends BaseService {
	
	new(Context context) {
		super(context)
	}
	
	def Map<String, PokemonSpecies> getPokemonSpeciesByName(List<String> speciesNames) {
		val pokemonSpecies = database.getPokemonSpecies(Filters.in("name", speciesNames))
		val pokemonSpeciesDaosByName = pokemonSpecies.toMap[name]
		
		val pokemonNames = pokemonSpecies.flatMap[varieties].filter[isDefault].map[pokemon.name]
		val pokemonDaosByName = database.getPokemon(Filters.in("name", pokemonNames)).toMap[name]
		
		val pokemonFormNames = pokemonDaosByName.values.map[forms.head.name]
		val pokemonFormDaosByName = database.getPokemonForms(Filters.in("name", pokemonFormNames)).toMap[name]
		
		val moveNames = pokemonDaosByName.values.flatMap[moves].map[move.name]
		val moveDaosByName = database.getMoves(Filters.in("name", moveNames)).toMap[name]
		
		val abilityNames = pokemonDaosByName.values.flatMap[abilities].map[ability.name]
		val abilityDaosByName = database.getAbilities(Filters.in("name", abilityNames)).toMap[name]
		
		val result = new HashMap<String, PokemonSpecies>
		
		speciesNames.forEach[ speciesName |
			val speciesDao = pokemonSpeciesDaosByName.get(speciesName)
			if (speciesDao === null) {
				println(speciesName)
			}
			val pokemonDao = pokemonDaosByName.get(speciesDao.varieties.findFirst[isDefault].pokemon.name)
			val formDao = pokemonFormDaosByName.get(pokemonDao.forms.head.name)
			val moveDaos = pokemonDao.moves.map[moveDaosByName.get(move.name)]
			val abilityDaos = pokemonDao.abilities.filter[!hidden].map[abilityDaosByName.get(ability.name)].toList
			val hiddenAbilityDao = abilityDaosByName.get(pokemonDao.abilities.findFirst[hidden]?.ability?.name)
			
			result.put(speciesDao.name, new PokemonSpecies(
				speciesDao,
				formDao,
				pokemonDao, 
				moveDaos, 
				abilityDaos,
				hiddenAbilityDao,
				player.languageName
			))
		]
		
		return result
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
		val allSpeciesDaos = database.getPokemonSpecies(Filters.in("id", pokemons.map[species.pokemonSpeciesDaoId]))
		
		for (pokedex : player.pokedexes) {
			pokedex.updateEntries(allSpeciesDaos, status, player.languageName)
		}
	}
	
}