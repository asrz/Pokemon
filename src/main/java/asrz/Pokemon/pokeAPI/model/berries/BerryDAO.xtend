package asrz.Pokemon.pokeAPI.model.berries

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.items.ItemDAO
import asrz.Pokemon.pokeAPI.model.pokemon.TypeDAO
import java.util.List

@MongoPojo
class BerryDAO extends NamedPokeApiResource {
	int growthTime
	int maxHarvest
	int naturalGiftPower
	int size
	int smoothness
	int soilDryness
	NamedApiResource<BerryFirmnessDAO> firmness
	List<BerryFlavorMapDAO> flavors
	NamedApiResource<ItemDAO> item
	NamedApiResource<TypeDAO> naturalGiftType
}

@MongoPojo
class BerryFlavorMapDAO {
	int potency
	NamedApiResource<BerryFlavorDAO> flavor
}