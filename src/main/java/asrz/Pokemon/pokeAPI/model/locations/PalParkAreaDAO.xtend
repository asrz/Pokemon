package asrz.Pokemon.pokeAPI.model.locations

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class PalParkAreaDAO extends NamedPokeApiResource {
	List<NameDAO> names
	List<PalParkEncounterSpeciesDAO> pokemonEncounters
}

@MongoPojo
class PalParkEncounterSpeciesDAO {
	int baseScore
	int rate
	NamedApiResource<PokemonSpeciesDAO> pokemonSpecies
}
