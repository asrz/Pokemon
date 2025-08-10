package asrz.Pokemon.pokeAPI.model.contests

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.berries.BerryFlavorDAO
import asrz.Pokemon.pokeAPI.model.utility.LanguageDAO
import java.util.List

@MongoPojo
class ContestTypeDAO extends NamedPokeApiResource {
	NamedApiResource<BerryFlavorDAO> berryFlavor
	List<ContestNameDAO> contestNames
}

@MongoPojo
class ContestNameDAO {
	String name
	String color
	NamedApiResource<LanguageDAO> language
}