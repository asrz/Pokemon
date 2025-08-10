package asrz.Pokemon.pokeAPI.model.locations

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.encounters.EncounterMethodDAO
import asrz.Pokemon.pokeAPI.model.games.VersionDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import asrz.Pokemon.pokeAPI.model.utility.VersionEncounterDetailDAO
import java.util.List

@MongoPojo
class LocationAreaDAO extends NamedPokeApiResource {
	int gameIndex
	List<EncounterMethodRateDAO> encounterMethodRates
	NamedApiResource<LocationDAO> location
	List<NameDAO> names
	List<PokemonEncounterDAO> pokemonEncounters
}

@MongoPojo
class EncounterMethodRateDAO {
	NamedApiResource<EncounterMethodDAO> encounterMethod
	List<EncounterVersionDetailsDAO> versionDetails
}

@MongoPojo
class EncounterVersionDetailsDAO {
	int rate
	NamedApiResource<VersionDAO> version
}

@MongoPojo
class PokemonEncounterDAO {
	NamedApiResource<PokemonDAO> pokemon
	List<VersionEncounterDetailDAO> versionDetails
}