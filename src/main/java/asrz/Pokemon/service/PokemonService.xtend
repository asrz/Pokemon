package asrz.Pokemon.service

import asrz.Pokemon.application.Context
import asrz.Pokemon.model.Ability
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.PokemonSpecies
import asrz.Pokemon.model.Trainer
import asrz.Pokemon.model.TrainerClass
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

		speciesNames.forEach [ speciesName |
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

	def List<PokemonSpecies> getPokemonSpecies(List<PokemonDAO> pokemonDAOs) {
		val pokemonSpeciesDAOs = database.getPokemonSpecies(Filters.in("name", pokemonDAOs.map[species.name]))
		val pokemonSpeciesDAOsByName = pokemonSpeciesDAOs.toMap[name]

		val pokemonFormDAOs = database.getPokemonForms(Filters.in("name", pokemonDAOs.map[forms.head.name]))
		val pokemonFormDAOsByName = pokemonFormDAOs.toMap[name]

		val moveNames = pokemonDAOs.flatMap[moves].map[move.name]
		val moveDAOs = database.getMoves(Filters.in("name", moveNames))
		val moveDAOsByName = moveDAOs.toMap[name]

		val abilityDAOs = database.getAbilities(Filters.in("name", pokemonDAOs.flatMap[abilities].map[ability.name]))
		val abilityDAOsByName = abilityDAOs.toMap[name]

		return pokemonDAOs.map [ pokemonDAO |
			val pokemonSpeciesDAO = pokemonSpeciesDAOsByName.get(pokemonDAO.species.name)
			val pokemonFormDAO = pokemonFormDAOsByName.get(pokemonDAO.forms.head.name)
			val pokemonMoveDAOs = pokemonDAO.moves.map[moveDAOsByName.get(move.name)]
			val pokemonAbilityDAOs = pokemonDAO.abilities.filter[!hidden].map[abilityDAOsByName.get(ability.name)].
				toList
			val hiddenAbilityDAO = abilityDAOsByName.get(pokemonDAO.abilities.filter[hidden].map[ability.name].head)

			return new PokemonSpecies(
				pokemonSpeciesDAO,
				pokemonFormDAO,
				pokemonDAO,
				pokemonMoveDAOs,
				pokemonAbilityDAOs,
				hiddenAbilityDAO,
				player.languageName
			)
		]
	}

	def buildPokemon(String pokemonDaoName, int level) {
		return buildPokemon(pokemonDaoName, level, null, null)
	}

	def buildPokemon(String pokemonDaoName, int level, String abilityDaoName, List<String> moveDaoNames) {
		if (moveDaoNames !== null && moveDaoNames.size() > 4) {
			throw new RuntimeException("Pokémon can only have four moves")
		}
		
		val pokemonDao = database.getPokemon(Filters.eq("name", pokemonDaoName)).first
		if (pokemonDao === null) {
			throw new RuntimeException("Pokémon not found: " + pokemonDaoName)
		}
		
		val pokemonSpecies = getPokemonSpecies(pokemonDao)

		val pokemon = Pokemon.fromSpeciesWithNoIVsAndRandomNeutralNature(pokemonSpecies)
		if (level > 1) {
			for (i : 2 .. level) {
				pokemon.levelUp(null, null)
			}
		}
		
		if (abilityDaoName !== null && pokemon.ability.abilityDaoName !== abilityDaoName) {
			val abilityDao = database.getAbilities(Filters.eq("name", abilityDaoName)).first
			if (abilityDao === null) {
				throw new RuntimeException("Error finding ability: " + abilityDaoName)
			}
			pokemon.ability = Ability.fromApi(abilityDao, player.languageName)
		}
		
		if (!Util.isEmpty(moveDaoNames)) {
			val moves = database.getMoves(Filters.in("name", moveDaoNames)).map[moveDao | Move.fromApi(moveDao, player.languageName)]
			if (moves.size() !== moveDaoNames.size()) {
				throw new RuntimeException("Error finding all moves: " + moveDaoNames.join(", "))
			}
			pokemon.setMoves(moves)
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

	def Trainer getTrainer(TrainerClass trainerClass, int maxGeneration, int minLevel, int maxLevel, int maxBst) {
		val result = new Trainer(trainerClass, "")

		val pokemonSpeciesDAOs = database.getPokemonSpecies(Filters.in("generation.name", PokemonUtil.getGenerationNames(maxGeneration)))

		println(pokemonSpeciesDAOs.map[name].join(', '))

		var pokemonDAOs = database.getPokemon(Filters.in("species.name", pokemonSpeciesDAOs.map[name]))
//			.filter[it.getBaseStatTotal() <= 600].toList() //TODO BST

		pokemonDAOs = pokemonDAOs.filter(trainerClass.pokemonPredicate).toList()

		var trainerPokemonSpecies = getPokemonSpecies(pokemonDAOs)

		println(trainerClass.name + ": " + trainerPokemonSpecies.map[name].join(","))

		val numberOfPokemon = Util.randomChoice(Util.list(2, 3, 4))

		for (var i = 0; i < numberOfPokemon; i++) {
			val level = if (numberOfPokemon == 2) {
					Util.randomInt(minLevel, maxLevel)
				} else if (numberOfPokemon == 3) {
					Util.randomInt(Math.floor(minLevel * 0.9) as int, Math.floor(maxLevel * 0.9) as int)
				} else if (numberOfPokemon == 4) {
					Util.randomInt(Math.floor(minLevel * 0.8) as int, Math.floor(maxLevel * 0.8) as int)
				}

			val pokemonSpecies = Util.randomChoice(trainerPokemonSpecies)

			val pokemon = Pokemon.fromSpeciesWithRandomIVsAndNature(pokemonSpecies)
			for (var j = 1; j < level; j++) {
				pokemon.levelUp(null, []) // moveset?
			}

			result.team.addPokemon(pokemon)
		}

		return result
	}

}
