package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.utility.LanguageDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

class PokemonShapeDAO extends NamedPokeApiResource {
	List<AwesomeNameDAO> awesomeNames
	List<NameDAO> names
	List<NamedApiResource<PokemonSpeciesDAO>> pokemonSpecies
}

class AwesomeNameDAO {
	String awesomeName
	NamedApiResource<LanguageDAO> language
}