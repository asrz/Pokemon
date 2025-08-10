package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.utility.DescriptionDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class GrowthRateDAO extends NamedPokeApiResource {
	String formula
	List<DescriptionDAO> desciprionts
	List<GrowthRateExperienceLevelDAO> levels
	List<NamedApiResource<PokemonSpeciesDAO>> pokemonSpecies
}

@MongoPojo
class GrowthRateExperienceLevelDAO {
	int level
	int experience
}