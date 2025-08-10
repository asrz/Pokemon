package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.games.GenerationDAO
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.utility.EffectDAO
import asrz.Pokemon.pokeAPI.model.utility.LanguageDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import asrz.Pokemon.pokeAPI.model.utility.VerboseEffectDAO
import java.util.List

@MongoPojo
class AbilityDAO extends NamedPokeApiResource {
	boolean mainSeries
	NamedApiResource<GenerationDAO> generation
	
	List<NameDAO> names
	List<VerboseEffectDAO> effectEntries
	List<AbilityEffectChangeDAO> effectChanges
	List<AbilityFlavorTextDAO> flavorTextEntries
	List<AbilityPokemonDAO> pokemon
	
}

@MongoPojo
class AbilityEffectChangeDAO {
	List<EffectDAO> effectEntries
	NamedApiResource<VersionGroupDAO> versionGroup
}

@MongoPojo
class AbilityFlavorTextDAO {
	String flavorText
	NamedApiResource<LanguageDAO> language
	NamedApiResource<VersionGroupDAO> versionGroup
}

@MongoPojo
class AbilityPokemonDAO {
	boolean hidden
	int slot
	NamedApiResource<PokemonDAO> pokemon
}
