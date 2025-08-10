package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.locations.LocationAreaDAO
import asrz.Pokemon.pokeAPI.model.utility.VersionEncounterDetailDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.PokeApiResource

@MongoPojo
class LocationAreaEncounterDAO extends PokeApiResource {
	NamedApiResource<LocationAreaDAO> locationArea
	List<VersionEncounterDetailDAO> versionDetails
}