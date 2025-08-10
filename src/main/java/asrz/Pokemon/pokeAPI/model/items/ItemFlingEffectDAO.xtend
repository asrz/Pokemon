package asrz.Pokemon.pokeAPI.model.items

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.utility.EffectDAO
import java.util.List

@MongoPojo
class ItemFlingEffectDAO extends NamedPokeApiResource {
	List<EffectDAO> effectEntries
	List<NamedApiResource<ItemDAO>> items
}