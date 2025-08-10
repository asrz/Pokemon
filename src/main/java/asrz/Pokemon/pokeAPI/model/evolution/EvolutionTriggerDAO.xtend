package asrz.Pokemon.pokeAPI.model.evolution

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class EvolutionTriggerDAO extends NamedPokeApiResource {
	List<NameDAO> names
	List<NamedApiResource<PokemonSpeciesDAO>> pokemonSpecies
}