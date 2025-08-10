package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.ApiResource
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.evolution.EvolutionChainDAO
import asrz.Pokemon.pokeAPI.model.games.GenerationDAO
import asrz.Pokemon.pokeAPI.model.games.PokedexDAO
import asrz.Pokemon.pokeAPI.model.locations.PalParkAreaDAO
import asrz.Pokemon.pokeAPI.model.utility.DescriptionDAO
import asrz.Pokemon.pokeAPI.model.utility.FlavorTextDAO
import asrz.Pokemon.pokeAPI.model.utility.LanguageDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import org.bson.codecs.pojo.annotations.BsonProperty

@MongoPojo
class PokemonSpeciesDAO extends NamedPokeApiResource {
	int order
	int genderRate
	int captureRate
	int baseHappiness
	boolean baby
	boolean legendary
	boolean mythical
	int hatchCounter
	@BsonProperty("has_gender_differences")
	boolean hasGenderDifferences
	@BsonProperty("formsSwitchable")
	boolean formsSwitchable
	
	NamedApiResource<GrowthRateDAO> growthRate
	List<PokemonSpeciesDexEntryDAO> pokedexNumbers
	List<NamedApiResource<EggGroupDAO>> eggGroups
	NamedApiResource<PokemonColorDAO> color
	NamedApiResource<PokemonShapeDAO> shape
	NamedApiResource<PokemonSpeciesDAO> evolvesFromSpecies
	ApiResource<EvolutionChainDAO> evolutionChain
	NamedApiResource<PokemonHabitatDAO> habitat
	NamedApiResource<GenerationDAO> generation
	
	List<NameDAO> names
	List<PalParkEncounterAreaDAO> palParkEncounters
	List<FlavorTextDAO> flavorTextEntries
	List<DescriptionDAO> formDesciptions
	List<GenusDAO> genera
	List<PokemonSpeciesVarietyDAO> varieties
}

@MongoPojo
class GenusDAO {
	String genus
	NamedApiResource<LanguageDAO> language
}

@MongoPojo
class PokemonSpeciesDexEntryDAO {
	Integer entryNumber
	NamedApiResource<PokedexDAO> pokedex
}

@MongoPojo
class PalParkEncounterAreaDAO {
	int baseScore
	int rate
	NamedApiResource<PalParkAreaDAO> area
}

@MongoPojo
class PokemonSpeciesVarietyDAO {
	boolean isDefault
	NamedApiResource<PokemonDAO> pokemon
}