package asrz.Pokemon.pokeAPI.model.games

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.locations.RegionDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import asrz.Pokemon.pokeAPI.model.utility.DescriptionDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class PokedexDAO extends NamedPokeApiResource {
	boolean mainSeries
	List<DescriptionDAO> descriptions
	List<NameDAO> names
	List<PokemonEntryDAO> pokemonEntries
	NamedApiResource<RegionDAO> region
	List<NamedApiResource<VersionGroupDAO>> versionGroups
}

@MongoPojo
class PokemonEntryDAO {
	int entryNumber
	NamedApiResource<PokemonSpeciesDAO> pokemonSpecies
}