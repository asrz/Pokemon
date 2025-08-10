package asrz.Pokemon.pokeAPI.model.moves

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class MoveBattleStyleDAO extends NamedPokeApiResource {
	List<NameDAO> names
}