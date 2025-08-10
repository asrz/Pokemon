package asrz.Pokemon.pokeAPI.model.games

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.locations.RegionDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.pokemon.AbilityDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import asrz.Pokemon.pokeAPI.model.pokemon.TypeDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class GenerationDAO extends NamedPokeApiResource {
	List<NamedApiResource<AbilityDAO>> abilities
	List<NameDAO> names
	NamedApiResource<RegionDAO> mainRegion
	List<NamedApiResource<MoveDAO>> moves
	List<NamedApiResource<PokemonSpeciesDAO>> pokemonSpecies
	List<NamedApiResource<TypeDAO>> types
	List<NamedApiResource<VersionGroupDAO>> versionGroups
}