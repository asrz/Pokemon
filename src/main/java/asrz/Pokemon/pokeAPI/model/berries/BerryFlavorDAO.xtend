package asrz.Pokemon.pokeAPI.model.berries

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.contests.ContestTypeDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class BerryFlavorDAO extends NamedPokeApiResource {
	List<FlavorBerryMapDAO> berries
	NamedApiResource<ContestTypeDAO> contestType
	List<NameDAO> names
}

@MongoPojo
class FlavorBerryMapDAO {
	int potency
	NamedApiResource<BerryDAO> berry
}