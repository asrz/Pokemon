package asrz.Pokemon.pokeAPI.model.games

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class VersionDAO extends NamedPokeApiResource {
	List<NameDAO> names
	NamedApiResource<VersionGroupDAO> versionGroup
}