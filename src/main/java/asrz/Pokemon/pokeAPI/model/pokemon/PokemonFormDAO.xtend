package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class PokemonFormDAO extends NamedPokeApiResource {
	int order
	int formOrder
	boolean isDefault
	boolean battleOnly
	boolean mega
	String formName
	NamedApiResource<PokemonDAO> pokemon
	List<PokemonFormTypeDAO> types
	PokemonFormSpritesDAO sprites
	NamedApiResource<VersionGroupDAO> versionGroup
	List<NameDAO> names
	List<NameDAO> formNames
}

@MongoPojo
class PokemonFormSpritesDAO {
	String frontDefault
	String frontShiny
	String backDefault
	String backShiny
}