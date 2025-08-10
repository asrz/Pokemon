package asrz.Pokemon.pokeAPI.model.contests

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.PokeApiResource
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.utility.FlavorTextDAO
import java.util.List

@MongoPojo
class SuperContestEffectDAO extends PokeApiResource {
	int appeal
	List<FlavorTextDAO> flavorTextEntries
	List<NamedApiResource<MoveDAO>> moves
}