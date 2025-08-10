package asrz.Pokemon.service

import asrz.Pokemon.application.Context
import asrz.Pokemon.model.Ability
import asrz.Pokemon.model.Item
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Player
import asrz.Pokemon.model.Pokemon
import com.mongodb.client.model.Filters

class PlayerService extends BaseService {
	
	new(Context context) {
		super(context)
	}
	
	def loadGame(Player player) {
		val pokemonById = database.getLocalPokemon(Filters.in("_id", player.team.allPokemonIds)).toMap[id]
		val pokemonDaosById = database.getPokemon(Filters.in("id", pokemonById.values.map[pokemonDaoId])).toMap[id]
		
		val itemDaosById = database.getItems(Filters.in("id", player.itemBag.allItemStacks.map[itemDaoId])).toMap[id]
		
		val moveIds = pokemonById.values.flatMap[moveDaoIds].toList
		moveIds.addAll(pokemonById.values.map[learnedMoves].flatten.map[moveDaoId])
		val moveDaosById = database.getMoves(Filters.in("id", moveIds)).toMap[id]
		
		val abilitiesByName = database.getAbilities(Filters.in("name", pokemonById.values.map[abilityDaoName])).toMap[name]
		
		player.team.pokemon_1 = pokemonById.get(player.team.pokemon_1Id)
		player.team.pokemon_2 = pokemonById.get(player.team.pokemon_2Id)
		player.team.pokemon_3 = pokemonById.get(player.team.pokemon_3Id)
		player.team.pokemon_4 = pokemonById.get(player.team.pokemon_4Id)
		player.team.pokemon_5 = pokemonById.get(player.team.pokemon_5Id)
		player.team.pokemon_6 = pokemonById.get(player.team.pokemon_6Id)
		
		player.team.allPokemon.forEach[pokemon | 
			pokemon.species = c.pokemonService.getPokemonSpecies(pokemonDaosById.get(pokemon.pokemonDaoId))
			pokemon.ability = Ability.fromApi(abilitiesByName.get(pokemon.abilityDaoName), player.languageName)
			if (pokemon.move_1DaoId !== null) {
				pokemon.move_1 = Move.fromApi(moveDaosById.get(pokemon.move_1DaoId), player.languageName)
			}
			if (pokemon.move_2DaoId !== null) {
				pokemon.move_2 = Move.fromApi(moveDaosById.get(pokemon.move_2DaoId), player.languageName)
			}
			if (pokemon.move_3DaoId !== null) {
				pokemon.move_3 = Move.fromApi(moveDaosById.get(pokemon.move_3DaoId), player.languageName)
			}
			if (pokemon.move_4DaoId !== null) {
				pokemon.move_4 = Move.fromApi(moveDaosById.get(pokemon.move_4DaoId), player.languageName)
			}
			pokemon.learnedMoves.all = pokemon.learnedMoves.map[move | moveDaosById.get(move.moveDaoId)].map[moveDao | Move.fromApi(moveDao, player.languageName)]
		]
		
		player.itemBag.allItemStacks.forEach[ itemStack |
			itemStack.item = Item.fromApi(itemDaosById.get(itemStack.itemDaoId), player.languageName)
		]
		
		c.player = player
		player.team.allPokemon.forEach[
			initializeBindings
			healHpAndStatuses
		]
	}
	
	def saveGame(Player player) {
		for (itemStack : player.itemBag.getAllItemStacks()) {
			itemStack.itemDaoId = itemStack.item.itemDaoId
		}
		
		player.team.populatePokemonIds
		database.saveEntity(player, Player)
		
		for (pokemon : player.team.allPokemon) {
			pokemon.pokemonDaoId = pokemon.species.pokemonDaoId
			pokemon.abilityDaoName = pokemon.ability.abilityDaoName
			pokemon.move_1DaoId = pokemon.move_1?.moveDaoId
			pokemon.move_2DaoId = pokemon.move_2?.moveDaoId
			pokemon.move_3DaoId = pokemon.move_3?.moveDaoId
			pokemon.move_4DaoId = pokemon.move_4?.moveDaoId
			
			database.saveEntity(pokemon, Pokemon)
		}
	}
	
	def deleteGame(Player player) {
		println("deleteGame: " + player.id)
		database.deletePlayers(Filters.eq("_id", player.id))
		player.team.populatePokemonIds()
		database.deletePokemon(Filters.in("_id", player.team.allPokemonIds))
	}
	
}