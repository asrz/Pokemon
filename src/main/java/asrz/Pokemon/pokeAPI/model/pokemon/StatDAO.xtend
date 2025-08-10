package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.ApiResource
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDamageClassDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class StatDAO extends NamedPokeApiResource {
	int gameIndex
	boolean battleOnly
	MoveStatAffectSetsDAO affectingMoves
	NatureStatAffectSetsDAO affectingNatures
	List<ApiResource<CharacteristicDAO>> characteristics
	NamedApiResource<MoveDamageClassDAO> moveDamageClass
	List<NameDAO> names
}

@MongoPojo
class MoveStatAffectSetsDAO {
	List<MoveStatAffectDAO> increase
	List<MoveStatAffectDAO> decrease
}

@MongoPojo
class MoveStatAffectDAO {
	int change
	NamedApiResource<MoveDAO> move
}

@MongoPojo
class NatureStatAffectSetsDAO {
	List<NamedApiResource<NatureDAO>> increase
	List<NamedApiResource<NatureDAO>> decrease
}