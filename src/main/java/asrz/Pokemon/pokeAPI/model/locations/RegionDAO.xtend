package asrz.Pokemon.pokeAPI.model.locations

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.games.GenerationDAO
import asrz.Pokemon.pokeAPI.model.games.PokedexDAO
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class RegionDAO extends NamedPokeApiResource {
	List<NamedApiResource<LocationDAO>> locations
	List<NameDAO> names
	NamedApiResource<GenerationDAO> mainGeneration
	List<NamedApiResource<PokedexDAO>> pokedexes
	List<NamedApiResource<VersionGroupDAO>> versionGroups
}