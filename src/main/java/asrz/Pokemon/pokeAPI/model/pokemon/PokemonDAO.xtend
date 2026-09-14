package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.games.GenerationDAO
import asrz.Pokemon.pokeAPI.model.games.VersionDAO
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.items.ItemDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveLearnMethodDAO
import asrz.Pokemon.pokeAPI.model.utility.VersionGameIndexDAO
import java.util.List

@MongoPojo
class PokemonDAO extends NamedPokeApiResource {
	int baseExperience
	int height
	boolean isDefault
	int order
	int weight
	
	List<PokemonAbilityDAO> abilities
	List<NamedApiResource<PokemonFormDAO>> forms
	List<VersionGameIndexDAO> gameIndices
	List<HeldItemDAO> heldItems
	String locationAreaEncounters
	List<PokemonMoveDAO> moves
	
	List<PastTypeDAO> pastTypes
	List<PokemonAbilityPastDAO> pastAbilities
	PokemonSpritesDAO sprites
	PokemonCriesDAO cries
	NamedApiResource<PokemonSpeciesDAO> species
	List<PokemonStatDAO> stats
	List<TypeDAO> types
	
	def int getBaseStatTotal() {
		return stats.map[baseStat].reduce([a,b | a+b])
	}
}

@MongoPojo
class PokemonAbilityDAO {
	boolean hidden
	int slot
	NamedApiResource<AbilityDAO> ability
}

@MongoPojo
class PokemonAbilityPastDAO {
	NamedApiResource<GenerationDAO> generation
	List<TypeDAO> types
}

@MongoPojo
class PokemonTypeDAO {
	int slot
	NamedApiResource<TypeDAO> type
}

@MongoPojo
class PokemonFormTypeDAO {
	int slot
	NamedApiResource<TypeDAO> type
}

@MongoPojo
class PastTypeDAO {
	NamedApiResource<GenerationDAO> generation
	List<PokemonTypeDAO> types
}

@MongoPojo
class HeldItemDAO {
	NamedApiResource<ItemDAO> item
	List<HeldItemVersionDAO> versionDetails
}

@MongoPojo
class HeldItemVersionDAO {
	NamedApiResource<VersionDAO> version
	int rarity
}

@MongoPojo
class PokemonMoveDAO {
	NamedApiResource<MoveDAO> move
	List<PokemonMoveVersionDAO> versionGroupDetails
}

@MongoPojo
class PokemonMoveVersionDAO {
	NamedApiResource<MoveLearnMethodDAO> moveLearnMethod
	NamedApiResource<VersionGroupDAO> versionGroup
	int levelLearnedAt
	Integer order
}

@MongoPojo
class PokemonStatDAO {
	NamedApiResource<StatDAO> stat
	int effort
	int baseStat
}

@MongoPojo
class PokemonSpritesDAO {
	String frontDefault
	String frontShiny
	String frontFemale
	String frontFemaleShiny
	
	String backDefault
	String backShiny
	String backFemale
	String backFemaleShiny
}

@MongoPojo
class PokemonCriesDAO {
	String latest
	String legacy
}