package asrz.Pokemon.pokeAPI.model.moves

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.utility.DescriptionDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class MoveTargetDAO extends NamedPokeApiResource {
	List<DescriptionDAO> descriptions
	List<NamedApiResource<MoveDAO>> moves
	List<NameDAO> names
}