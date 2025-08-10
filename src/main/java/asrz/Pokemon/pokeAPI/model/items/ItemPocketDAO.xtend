package asrz.Pokemon.pokeAPI.model.items

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class ItemPocketDAO extends NamedPokeApiResource {
	List<NamedApiResource<ItemCategoryDAO>> categories
	List<NameDAO> names
}