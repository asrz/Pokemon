package asrz.Pokemon.pokeAPI.model.moves

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.utility.DescriptionDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class MoveCategoryDAO extends NamedPokeApiResource {
	List<NamedApiResource<MoveDAO>> moves
	List<DescriptionDAO> descriptions
}