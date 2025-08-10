package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class GenderDAO extends NamedPokeApiResource {
	List<PokemonSpeciesGenderDAO> pokemonSpeciesDetails
	List<NamedApiResource<PokemonSpeciesDAO>> requiredForEvolution
}

@MongoPojo
class PokemonSpeciesGenderDAO {
	int rate
	NamedApiResource<PokemonSpeciesDAO> pokemonSpecies
}