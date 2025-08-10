package asrz.Pokemon.pokeAPI.model.encounters

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class EncounterMethodDAO extends NamedPokeApiResource {
	int order
	List<NameDAO> names
}