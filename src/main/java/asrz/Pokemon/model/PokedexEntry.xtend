package asrz.Pokemon.model

import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import xtendfx.beans.FXBindable

@FXBindable
class PokedexEntry {
	
	Integer pokemonSpeciesDaoId
	PokedexEntryStatus status
	
	int number
	String description
	
	new() {}
	
	new(PokemonSpeciesDAO species, String description, PokedexEntryStatus status, int number) {
		this.pokemonSpeciesDaoId = species?.id
		this.description = description
		this.status = status
		this.number = number
	}
	
}
