package asrz.Pokemon.pokeAPI.model.moves

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.utility.DescriptionDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class MoveLearnMethodDAO extends NamedPokeApiResource {
	List<DescriptionDAO> descriptions
	List<NameDAO> names
	List<NamedApiResource<VersionGroupDAO>> versionGroups
}