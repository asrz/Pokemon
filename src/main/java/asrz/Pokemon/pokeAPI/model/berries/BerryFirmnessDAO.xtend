package asrz.Pokemon.pokeAPI.model.berries

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class BerryFirmnessDAO extends NamedPokeApiResource {
	List<NamedApiResource<BerryDAO>> berries
	List<NameDAO> names
}