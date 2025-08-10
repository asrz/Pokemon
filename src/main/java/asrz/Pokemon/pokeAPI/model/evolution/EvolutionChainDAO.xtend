package asrz.Pokemon.pokeAPI.model.evolution

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.PokeApiResource
import asrz.Pokemon.pokeAPI.model.items.ItemDAO
import asrz.Pokemon.pokeAPI.model.locations.LocationDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import asrz.Pokemon.pokeAPI.model.pokemon.TypeDAO
import java.util.List
import org.bson.codecs.pojo.annotations.BsonProperty

@MongoPojo
class EvolutionChainDAO extends PokeApiResource {
	NamedApiResource<ItemDAO> babyTriggerItem
	ChainLinkDAO chain
}

@MongoPojo
class ChainLinkDAO {
	boolean baby
	NamedApiResource<PokemonSpeciesDAO> species
	List<EvolutionDetailDAO> evolutionDetails
	List<ChainLinkDAO> evolvesTo
}

@MongoPojo
class EvolutionDetailDAO {
	NamedApiResource<ItemDAO> item
	NamedApiResource<EvolutionTriggerDAO> trigger
	int gender
	NamedApiResource<ItemDAO> heldItem
	NamedApiResource<MoveDAO> knownMove
	NamedApiResource<TypeDAO> knownMoveType
	NamedApiResource<LocationDAO> location
	int minLevel
	int minHappiness
	int minBeauty
	int minAffection
	boolean needsOverworldRain
	NamedApiResource<PokemonSpeciesDAO> partySpecies
	NamedApiResource<TypeDAO> partyType
	int relativePhysicalStats
	String timeOfDay
	NamedApiResource<PokemonSpeciesDAO> tradeSpecies
	@BsonProperty("turn_upside_down")
	boolean turnUpsideDown
}