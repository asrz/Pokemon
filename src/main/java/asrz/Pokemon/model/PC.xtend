package asrz.Pokemon.model

import xtendfx.beans.FXBindable

@FXBindable
class PC {
	
	IntegerList unlockedPokemonDaoIds = new IntegerList
	
	def addPokemon(Pokemon pokemon) {
		unlockedPokemonDaoIds.add(pokemon.pokemonDaoId)
	}
}