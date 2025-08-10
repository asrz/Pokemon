package asrz.Pokemon.pokeAPI.model.games

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.locations.RegionDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveLearnMethodDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class VersionGroupDAO extends NamedPokeApiResource {
	int order
	NamedApiResource<GenerationDAO> generation
	List<NamedApiResource<MoveLearnMethodDAO>> moveLearnMethods
	List<NamedApiResource<PokedexDAO>> pokedexes
	List<NamedApiResource<RegionDAO>> regions
	List<NamedApiResource<VersionDAO>> versions
}