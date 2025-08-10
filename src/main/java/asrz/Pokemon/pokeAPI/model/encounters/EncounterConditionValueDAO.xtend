package asrz.Pokemon.pokeAPI.model.encounters

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class EncounterConditionValueDAO extends NamedPokeApiResource {
	NamedApiResource<EncounterConditionDAO> condition
	List<NameDAO> names
}