package asrz.Pokemon.pokeAPI.model.moves

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.ApiResource
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.contests.ContestEffectDAO
import asrz.Pokemon.pokeAPI.model.contests.ContestTypeDAO
import asrz.Pokemon.pokeAPI.model.contests.SuperContestEffectDAO
import asrz.Pokemon.pokeAPI.model.games.GenerationDAO
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.pokemon.AbilityEffectChangeDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.pokeAPI.model.pokemon.StatDAO
import asrz.Pokemon.pokeAPI.model.pokemon.TypeDAO
import asrz.Pokemon.pokeAPI.model.utility.LanguageDAO
import asrz.Pokemon.pokeAPI.model.utility.MachineVersionDetailDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import asrz.Pokemon.pokeAPI.model.utility.VerboseEffectDAO
import java.util.List
import org.bson.codecs.pojo.annotations.BsonProperty

@MongoPojo
class MoveDAO extends NamedPokeApiResource {
	Integer accuracy
	Integer effectChance
	int pp
	int priority
	Integer power
	
	ContestComboSetsDAO contestCombos
	NamedApiResource<ContestTypeDAO> contestType
	ApiResource<ContestEffectDAO> contestEffect
	NamedApiResource<MoveDamageClassDAO> damageClass
	
	List<VerboseEffectDAO> effectEntries
	List<AbilityEffectChangeDAO> effectChanges
	List<NamedApiResource<PokemonDAO>> learnedByPokemon
	List<MoveFlavorTextDAO> flavorTextEntries
	NamedApiResource<GenerationDAO> generation
	List<MachineVersionDetailDAO> machines
	MoveMetaDataDAO meta
	List<NameDAO> names
	List<PastMoveStatValuesDAO> pastValues
	List<MoveStatChangeDAO> statChanges
	ApiResource<SuperContestEffectDAO> superContestEffect
	NamedApiResource<MoveTargetDAO> target
	NamedApiResource<TypeDAO> type
}

@MongoPojo
class ContestComboSetsDAO {
	ContestComboDetailDAO normal
	@BsonProperty("super")
	ContestComboDetailDAO superDetails
}

@MongoPojo
class ContestComboDetailDAO {
	List<NamedApiResource<MoveDAO>> useBefore
	List<NamedApiResource<MoveDAO>> useAfter
}

@MongoPojo
class MoveFlavorTextDAO { 
	String flavorText
	NamedApiResource<LanguageDAO> language
	NamedApiResource<VersionGroupDAO> versionGroup
}

@MongoPojo
class MoveMetaDataDAO {
	NamedApiResource<MoveAilmentDAO> ailment
	NamedApiResource<MoveCategoryDAO> category
	
	Integer minHits
	Integer maxHits
	Integer minTurns
	Integer maxTurns
	Integer drain
	Integer healing
	Integer critRate
	Integer ailmentChance
	Integer flinchChance
	Integer statChance
}

@MongoPojo
class MoveStatChangeDAO {
	int change
	NamedApiResource<StatDAO> stat
}

@MongoPojo
class PastMoveStatValuesDAO {
	Integer accuracy
	Integer effectChance
	Integer power
	Integer pp
	List<VerboseEffectDAO> effectEntries
	NamedApiResource<TypeDAO> type
	NamedApiResource<VersionGroupDAO> versionGroup
}