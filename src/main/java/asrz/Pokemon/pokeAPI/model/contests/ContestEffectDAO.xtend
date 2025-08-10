package asrz.Pokemon.pokeAPI.model.contests

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.PokeApiResource
import asrz.Pokemon.pokeAPI.model.utility.EffectDAO
import asrz.Pokemon.pokeAPI.model.utility.FlavorTextDAO
import java.util.List

@MongoPojo
class ContestEffectDAO extends PokeApiResource {
	int appeal
	int jam
	List<EffectDAO> effectEntries
	List<FlavorTextDAO> flavorTextEntries
}
