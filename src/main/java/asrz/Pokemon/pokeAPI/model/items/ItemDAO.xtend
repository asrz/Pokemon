package asrz.Pokemon.pokeAPI.model.items

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.ApiResource
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.evolution.EvolutionChainDAO
import asrz.Pokemon.pokeAPI.model.games.VersionDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.pokeAPI.model.utility.GenerationGameIndexDAO
import asrz.Pokemon.pokeAPI.model.utility.MachineVersionDetailDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import asrz.Pokemon.pokeAPI.model.utility.VerboseEffectDAO
import asrz.Pokemon.pokeAPI.model.utility.VersionGroupFlavorTextDAO
import java.util.List
import org.bson.codecs.pojo.annotations.BsonProperty

@MongoPojo
class ItemDAO extends NamedPokeApiResource {
	Integer cost
	Integer flingPower
	NamedApiResource<ItemFlingEffectDAO> flingEffect
	List<NamedApiResource<ItemAttributeDAO>> attributes
	NamedApiResource<ItemCategoryDAO> category
	List<VerboseEffectDAO> effectEntries
	List<VersionGroupFlavorTextDAO> flavorTextEntries
	List<GenerationGameIndexDAO> gameIndices
	List<NameDAO> names
	ItemSpritesDAO sprites
	List<ItemHolderPokemonDAO> heldByPokemon
	ApiResource<EvolutionChainDAO> babyTriggerFor
	List<MachineVersionDetailDAO> machines
}

@MongoPojo
class ItemSpritesDAO {
	@BsonProperty("default")
	String defaultSprite
}

@MongoPojo
class ItemHolderPokemonDAO {
	NamedApiResource<PokemonDAO> pokemon
	List<ItemHolderPokemonVersionDetailDAO> versionDetails
}

@MongoPojo
class ItemHolderPokemonVersionDetailDAO {
	int rarity
	NamedApiResource<VersionDAO> version
}
